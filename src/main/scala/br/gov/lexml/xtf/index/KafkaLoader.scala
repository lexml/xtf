package br.gov.lexml.xtf.index

import com.github.luben.zstd.{ZstdDictCompress, ZstdOutputStream}
import net.sf.saxon.FeatureKeys
import net.sf.saxon.om.NamePool
import org.cdlib.xtf.servletBase.{DTDSuppressingXMLReader, StylesheetCache}
import org.cdlib.xtf.textEngine.IndexUtil
import org.cdlib.xtf.textIndexer.LuceneDocBuilderHandler
import org.cdlib.xtf.util.{Path, XTFSaxonErrorListener}
import org.kamranzafar.jtar.{TarEntry, TarHeader, TarOutputStream}
import org.xml.sax.InputSource
import zio.*
import zio.stream.*

import java.io.{ByteArrayInputStream, ByteArrayOutputStream, File, FileOutputStream, IOException, OutputStream}
import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Path, Paths}
import javax.xml.transform.{OutputKeys, Templates}
import javax.xml.transform.sax.SAXSource
import javax.xml.transform.stream.{StreamResult, StreamSource}
import scala.xml.{Elem, XML}

object KafkaLoader extends ZIOAppDefault:
  def pathStream(root : File, fileFilter : File => Boolean = _ => true, subDirFilter : File => Boolean = _ => true)
    : ZStream[Any,IOException,File] =
    def makeStream(base : File) : ZStream[Any,IOException,File] =
      if base.isFile && fileFilter(base) then
        ZStream(base)
      else if base.isDirectory && subDirFilter(base) then
        val fl = Chunk.fromArray(base.listFiles())
        val files = fl.filter(f => f.isFile && fileFilter(f))
        val subDirs = fl.filter(f => f.isDirectory && subDirFilter(f))

        if fl.isEmpty then
          ZStream.fromChunk(subDirs).flatMapPar(4)(makeStream)
        else
          ZStream.fromChunk(files) ++ (ZStream.fromChunk(subDirs).flatMap(makeStream))
      else ZStream.empty
    makeStream(root)

  def readFilePipeline : ZPipeline[Any,IOException,File,(File,Array[Byte])] =
    ZPipeline.mapZIO { file =>
      ZIO.attemptBlockingIO {
        if file.isDirectory then throw new IOException(s"file $file is a directory!") else
          (file,Files.readAllBytes(file.toPath))
      }
    }

  private val xtfHomePath = "/home/joao/git/senado/lexml-portal-docker/docker/lexml-carga-batch-docker/filesystem/var/aplicacoes/xtf"

  private val dcPreFilterFile =
    File(File(xtfHomePath), "style/textIndexer/dcPreFilter.xsl")
  if !dcPreFilterFile.exists() then
    throw new RuntimeException()
  else ()

  private val transformerFactory = {
    val tfConfig = new net.sf.saxon.Configuration()
    tfConfig.setNamePool(NamePool.getDefaultNamePool)
    val tf = net.sf.saxon.TransformerFactoryImpl(tfConfig)
    if (! tf.getErrorListener.isInstanceOf[XTFSaxonErrorListener]) then
      tf.setErrorListener(new XTFSaxonErrorListener())
    else ()
    tf.setAttribute(FeatureKeys.SOURCE_PARSER_CLASS, classOf[DTDSuppressingXMLReader].getName)
    tf
  }

  private val dcStyleSheet =
    transformerFactory.newTemplates(new StreamSource(Files.newInputStream(dcPreFilterFile.toPath)))

  private val expectedIncrease : Double = 0.2

  def transformPipeline[A](templates : Templates,paralelism : Int = 16) : ZPipeline[Any,Exception,(A,Array[Byte]),(Int,A,Either[Exception,Array[Byte]])] =
    ZPipeline.mapZIOParUnordered[Any,Exception,(A,Array[Byte]),(Int,A,Either[Exception,Array[Byte]])](paralelism) { (f,inBytes) =>
      (for {
        tf <- ZIO.attempt { templates.newTransformer() }
        _ <- ZIO.attempt {
          tf.setOutputProperty(OutputKeys.METHOD, "xml")
          tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8")
          tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
        }
        baos = new ByteArrayOutputStream((inBytes.length * (1.0 + expectedIncrease)).toInt)
        _ <- ZIO.attempt {
          tf.transform(new StreamSource(new ByteArrayInputStream(inBytes)),
            new StreamResult(baos))
        }
      } yield baos.toByteArray).refineOrDie { case ex : Exception => ex }.either.map(x => (inBytes.length,f,x))
    }

  enum FieldValue:
    case FV_EMPTY, FV_NUMBER, FV_YEAR, FV_DATE, FV_STRING

  object FieldValue:
    private val reYear = """^\d\d\d\d$""".r
    private val reDate = """^\d\d\d\d-\d\d-\d\d$""".r
    private val reNumber = """^\d\+$""".r

    def fromString(str: String): FieldValue = str match {
      case reYear() => FieldValue.FV_YEAR
      case reDate() => FieldValue.FV_DATE
      case reNumber() => FieldValue.FV_NUMBER
      case _ => FieldValue.FV_STRING
    }

  final case class FieldSpec(values : Set[FieldValue] = Set(),cardMin : Int = 1,cardMax : Int = 1):
    def +(f : FieldSpec) : FieldSpec =
      copy(values = values ++ f.values, cardMin = math.min(cardMin,f.cardMin), cardMax = math.max(cardMax,f.cardMax))
    override def toString : String = values.mkString("(",", ",")") + s" [$cardMin .. $cardMax]"

  final case class FieldMap(m : Map[String,FieldSpec]):
    def +(fm : FieldMap) : FieldMap =
      val newFm = (m.keySet ++ fm.m.keySet).toSeq.map { k =>
        (m.get(k), fm.m.get(k)) match {
          case (None, None) => sys.error("Unexpected")
          case (Some(thisSpec), None) => (k, thisSpec.copy(cardMin = 0))
          case (None, Some(thatSpec)) => (k, thatSpec.copy(cardMin = 0))
          case (Some(thisSpec), Some(thatSpec)) => (k, thisSpec + thatSpec)
        }
      }.toMap
      FieldMap(newFm)

  def parsePipeline[A] : ZPipeline[Any,Exception,(A,Array[Byte]),(A,Elem)] =
    ZPipeline.mapZIO { (f,inBytes) =>
      ZIO.attempt { (f,XML.load(new ByteArrayInputStream(inBytes))) }.refineOrDie { case ex : Exception => ex }
    }

  def xmlToFieldMap(doc : Elem) : FieldMap =
    val l = doc.child.collect { case e : Elem =>
      val v = e.text.trim
      val vv = FieldValue.fromString(v)
      (e.label,vv)
    }
    val m = l.groupBy(_._1).view.mapValues {
      ss =>
        val valueSet = ss.map(_._2).toSet
        val card = ss.length
        FieldSpec(valueSet,card,card)
    }.toMap
    FieldMap(m)

  def fieldMapPipeline : ZPipeline[Any,Nothing,Elem,FieldMap] =
    ZPipeline.map(xmlToFieldMap)


  /*override def run : ZIO[Any,Exception,Unit] =
    for {
      timeAndResult <- pathStream(new File("/zfs_lexml/www-data/doc"),_.getName.endsWith(".dc.xml"))
        .via(readFilePipeline)
        .via(transformPipeline(dcStyleSheet))
        .collect {
          case (_,Right(v)) => v
        }
        .via(parsePipeline)
        .via(fieldMapPipeline)
        .runFold[Option[FieldMap]](None) {
          case (None,fm) => Some(fm)
          case (Some(fm1),fm2) => Some(fm1 + fm2)
        }.timed
      (ellapsed,fieldMap) = timeAndResult
      _ <- Console.printLine(s"Ellapsed time: $ellapsed secs")
      _ <- ZIO.foreachDiscard(fieldMap.map(_.m).getOrElse(Map())) { (fieldName,fieldSpec) =>
        Console.printLine(s"\t$fieldName: $fieldSpec")
      }
    } yield ()*/

  override def run: ZIO[Scope, Exception, Unit] =
    for {
      counter <- Ref.Synchronized.make[Long](0L)
      tos <- ZIO.acquireRelease[Any,Any,IOException,TarOutputStream](
        ZIO.attemptBlockingIO {
          val fos = new FileOutputStream(new File("/zfs_lexml/result/indexable-docs.tar.zstd"))
          val zstdOs = new ZstdOutputStream(fos,9)
          new TarOutputStream(zstdOs)
        }
      )( os => ZIO.attemptBlockingIO(os.close()).ignore)
      fib <- (for {
        timeAndResult <- pathStream(new File("/zfs_lexml/www-data/doc"), _.getName.endsWith(".dc.xml"))
          .via(readFilePipeline)
          .via(transformPipeline[File](dcStyleSheet))
          .collect {
            case (_, f, Right(v)) => (f,v)
          }
          .via(parsePipeline[File])
          .runForeach { (f : File,elem : Elem) =>
            val id = (elem \ "idDocumento").text.trim.toLong
            val idStr = f"$id%09d"
            val entryName = f"${idStr.substring(0,3)}/${idStr.substring(3,6)}/$idStr.xml"
            val data = elem.toString.getBytes(StandardCharsets.UTF_8)
            val header = TarHeader.createHeader(entryName, data.length, f.lastModified(), false, 6*64+6*8+6)
            for {
              _ <- ZIO.attemptBlockingIO { tos.putNextEntry(new TarEntry(header)) }
              _ <- ZIO.attemptBlockingIO { tos.write(elem.toString.getBytes(StandardCharsets.UTF_8)) }
              _ <- counter.update(_ + 1)
            } yield ()
          }
          .timed
        (ellapsed, _) = timeAndResult
        _ <- Console.printLine(s"Ellapsed time: $ellapsed secs")
        _ <- counter.set(-1)
      } yield ()).fork
      _ <-
        counter.get.flatMap { cnt =>
          Console.printLine(s"So far: $cnt") *>
            ZIO.sleep(Duration.fromSeconds(15))
        }.repeatUntilZIO { _ =>
          counter.get.map(_ < 0)
        }
      _ <- fib.join
    } yield ()




