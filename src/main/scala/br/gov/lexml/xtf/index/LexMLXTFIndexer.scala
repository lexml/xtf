package br.gov.lexml.xtf.index

import org.cdlib.xtf.textIndexer.{IndexerConfig, SrcTreeProcessor}
import org.cdlib.xtf.util.{SubDirFilter, Trace}

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
    val res = f
    val endTimeNano = System.nanoTime()
    val deltaSeconds = (endTimeNano - startTimeNano) / 1e9
    System.err.println(f"\nStarting [$desc%s]: ellapsed time: ${deltaSeconds}%.2f seconds.")
    System.err.flush()
    res

  @main
  def index : Unit =
    val cfgInfo = makeIndexConfig
    val xtfHomeFile = File(cfgInfo.xtfHomePath)
    val srcTreeProcessor = SrcTreeProcessor(cfgInfo)
    val srcRootFile = File(cfgInfo.indexInfo.sourcePath)
    val indexFile = File(cfgInfo.indexInfo.indexPath)
    val subDirFilter : SubDirFilter = null

    ellapse("processDir ") {
      srcTreeProcessor.processDir(srcRootFile, subDirFilter, true)
    }
    println("processDir ended. Calling srcTreeProcessor.close()")
    ellapse("srcTreeProcessor.close") {
      srcTreeProcessor.close()
    }