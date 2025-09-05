package br.gov.lexml.xtf.index

import org.cdlib.xtf.textIndexer.{IdxTreeOptimizer, IndexerConfig, SrcTreeProcessor}
import org.cdlib.xtf.util.{Path, SubDirFilter, Trace}

import java.io.File
import java.time.Instant

object LexMLXTFIndexer:
  def makeIndexConfig : IndexerConfig =
    val cfg = IndexerConfig()
    cfg.xtfHomePath = "/home/joao/git/senado/lexml-portal-docker/docker/lexml-carga-batch-docker/filesystem/var/aplicacoes/xtf"
    cfg.buildLazyFiles = false
    cfg.traceLevel = Trace.info;
    cfg.indexInfo.indexName = "default"
    cfg.indexInfo.sourcePath = "/zfs_lexml/www-data/doc" // "/zfs_lexml/www-data/doc"
    cfg.indexInfo.indexPath = "/zfs_lexml/www-data/xtf/index"
    cfg.indexInfo.setChunkSize(200)
    cfg.indexInfo.setChunkOvlp(20)
    cfg.indexInfo.docSelectorPath = "./style/textIndexer/docSelector.xsl"
    cfg.indexInfo.stopWords = "de e a do da o em para que no as os das dos com por na ou ao pelo pela sua nos como sobre aos"
    cfg.indexInfo.pluralMapPath = "./conf/pluralFolding/pluralMap.txt.gz"
    cfg.indexInfo.accentMapPath = "./conf/accentFolding/accentMap.txt"
    cfg.indexInfo.createSpellcheckDict = true
    cfg
  end makeIndexConfig

  inline def ellapse[T](desc : String)(f : => T) : T =
    val startTimeNano = System.nanoTime()
    System.err.println(s"\nStarting [$desc] ...")
    System.err.flush()
    try {
      f
    } catch {
      case t : Throwable =>
        t.printStackTrace()
        throw t
    } finally {
      val endTimeNano = System.nanoTime()
      val deltaSeconds = (endTimeNano - startTimeNano) / 1e9
      System.err.println(f"\nStarting [$desc%s]: ellapsed time: ${deltaSeconds}%.2f seconds.")
      System.err.flush()
    }

  @main
  def index : Unit =
    ellapse("index creationg") {
      val cfgInfo = makeIndexConfig
      val xtfHomeFile = File(cfgInfo.xtfHomePath)
      val srcTreeProcessor = SrcTreeProcessor(cfgInfo, tokenizedFields)
      val srcRootFile = File(cfgInfo.indexInfo.sourcePath)
      val indexFile = File(cfgInfo.indexInfo.indexPath)
      val subDirFilter: SubDirFilter = null

      val t1 = new Thread(new Runnable {
        override def run(): Unit =
          ellapse("processDir ") {
            srcTreeProcessor.processDir(srcRootFile, subDirFilter, true)
            srcTreeProcessor.finishInput()
          }
      }, "processDirThread")

      val t2 = new Thread(new Runnable {
        override def run(): Unit =
          ellapse("srcTreeProcessor.close") {
            srcTreeProcessor.close()
          }
      }, "closeThread")
      t1.start()
      t2.start()
      t1.join()
      t2.join()
      ellapse("optimization") {
        val optimizer = new IdxTreeOptimizer()
        val idxRootDir = new File(Path.resolveRelOrAbs(
          cfgInfo.xtfHomePath,
          cfgInfo.indexInfo.indexPath))
        optimizer.processDir(idxRootDir)
      }
    }
   
  val tokenizedFields : java.util.List[String] = {
    val l = new java.util.ArrayList[String]
    l.add("acronimo")
    l.add("anosDoutrina")
    l.add("apelido")
    l.add("autoridade")
    l.add("dataRepresentativa")
    l.add("date")
    l.add("description")
    l.add("descritor")
    l.add("doutrinaAutor")
    l.add("doutrinaBiblioteca")
    l.add("doutrinaClasse")
    l.add("doutrinaLingua")
    l.add("doutrinasReferenciadas")
    l.add("idDocumento")
    l.add("idSuperDocumento")
    l.add("localidade")
    l.add("oculto")
    l.add("relacionamentosSucessao")
    l.add("relacionamentosSucessaoInv")
    l.add("set")
    l.add("subject")
    l.add("text")
    l.add("textoAnotado")
    l.add("tipoDocumento")
    l.add("title")
    l.add("titleAlternativo")
    l.add("titleIndexacao")
    l.add("type")
    l.add("urn")
    l.add("year")
    l
  }
  
  val facetedFields : java.util.List[String] =
    import scala.jdk.CollectionConverters.SeqHasAsJava
    Seq[String](
      "facet-tipoDocumento",
      "facet-autoridade",
      "facet-doutrinaAutor",
      "facet-doutrinaLingua",
      "facet-doutrinaClasse",
      "facet-doutrinaBibDigital",
      "facet-doutrinaBiblioteca",
      "facet-acronimo",
      "facet-localidade",
      "facet-date",
      "facet-subject"
    ).asJava
