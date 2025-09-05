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

import java.io.{File, IOException}
import java.nio.file.{Files, Path, Paths}
import javax.xml.transform.Templates

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
  if(!dcPreFilterFile.exists()) then
    throw new RuntimeException()  
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
  


  private lazy val dcStyleSheet = {
    transformerFactory.newTemplates(new SAXSource(new InputSource(dcPreFilterFilter.toURL)))
    stylesheetCache.find(org.cdlib.xtf.util.Path.resolveRelOrAbs(
      xtfHomePath, "style/textIndexer/dcPreFilter.xsl"))
  }

  private val preFilters = Array(dcStyleSheet)
  def transform(f : File, handler : LuceneDocBuilderHandler) =
    // Instantiate a new XML parser, being sure to get the right one.
    val xmlParser = IndexUtil.createSAXParser()

    // Get the input source from the record.
    val xmlSource = new InputSource(Files.newBufferedReader(f.toPath))

    IndexUtil.applyPreFilters(preFilters,
      xmlParser.getXMLReader(),
      xmlSource,
      null,
      new SAXResult(handler));


  def readAndTransformFile(f : File) :
