
<!--
   Copyright (c) 2004, Regents of the University of California
   All rights reserved.
 
   Redistribution and use in source and binary forms, with or without 
   modification, are permitted provided that the following conditions are 
   met:

   - Redistributions of source code must retain the above copyright notice, 
     this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright 
     notice, this list of conditions and the following disclaimer in the 
     documentation and/or other materials provided with the distribution.
   - Neither the name of the University of California nor the names of its
     contributors may be used to endorse or promote products derived from 
     this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
   POSSIBILITY OF SUCH DAMAGE.
-->


<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xtf="http://cdlib.org/xtf">

  <xsl:param name="servlet.path"/>
  
  <xsl:param name="root.path"/>

  <xsl:param name="serverURL" select="$root.path"/>

  <xsl:param name="docId"/>

  <xsl:param name="subDir" select="substring($docId, 9, 2)"/>

  <!-- If an external 'source' document was specified, include it in the
       query string of links we generate. -->

  <xsl:param name="source" select="''"/>

  <xsl:variable name="sourceStr">
    <xsl:if test="$source">&amp;source=<xsl:value-of select="$source"/></xsl:if>
  </xsl:variable>

  <xsl:param name="query.string" select="concat('docId=', $docId, $sourceStr)"/>

  <xsl:param name="doc.path"><xsl:value-of select="$servlet.path"/>?<xsl:value-of select="$query.string"/></xsl:param>

  <xsl:param name="figure.path" select="concat($serverURL, 'data/', $subDir, '/', $docId, '/figures/')"/>

  <xsl:param name="pdf.path" select="concat($serverURL, 'data/', $subDir, '/', $docId, '/pdfs/')"/>

  <xsl:param name="doc.view" select="'0'"/>

  <xsl:param name="toc.depth" select="1"/>

  <xsl:param name="anchor.id" select="'0'"/>

  <xsl:param name="set.anchor" select="'0'"/>

  <!-- To support direct links from snippets, the following two parameters must check value of $hit.rank -->
  <xsl:param name="chunk.id">
    <xsl:choose>
      <xsl:when test="$hit.rank != '0' and key('hit-rank-dynamic', $hit.rank)/ancestor::div1">
       <xsl:value-of select="key('hit-rank-dynamic', $hit.rank)/ancestor::*[self::div7 or self::div6 or self::div5 or self::div4 or self::div3 or self::div2 or self::div1][1]/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
 
  <xsl:param name="toc.id">
    <xsl:choose>
      <xsl:when test="$hit.rank != '0' and key('hit-rank-dynamic', $hit.rank)/ancestor::div1">
       <xsl:value-of select="key('hit-rank-dynamic', $hit.rank)/ancestor::*[self::div7 or self::div6 or self::div5 or self::div4 or self::div3 or self::div2 or self::div1][1]/parent::*[self::div7 or self::div6 or self::div5 or self::div4 or self::div3 or self::div2 or self::div1]/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
 
  <xsl:param name="query"/>
  <xsl:param name="query-join"/>
  <xsl:param name="query-exclude"/>
  <xsl:param name="sectionType"/>
  
  <xsl:param name="search">
    <xsl:if test="$query">
      <xsl:value-of select="concat('&amp;query=', replace($query, '&amp;', '%26'))"/>
    </xsl:if>
    <xsl:if test="$query-join">
      <xsl:value-of select="concat('&amp;query-join=', $query-join)"/>
    </xsl:if>
    <xsl:if test="$query-exclude">
      <xsl:value-of select="concat('&amp;query-exclude=', $query-exclude)"/>
    </xsl:if>
    <xsl:if test="$sectionType">
      <xsl:value-of select="concat('&amp;sectionType=', $sectionType)"/>
    </xsl:if>
  </xsl:param>  
    
  <xsl:param name="hit.rank" select="'0'"/>

  <!-- Brand Parameter -->
  <xsl:param name="brand"/>
  
  <!-- Retrieve Branding Nodes -->
  <xsl:variable name="brand.file">
    <xsl:choose>
      <xsl:when test="$brand != ''">
        <xsl:copy-of select="document(concat('../../../../brand/',$brand,'.xml'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="document('../../../../brand/default.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:param name="brand.links" select="$brand.file//links/*"/>
  <xsl:param name="brand.header" select="$brand.file//header/*"/>
  <xsl:param name="brand.header.dynaxml.header" select="$brand.file//header.dynaxml.header/*"/>
  <xsl:param name="brand.header.dynaxml.topnav.left" select="$brand.file//header.dynaxml.topnav.left/*"/>
  <xsl:param name="brand.header.dynaxml.topnav.right" select="$brand.file//header.dynaxml.topnav.right/*"/>
  <xsl:param name="brand.footer" select="$brand.file//footer/*"/>
  
  <!-- URL Encoding Map -->

  <xtf:encoding-map>
    <xtf:regex>
      <xtf:find>%</xtf:find>    <!-- % must be done first! -->
      <xtf:replace>%25</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>SPACE</xtf:find>
      <xtf:replace>%20</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>"</xtf:find>
      <xtf:replace>%22</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>'</xtf:find>
      <xtf:replace>%27</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>&lt;</xtf:find>
      <xtf:replace>%3C</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>&gt;</xtf:find>
      <xtf:replace>%3E</xtf:replace>
    </xtf:regex>
    <xtf:regex>
      <xtf:find>#</xtf:find>
      <xtf:replace>%23</xtf:replace>
    </xtf:regex>
 </xtf:encoding-map>

  <xsl:template name="url-encode">
    <xsl:param name="url-string"/>
    <xsl:param name="regex" select="document('')/*/xtf:encoding-map/xtf:regex"/>
    <xsl:variable name="encoded-string">
      <xsl:call-template name="regex-replace">
        <xsl:with-param name="string" select="$url-string"/>
        <xsl:with-param name="find" select="$regex[1]/xtf:find"/>
        <xsl:with-param name="replace" select="$regex[1]/xtf:replace"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$regex[2]">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="url-string" select="$encoded-string"/>
          <xsl:with-param name="regex" select="$regex[position() > 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$encoded-string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="regex-replace">
    <xsl:param name="string"/>
    <xsl:param name="find"/>
    <xsl:param name="replace"/>
    <xsl:choose>
      <xsl:when test="contains($string, ' ') and $find='SPACE'">
        <xsl:value-of select="substring-before($string, ' ')"/>
        <xsl:value-of select="$replace"/>
        <xsl:call-template name="regex-replace">
          <xsl:with-param name="string" select="substring-after($string, ' ')"/>
          <xsl:with-param name="find" select="$find"/>
          <xsl:with-param name="replace" select="$replace"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($string, $find)">
        <xsl:value-of select="substring-before($string, $find)"/>
        <xsl:value-of select="$replace"/>
        <xsl:call-template name="regex-replace">
          <xsl:with-param name="string" select="substring-after($string, $find)"/>
          <xsl:with-param name="find" select="$find"/>
          <xsl:with-param name="replace" select="$replace"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
