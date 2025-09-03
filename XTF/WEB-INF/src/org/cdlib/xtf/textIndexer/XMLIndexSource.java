package org.cdlib.xtf.textIndexer;


/*
 * Copyright (c) 2004, Regents of the University of California
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of the University of California nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Acknowledgements:
 *
 * A significant amount of new and/or modified code in this module
 * was made possible by a grant from the Andrew W. Mellon Foundation,
 * as part of the Melvyl Recommender Project.
 */
import java.io.File;
import javax.xml.parsers.SAXParser;
import javax.xml.transform.Templates;
import org.cdlib.xtf.textEngine.IndexUtil;
import org.cdlib.xtf.util.Normalizer;
import org.xml.sax.InputSource;

/**
 * Supplies a single file containing a single record to the
 * {@link XMLTextProcessor}.
 *
 * @author Martin Haye
 */
public class XMLIndexSource extends IndexSource {

    private final long lastModified;
    private final long totalSize;
    /** Source of XML data */
    private final InputSource inSrc;


    /** Key used to identify this file in the index */
    private final String key;

    /** XSLT pre-filters used to massage the XML document (null for none) */
    private final Templates[] preFilters;

  /** Stylesheet from which to gather XSLT key definitions to be computed
   *  and cached on disk. Typically, one would use the actual display
   *  stylesheet for this purpose, guaranteeing that all of its keys will be
   *  pre-cached.<br><br>
   *
   *  Background: stylesheet processing can be optimized by using XSLT 'keys',
   *  which are declared with an &lt;xsl:key&gt; tag. The first time a key
   *  is used in a given source document, it must be calculated and its values
   *  stored on disk. The text indexer can optionally pre-compute the keys so
   *  they need not be calculated later during the display process.
   */
  private final Templates displayStyle;


  /** Constructor -- initializes all the fields */
  public XMLIndexSource(InputSource inSrc, long lastModified, long totalSize, String key,
                          Templates[] preFilters, Templates displayStyle) {
     this.lastModified = lastModified;
     this.totalSize = totalSize;
     this.inSrc = inSrc;
     this.key = key;
     this.preFilters = preFilters;
     this.displayStyle = displayStyle;
  }
  public InputSource getInputSource() {
      return inSrc;
  }

    // inherit JavaDoc
  @Override public String key() {
    return key;
  }

  // inherit JavaDoc
  public Templates[] preFilters() {
    return preFilters;
  }

  // inherit JavaDoc
  public Templates displayStyle() {
    return displayStyle;
  }

  /**
   * Prepare a string for inclusion in an XML document. Unicode strings are
   * normalized to their canonical equivalents, a few characters are
   * escaped as entities, and invalid characters are removed.
   *
   * @param s   string to normalize
   * @return    possibly changed version of the string
   */
  public static String normalize(String s) 
  {
    char[] ch = s.toCharArray();

    // Scan for suspicious characters that might need Unicode 
    // normalization.
    //
    boolean needNormalize = false;
    int needEscape = 0;
    for (int i = 0; i < ch.length; i++) 
    {
      if ((ch[i] & ~0x7f) != 0)
        needNormalize = true;

      if (ch[i] == '&' || ch[i] == '<')
        ++needEscape;
      else if (ch[i] < '\u0020' &&
               (ch[i] != '\t' && ch[i] != '\n' && ch[i] != '\r')) 
      {
        ++needEscape;
      }
      else if (ch[i] >= '\uD800' && ch[i] <= '\uDFFF')
        ++needEscape;
      else if (ch[i] >= '\uFFFE' && ch[i] <= '\uFFFF')
        ++needEscape;
    }

    if (needNormalize) 
    {
      String s2 = Normalizer.normalize(s);
      if (!s.equals(s2)) {
        s = s2;
        ch = s2.toCharArray();
      }
    }

    if (needEscape > 0) 
    {
      int maxSpace = ch.length + (needEscape * 5);
      char[] newCh = new char[maxSpace];
      int dp = 0;
      for (int sp = 0; sp < ch.length; sp++) 
      {
        if (ch[sp] == '&') {
          newCh[dp++] = '&';
          newCh[dp++] = 'a';
          newCh[dp++] = 'm';
          newCh[dp++] = 'p';
          newCh[dp++] = ';';
        }
        else if (ch[sp] == '<') {
          newCh[dp++] = '&';
          newCh[dp++] = 'l';
          newCh[dp++] = 't';
          newCh[dp++] = ';';
        }
        else if (ch[sp] < '\u0020' &&
                 (ch[sp] != '\t' && ch[sp] != '\n' && ch[sp] != '\r')) 
        {
          ; // delete invalid character
        }
        else if (ch[sp] >= '\uD800' && ch[sp] <= '\uDFFF')
          ; // delete invalid character
        else if (ch[sp] >= '\uFFFE' && ch[sp] <= '\uFFFF')
          ; // delete invalid character
        else
          newCh[dp++] = ch[sp];
      }
      s = new String(newCh, 0, dp);
    }

    return s;
  } // normalize()

    @Override
    public final long lastModified() {
        return lastModified;
    }

    @Override
    public final long totalSize() {
        return totalSize;
    }
} // class SimpleSrcTextInfo
