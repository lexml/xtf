package br.gov.lexml.xtf.index

import net.sf.saxon.FeatureKeys
import net.sf.saxon.om.NamePool
import org.cdlib.xtf.servletBase.{DTDSuppressingXMLReader, StylesheetCache}
import org.cdlib.xtf.textEngine.IndexUtil
import org.cdlib.xtf.textIndexer.LuceneDocBuilderHandler
import org.cdlib.xtf.util.{Path, XTFSaxonErrorListener}
import org.xml.sax.InputSource
import zio.*
import zio.stream.*

import java.io.{ByteArrayInputStream, ByteArrayOutputStream, File, IOException}
import java.nio.file.{Files, Path, Paths}
import javax.xml.transform.{OutputKeys, Templates}
import javax.xml.transform.sax.SAXSource
import javax.xml.transform.stream.{StreamResult, StreamSource}

object KafkaLoader:
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
          ZStream.fromChunk(fl) ++ ZStream.fromChunk(subDirs).flatMap(makeStream)
      else ZStream.empty
    makeStream(root)

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
    if (! tf.getErrorListener().isInstanceOf[XTFSaxonErrorListener]) then
      tf.setErrorListener(new XTFSaxonErrorListener())
    else ()
    tf.setAttribute(FeatureKeys.SOURCE_PARSER_CLASS, classOf[DTDSuppressingXMLReader].getName)
    tf
  }

  private val dcStyleSheet =
    transformerFactory.newTemplates(new StreamSource(Files.newInputStream(dcPreFilterFile.toPath)))

  private val expectedIncrease : Double = 0.2

  def transformStream(templates : Templates,paralelism : Int = 16) : ZPipeline[Any,Exception,Array[Byte],Either[Exception,Array[Byte]]] =
    ZPipeline.mapZIOParUnordered[Any,Exception,Array[Byte],Either[Exception,Array[Byte]]](paralelism) { inBytes =>
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
      } yield baos.toByteArray).refineOrDie { case ex : Exception => ex }.either
    }



