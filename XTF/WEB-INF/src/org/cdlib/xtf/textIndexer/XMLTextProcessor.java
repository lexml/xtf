package org.cdlib.xtf.textIndexer;


import java.io.*;
import java.nio.file.Files;
import java.util.*;
import java.util.zip.GZIPInputStream;
import javax.xml.parsers.SAXParser;
import javax.xml.transform.Templates;
import javax.xml.transform.sax.SAXResult;

import org.apache.lucene.document.DateTools;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.spelt.SpellWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.bigram.BigramStopFilter;
import org.cdlib.xtf.textEngine.XtfSearcher;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import org.cdlib.xtf.textEngine.IndexUtil;
import org.cdlib.xtf.textEngine.Constants;
import org.cdlib.xtf.textEngine.NativeFSDirectory;
import org.cdlib.xtf.util.CharMap;
import org.cdlib.xtf.util.Path;
import org.cdlib.xtf.util.Trace;
import org.cdlib.xtf.util.WordMap;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 * This class performs the actual parsing of the XML source text files and
 * generates index information for it. <br><br>
 *
 * The <code>XMLTextProcessor</code> class uses the configuration information
 * recorded in the {@link IndexerConfig} instance passed to add one or more
 * source text documents to the associated Lucene index. The process of indexing
 * an XML source document consists of breaking the document up into small
 * overlapping "chunks" of text, and indexing the individual words encountered
 * in each chunk. <br><br>
 *
 * The reason source documents are split into chunks during indexing is to
 * allow the search engine to load only small pieces of a document when
 * displaying summary "blurbs" for matched text. This significantly lowers the
 * memory requirements to display search results for multiple documents. The
 * reason chunks are overlapped is to allow proximity matches to be found
 * that span adjacent chunks. At this time, the maximum distance that a
 * proximity can be found using this approach is equal to or less than the
 * chunk size used when the text document was indexed. This is because
 * proximity search checks are currently only performed on two adjacent
 * chunks. <br><br>
 *
 * Within a chunk, adjacent words are considered to be one word apart. In
 * Lucene parlance, the <i><b>word bump</b></i> for adjacent words is one.
 * Larger word bump values can be set for sub-sections of a document. Doing
 * so makes proximity matches within a sub-section more relevant than ones that
 * span sections. <br><br>
 *
 * Word bump adjustments are made through the use of attributes added to nodes
 * in the XML source text file. The available word bump attributes are:
 *
 * <blockquote dir=ltr style="MARGIN-RIGHT: 0px">
 *   <b><code>xtf:sentencebump="</code><font color=#0000ff><i>xxx</i></font><code>"</code></b><br>
 *   Set the additional word distance implied by sentence breaks in the
 *   associated node. If not set explicitly, the default sentence bump value
 *   is 5. <br><br>
 *
 *   <b><code>xtf:sectiontype="</code><font color=#0000ff><i>xxx</i></font><code>"</code></b><br>
 *   While this attribute's primary purpose is to assign names to a section of
 *   text, it also forces sections with a different names to start in new, non-
 *   overlapping chunks. The net result is equivalent to placing an "infinite
 *   word bump" between differently named sections, causing proximity searches
 *   to never find a match that spans multiple sections. <br><br>
 *
 *   <b><code>xtf:proximitybreak</code></b><br>
 *   Forces its associated node in the source text to start in a new, non-overlapping
 *   chunk. As with new sections described above, the net result is equivalent to
 *   placing an "infinite word bump" between adjacent sections, causing proximity
 *   searches to never find a match that spans the proximity break. <br><br>
 * </blockquote>
 *
 * In addition to the the word bump modifiers described above, there are two
 * additional non-bump attributes that can be applied to nodes in a source text
 * file:
 *
 * <blockquote dir=ltr style="MARGIN-RIGHT: 0px">
 *   <b><code>xtf:boost="</code><font color=#0000ff><i>xxx</i></font><code>"</code></b><br>
 *   Boosts the ranking of words found in the associated node by multiplying
 *   their base relevance by the number <font color=#0000ff><i>xxx</i></font>.
 *   Normally, a boost value greater than <code>1.0</code> is used to emphasize
 *   the associated text, but values less than <code>1.0</code> can be used as
 *   an "inverse" boost to de-emphasize the relevance of text.  Also, since
 *   Lucene only applies boost values to entire chunks, changing the boost
 *   value for a node causes the text to start in a new, non-overlapping chunk.
 *   <br><br>
 *
 *   <b><code>xtf:noindex</code></b><br>
 *   This attribute when added to a source text node causes the contained text
 *   to not be indexed.
 * </blockquote>
 *
 * Normally, the above mentioned node attributes aren't actually in the source
 * text nodes, but are embedded via the use of an XSL pre-filter before the
 * node is indexed. The XSL pre-filter used is the one defined for the current
 * index in the XML configuration file passed to the <code>TextIndexer</code>.
 * <br><br>
 *
 * For both bump and non-bump attributes, the namespace <code>uri</code> defined
 * by the {@link XMLTextProcessor#xtfUri xtfUri} member must be specified for
 * the <code>XMLTextProcessor</code> to recognize and process them. <br><br>
 *
 */
public class XMLTextProcessor extends DefaultHandler 
{

    /** The set of stop words to remove while indexing. See
   *  {@link IndexInfo#stopWords} for details.
   */
  private Set<String> stopSet = null;

  /** The set of plural words to de-pluralize while indexing. See
   *  {@link IndexInfo#pluralMapPath} for details.
   */
  private WordMap pluralMap = null;

  /** The set of accented chars to remove diacritics from. See
   *  {@link IndexInfo#accentMapPath} for details.
   */
  private CharMap accentMap = null;

  /** A reference to the configuration information for the current index being
   *  updated. See the {@link IndexInfo} class description for more details.
   */
  private IndexInfo indexInfo;
  
  /** Whether to ignore file modification times */
  private boolean ignoreFileTimes;

  /** The base directory from which to resolve relative paths (if any) */
  private String xtfHomePath;

  /** List of files to process. For an explanation of file queuing, see the
   *  {@link XMLTextProcessor#processQueuedTexts() processQueuedTexts()} method.
   */
  private List<FileQueueEntry> fileQueue = new LinkedList<>();

  /** The location of the XML source text file currently being indexed. For
   *  more information about this structure, see the
   * {@link IndexSource} class.
   */
  private IndexSource curIdxSrc;

  /** Display name of the current file */
  private String curPrettyKey;

  /** The base directory for the current Lucene database. */
  private String indexPath;




  /** An Lucene index reader object, used in conjunction with the
   * {@link XMLTextProcessor#indexSearcher indexSearcher} to check if
   * the current document needs to be added to, updated in, or
   * removed from the index.
   */
  private IndexReader indexReader;

  /** An Lucene index searcher object, used in conjunction with the
   * {@link XMLTextProcessor#indexReader indexReader} to check if the
   * current document needs to be added to, updated in, or removed
   * from the index.
   */
  private IndexSearcher indexSearcher;

  /** An Lucene index writer object, used to add or update documents
   *  to the index currently opened for writing.
   */
  private IndexWriter indexWriter;

  /** Queues words for spelling dictionary creator */
  private SpellWriter spellWriter;

  private final List<String> tokenizedFields;


  /** Maximum number of document deletions to do in a single batch */
  private static final int MAX_DELETION_BATCH = 50;


  /** The namespace string used to identify attributes that must be processed
   *  by the <code>XMLTextProcessor</code> class. <br><br>
   *
   *  Indexer specific attributes are usuall inserted into XML source text
   *  elements by way of an XSL pre-filter. For these pre-filter attributes
   *  to be recognized by the <code>XMLTextProcessor</code>, this string
   *  ({@value}) must be set as the attributes <code>uri</code>. To learn more
   *  about pre-filter attributes, see the {@link XMLTextProcessor} class
   *  description.
   */
  private static final String xtfUri = "http://cdlib.org/xtf";

    public XMLTextProcessor(List<String> tokenizedFields) {
        this.tokenizedFields = tokenizedFields;
    }

    /**
   * Open a TextIndexer (Lucene) index for reading or writing. <br><br>
   *
   * The primary purpose of this method is to open the index identified by the
   * <code>cfgInfo</code> for reading and searching. Index reading and searching
   * operations are used to clean, cull, or optimize an index. Opening an index
   * for writing is performed by the method
   * {@link XMLTextProcessor#openIdxForWriting() openIdxForWriting()}
   * only when the index is being updated with new document information. <br><br>
   *
   * @param  homePath Path from which to resolve relative path names.<br>
   *
   * @param  idxInfo  A config structure containing information about the index
   *                  to open. <br>
   *
   * @param  clean    true to truncate any existing index; false to add to it.
   *                  <br><br>
   *                  
   * @param ignoreFileTimes true to ignore file time checks (only applies
   *                  during incremental indexing).
   *
   * @.notes
   *   This method will create an index if it doesn't exist, or truncate an index
   *   that does exist if the <code>clean</code> flag is set in the
   *   <code>cfgInfo</code> structure. <br><br>
   *
   *   This method makes a private internal reference
   *   {@link XMLTextProcessor#indexInfo indexInfo}
   *   to the passed configuration structure for use by other methods in this
   *   class. <br><br>
   *
   * @throws
   *   IOException  Any I/O exceptions that occurred during the opening,
   *                creation, or truncation of the Lucene index. <br><br>
   *
   */
  public void open(String homePath, IndexInfo idxInfo, boolean clean,
                   boolean ignoreFileTimes)
    throws IOException 
  {
    fileQueue = new LinkedList<>();
    
    try 
    {
      // Get a reference to the passed in configuration that all the
      // methods can access.
      //
      this.indexInfo = idxInfo;
      this.xtfHomePath = homePath;
      this.ignoreFileTimes = ignoreFileTimes;

      // Determine where the index database is located.
      indexPath = getIndexPath();

      // Determine the set of stop words to remove (if any)
      if (indexInfo.stopWords != null)
        stopSet = BigramStopFilter.makeStopSet(indexInfo.stopWords);

      // If we were told to create a clean index...
      if (clean) 
      {
        // Create the index db Path in case it doesn't exist yet.
        Path.createPath(indexPath);

        // And then create the index.
        createIndex(indexInfo);
      }

      // Otherwise...
      else 
      {
        // If it doesn't exist yet, create the index db Path. If it 
        // does exist, this call will do nothing.
        //
        Path.createPath(indexPath);

        // Get a Lucene style directory.
        FSDirectory idxDir = NativeFSDirectory.getDirectory(indexPath);

        // If an index doesn't exist there, create it.
        if (!IndexReader.indexExists(idxDir))
          createIndex(indexInfo);
      } // else( !clean )

      // Try to open the index for reading and searching.
      openIdxForReading();

      // Locate the index information document
      Hits match = indexSearcher.search(new TermQuery(new Term("indexInfo", "1")));

      // If we can't find it, then this index is either corrupt or
      // very old. Fail in either case.
      //
      if (match.length() == 0)
        throw new RuntimeException("Index missing indexInfo");

      Document doc = match.doc(0);
      
      // Ensure that the version is compatible.
      String indexVersion = doc.get("xtfIndexVersion");
      if (indexVersion == null)
        indexVersion = "1.0";
      if (indexVersion.compareTo(TextIndexer.REQUIRED_VERSION) < 0) {
        throw new RuntimeException(
          "Incompatible index version " + indexVersion + "; require at least " + 
          TextIndexer.REQUIRED_VERSION + "... consider re-indexing with '-clean'.");
      }

      // Ensure that the chunk size and overlap are the same.
      if (Integer.parseInt(doc.get("chunkSize")) != indexInfo.getChunkSize()) {
        throw new RuntimeException(
          "Index chunk size (" + doc.get("chunkSize") +
          ") doesn't match config (" + indexInfo.getChunkSize() + ")");
      }

      if (Integer.parseInt(doc.get("chunkOvlp")) != indexInfo.getChunkOvlp()) {
        throw new RuntimeException(
          "Index chunk overlap (" + doc.get("chunkOvlp") +
          ") doesn't match config (" + indexInfo.getChunkOvlp() + ")");
      }

      // Ensure that the stop-word settings are the same.
      String stopWords = indexInfo.stopWords;
      if (stopWords == null)
        stopWords = "";
      if (!doc.get("stopWords").equals(stopWords)) {
        throw new RuntimeException(
          "Index stop words (" + doc.get("stopWords") +
          ") doesn't match config (" + indexInfo.stopWords + ")");
      }

      // Read in the accent map, if there is one.
      String accentMapName = doc.get("accentMap");
      if (accentMapName != null && !accentMapName.isEmpty())
      {
        File accentMapFile = new File(
          Path.normalizePath(indexPath + accentMapName));
        InputStream stream = Files.newInputStream(accentMapFile.toPath());

        if (accentMapName.endsWith(".gz"))
          stream = new GZIPInputStream(stream);

        accentMap = new CharMap(stream);
      }

      // Read in the plural map, if there is one. Be sure to apply
      // the accent map (if any) to it so that plurals get mapped
      // whether they're accented or not.
      //
      String pluralMapName = doc.get("pluralMap");
      if (pluralMapName != null && !pluralMapName.isEmpty())
      {
        File pluralMapFile = new File(
          Path.normalizePath(indexPath + pluralMapName));
        InputStream stream = Files.newInputStream(pluralMapFile.toPath());

        if (pluralMapName.endsWith(".gz"))
          stream = new GZIPInputStream(stream);

        pluralMap = new WordMap(stream, accentMap);
      }
    } // try

    catch (IOException e) 
    {
      // Log the error caught.
      Trace.tab();
      Trace.error("*** IOException Opening or Creating Index: " + e);
      Trace.untab();

      // Shut down any open index files.
      close();

      // And pass the exception on.
      throw e;
    } // catch( IOException e )
  } // open()

  ////////////////////////////////////////////////////////////////////////////

  /**
   * Close the Lucene index. <br><br>
   *
   * This method closes the current open Lucene index (if any.) <br><br>
   *
   * @.notes
   *   This method closes any <code>indexReader</code>, <code>indexWriter</code>
   *   or <code>indexSearcher</code> objects open for the current Lucene index.
   *   <br><br>
   *
   * @throws
   *   IOException  Any I/O exceptions that occurred during the closing,
   *                of the Lucene index. <br><br>
   *
   */
  public void close()
    throws IOException 
  {
    if (spellWriter != null)
      spellWriter.close();
    if (indexWriter != null)
      indexWriter.close();
    if (indexSearcher != null)
      indexSearcher.close();
    if (indexReader != null)
      indexReader.close();

    spellWriter = null;
    indexWriter = null;
    indexSearcher = null;
    indexReader = null;
  } // close() 

  ////////////////////////////////////////////////////////////////////////////

  /**
   * Utility function to create a new Lucene index database for reading or
   * searching. <br><br>
   *
   * This method is used by the {@link XMLTextProcessor#createIndex(IndexInfo) createIndex() }
   * method to create a new or clean index for reading and searching. <br><br>
   *
   * @.notes
   *   This method creates the Lucene database for the index, and then adds
   *   an "index info chunk" that identifies the chunk size and overlap used.
   *   This information is required by the search engine to correctly detect
   *   and hilight proximity search results. <br><br>
   *
   * @throws
   *   IOException  Any I/O exceptions that occurred during the deletion of
   *                a previous Lucene database or during the creation of the
   *                new index currently specified by the internal
   *                {@link XMLTextProcessor#indexInfo indexInfo}
   *                structure. <br><br>
   *
   */
  private void createIndex(IndexInfo indexInfo)
    throws IOException 
  {
    try 
    {
      // Delete the old directory.
      Path.deleteDir(new File(indexPath));

      // First, make the index.
      Directory indexDir = NativeFSDirectory.getDirectory(indexPath);
      indexWriter = new IndexWriter(indexDir,
                                    new XTFTextAnalyzer(stopSet, pluralMap, accentMap),
                                    true);

      // Then add the index info chunk to it.
      Document doc = new Document();
      doc.add(new Field("indexInfo", "1", Field.Store.YES, Field.Index.UN_TOKENIZED));
      doc.add(new Field("xtfIndexVersion", TextIndexer.CURRENT_VERSION, Field.Store.YES, Field.Index.NO));
      doc.add(new Field("chunkSize", indexInfo.getChunkSizeStr(), Field.Store.YES, Field.Index.NO));
      doc.add(new Field("chunkOvlp", indexInfo.getChunkOvlpStr(), Field.Store.YES, Field.Index.NO));

      // If plural map, accent map, and/or validation files were specified, copy them to the
      // index directory.
      //
      copyDependentFile(indexInfo.pluralMapPath,  "pluralMap", doc);
      copyDependentFile(indexInfo.accentMapPath,  "accentMap", doc);
      copyDependentFile(indexInfo.validationPath, "validation", doc);

      File tokenizedFieldsFile =
              new File(Path.normalizePath(indexPath) + "tokenizedFields.txt");
      if(!tokenizedFieldsFile.exists()) {
          try (PrintWriter pw = new PrintWriter(new FileWriter(tokenizedFieldsFile))) {
              for(String field : tokenizedFields) {
                  pw.println(field);
              }
          }
      }

      // Copy the stopwords to the index
      String stopWords = indexInfo.stopWords;
      if (stopWords == null)
        stopWords = "";
      doc.add(new Field("stopWords", stopWords, Field.Store.YES, Field.Index.NO));
      indexWriter.addDocument(doc);
    } // try

    finally 
    {
      // Finish up.
      if (indexWriter != null) {
        indexWriter.close();
        indexWriter = null;
      }
    } // finally
  } // createIndex()

  ////////////////////////////////////////////////////////////////////////////

  private void copyDependentFile(String filePath, String fieldName, Document doc)
      throws IOException 
  {
    if (filePath != null && !filePath.isEmpty()) {
      File sourceFile = new File(Path.resolveRelOrAbs(xtfHomePath, filePath));
      File targetFile = new File(new File(indexPath), sourceFile.getName());
      Path.copyFile(sourceFile, targetFile);
      doc.add(new Field(fieldName, sourceFile.getName(), Field.Store.YES, Field.Index.NO));
    }
  }

  ////////////////////////////////////////////////////////////////////////////

  /** Check and conditionally queue a source text file for
   *  (re)indexing. <br><br>
   *
   *  This method first checks if the given source file is already in the
   *  index. If not, it adds it to a queue of files to be (re)indexed.
   *
   *  @param idxSrc  The source to add to the queue of sources to be
   *                 indexed/reindexed. <br><br>
   *
   *  @.notes
   *    For more about why source text files are queued, see the
   *    {@link XMLTextProcessor#processQueuedTexts() processQueuedTexts()}
   *    method. <br><br>
   *
   */
  public void checkAndQueueText(IndexSource idxSrc)
    throws IOException
  {
    // Check the status of this file. If the index is already up to date, 
    // we're done.
    //
    int ret = checkFile(idxSrc);
    if (ret == 1)
      return;

    // Otherwise, queue it to be indexed. If an older version is already in
    // the index, make sure it will get deleted before re-indexing it.
    //
    boolean deleteFirst = (ret == 2);
    queueText(idxSrc, deleteFirst);
  } // checkAndQueueText()

  ////////////////////////////////////////////////////////////////////////////

  /** Queue a source text file for (re)indexing. <br><br>
   *
   *  @param srcInfo  The source XML text file to add to the queue of
   *                  files to be indexed/reindexed. <br><br>
   *
   *  @.notes
   *    For more about why source text files are queued, see the
   *    {@link XMLTextProcessor#processQueuedTexts() processQueuedTexts()}
   *    method. <br><br>
   *
   */
  public void queueText(IndexSource srcInfo, boolean deleteFirst) {
    fileQueue.add(new FileQueueEntry(srcInfo, deleteFirst));
  } // queueText( IndexSource, boolean )

  ////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////

  /** If the first entry in the file queue requires deletion, we start up
   *  a batch delete up to {@link #MAX_DELETION_BATCH} deletions. We batch
   *  these up because in Lucene, you can only delete with an IndexReader.
   *  It costs time to close our IndexWriter, open an IndexReader for
   *  the deletions, and then reopen the IndexWriter.
   *
   *  @throws
   *    IOException   Any I/O exceptions encountered when reading the source
   *                  text file or writing to the Lucene index. <br><br>
   */
  public void batchDelete()
    throws IOException 
  {
    // If the first queue entry doesn't need deletion, don't do anything.
    if (fileQueue.isEmpty() || !fileQueue.get(0).deleteFirst)
      return;

    // Okay, we need an index reader for the deletions. This has the effect
    // of closing the index writer, but it will be reopened after the 
    // deletions.
    //
    openIdxForReading();

    // Let's do it.
    int batchSize = 0;
    Iterator<FileQueueEntry> iter = fileQueue.iterator();
    while (iter.hasNext() && batchSize < MAX_DELETION_BATCH) 
    {
      FileQueueEntry ent = iter.next();
      batchSize++;

      // Skip entries that don't need deleting.
      if (!ent.deleteFirst)
        continue;

      // Okay, delete chunks from the old document, and clear the flag.
      indexReader.deleteDocuments(new Term("key", ent.idxSrc.key()));
      ent.deleteFirst = false;
    }
  } // public batchDelete()

  ////////////////////////////////////////////////////////////////////////////

  /** Process the list of files queued for indexing or reindexing. <br><br>
   *
   *  This method iterates through the list of queued source text files,
   *  (re)indexing the files as needed. <br><br>
   *
   *  @throws
   *    IOException   Any I/O exceptions encountered when reading the source
   *                  text file or writing to the Lucene index. <br><br>
   *
   *  @.notes
   *    Originally, the <code>XMLTextProcessor</code> opened the Lucene
   *    database, (re)indexed the source file, and then closed the database
   *    for each XML file encountered in the source tree. Unfortunately,
   *    opening and closing the Lucene database is a fairly time consuming
   *    operation, and doing so for each file made the time to index an entire
   *    source tree much higher than it had to be. So to minimize the open/close
   *    overhead, the <code>XMLTextProcessor</code> was changed to traverse
   *    the source tree first and collect all the XML filenames it found into a
   *    processing queue. Once the files were queued, the Lucene database could
   *    be opened, all the files in the queue could be (re)indexed, and the
   *    database could be closed. Doing so significantly reduced the time to
   *    index the entire source tree. <br><br>
   *
   *    It should be noted that each file in the queue is identified by a
   *    "relocatable" path to the source tree directory where it was found,
   *    and that this relocatable path is stored in the Lucene database when
   *    the file is indexed. This relocatable path consists of the index name
   *    followed by the source tree sub-path at which the file is located.
   *    Storing this relocatable file path in the index allows the indexer
   *    and the search engine to correctly locate the source text, even if
   *    the source tree base directory has been renamed or moved. Correctly
   *    locating the original source text for chunks in an index is necessary
   *    when displaying search results, or to determine if source text needs
   *    to be reindexed due to changes, or removed from an index because
   *    it no longer exists. Ultimately, both the indexer and the query
   *    engine use the {@linkplain XMLConfigParser index configuration file} to
   *    map the index name back into an absolute path when a source text needs
   *    to be accessed. <br><br>
   *
   */
  public void processQueuedTexts()
    throws IOException 
  {
    // Initialize the string buffers for accumulating and compacting the 
    // text to index.
    //



    // Calculate the total size of files in the queue
    long totalSize = 0;
    for (FileQueueEntry ent : fileQueue) {
      totalSize += ent.idxSrc.totalSize();
    }
    if (totalSize < 1)
      totalSize = 1; // avoid divide-by-zero problems
    long processedSize = 0;

    final Handler handler = new Handler(indexInfo.stripWhitespace);

    // Process each queued file.
    while (!fileQueue.isEmpty()) 
    {


      // Process deletions in batches.
      batchDelete();

      // Open the index writer (which might have been closed by a batch
      // deletion.)
      //
      openIdxForWriting();

      // Get the next file.
      FileQueueEntry ent = fileQueue.remove(0);
      IndexSource idxFile = ent.idxSrc;
      assert !ent.deleteFirst; // Should have been processed by batchDelete()

      try {

          final long fileBytesDone = idxFile.totalSize();
          final int prevPercentDone = (int)((processedSize) * 100 / totalSize);
          final int percentDone = (int)((processedSize + fileBytesDone) * 100 / totalSize);
          if(prevPercentDone < percentDone) {
              final StringBuilder msg = new StringBuilder();
              msg.append("(").append(percentDone).append("%) ");
              Trace.info(msg.toString());
          }
          // Now index this record.
          processText(idxFile, handler);

      }
      catch (SAXException e) 
      {
        throw new RuntimeException(e);
      }

      processedSize += idxFile.totalSize();
    }
  } // processQueuedTexts()

  ////////////////////////////////////////////////////////////////////////////

  /**
   * Add the specified XML source record to the active Lucene index.
   * <p>
   * This method indexes the specified XML source text file, adding it to the
   * Lucene database currently specified by the {@link #indexPath} member.
   *
   * @param file The XML source text file to process.
   * @.notes To learn more about the actual mechanincs of how XML source files are
   * indexed, see the {@link XMLTextProcessor} class description.
   *
   */
  private void processText(IndexSource file, Handler handler)
    throws SAXException
  {


    // Record the file's parameters so other methods can get to them easily. Then
    // tell the user what we're doing.
    //
    curIdxSrc = file;

    // Now parse it.
      parseText(handler);
  } // processText()

  ////////////////////////////////////////////////////////////////////////////

  /**
   * Parse the XML source text file specified. <br><br>
   * <p>
   * This method instantiates a SAX XML file parser and passes this class
   * as the token handler. Doing so causes the
   * {@link XMLTextProcessor#startDocument() startDocument()},
   * {@link XMLTextProcessor#startElement(String, String, String, Attributes) startElement()},
   * {@link XMLTextProcessor#endElement(String, String, String) endElement()},
   * {@link XMLTextProcessor#endDocument() endDocument()}, and
   * {@link XMLTextProcessor#characters(char[], int, int) characters()}
   * methods in this class to be called. These methods in turn process the
   * actual text in the XML source document, "blurbifying" the text, breaking
   * it up into overlapping chunks, and adding it to the Lucene index. <br><br>
   *
   * @.notes method. <br><br>
   * <p>
   * This function enables namespaces for XML tag attributes. Consquently,
   * attributes such as <code>sectiontype</code> and <code>proximitybreak</code>
   * are assumed to be prefixed by the namespace <code>xtf</code>. <br><br>
   * <p>
   * If present in the {@link XMLTextProcessor#indexInfo indexInfo} member,
   * the XML file will be prefiltered with the specified XSL filter before
   * XML parsing begins. This allows node attributes to be inserted that
   * modify the proximity of various text sections as well as boost or
   * deemphasize the relevance sections of text. For a description of
   * attributes handled by this XML parser, see the {@link XMLTextProcessor}
   * class description. <br><br>
   */
  private void parseText(final Handler handler) //curIdxSrc, indexInfo.passThroughAtttribs, curPrettyKey
  {
    try 
    {
      // Instantiate a new XML parser, being sure to get the right one.
      final SAXParser xmlParser = IndexUtil.createSAXParser();

      // Get the input source from the record.
      final InputSource xmlSource = curIdxSrc.getInputSource();

      // If there are no XSLT input filters defined for this index, just 
      // parse the source XML file directly, and return early.
      //
      final Templates[] prefilters = curIdxSrc.preFilters();
      if (prefilters == null || prefilters.length == 0) {
        xmlParser.parse(xmlSource, this);
        return;
      }


      handler.init(curIdxSrc.key(),curIdxSrc.lastModified());
      // Apply the prefilters.
      IndexUtil.applyPreFilters(prefilters,
                                xmlParser.getXMLReader(),
                                xmlSource,
                                indexInfo.passThroughAttribs,
                                new SAXResult(handler));

      // Get the analyzer that will be used to tokenize fields. Tell it to
      // forget what it knows about facet fields (we'll re-mark them below.)
      //
      XTFTextAnalyzer analyzer = (XTFTextAnalyzer)indexWriter.getAnalyzer();
      analyzer.clearFacetFields();

      handler.getFacetedFields().forEach(analyzer::addFacetField);

      try {
          // Add the document info block to the index.
          indexWriter.addDocument(handler.getDocument());
      } catch (Throwable t) {
          // Log the problem.
          Trace.tab();
          Trace.error("*** Exception Adding docInfo to Index: " + t);
          Trace.untab();

          if (t instanceof RuntimeException)
              throw (RuntimeException)t;
          else
              throw new RuntimeException(t);
      }
    } // try

    catch (Throwable t) 
    {

      // Tell the caller (and the user) that ther was an error..      
      Trace.more(Trace.info, "Skipping Due to Errors");

      String message = "*** XML Parser Exception: " + t.getClass() + "\n" +
                       "    With message: " + t.getMessage() + "\n" +
                       "    File: " + curPrettyKey;

      Trace.info(message);

    } // try( to filter the input file )

    // If we got to this point, tell the caller that all went well.
  } // public parseText()

    ////////////////////////////////////////////////////////////////////////////

    /**
     * Adds a field to the on-disk list of tokenized fields for an index.
     * Exceptions are handled internally and thrown as RuntimeException.
     */
    private void addToTokenizedFieldsFile(Collection<String> fields) {
        System.err.println("DEBUG: addToTokenizedFieldsFiled called: " +
                fields);
        try
        {
            // If we wrote directly to the file, it could mess with indexes that have
            // hard-links to the existing file. Instead, write a new one and then rename.
            //
            String path = Path.normalizePath(indexPath) + "tokenizedFields.txt";
            File oldFile = new File(path);
            File tmpFile = new File(path + ".tmp");
            BufferedWriter writer = new BufferedWriter(new FileWriter(tmpFile));
            try
            {
                // If there is an existing file...
                if (oldFile.canRead())
                {
                    BufferedReader reader = new BufferedReader(new FileReader(oldFile));
                    try
                    {
                        // ...copy the existing fields
                        while (true) {
                            String line = reader.readLine();
                            if (line == null)
                                break;
                            writer.write(line + "\n");
                        }
                    }
                    finally {
                        reader.close();
                    }
                }

                // Write the new field
                for(String field : fields) {
                    writer.write(field + "\n");
                }
            }
            finally {
                writer.close();
            }

            // Now replace the old file with the new one.
            tmpFile.renameTo(oldFile);
        }

        // If something went wrong...
        catch (Throwable t)
        {
            // Log the problem.
            Trace.tab();
            Trace.error("*** Exception Adding to tokenizedFields.txt: " + t);
            Trace.untab();

            if (t instanceof RuntimeException)
                throw (RuntimeException)t;
            else
                throw new RuntimeException(t);
        }
    }


    private static class Handler extends DefaultHandler {
        /**
         * Map special characters in XML to their entity equivalents.
         */
        private static String mapXMLChars(String str)
        {
            if (str.indexOf('&') >= 0)
                str = str.replaceAll("&", "&amp;");
            if (str.indexOf('<') >= 0)
                str = str.replaceAll("<", "&lt;");
            if (str.indexOf('>') >= 0)
                str = str.replaceAll(">", "&gt;");
            return str;
        }
      /** Flag indicating how deeply nested in a meta-data section the current
       *  text/tag being processed is.
       */
      private int inMeta = 0;

      /** The current meta-field data being processed. */
      private MetaField metaField;

      /** A buffer for accumulating meta-text from the source XML file. */
      private final StringBuffer metaBuf = new StringBuffer();

      /** Character buffer for accumulating partial text blocks (possibly) passed
       *  in to the {@link XMLTextProcessor#characters(char[],int,int) characters()}
       *  method from the SAX parser.
       */
      private char[] charBuf = new char[1024];

      /** Current end of the {@link XMLTextProcessor.Handler#charBuf charBuf} buffer. */
      private int charBufPos = 0;

      private final boolean stripWhiteSpace;

      private final List<MetaField> metaFields = new LinkedList<>();

      /** The number of chunks of XML source text that have been processed. Used
       *  to assign a unique chunk number to each chunk for a document.
       */
      private int chunkCount = 0;

      private String key;

      private long lastModified;

      private Document doc = new Document();

      private final Set<String> facetedFields = new HashSet<>();

      private final Set<String> tokenizedFields = new HashSet<>();

      public Handler(boolean stripWhiteSpace) {
        this.stripWhiteSpace = stripWhiteSpace;
        this.metaBuf.ensureCapacity(65536);
      }

      public void init(String key, long lastModified) {
          this.facetedFields.clear();
          this.tokenizedFields.clear();
          this.doc = new Document();
          this.key = key;
          this.lastModified = lastModified;
          this.chunkCount = 0;
          this.metaFields.clear();
          this.charBufPos = 0;
          this.metaBuf.setLength(0);
          this.inMeta = 0;
      }

      public Document getDocument() {
          return doc;
      }

      public Set<String> getFacetedFields() {
          return facetedFields;
      }

      public Set<String> getTokenizedFields() {
          return tokenizedFields;
      }


      ////////////////////////////////////////////////////////////////////////////

      /** Build a string representing any non-XTF attributes in the given
       *  attribute list. This will be a series of name="value" pairs, separated
       *  by spaces. If there are no non-XTF attributes, empty string is returned.
       *  <br><br>
       */
      private String processMetaAttribs(Attributes atts)
      {
          StringBuilder buf = new StringBuilder();

          // Scan the list
          for (int i = 0; i < atts.getLength(); i++)
          {
              // Skip XTF-specific attributes
              String attrUri = atts.getURI(i);
              if (attrUri.equals(xtfUri))
                  continue;

              // Found one. Add it to the buffer, being certain to map special chars
              // (e.g. attribute values with ampersands in the string).
              //
              if (buf.length() > 0)
                  buf.append(' ');
              String name = atts.getLocalName(i);
              String value = atts.getValue(i);
              buf.append(name).append("=\"").append(mapXMLChars(value)).append("\"");
          } // for i

          // All done.
          return buf.toString();
      } // processMetaAttribs( Attributes atts )

      ////////////////////////////////////////////////////////////////////////////

      /** Process the start of a new XML source text element/node/tag. <br><br>
       *
       *  Called by the XML file parser each time a new start tag is encountered.
       *  <br><br>
       *
       *  @param  uri        Any namespace qualifier that applies to the current
       *                     XML tag.
       *
       *  @param  localName  The non-qualified name of the current XML tag.
       *
       *  @param  qName      The qualified name of the current XML tag.
       *
       *  @param  atts       Any attributes for the current tag. Note that only
       *                     attributes that are in the namespace specified by the
       *                     {@link XMLTextProcessor#xtfUri xtfUri}
       *                     member of this class are actually processed by this
       *                     method. <br><br>
       *
       *  @.notes
       *    This method processes any text accumulated before the current start tag
       *    was encountered by calling the {@link XMLTextProcessor.Handler#flushCharacters() flushCharacters()}
       *    method.  <br><br>
       */
      public void startElement(String uri, String localName, String qName,
                               Attributes atts)

      {
          // Process any characters accumulated for the previous node, writing them
          // out as chunks to the index if needed.
          //
          flushCharacters();

          // If this is the start of a meta data node (marked with an xtf:meta
          // attribute), read in the meta data. Note that these meta-data nodes are
          // not indexed as part of the general text.
          //
          int metaIndex = atts.getIndex(xtfUri, "meta");
          String metaVal = (metaIndex >= 0) ? atts.getValue(metaIndex) : "";
          if (metaIndex >= 0 && ("yes".equals(metaVal) || "true".equals(metaVal))) {
              if (inMeta > 0)
                  throw new RuntimeException("Meta-data fields may not nest");

              inMeta = 1;

              // See if there is a "store" attribute set for this node. If not,
              // default to true.
              //
              boolean store = true;
              int tokIdx = atts.getIndex(xtfUri, "store");
              if (tokIdx >= 0) {
                  String tokStr = atts.getValue(tokIdx);
                  if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                      store = false;
              }

              // See if there is an "index" attribute set for this node. If not,
              // default to true.
              //
              boolean index = true;
              tokIdx = atts.getIndex(xtfUri, "index");
              if (tokIdx >= 0) {
                  String tokStr = atts.getValue(tokIdx);
                  if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                      index = false;
              }

              // See if there is a "noIndex" attribute set for this node.
              tokIdx = atts.getIndex(xtfUri, "noIndex");
              if (tokIdx >= 0) {
                  String tokStr = atts.getValue(tokIdx);
                  if (tokStr != null && (tokStr.equals("yes") || tokStr.equals("true")))
                      index = false;
              }

              // See if there is a "tokenize" attribute set for this node. If not,
              // default to true.
              //
              boolean tokenize = true;
              tokIdx = atts.getIndex(xtfUri, "tokenize");
              if (tokIdx >= 0) {
                  String tokStr = atts.getValue(tokIdx);
                  if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                      tokenize = false;
              }

              // See if there is a "facet" attribute set for this node. If not,
              // default to false.
              //
              boolean isFacet = false;
              tokIdx = atts.getIndex(xtfUri, "facet");
              if (tokIdx >= 0) {
                  String tokStr = atts.getValue(tokIdx);
                  if (tokStr != null && (tokStr.equals("yes") || tokStr.equals("true")))
                      isFacet = true;
              }

              // See if there is a "wordBoost" attribute for this node. If not,
              // default to 1.0f.
              //
              float boost = 1.0f;
              int boostIdx = atts.getIndex(xtfUri, "wordBoost");
              if (boostIdx < 0)
                  boostIdx = atts.getIndex(xtfUri, "wordboost");
              if (boostIdx >= 0) {
                  String boostStr = atts.getValue(boostIdx);
                  boost = Float.parseFloat(boostStr);
              }

              // Certain field names are reserved for internal use.
              if (localName.matches("^(text|key|docInfo|chunkCount|chunkOvlp|chunkSize|fileDate|indexInfo|stopWords|tokenizedFields|xtfIndexVersion)$"))
                  throw new RuntimeException("Reserved name '" + localName + "' not allowed as meta-data field");

              // Allocate a place to store the contents of the meta-data field.
              metaField = new MetaField(localName,
                      store,
                      index,
                      tokenize,
                      isFacet,
                      boost);
              assert metaBuf.length() == 0 : "Should have cleared meta-buf";

              // If there are non-XTF attributes on the node, record them.
              String attrString = processMetaAttribs(atts);
              if (!attrString.isEmpty())
                  metaBuf.append("<$ ").append(attrString).append(">");
          }

          // If there are nested tags below a meta-field (and if they're not
          // meta-fields themselves), keep track of how far down they go, so we can
          // know when we hit the end of the top-level tag.
          //
          else if (inMeta > 0) {
              inMeta++;
              metaBuf.append("<").append(localName);
              String attrString = processMetaAttribs(atts);
              if (!attrString.isEmpty())
                  metaBuf.append(" ").append(attrString);
              metaBuf.append(">");
          }
      } // public startElement()

      ////////////////////////////////////////////////////////////////////////////

      /** Process the end of a new XML source text element/node/tag. <br><br>
       *
       *  Called by the XML file parser each time an end-tag is encountered.
       *  <br><br>
       *
       *  @param  uri        Any namespace qualifier that applies to the current
       *                     XML tag.
       *
       *  @param  localName  The non-qualified name of the current XML tag.
       *
       *  @param  qName      The qualified name of the current XML tag. <br><br>
       *
       *  @.notes
       *    This method processes any text accumulated before the current end tag
       *    was encountered by calling the
       *    {@link XMLTextProcessor.Handler#flushCharacters() flushCharacters()} method. <br><br>
       */
      public void endElement(String uri, String localName, String qName)

      {
          // Process any characters accumulated for the previous node, writing them
          // out as chunks to the index if needed.
          //
          flushCharacters();

          // If we're in a meta-data field, record the end tag (except if it's the
          // top-level tag, which we leave out to save space on non-structured
          // meta-data.)
          //
          if (inMeta > 1)
              metaBuf.append("</").append(localName).append(">");

          // If this is the end of a meta-data field, record it.
          if (inMeta == 1) {
              metaField.value = metaBuf.toString().trim();

              // If tokenized, add the special start-of-field and end-of-field tokens
              // to the meta-data value.
              //
              if (metaField.tokenize && !metaField.isFacet)
              {
                  // If attributes were recorded for the top-level node, be sure to
                  // put the start marker after them.
                  //
                  if (!metaField.value.isEmpty() && metaField.value.charAt(0) == '<') {
                      int insertPoint = metaField.value.indexOf('>') + 1;
                      metaField.value = metaField.value.substring(0, insertPoint) +
                              Constants.FIELD_START_MARKER +
                              metaField.value.substring(insertPoint) +
                              Constants.FIELD_END_MARKER;
                  }
                  else {
                      metaField.value = Constants.FIELD_START_MARKER + metaField.value +
                              Constants.FIELD_END_MARKER;
                  }
              }

              // Lucene will fail subtly if we add two fields with the same name.
              // Basically, the terms for each field are added at overlapping
              // positions, causing a phrase search to easily span them. To counter
              // this, we stick them all together in one field, but add word bump
              // separators to keep hits from occurring across one and the next.
              // We use the special word bump 'x' to mean a million, which should be
              // quite sufficient to keep matches from spanning these boundaries.
              //
              // Of course, we only need to do this work for tokenized fields (as
              // we must assume that untokenized fields will be used for sorting and
              // grouping only, and glomming things together would mess that up.)
              //

              for (Iterator<MetaField> i = metaFields.iterator(); i.hasNext();)
              {
                  MetaField mf = i.next();
                  boolean found = mf.name.equals(metaField.name);

                  // Overwrite inherited field of the same name
                  if (found) {
                      i.remove();
                  }
              }

              // Record the new field.
              metaFields.add(metaField);

              metaField = null;
              metaBuf.setLength(0);
              inMeta = 0;
          }
          else if (inMeta > 1)
              inMeta--;
      } // public endElement()

      ////////////////////////////////////////////////////////////////////////////
      public void processingInstruction(String target, String data) {
          // Filter out processing instructions.
      } // processingInstruction()


      ////////////////////////////////////////////////////////////////////////////

      /** Accumulate chunks of text encountered between element/node/tags.
       *
       *  @param  ch      A block of characters from which to accumulate text.
       *                  <br><br>
       *
       *  @param  start   The starting offset in <code>ch</code> of the characters
       *                  to accumulate. <br><br>
       *
       *  @param  length  The number of characters to accumulate from <code>ch</code>.
       *                  <br><br>
       *
       *  @.notes
       *    Depending on how the XML parser is implemented, a call to this function
       *    may or may not receive all the characters encountered between two tags
       *    in an XML file. However, for the <code>XMLTextProcessor</code> to
       *    correctly assemble overlapping chunks for the Lucene database, it needs
       *    to have all the characters between two tags available as a single chunk
       *    of text. Consequently this method simply accumulates text, and calls
       *    calls from the XML parser to
       *    {@link XMLTextProcessor#startElement(String,String,String,Attributes) startElement()}
       *    and
       *    {@link XMLTextProcessor#endElement(String,String,String) endElement()}
       *    trigger the actual processing of accumulated text.
       */
      public void characters(char[] ch, int start, int length) {
          // If the accumulation buffer is not big enough to receive the current
          // block of new characters...
          //
          if (charBufPos + length > charBuf.length)
          {
              // Hang on to the old buffer.
              char[] old = charBuf;

              // Create a new buffer that does have space plus a bit (to try to
              // avoid unnecessary reallocations for any small additional chunks
              // that might follow.)
              //
              charBuf = new char[charBufPos + length + 1024];

              // And copy the previously accumulated text into the new buffer.
              System.arraycopy(old, 0, charBuf, 0, charBufPos);
          }

          // Add the new block of text to the accumulation buffer, and update the
          // count of accumulated characters.
          //
          System.arraycopy(ch, start, charBuf, charBufPos, length);
          charBufPos += length;
      } // public characters()

      ////////////////////////////////////////////////////////////////////////////

      /** Process any accumulated source text, writing indexing completed chunks
       *  to the Lucene database as necessary. <br><br>
       *
       *  @.notes
       *    This method processes any accumulated text as follows:
       *
       *    <blockquote dir=ltr style="MARGIN-RIGHT: 0px">
       *     1. First the accumulated text is "blurbified." See the
       *        method for more information about what this entails. <br><br>
       *
       *     2. Next, a chunk is assembled a word at a time from the accumulated
       *        text until the required chunk size (in words) is reached. The
       *        completed chunk is then added to the Lucene database.
       *        <br><br>
       *
       *     3. Step two is repeated until no more complete chunks can be assembled
       *        from the accumulated text. (Any partial chunk text is saved until
       *        the next call to this method.)
       *     </blockquote>
       */
      public void flushCharacters()
      {
          // Get local references to the accumulated text buffer that we can
          // adjust as we go.
          //
          char[] ch = charBuf;
          int length = charBufPos;
          int start = 0;

          // Reset the accumulated character count to zero in anticipation of
          // accumulating characters for a new node later on. (Do this now because
          // of multiple exit points in this function.)
          //
          charBufPos = 0;

          // If the entire buffer is whitespace (or empty), we can safely strip it.
          int i = 0;
          if (stripWhiteSpace) {
              for (i = 0; i < length; i++)
                  if (!Character.isWhitespace(charBuf[i]))
                      break;
          }
          if (i == length)
              return;

          // If we're processing a meta-info section, simply add the characters to
          // the meta-info buffer.
          //
          if (inMeta > 0)
          {
              String tmp = new String(ch, start, length);

              // Map special XML characters to entities, so we can tell the difference
              // between these and embedded XML in the meta-data.
              //
              tmp = mapXMLChars(tmp);
              metaBuf.append(tmp);
          }

      } // public characters()

      ////////////////////////////////////////////////////////////////////////////

      /** Perform any final document processing when the end of the XML source
       *  text has been reached. <br><br>
       *
       *  Called by the XML file parser when the end of the source document is
       *  encountered. <br><br>
       *
       *  @throws  SAXException  Any exceptions generated during the final writing
       *                         of the Lucene database or the "lazy tree"
       *                         representation of the XML file. <br><br>
       *
       *  @.notes
       *    This method indexes any remaining accumulated text, adds any remaining
       *    text to the "lazy tree" representation of the the XML document, and
       *    writes out the document summary record (chunk) to the Lucene database.
       *    <br><br>
       *
       */


      /** Save document information associated with a collection of chunks. <br><br>
       *
       *  This method saves a special document summary information chunk to the
       *  Lucene database that binds all the indexed text chunks for a document
       *  back to the original XML source text.
       *
       *  @.notes
       *    The document summary chunk is the last chunk written to a Lucene
       *    database for a given XML source document. Its presence or absence
       *    then can be used to identify whether or a document was completely
       *    indexed or not. The absence of a document summary for any given
       *    text chunk implies that indexing was aborted before the document
       *    was completely indexed. This property of document summary chunks
       *    is used by the  {@link IdxTreeCleaner} class to stript out any
       *    partially indexed documents.<br><br>
       *
       *    The document summary includes the relative path to the original
       *    XML source text, the number of chunks indexed for the document,
       *    a unique key that associates this summary with all the indexed
       *    text chunks, the date the document was added to the index, and any
       *    meta-data associated with the document. <br><br>
       */
      public void endDocument() {
          // Add a header flag as a stored, indexed, non-tokenized field
          // to the document database.
          //
          doc.add(new Field("docInfo", "1",
                  Field.Store.YES, Field.Index.UN_TOKENIZED));

          // Add the number of chunks in the index for this document.
          doc.add(new Field("chunkCount",
                  Integer.toString(chunkCount),
                  Field.Store.YES, Field.Index.NO));

          // Reset the chunk count, in case this is just a subdocument within
          // the larger text. Also reset the word counter for this sub-doc.
          //
          chunkCount = 0;

          // Add the key to the document header as a stored, indexed,
          // non-tokenized field.
          //
          doc.add(new Field("key", key,
                  Field.Store.YES, Field.Index.UN_TOKENIZED));


          if (lastModified >= 0L) {
              String fileDateStr = DateTools.timeToString(
                      lastModified, DateTools.Resolution.MILLISECOND);

              // Add the XML file modification date as a stored, non-indexed,
              // non-tokenized field.
              //
              doc.add(new Field("fileDate", fileDateStr, Field.Store.YES, Field.Index.NO));
          }



          // Make sure we got meta-info for this document.
          if (metaFields.isEmpty()) {
              Trace.tab();
              Trace.warning("*** Warning: No meta data found for document.");
              Trace.untab();
          } else {
              // Add all the meta fields to the docInfo chunk.
              for (MetaField metaField : metaFields) {
                  // If it's a facet field, tell the analyzer so it knows to apply
                  // special tokenization.
                  //
                  if (metaField.isFacet && metaField.index) {
                      metaField.tokenize = true;
                      facetedFields.add(metaField.name); // analyzer.addFacetField(metaField.name);
                  }

                  // Add it to the document. Store, index, and/or tokenize as
                  // specified by the field.
                  //
                  Field docField = new Field(metaField.name,
                          metaField.value,
                          metaField.store ? Field.Store.YES : Field.Store.NO,
                          metaField.index ?
                                  (metaField.tokenize ?
                                          Field.Index.TOKENIZED
                                          : Field.Index.UN_TOKENIZED)
                                  : Field.Index.NO);
                  docField.setBoost(metaField.wordBoost);
                  doc.add(docField);

                  // Record which fields are tokenized, the first time we notice
                  // the fact. It doesn't matter which document we do this on, as
                  // the reader code simply iterates the terms.
                  //
                  if (metaField.tokenize && !metaField.isFacet) {
                      tokenizedFields.add(metaField.name);
                  }
              } // while(  metaIter.hasNext() )
          } // else( metaInfo != null && !metaInfo.isEmpty() )


      } // saveDocInfo()
  }

  /** Returns a normalized version of the base path of the Lucene database
   *  for an index. <br><br>
   *
   *  @throws IOException  Any exceptions generated retrieving the path for
   *                       a Lucene database. <br><br>
   */
  private String getIndexPath()
    throws IOException 
  {
    String idxPath = Path.resolveRelOrAbs(xtfHomePath, indexInfo.indexPath);
    return Path.normalizePath(idxPath);
  } // private getIndexPath()

  ////////////////////////////////////////////////////////////////////////////

  /** Check to see if the current XML source text file exists in the Lucene
   *  database, and if so, whether or not it needs to be updated. <br><br>
   *
   *  @return
   *    <code>0</code> - Specified XML source document not found in the Lucene
   *                     database. <br>
   *
   *    <code>1</code> - Specified XML source document found in the index, and
   *                     the index is up-to-date. <br>
   *
   *    <code>2</code> - Specified XML source document is in the index, but
   *                     the source text has changed since it was last indexed.
   *                     <br><br>
   *
   *  @.notes
   *     The XML source document checked by this function is specified by the
   *     {@link XMLTextProcessor#curIdxSrc curIdxSrc} member. <br><br>
   *
   *     An XML source document needs reindexing if its modification date
   *     differs from the modification date stored in the summary info chunk
   *     the last time it was indexed. <br><br>
   */
  private int checkFile(IndexSource srcInfo)
    throws IOException 
  {
    // We need to find the docInfo chunk that contains the specified
    // file. So construct a boolean query looking for a chunk with 
    // a "docInfo" field AND a "key" field containing the specified
    // source file key.
    //
    BooleanQuery query = new BooleanQuery();
    Term docInfo = new Term("docInfo", "1");
    Term keyTerm = new Term("key", srcInfo.key());
    query.add(new TermQuery(docInfo), BooleanClause.Occur.MUST);
    query.add(new TermQuery(keyTerm), BooleanClause.Occur.MUST);

    // Use the query to see if the document is in the index..
    boolean docInIndex = false;
    boolean docChanged = false;

    Hits match = indexSearcher.search(query);
    if (match.length() > 0) 
    {
      // Flag that the document is in the index.
      docInIndex = true;

      // Get the file modification date from the "docInfo" chunk.
      Document doc = match.doc(0);
      String indexDateStr = doc.get("fileDate");

      // See what the date is on the actual source file right now.
      String fileDateStr = DateTools.timeToString(
        srcInfo.lastModified(),
        DateTools.Resolution.MILLISECOND);

      // If the dates are different (or we're ignoring them)...
      if (fileDateStr.compareTo(indexDateStr) != 0 || ignoreFileTimes) 
      {
        // Delete the old lazy file, if any. Might as well delete any
        // empty parent directories as well.
        //
        /*File lazyFile = IndexUtil.calcLazyPath(new File(xtfHomePath),
                                               indexInfo,
                                               srcInfo.path(),
                                               false);
        Path.deletePath(lazyFile.toString());*/

        // And flag that we need to re-add them.
        docChanged = true;

        ////////////////////////////////////////////////////////
        //                                                    //                  
        // (We reindex like this with a 'remove and add'      //
        //  because Lucene doesn't have a 'reindex document' //
        //  operation.)                                       //
        //                                                    //
        ////////////////////////////////////////////////////////
      } // if( fileDateStr.compareTo(indexDateStr) != 0 ) 
    } // if( match.length() > 0 )

    // Now let the caller know the status.
    if (!docInIndex)
      return 0;
    if (!docChanged)
      return 1;
    return 2;
  } // checkFile()


  /** Open the active Lucene index database for reading (and deleting, an
   *  oddity in Lucene). <br><br>
   *
   *  @throws
   *    IOException  Any exceptions generated during the creation of the
   *                 Lucene database writer object.
   *
   *  @.notes
   *    This method attempts to open the Lucene database specified by the
   *    {@link XMLTextProcessor#indexPath indexPath} member for reading
   *    and/or deleting. It is strange that you delete things from a
   *    Lucene index by using an IndexReader, but hey, whatever floats your
   *    boat man.
   *    <br><br>
   */
  private void openIdxForReading()
    throws IOException 
  {
    if (indexWriter != null)
      indexWriter.close();
    indexWriter = null;

    if (spellWriter != null)
      spellWriter.close();
    spellWriter = null;

    if (indexReader == null)
      indexReader = IndexReader.open(NativeFSDirectory.getDirectory(indexPath));

    if (indexSearcher == null)
      indexSearcher = new IndexSearcher(indexReader);
  } // openIdxForReading()

  /** Open the active Lucene index database for writing. <br><br>
   *
   *  @throws
   *    IOException  Any exceptions generated during the creation of the
   *                 Lucene database writer object.
   *
   *  @.notes
   *    This method attempts to open the Lucene database specified by the
   *    {@link XMLTextProcessor#indexPath indexPath} member for writing.
   *    <br><br>
   */
  private void openIdxForWriting()
    throws IOException 
  {
    // Close the reader and searcher, since doing so will make indexing 
    // go much more quickly.
    //
    if (indexSearcher != null)
      indexSearcher.close();
    if (indexReader != null)
      indexReader.close();
    indexSearcher = null;
    indexReader = null;

    // If already open for writing, it would be bad to do it over again.
    if (indexWriter != null)
      return;

    // Make an analyzer that does all kinds of special stuff for us.
    XTFTextAnalyzer analyzer = new XTFTextAnalyzer(stopSet, pluralMap, accentMap);

    // Create an index writer, using the selected index db Path
    // and create mode. Pass it our own text analyzer. 
    //
    Directory indexDir = NativeFSDirectory.getDirectory(indexPath);
    indexWriter = new IndexWriter(indexDir, analyzer, false);

    // Since we end up adding tons of little 'documents' to Lucene, it's much 
    // faster to queue up a bunch in RAM before sorting and writing them out. 
    // This limit gives good speed, but requires quite a bit of RAM (probably
    // 100 megs is about right.)
    //
    indexWriter.setMaxBufferedDocs(100);

    // If requested to make a spellcheck dictionary for this index, attach 
    // a spelling writer to the text analyzer, so that tokenized words get 
    // passed to it and queued.
    //
    if (indexInfo.createSpellcheckDict) {
      if (spellWriter == null) {
        spellWriter = SpellWriter.open(new File(indexPath + "spellDict/"));
        spellWriter.setStopwords(stopSet);
        spellWriter.setMinWordFreq(3);
      }
      analyzer.setSpellWriter(spellWriter);
    }
  } // private openIdxForWriting()  

} // class XMLTextProcessor
