package org.cdlib.xtf.textIndexer;

import org.apache.lucene.document.DateTools;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.cdlib.xtf.textEngine.Constants;
import org.cdlib.xtf.util.Trace;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.util.*;

public class LuceneDocBuilderHandler extends DefaultHandler {
    /**
     * Map special characters in XML to their entity equivalents.
     */
    private static String mapXMLChars(String str) {
        if (str.indexOf('&') >= 0)
            str = str.replaceAll("&", "&amp;");
        if (str.indexOf('<') >= 0)
            str = str.replaceAll("<", "&lt;");
        if (str.indexOf('>') >= 0)
            str = str.replaceAll(">", "&gt;");
        return str;
    }

    /**
     * Flag indicating how deeply nested in a meta-data section the current
     * text/tag being processed is.
     */
    private int inMeta = 0;

    /**
     * The current meta-field data being processed.
     */
    private MetaField metaField;

    /**
     * A buffer for accumulating meta-text from the source XML file.
     */
    private final StringBuffer metaBuf = new StringBuffer();

    /**
     * Character buffer for accumulating partial text blocks (possibly) passed
     * in to the {@link XMLTextProcessor#characters(char[], int, int) characters()}
     * method from the SAX parser.
     */
    private char[] charBuf = new char[1024];

    /**
     * Current end of the {@link LuceneDocBuilderHandler#charBuf charBuf} buffer.
     */
    private int charBufPos = 0;

    private final boolean stripWhiteSpace;

    private final List<MetaField> metaFields = new LinkedList<>();

    /**
     * The number of chunks of XML source text that have been processed. Used
     * to assign a unique chunk number to each chunk for a document.
     */
    private int chunkCount = 0;

    private String key;

    private long lastModified;

    private Document doc = new Document();

    private final Set<String> facetedFields = new HashSet<>();

    private final Set<String> tokenizedFields = new HashSet<>();

    public LuceneDocBuilderHandler(boolean stripWhiteSpace) {
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

    /**
     * Build a string representing any non-XTF attributes in the given
     * attribute list. This will be a series of name="value" pairs, separated
     * by spaces. If there are no non-XTF attributes, empty string is returned.
     * <br><br>
     */
    private String processMetaAttribs(Attributes atts) {
        StringBuilder buf = new StringBuilder();

        // Scan the list
        for (int i = 0; i < atts.getLength(); i++) {
            // Skip XTF-specific attributes
            String attrUri = atts.getURI(i);
            if (attrUri.equals(XMLTextProcessor.xtfUri))
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

    /**
     * Process the start of a new XML source text element/node/tag. <br><br>
     * <p>
     * Called by the XML file parser each time a new start tag is encountered.
     * <br><br>
     *
     * @param uri       Any namespace qualifier that applies to the current
     *                  XML tag.
     * @param localName The non-qualified name of the current XML tag.
     * @param qName     The qualified name of the current XML tag.
     * @param atts      Any attributes for the current tag. Note that only
     *                  attributes that are in the namespace specified by the
     *                  {@link XMLTextProcessor#xtfUri xtfUri}
     *                  member of this class are actually processed by this
     *                  method. <br><br>
     * @.notes This method processes any text accumulated before the current start tag
     * was encountered by calling the {@link LuceneDocBuilderHandler#flushCharacters() flushCharacters()}
     * method.  <br><br>
     */
    public void startElement(String uri, String localName, String qName,
                             Attributes atts) {
        // Process any characters accumulated for the previous node, writing them
        // out as chunks to the index if needed.
        //
        flushCharacters();

        // If this is the start of a meta data node (marked with an xtf:meta
        // attribute), read in the meta data. Note that these meta-data nodes are
        // not indexed as part of the general text.
        //
        int metaIndex = atts.getIndex(XMLTextProcessor.xtfUri, "meta");
        String metaVal = (metaIndex >= 0) ? atts.getValue(metaIndex) : "";
        if (metaIndex >= 0 && ("yes".equals(metaVal) || "true".equals(metaVal))) {
            if (inMeta > 0)
                throw new RuntimeException("Meta-data fields may not nest");

            inMeta = 1;

            // See if there is a "store" attribute set for this node. If not,
            // default to true.
            //
            boolean store = true;
            int tokIdx = atts.getIndex(XMLTextProcessor.xtfUri, "store");
            if (tokIdx >= 0) {
                String tokStr = atts.getValue(tokIdx);
                if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                    store = false;
            }

            // See if there is an "index" attribute set for this node. If not,
            // default to true.
            //
            boolean index = true;
            tokIdx = atts.getIndex(XMLTextProcessor.xtfUri, "index");
            if (tokIdx >= 0) {
                String tokStr = atts.getValue(tokIdx);
                if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                    index = false;
            }

            // See if there is a "noIndex" attribute set for this node.
            tokIdx = atts.getIndex(XMLTextProcessor.xtfUri, "noIndex");
            if (tokIdx >= 0) {
                String tokStr = atts.getValue(tokIdx);
                if (tokStr != null && (tokStr.equals("yes") || tokStr.equals("true")))
                    index = false;
            }

            // See if there is a "tokenize" attribute set for this node. If not,
            // default to true.
            //
            boolean tokenize = true;
            tokIdx = atts.getIndex(XMLTextProcessor.xtfUri, "tokenize");
            if (tokIdx >= 0) {
                String tokStr = atts.getValue(tokIdx);
                if (tokStr != null && (tokStr.equals("no") || tokStr.equals("false")))
                    tokenize = false;
            }

            // See if there is a "facet" attribute set for this node. If not,
            // default to false.
            //
            boolean isFacet = false;
            tokIdx = atts.getIndex(XMLTextProcessor.xtfUri, "facet");
            if (tokIdx >= 0) {
                String tokStr = atts.getValue(tokIdx);
                if (tokStr != null && (tokStr.equals("yes") || tokStr.equals("true")))
                    isFacet = true;
            }

            // See if there is a "wordBoost" attribute for this node. If not,
            // default to 1.0f.
            //
            float boost = 1.0f;
            int boostIdx = atts.getIndex(XMLTextProcessor.xtfUri, "wordBoost");
            if (boostIdx < 0)
                boostIdx = atts.getIndex(XMLTextProcessor.xtfUri, "wordboost");
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

    /**
     * Process the end of a new XML source text element/node/tag. <br><br>
     * <p>
     * Called by the XML file parser each time an end-tag is encountered.
     * <br><br>
     *
     * @param uri       Any namespace qualifier that applies to the current
     *                  XML tag.
     * @param localName The non-qualified name of the current XML tag.
     * @param qName     The qualified name of the current XML tag. <br><br>
     * @.notes This method processes any text accumulated before the current end tag
     * was encountered by calling the
     * {@link LuceneDocBuilderHandler#flushCharacters() flushCharacters()} method. <br><br>
     */
    public void endElement(String uri, String localName, String qName) {
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
            if (metaField.tokenize && !metaField.isFacet) {
                // If attributes were recorded for the top-level node, be sure to
                // put the start marker after them.
                //
                if (!metaField.value.isEmpty() && metaField.value.charAt(0) == '<') {
                    int insertPoint = metaField.value.indexOf('>') + 1;
                    metaField.value = metaField.value.substring(0, insertPoint) +
                            Constants.FIELD_START_MARKER +
                            metaField.value.substring(insertPoint) +
                            Constants.FIELD_END_MARKER;
                } else {
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

            for (Iterator<MetaField> i = metaFields.iterator(); i.hasNext(); ) {
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
        } else if (inMeta > 1)
            inMeta--;
    } // public endElement()

    /// /////////////////////////////////////////////////////////////////////////
    public void processingInstruction(String target, String data) {
        // Filter out processing instructions.
    } // processingInstruction()


    ////////////////////////////////////////////////////////////////////////////

    /**
     * Accumulate chunks of text encountered between element/node/tags.
     *
     * @param ch     A block of characters from which to accumulate text.
     *               <br><br>
     * @param start  The starting offset in <code>ch</code> of the characters
     *               to accumulate. <br><br>
     * @param length The number of characters to accumulate from <code>ch</code>.
     *               <br><br>
     * @.notes Depending on how the XML parser is implemented, a call to this function
     * may or may not receive all the characters encountered between two tags
     * in an XML file. However, for the <code>XMLTextProcessor</code> to
     * correctly assemble overlapping chunks for the Lucene database, it needs
     * to have all the characters between two tags available as a single chunk
     * of text. Consequently this method simply accumulates text, and calls
     * calls from the XML parser to
     * {@link XMLTextProcessor#startElement(String, String, String, Attributes) startElement()}
     * and
     * {@link XMLTextProcessor#endElement(String, String, String) endElement()}
     * trigger the actual processing of accumulated text.
     */
    public void characters(char[] ch, int start, int length) {
        // If the accumulation buffer is not big enough to receive the current
        // block of new characters...
        //
        if (charBufPos + length > charBuf.length) {
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

    /**
     * Process any accumulated source text, writing indexing completed chunks
     * to the Lucene database as necessary. <br><br>
     *
     * @.notes This method processes any accumulated text as follows:
     *
     * <blockquote dir=ltr style="MARGIN-RIGHT: 0px">
     * 1. First the accumulated text is "blurbified." See the
     * method for more information about what this entails. <br><br>
     * <p>
     * 2. Next, a chunk is assembled a word at a time from the accumulated
     * text until the required chunk size (in words) is reached. The
     * completed chunk is then added to the Lucene database.
     * <br><br>
     * <p>
     * 3. Step two is repeated until no more complete chunks can be assembled
     * from the accumulated text. (Any partial chunk text is saved until
     * the next call to this method.)
     * </blockquote>
     */
    public void flushCharacters() {
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
        if (inMeta > 0) {
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
     *  @throws SAXException  Any exceptions generated during the final writing
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


    /**
     * Save document information associated with a collection of chunks. <br><br>
     * <p>
     * This method saves a special document summary information chunk to the
     * Lucene database that binds all the indexed text chunks for a document
     * back to the original XML source text.
     *
     * @.notes The document summary chunk is the last chunk written to a Lucene
     * database for a given XML source document. Its presence or absence
     * then can be used to identify whether or a document was completely
     * indexed or not. The absence of a document summary for any given
     * text chunk implies that indexing was aborted before the document
     * was completely indexed. This property of document summary chunks
     * is used by the  {@link IdxTreeCleaner} class to stript out any
     * partially indexed documents.<br><br>
     * <p>
     * The document summary includes the relative path to the original
     * XML source text, the number of chunks indexed for the document,
     * a unique key that associates this summary with all the indexed
     * text chunks, the date the document was added to the index, and any
     * meta-data associated with the document. <br><br>
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
