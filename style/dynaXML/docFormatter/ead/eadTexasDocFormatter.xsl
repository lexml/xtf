<!-- EAD2002 Style 2 (Table) Version 1 Minnie Rangel using EAD1 stylesheets by Micheal Fox 2003 April 22  -->

<!--  This stylesheet generates Style 2 which has a Table of Contents in an HTML table cell along the left side of the screen. It may be used when an HTML frame is not desired.  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:redirect="http://xml.apache.org/xalan/redirect" extension-element-prefixes="redirect">
  <xsl:strip-space elements="*" />
  <!-- Creates the body of the finding aid.-->
  <xsl:template match="/">
    <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid" />
    </xsl:variable>
    <html lang="en">
      <head>
        <style> h1, h2, h3 {font-family: arial} </style>
        <title>
          <xsl:value-of select="ead/eadheader/filedesc/titlestmt/titleproper" />
          <xsl:text>  </xsl:text>
          <xsl:value-of select="ead/eadheader/filedesc/titlestmt/subtitle" />
        </title>
        <link href="/taro/taro-aid.css" rel="styleSheet" type="text/css" />
      </head>
      <body class="findingaid-full">
        <table border="0" width="100%">
          <tr>
            <td align="left" valign="top">
              <br />
              <div align="right">
                <!-- <xsl:call-template name="toggle" /> -->
              </div>
            </td>
          </tr>
        </table>
        <table width="100%" cellpadding="5">
          <tr>
            <td valign="top" class="content-aid">
              <xsl:call-template name="body" />
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="body">
    <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid" />
    </xsl:variable>
    <xsl:call-template name="eadlogo" />
    <xsl:call-template name="eadheader" />
    <xsl:call-template name="archdesc-did" />
    <xsl:call-template name="archdesc-bioghist" />
    <xsl:call-template name="archdesc-scopecontent" />
    <xsl:call-template name="archdesc-arrangement" />
    <xsl:call-template name="archdesc-restrict" />
    <xsl:call-template name="archdesc-control" />
    <xsl:call-template name="archdesc-relatedmaterial" />
    <xsl:call-template name="archdesc-admininfo" />
    <xsl:call-template name="archdesc-otherfindaid" />
    <xsl:call-template name="archdesc-odd" />
    <xsl:call-template name="archdesc-bibliography" />
    <xsl:call-template name="dsc" />
    <xsl:call-template name="archdesc-index" />
    <xsl:call-template name="archdesc-odd2" />
    <!-- <xsl:call-template name="index-list"/> -->
  </xsl:template>
  <!-- MR added to create school logo -->
  <xsl:template name="eadlogo">
    <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid" />
    </xsl:variable>
    <xsl:if test="contains($file, 'tslac')">
      <div align="center">
        <img src="/taro/graphics/logo-tslac.jpg" width="84" height="150" border="0" alt="Texas State Library and Archives Commission" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'cah')">
      <div align="center">
        <img src="/taro/graphics/logo-utcah.jpg" width="360" height="210" border="0" alt="University of Texas, Center for American History" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'aaa')">
      <div align="center">
        <img src="/taro/graphics/logo-utaaa.jpg" width="250" height="134" border="0" alt="University of Texas, Alexander Architectural Archive" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'hrc')">
      <div align="center">
        <img src="/taro/graphics/logo-uthrc.gif" width="381" height="75" border="0" alt="University of Texas, Harry Ransom Humanities Research Center" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'law')">
      <div align="center">
        <img src="/taro/graphics/logo-utlaw.jpg" width="325" height="118" border="0" alt="University of Texas, Tarlton Law Library" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'blac')">
      <div align="center">
        <img src="/taro/graphics/logo-utlac.gif" width="134" height="150" alt="The Benson Latin American Collection" border="0" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'cush')">
      <div align="center">
        <img src="/taro/graphics/logo-tamucush.jpg" width="179" height="150" border="0" alt="Cushing Memorial Library, Texas A &#x0026; M University" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'rice')">
      <div align="center">
        <img src="/taro/graphics/logo-rice.gif" width="65" height="81" border="0" alt="Woodson Research Center, Rice University" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'uh')">
      <div align="center">
        <img src="/taro/graphics/logo-houston.gif" border="0" alt="University of Houston Libraries, Special Collections and Archives" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'ttu')">
      <div align="center">
        <img src="/taro/graphics/logo-tech.jpg" border="0" alt="Southwest Collection/Special Collections Library, Texas Tech University" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'aushc')">
      <div align="center">
        <img src="/taro/graphics/logo-aushc.jpg" width="300" height="63" border="0" alt="Austin History Center" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'smu')">
      <div align="center">
        <img src="/taro/graphics/logo-smu.jpg" width="141" height="62" border="0" alt="Southern Methodist University" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'swtsu')">
      <div align="center">
        <img src="/taro/graphics/logo-swwc.jpg" width="343" height="112" border="0" alt="Texas State Special Collections" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utpanam')">
      <div align="center">
        <img src="/taro/graphics/logo-utpanam.jpg" border="0" alt="University of Texas Pan American" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utep')">
      <div align="center">
        <img src="/taro/graphics/logo-utep.jpg" border="0" alt="University of Texas El Paso" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utmb')">
      <div align="center">
        <img src="/taro/graphics/logo-utmb.jpg" border="0" alt="University of Texas Medical Branch" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utsa')">
      <div align="center">
        <img src="/taro/graphics/logo-utsa.gif" width="416" height="66" border="0" alt="University of Texas San Antonio" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utarl')">
      <div align="center">
        <img src="/taro/graphics/logo-utarl.gif" width="292" height="49" border="0" alt="University of Texas Arlington" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'utmda')">
      <div align="center">
        <img src="/taro/graphics/logo-utmda.jpg" border="0" alt="University of Texas M.D. Anderson" />
      </div>
      <br />
    </xsl:if>
    <xsl:if test="contains($file, 'houpub')">
      <div align="center">
        <img src="/taro/graphics/logo-houpub.jpg" width="234" height="150" border="0" alt="Houston Public Library, Houston Metropolitan Research Center" />
      </div>
      <br />
    </xsl:if>
  </xsl:template>
  <xsl:template name="eadheader">
    <xsl:for-each select="ead/eadheader/filedesc/titlestmt">
      <h2 style="text-align:center">
        <xsl:value-of select="titleproper" />
      </h2>
      <h3 style="text-align:center">
        <xsl:value-of select="subtitle" />
      </h3>
      <br />
    </xsl:for-each>
    <hr />
  </xsl:template>
  <!-- The following general templates format the display of various RENDER attributes.-->
  <xsl:template match="emph[@render='bold']">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <xsl:template match="emph[@render='italic']">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>
  <xsl:template match="emph[@render='underline']">
    <u>
      <xsl:apply-templates />
    </u>
  </xsl:template>
  <xsl:template match="emph[@render='sub']">
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>
  <xsl:template match="emph[@render='super']">
    <super>
      <xsl:apply-templates />
    </super>
  </xsl:template>
  <xsl:template match="emph[@render='doublequote']">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates />
    <xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="emph[@render='singlequote']">
    <xsl:text>'</xsl:text>
    <xsl:apply-templates />
    <xsl:text>'</xsl:text>
  </xsl:template>
  <xsl:template match="emph[@render='bolddoublequote']">
    <strong>
      <xsl:text>"</xsl:text>
      <xsl:apply-templates />
      <xsl:text>"</xsl:text>
    </strong>
  </xsl:template>
  <xsl:template match="emph[@render='boldsinglequote']">
    <strong>
      <xsl:text>'</xsl:text>
      <xsl:apply-templates />
      <xsl:text>'</xsl:text>
    </strong>
  </xsl:template>
  <xsl:template match="emph[@render='boldunderline']">
    <strong>
      <u>
        <xsl:apply-templates />
      </u>
    </strong>
  </xsl:template>
  <xsl:template match="emph[@render='bolditalic']">
    <strong>
      <em>
        <xsl:apply-templates />
      </em>
    </strong>
  </xsl:template>
  <xsl:template match="emph[@render='boldsmcaps']">
    <span style="font-variant: small-caps">
      <strong>
        <xsl:apply-templates />
      </strong>
    </span>
  </xsl:template>
  <xsl:template match="emph[@render='smcaps']">
    <span style="font-variant: small-caps">
      <xsl:apply-templates />
    </span>
  </xsl:template>
  <xsl:template match="title[@render='bold']">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <xsl:template match="title[@render='italic']">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>
  <xsl:template match="title[@render='underline']">
    <u>
      <xsl:apply-templates />
    </u>
  </xsl:template>
  <xsl:template match="title[@render='sub']">
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>
  <xsl:template match="title[@render='super']">
    <super>
      <xsl:apply-templates />
    </super>
  </xsl:template>
  <xsl:template match="title[@render='boldunderline']">
    <strong>
      <u>
        <xsl:apply-templates />
      </u>
    </strong>
  </xsl:template>
  <xsl:template match="title[@render='bolditalic']">
    <strong>
      <em>
        <xsl:apply-templates />
      </em>
    </strong>
  </xsl:template>
  <xsl:template match="title[@render='doublequote']">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates />
    <xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="title[@render='singlequote']">
    <xsl:text>'</xsl:text>
    <xsl:apply-templates />
    <xsl:text>'</xsl:text>
  </xsl:template>
  <xsl:template match="title[@render='bolddoublequote']">
    <strong>
      <xsl:text>"</xsl:text>
      <xsl:apply-templates />
      <xsl:text>"</xsl:text>
    </strong>
  </xsl:template>
  <xsl:template match="title[@render='boldsinglequote']">
    <strong>
      <xsl:text>'</xsl:text>
      <xsl:apply-templates />
      <xsl:text>'</xsl:text>
    </strong>
  </xsl:template>
  <xsl:template match="title[@render='boldsmcaps']">
    <span style="font-variant: small-caps">
      <strong>
        <xsl:apply-templates />
      </strong>
    </span>
  </xsl:template>
  <xsl:template match="title[@render='smcaps']">
    <span style="font-variant: small-caps">
      <xsl:apply-templates />
    </span>
  </xsl:template>
  <!--This template rule formats a role attribute used in some tags.-->
  <xsl:template match="*[@role]">
    <strong>
      <xsl:apply-templates select="@role" />
    </strong>
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
  </xsl:template>
  <!--This template rule formats a label attribute used in some tags.-->
  <xsl:template match="*[@label]">
    <br />
    <strong>
      <xsl:apply-templates select="@label" />
    </strong>
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
  </xsl:template>
  <!--This template rule formats an ID attribute used for the target of a ref.-->
  <xsl:template match="*[@id]">
    <a name="{@id}" />
  </xsl:template>
  <!-- This template converts a Ref element into an HTML anchor.-->
  <xsl:template match="ref"> &#160;&#160; <a href="#{@target}">
      <xsl:apply-templates />
    </a>
  </xsl:template>
  <xsl:template match="ptrgrp">
    <xsl:apply-templates />
  </xsl:template>
  <!-- This template converts an "archref" element into an HTML anchor.-->
  <xsl:template match="archref">
    <div>
      <xsl:choose>
        <xsl:when test="@show='replace'">
          <a href="{@href}" target="_self">
            <xsl:apply-templates />
          </a>
        </xsl:when>
        <xsl:when test="@show='new'">
          <a href="{@href}" target="_blank">
            <xsl:apply-templates />
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  <!-- This template converts an "extptr" element into an HTML anchor.-->
  <xsl:template match="extptr">
    <xsl:if test="@show='replace'">
      <a href="{@href}" target="_self">
        <xsl:apply-templates />
      </a>
    </xsl:if>
    <xsl:if test="@show='new'">
      <a href="{@href}" target="_blank">
        <xsl:apply-templates />
      </a>
    </xsl:if>
  </xsl:template>
  <!-- This template converts a "dao" element into an HTML anchor.-->
  <!-- <dao linktype="simple" href="http://www.lib.utexas.edu/benson/rg/atitlan.jpg" actuate="onrequest" show="new"/> -->
  <xsl:template name="dao">
    <xsl:choose>
      <xsl:when test="@actuate='onload'">
        <xsl:choose>
          <xsl:when test="@title">
            <img src="{@href}" alt="{@title}" />
          </xsl:when>
          <xsl:otherwise>
            <img src="{@href}" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@actuate='onrequest'">
        <xsl:choose>
          <xsl:when test="@title">
            <a href="{@href}" target="_blank">
              <xsl:value-of select="@title" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{@href}" target="_blank">
              <xsl:value-of select="@href" />
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@href}" target="_blank">
          <xsl:value-of select="@href" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- This template converts an "extref" element into an HTML anchor.-->
  <xsl:template match="extref">
    <xsl:if test="@show='replace'">
      <a href="{@href}" target="_self">
        <xsl:apply-templates />
      </a>
    </xsl:if>
    <xsl:if test="@show='new'">
      <a href="{@href}" target="_blank">
        <xsl:apply-templates />
      </a>
    </xsl:if>
    <xsl:if test="@show='showother'">
      <a href="{@href}">
        <xsl:apply-templates />
      </a>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a list element.-->
  <xsl:template match="*/list">
    <xsl:for-each select="head">
      <strong>
        <xsl:apply-templates select="." />
      </strong>
      <br />
    </xsl:for-each>
    <xsl:for-each select="item">
      <div class="bod-in60">
        <xsl:apply-templates />
      </div>
    </xsl:for-each>
  </xsl:template>
  <!--Formats a simple table with border. The width of each column is defined by the colwidth attribute in a colspec element.-->
  <xsl:template match="table">
    <h3>
      <xsl:apply-templates select="head" />
    </h3>
    <xsl:for-each select="tgroup">
      <table border="1" align="center">
        <tr>
          <xsl:for-each select="colspec">
            <td width="{@colwidth}" />
          </xsl:for-each>
        </tr>
        <xsl:for-each select="thead">
          <xsl:for-each select="row">
            <tr>
              <xsl:for-each select="entry">
                <xsl:choose>
                  <xsl:when test="@align and @valign">
                    <td align="{@align}" valign="{@valign}">
                      <strong>
                        <xsl:value-of select="." />
                      </strong>
                    </td>
                  </xsl:when>
                  <xsl:when test="@align">
                    <td align="{@align}">
                      <strong>
                        <xsl:value-of select="." />
                      </strong>
                    </td>
                  </xsl:when>
                  <xsl:when test="@valign">
                    <td align="left" valign="{@valign}">
                      <strong>
                        <xsl:value-of select="." />
                      </strong>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td align="left">
                      <strong>
                        <xsl:value-of select="." />
                      </strong>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="tbody">
          <xsl:for-each select="row">
            <tr>
              <xsl:for-each select="entry">
                <xsl:choose>
                  <xsl:when test="@align and @valign">
                    <td align="{@align}" valign="{@valign}">
                      <xsl:value-of select="." />
                    </td>
                  </xsl:when>
                  <xsl:when test="@align">
                    <td align="{@align}">
                      <xsl:value-of select="." />
                    </td>
                  </xsl:when>
                  <xsl:when test="@valign">
                    <td align="left" valign="{@valign}">
                      <xsl:value-of select="." />
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td align="left">
                      <xsl:value-of select="." />
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
      </table>
    </xsl:for-each>
  </xsl:template>
  <!--This template rule formats a name element.-->
  <xsl:template match="name">
    <br />
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <!--This template rule formats an imprint element.-->
  <xsl:template match="imprint">
    <xsl:for-each select="geogname | publisher | date">
      <br />
      <xsl:apply-templates />
    </xsl:for-each>
  </xsl:template>
  <!--This template rule formats a num element.-->
  <xsl:template match="num">
    <br />
    <xsl:apply-templates />
  </xsl:template>
  <!--This template rule formats an abbr element.-->
  <xsl:template match="abbr">
    <br />
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <!--This template rule formats an expan element.-->
  <xsl:template match="expan">
    <br />
    <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>
  <!--This template rule formats a chronlist element.-->
  <xsl:template match="chronlist">
    <table width="100%">
      <tr>
        <td width="5%" />
        <td width="30%" />
        <td width="65%" />
      </tr>
      <xsl:apply-templates />
    </table>
  </xsl:template>
  <xsl:template match="chronlist/listhead">
    <tr>
      <td></td>
      <td>
        <strong>
          <xsl:apply-templates select="head01" />
        </strong>
      </td>
      <td>
        <strong>
          <xsl:apply-templates select="head02" />
        </strong>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="chronlist/chronitem">
    <!--Determine if there are event groups.-->
    <xsl:choose>
      <xsl:when test="eventgrp">
        <!--Put the date and first event on the first line.-->
        <tr>
          <td></td>
          <td valign="top">
            <xsl:apply-templates select="date" />
          </td>
          <td valign="top">
            <xsl:apply-templates select="eventgrp/event[position()=1]" />
          </td>
        </tr>
        <!--Put each successive event on another line.-->
        <xsl:for-each select="eventgrp/event[not(position()=1)]">
          <tr>
            <td></td>
            <td></td>
            <td valign="top">
              <xsl:apply-templates select="." />
            </td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <!--Put the date and event on a single line.-->
      <xsl:otherwise>
        <tr>
          <td></td>
          <td valign="top">
            <xsl:apply-templates select="date" />
          </td>
          <td valign="top">
            <xsl:apply-templates select="event" />
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--This template rule formats the top-level did element.-->
  <xsl:template name="archdesc-did">
    <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid" />
    </xsl:variable>
    <!-- For each element of the did, this template inserts the value of the LABEL attribute or, if none is present, a default value. -->
    <xsl:for-each select="ead/archdesc/did">
      <table width="100%">
        <tr>
          <td width="5%" />
          <td width="20%" />
          <td width="75%" />
        </tr>
        <tr>
          <td colspan="3">
            <h3>
              <a name="did">
                <xsl:apply-templates select="head" />
              </a>
            </h3>
          </td>
        </tr>
        <!--One can change the order of appearance for the children of did by changing the order of the following statements.-->
        <xsl:apply-templates select="origination" />
        <xsl:apply-templates select="unittitle" />
        <xsl:apply-templates select="unitdate" />
        <xsl:apply-templates select="abstract" />
        <xsl:apply-templates select="unitid" />
        <xsl:apply-templates select="physdesc" />
        <xsl:apply-templates select="physloc" />
        <xsl:apply-templates select="langmaterial" />
        <xsl:apply-templates select="materialspec" />
        <xsl:apply-templates select="note" />
        <xsl:apply-templates select="repository" />
      </table>
      <hr />
      <xsl:if test="child::dao">
        <table width="100%">
          <xsl:for-each select="dao">
            <tr>
              <td>
                <xsl:call-template name="dao" />
              </td>
            </tr>
          </xsl:for-each>
        </table>
        <hr />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--This template formats the repostory, origination, physdesc, abstract, unitid, physloc and materialspec elements of archdesc/did which share a common presentaiton. The sequence of their appearance is governed by the previous template.-->
  <xsl:template
    match="archdesc/did/repository | archdesc/did/origination | archdesc/did/physdesc | archdesc/did/unitid | archdesc/did/physloc | archdesc/did/abstract | archdesc/did/langmaterial | archdesc/did/materialspec">
    <!--The template tests to see if there is a label attribute, inserting the contents if there is or adding display textif there isn't. The content of the supplied label depends on the element.  To change the supplied label, simply alter the template below.-->
    <xsl:choose>
      <xsl:when test="@label">
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:value-of select="@label" />
            </strong>
          </td>
          <td>
            <xsl:apply-templates />
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:choose>
                <xsl:when test="self::repository">
                  <xsl:text>Repository: </xsl:text>
                </xsl:when>
                <xsl:when test="self::origination">
                  <xsl:text>Creator: </xsl:text>
                </xsl:when>
                <xsl:when test="self::physdesc">
                  <xsl:text>Quantity: </xsl:text>
                </xsl:when>
                <xsl:when test="self::physloc">
                  <xsl:text>Location: </xsl:text>
                </xsl:when>
                <xsl:when test="self::unitid">
                  <xsl:text>Identification: </xsl:text>
                </xsl:when>
                <xsl:when test="self::abstract">
                  <xsl:text>Abstract:</xsl:text>
                </xsl:when>
                <xsl:when test="self::langmaterial">
                  <xsl:text>Language: </xsl:text>
                </xsl:when>
                <xsl:when test="self::materialspec">
                  <xsl:text>Technical: </xsl:text>
                </xsl:when>
              </xsl:choose>
            </strong>
          </td>
          <td>
            <xsl:apply-templates />
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- The following two templates test for and processes various permutations of unittitle and unitdate.-->
  <xsl:template match="archdesc/did/unittitle">
    <!--The template tests to see if there is a label attribute for unittitle, inserting the contents if there is or adding one if there isn't. -->
    <xsl:choose>
      <xsl:when test="@label">
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:value-of select="@label" />
            </strong>
          </td>
          <td>
            <!--Inserts the text of unittitle and any children other that unitdate.-->
            <xsl:apply-templates select="text() | *[not(self::unitdate)]" />
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:text>Title: </xsl:text>
            </strong>
          </td>
          <td>
            <xsl:apply-templates select="text() | *[not(self::unitdate)]" />
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
    <!--If unitdate is a child of unittitle, it inserts unitdate on a new line.  -->
    <xsl:if test="child::unitdate">
      <!--The template tests to see if there is a label attribute for unitdate, inserting the contents if there is or adding one if there isn't. -->
      <xsl:choose>
        <xsl:when test="unitdate/@label">
          <tr>
            <td></td>
            <td valign="top">
              <strong>
                <xsl:value-of select="unitdate/@label" />
              </strong>
            </td>
            <td>
              <xsl:value-of select="unitdate" />
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td></td>
            <td valign="top">
              <strong>
                <xsl:text>Dates: </xsl:text>
              </strong>
            </td>
            <td>
              <xsl:apply-templates select="unitdate" />
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!-- Processes the unit date if it is not a child of unit title but a child of did, the current context.-->
  <xsl:template match="archdesc/did/unitdate">
    <!--The template tests to see if there is a label attribute for a unittitle that is the child of did and not unittitle, inserting the contents if there is or adding one if there isn't.-->
    <xsl:choose>
      <xsl:when test="@label">
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:value-of select="@label" />
            </strong>
          </td>
          <td>
            <xsl:apply-templates />
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td></td>
          <td valign="top">
            <strong>
              <xsl:text>Dates: </xsl:text>
            </strong>
          </td>
          <td>
            <xsl:apply-templates />
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--This template processes the note element.-->
  <xsl:template match="archdesc/did/note">
    <xsl:for-each select="p">
      <!--The template tests to see if there is a label attribute,
 inserting the contents if there is or adding one if there isn't. -->
      <xsl:choose>
        <xsl:when test="parent::note[@label]">
          <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
          <xsl:choose>
            <xsl:when test="position()=1">
              <tr>
                <td></td>
                <td valign="top">
                  <strong>
                    <xsl:value-of select="@label" />
                  </strong>
                </td>
                <td valign="top">
                  <xsl:apply-templates />
                </td>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td></td>
                <td valign="top" />
                <td valign="top">
                  <xsl:apply-templates />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!--Processes situations where there is no label attribute by supplying default text.-->
        <xsl:otherwise>
          <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
          <xsl:choose>
            <xsl:when test="position()=1">
              <tr>
                <td></td>
                <td valign="top">
                  <strong>
                    <xsl:text>Note: </xsl:text>
                  </strong>
                </td>
                <td>
                  <xsl:apply-templates />
                </td>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td></td>
                <td valign="top" />
                <td>
                  <xsl:apply-templates />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <!--Closes each paragraph-->
    </xsl:for-each>
  </xsl:template>
  <!--This template rule formats the top-level bioghist element.-->
  <xsl:template name="archdesc-bioghist">
    <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid" />
    </xsl:variable>
    <xsl:if test="ead/archdesc/bioghist[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/bioghist">
        <xsl:apply-templates />
        <hr />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template match="ead/archdesc/bioghist/head">
    <h3>
      <a name="bioghist">
        <xsl:apply-templates />
      </a>
    </h3>
  </xsl:template>
  <xsl:template match="ead/archdesc/bioghist/p">
    <p class="bod-in25">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="ead/archdesc/bioghist/dao">
    <div class="bod-in25">
      <xsl:call-template name="dao" />
    </div>
  </xsl:template>
  <xsl:template match="ead/archdesc/bioghist/chronlist">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="ead/archdesc/bioghist/bioghist">
    <h3 class="bod-in25">
      <xsl:apply-templates select="head" />
    </h3>
    <xsl:for-each select="p">
      <p class="bod-in50">
        <xsl:apply-templates />
      </p>
    </xsl:for-each>
  </xsl:template>
  <!--This template rule formats a chronlist element.-->
  <xsl:template match="*/chronlist">
    <table width="100%">
      <tr>
        <td width="5%" />
        <td width="30%" />
        <td width="65%" />
      </tr>
      <xsl:for-each select="listhead">
        <tr>
          <td>
            <strong>
              <xsl:apply-templates select="head01" />
            </strong>
          </td>
          <td>
            <strong>
              <xsl:apply-templates select="head02" />
            </strong>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="chronitem">
        <tr>
          <td></td>
          <td valign="top">
            <xsl:apply-templates select="date" />
          </td>
          <td valign="top">
            <xsl:apply-templates select="event" />
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  <!--This template rule formats the scopecontent element.-->
  <xsl:template name="archdesc-scopecontent">
    <xsl:if test="ead/archdesc/scopecontent[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/scopecontent">
        <xsl:apply-templates />
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <xsl:template match="ead/archdesc/scopecontent/head">
    <h3>
      <a name="scopecontent">
        <xsl:apply-templates />
      </a>
    </h3>
  </xsl:template>
  <xsl:template match="ead/archdesc/scopecontent/p">
    <p class="bod-in25">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="ead/archdesc/scopecontent/dao">
    <div class="bod-in25">
      <xsl:call-template name="dao" />
    </div>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/scopecontent/head">
    <h3 class="bod-in25">
      <xsl:apply-templates />
    </h3>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/scopecontent/p">
    <p class="bod-in50">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/scopecontent/dao">
    <div class="bod-in50">
      <xsl:call-template name="dao" />
    </div>
  </xsl:template>
  <!-- This formats an arrangement list embedded in a scope content statement.-->
  <xsl:template match="archdesc/scopecontent/arrangement/head">
    <h4 class="bod-in25">
      <strong>
        <xsl:apply-templates />
      </strong>
    </h4>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/arrangement/p">
    <p class="bod-in25">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/arrangement/list/head">
    <div class="bod-in25">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  <xsl:template match="archdesc/scopecontent/arrangement/list/item">
    <div class="bod-in50">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  <!--This template rule formats the arrangement element.-->
  <xsl:template name="archdesc-arrangement">
    <xsl:if test="ead/archdesc/arrangement[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/arrangement">
        <table width="100%">
          <tr>
            <td width="5%" />
            <td width="5%" />
            <td width="90%" />
          </tr>
          <tr>
            <td colspan="3">
              <h3>
                <a name="arrangementlink">
                  <xsl:apply-templates select="head" />
                </a>
              </h3>
            </td>
          </tr>
          <xsl:for-each select="p">
            <tr>
              <td></td>
              <td colspan="2">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="list">
            <tr>
              <td></td>
              <td colspan="2">
                <xsl:apply-templates select="head" />
              </td>
            </tr>
            <xsl:for-each select="item">
              <tr>
                <td></td>
                <td></td>
                <td colspan="1">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <!--This template rule formats the top-level relatedmaterial element.-->
  <xsl:template name="archdesc-relatedmaterial">
    <xsl:if
      test="ead/archdesc/archdescgrp/relatedmaterial[string-length(text()|*)!=0] | ead/archdesc/relatedmaterial[string-length(text()|*)!=0] | ead/archdesc/descgrp/relatedmaterial[string-length(text()|*)!=0]">
      <xsl:choose>
        <xsl:when test="child::head">
          <h3>
            <a name="relatedmatlink">
              <strong>
                <xsl:apply-templates select="head" />
              </strong>
            </a>
          </h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <a name="relatedmatlink">
              <strong>
                <xsl:text>Related Material</xsl:text>
              </strong>
            </a>
          </h3>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="ead/archdesc/archdescgrp/relatedmaterial | ead/archdesc/relatedmaterial | ead/archdesc/descgrp/relatedmaterial">
        <table width="100%">
          <tr>
            <td width="5%" />
            <td width="5%" />
            <td width="90%" />
          </tr>
          <tr>
            <td></td>
            <td colspan="2">
              <xsl:for-each select="p">
                <p class="bod-in30">
                  <xsl:apply-templates />
                </p>
              </xsl:for-each>
            </td>
          </tr>
          <xsl:for-each select="./relatedmaterial">
            <tr>
              <td></td>
              <td colspan="2">
                <strong>
                  <xsl:apply-templates select="p" />
                </strong>
              </td>
            </tr>
            <xsl:for-each select="note ">
              <tr>
                <td></td>
                <td></td>
                <td>
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="archref | bibref ">
              <tr>
                <td></td>
                <td></td>
                <td>
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
      </xsl:for-each>
      <hr />
    </xsl:if>
    <xsl:if
      test="ead/archdesc/archdescgrp/separatedmaterial[string-length(text()|*)!=0] | ead/archdesc/separatedmaterial[string-length(text()|*)!=0] | ead/archdesc/descgrp/separatedmaterial[string-length(text()|*)!=0]">
      <xsl:choose>
        <xsl:when test="child::head">
          <h3>
            <a name="sepmatlink">
              <strong>
                <xsl:apply-templates select="head" />
              </strong>
            </a>
          </h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <a name="sepmatlink">
              <strong>
                <xsl:text>Separated Material</xsl:text>
              </strong>
            </a>
          </h3>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="ead/archdesc/archdescgrp/separatedmaterial | ead/archdesc/separatedmaterial | ead/archdesc/descgrp/separatedmaterial">
        <table width="100%">
          <tr>
            <td width="5%" />
            <td width="5%" />
            <td width="90%" />
          </tr>
          <tr>
            <td></td>
            <td colspan="2">
              <xsl:for-each select="p">
                <p class="bod-in30">
                  <xsl:apply-templates />
                </p>
              </xsl:for-each>
            </td>
          </tr>
          <xsl:for-each select="./separatedmaterial">
            <tr>
              <td></td>
              <td colspan="2">
                <strong>
                  <xsl:apply-templates select="p" />
                </strong>
              </td>
            </tr>
            <xsl:for-each select="note ">
              <tr>
                <td></td>
                <td></td>
                <td>
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="archref | bibref ">
              <tr>
                <td></td>
                <td></td>
                <td>
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <!--This template rule formats the top-level otherfindaid element.-->
  <xsl:template name="archdesc-otherfindaid">
    <xsl:if test="ead/archdesc//otherfindaid[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/otherfindaid | ead/archdesc/otherfindaid | ead/archdesc/descgrp/otherfindaid">
        <xsl:choose>
          <xsl:when test="child::head">
            <h3>
              <strong>
                <xsl:apply-templates select="head" />
              </strong>
            </h3>
          </xsl:when>
          <xsl:otherwise>
            <h3>
              <strong>
                <xsl:text>Other Finding Aid</xsl:text>
              </strong>
            </h3>
          </xsl:otherwise>
        </xsl:choose>
        <div class="bod-in30">
          <xsl:for-each select="p">
            <xsl:choose>
              <xsl:when test="child::bibref">
                <p>
                  <xsl:apply-templates />
                </p>
              </xsl:when>
              <xsl:otherwise>
                <p>
                  <xsl:apply-templates select="." />
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </div>
        <hr />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats the top-level index element.-->
  <xsl:template name="archdesc-index">
    <xsl:if test="ead/archdesc//index[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/index | ead/archdesc/index | ead/archdesc/descgrp/index">
        <h3>
          <a name="index">
            <xsl:apply-templates select="head" />
          </a>
        </h3>
        <xsl:for-each select="p">
          <p style="margin-left : 30pt">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
        <xsl:for-each select="indexentry">
          <div style="margin-left: 30pt">
            <xsl:apply-templates select="." />
          </div>
        </xsl:for-each>
        <hr />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- MR new template for "add" describing index listings -->
  <xsl:template name="index-list">
    <xsl:if test="ead/archdesc//list[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc//head">
        <table width="100%">
          <tr>
            <td width="5%" />
            <td width="5%" />
            <td width="90%" />
          </tr>
          <xsl:variable name="idx">
            <xsl:value-of select="position()" />
          </xsl:variable>
          <tr>
            <td colspan="3">
              <h3>
                <a>
                  <xsl:attribute name="name">index<xsl:value-of select="$idx" />
                  </xsl:attribute>
                  <xsl:value-of select="text()" />
                </a>
              </h3>
            </td>
          </tr>
          <xsl:for-each select="ancestor::p">
            <tr>
              <td></td>
              <td colspan="2">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="ancestor::list">
            <tr>
              <td></td>
              <td colspan="2">
                <xsl:apply-templates select="." />
              </td>
            </tr>
            <xsl:for-each select="item">
              <tr>
                <td></td>
                <td></td>
                <td colspan="1">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
        <hr />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- MR end additions -->
  <!-- MR new bibliography element -->
  <xsl:template name="archdesc-bibliography">
    <xsl:if test="ead/archdesc/bibliography[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/bibliography">
        <xsl:choose>
          <xsl:when test="child::head">
            <h3>
              <a name="bibliography">
                <strong>
                  <xsl:apply-templates select="head" />
                </strong>
              </a>
            </h3>
          </xsl:when>
          <xsl:otherwise>
            <h3>
              <a name="a10">
                <strong>
                  <xsl:text>Bibliograpy</xsl:text>
                </strong>
              </a>
            </h3>
          </xsl:otherwise>
        </xsl:choose>
        <table width="100%">
          <tr>
            <td width="5%" />
            <td width="5%" />
            <td width="90%" />
          </tr>
          <tr>
            <td></td>
            <td colspan="2">
              <xsl:for-each select="p">
                <p class="bod-in30">
                  <xsl:apply-templates />
                </p>
              </xsl:for-each>
            </td>
          </tr>
          <xsl:for-each select="note ">
            <tr>
              <td></td>
              <td></td>
              <td>
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="list ">
            <tr>
              <td></td>
              <td></td>
              <td>
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="bibref ">
            <tr>
              <td></td>
              <td></td>
              <td>
                <p class="bod-in30">
                  <xsl:apply-templates />
                </p>
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="bibliography ">
            <tr>
              <td></td>
              <td></td>
              <td>
                <xsl:if test="child::head">
                  <p>
                    <h4>
                      <xsl:apply-templates select="head" />
                    </h4>
                  </p>
                </xsl:if>
                <xsl:for-each select="p">
                  <p class="bod-in50">
                    <xsl:apply-templates />
                  </p>
                </xsl:for-each>
                <xsl:for-each select="bibref ">
                  <p class="bod-in50">
                    <xsl:apply-templates />
                  </p>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <!-- MR end new bibliography element -->
  <!-- This template rule formats the top-level odd element.-->
  <!-- MR changes for adding tables to odd tag -->
  <xsl:template name="archdesc-odd">
    <xsl:if test="ead/archdesc/odd[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/odd">
        <xsl:choose>
          <xsl:when test="@type='index'" />
          <xsl:otherwise>
            <h3>
              <a>
                <xsl:attribute name="name">odd<xsl:number />
                </xsl:attribute>&#xA0;<xsl:apply-templates select="head" />
              </a>&#xA0;</h3>
            <xsl:for-each select=".//p">
              <p class="bod-in30">
                <xsl:apply-templates select="." />
              </p>
            </xsl:for-each>
            <xsl:for-each select="./list">
              <div class="bod-in30">
                <xsl:apply-templates select="." />
              </div>
            </xsl:for-each>
            <xsl:for-each select=".//dao">
              <div class="bod-in30">
                <xsl:call-template name="dao" />
              </div>
            </xsl:for-each>
            <xsl:for-each select=".//table">
              <xsl:for-each select="tgroup">
                <table width="100%" border="0">
                  <tr>
                    <xsl:for-each select="colspec">
                      <td width="{@colwidth}" />
                    </xsl:for-each>
                  </tr>
                  <xsl:for-each select="thead">
                    <xsl:for-each select="row">
                      <tr>
                        <xsl:for-each select="entry">
                          <td valign="top">
                            <strong>
                              <xsl:apply-templates select="." />
                            </strong>
                          </td>
                        </xsl:for-each>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                  <xsl:for-each select="tbody">
                    <xsl:for-each select="row">
                      <tr>
                        <xsl:for-each select="entry">
                          <td valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </xsl:for-each>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                </table>
                <p>&#xA0;</p>
              </xsl:for-each>
            </xsl:for-each>
            <hr />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="archdesc-odd2">
    <xsl:if test="ead/archdesc/odd[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/odd">
        <xsl:if test="@type='index'">
          <h3>
            <a>
              <xsl:attribute name="name">odd<xsl:number />
              </xsl:attribute>&#xA0;<xsl:apply-templates select="head" />
            </a>&#xA0;</h3>
          <xsl:for-each select=".//p">
            <p class="bod-in30">
              <xsl:apply-templates select="." />
            </p>
          </xsl:for-each>
          <xsl:for-each select="./list">
            <div class="bod-in30">
              <xsl:apply-templates select="." />
            </div>
          </xsl:for-each>
          <xsl:for-each select=".//dao">
            <div class="bod-in30">
              <xsl:call-template name="dao" />
            </div>
          </xsl:for-each>
          <xsl:for-each select=".//table">
            <xsl:for-each select="tgroup">
              <table width="100%" border="0">
                <tr>
                  <xsl:for-each select="colspec">
                    <td width="{@colwidth}" />
                  </xsl:for-each>
                </tr>
                <xsl:for-each select="thead">
                  <xsl:for-each select="row">
                    <tr>
                      <xsl:for-each select="entry">
                        <td valign="top">
                          <strong>
                            <xsl:apply-templates select="." />
                          </strong>
                        </td>
                      </xsl:for-each>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="tbody">
                  <xsl:for-each select="row">
                    <tr>
                      <xsl:for-each select="entry">
                        <td valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </xsl:for-each>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </table>
              <p>&#xA0;</p>
            </xsl:for-each>
          </xsl:for-each>
          <hr />
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- END MR changes for adding tables to odd tag -->
  <xsl:template name="archdesc-control">
    <xsl:if test="ead/archdesc/controlaccess[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/controlaccess">
        <table width="100%">
          <tr>
            <td width="5%"></td>
            <td width="5%"></td>
            <td width="90%"></td>
          </tr>
          <tr>
            <td colspan="3">
              <h3>
                <a name="controlaccess">
                  <xsl:apply-templates select="head" />
                </a>
              </h3>
            </td>
          </tr>
          <tr>
            <td></td>
            <td colspan="2">
              <xsl:apply-templates select="p" />
            </td>
          </tr>
          <xsl:for-each select="subject |corpname | persname | famname | genreform | title | geogname | occupation |function">
            <tr>
              <td></td>
              <td></td>
              <td>
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="./controlaccess">
            <tr>
              <td></td>
              <td colspan="2">
                <strong>
                  <xsl:apply-templates select="head" />
                </strong>
              </td>
            </tr>
            <xsl:for-each select="subject |corpname | persname | famname | genreform | title | geogname | occupation |function">
              <tr>
                <td></td>
                <td></td>
                <td>
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level accessretrict element.-->
  <xsl:template name="archdesc-restrict">
    <xsl:if test="ead/archdesc/accessrestrict[string-length(text()|*)!=0] | ead/archdesc/userestrict[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/accessrestrict[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/userestrict[string-length(text()|*)!=0] | ead/archdesc/descgrp/accessrestrict[string-length(text()|*)!=0] | ead/archdesc/descgrp/userestrict[string-length(text()|*)!=0] | ead/archdesc/phystech[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/phystech[string-length(text()|*)!=0] | ead/archdesc/descgrp/phystech[string-length(text()|*)!=0]">
      <h3>
        <a name="restrictlink">
          <strong>
            <xsl:text>Restrictions</xsl:text>
          </strong>
        </a>
      </h3>
      <xsl:for-each select="ead/archdesc/accessrestrict | ead/archdesc/archdescgrp/accessrestrict | ead/archdesc/descgrp/accessrestrict">
        <h4 class="bod-in15">
          <strong>
            <xsl:value-of select="head" />
          </strong>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="ead/archdesc/userestrict | ead/archdesc/archdescgrp/userestrict | ead/archdesc/descgrp/userestrict">
        <h4 class="bod-in15">
          <strong>
            <xsl:value-of select="head" />
          </strong>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="ead/archdesc/phystech | ead/archdesc/archdescgrp/phystech | ead/archdesc/descgrp/phystech">
        <h4 class="bod-in15">
          <strong>
            <xsl:value-of select="head" />
          </strong>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
      <hr />
    </xsl:if>
  </xsl:template>
  <xsl:template name="archdesc-admininfo">
    <xsl:if test="ead/archdesc/prefercite[string-length(text()|*)!=0] | ead/archdesc/custodhist[string-length(text()|*)!=0] | ead/archdesc/altformavail[string-length(text()|*)!=0] | ead/archdesc/originalsloc[string-length(text()|*)!=0] | ead/archdesc/acqinfo[string-length(text()|*)!=0] | ead/archdesc/processinfo[string-length(text()|*)!=0] | ead/archdesc/appraisal[string-length(text()|*)!=0] | ead/archdesc/accruals[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/prefercite[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/custodhist[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/altformavail[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/originalsloc[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/acqinfo[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/processinfo[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/appraisal[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/accruals[string-length(text()|*)!=0] | ead/archdesc/descgrp/prefercite[string-length(text()|*)!=0] | ead/archdesc/descgrp/custodhist[string-length(text()|*)!=0] | ead/archdesc/descgrp/altformavail[string-length(text()|*)!=0] | ead/archdesc/descgrp/originalsloc[string-length(text()|*)!=0] | ead/archdesc/descgrp/acqinfo[string-length(text()|*)!=0] | ead/archdesc/descgrp/processinfo[string-length(text()|*)!=0] | ead/archdesc/descgrp/appraisal[string-length(text()|*)!=0] | ead/archdesc/descgrp/accruals[string-length(text()|*)!=0]">
      <h3>
        <a name="adminlink">
          <xsl:text>Administrative Information</xsl:text>
        </a>
      </h3>
      <xsl:call-template name="archdesc-custodhist" />
      <xsl:call-template name="archdesc-prefercite" />
      <xsl:call-template name="archdesc-acqinfo" />
      <xsl:call-template name="archdesc-processinfo" />
      <xsl:call-template name="archdesc-appraisal" />
      <xsl:call-template name="archdesc-accruals" />
      <xsl:call-template name="archdesc-altform" />
      <xsl:call-template name="archdesc-originalsloc" />
      <hr />
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level custodhist element.-->
  <xsl:template name="archdesc-custodhist">
    <xsl:if
      test="ead/archdesc/custodhist[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/custodhist[string-length(text()|*)!=0] | ead/archdesc/descgrp/custodhist[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/custodhist | ead/archdesc/custodhist | ead/archdesc/descgrp/custodhist">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level altformavail element.-->
  <xsl:template name="archdesc-altform">
    <xsl:if
      test="ead/archdesc/altformavail[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/altformavail[string-length(text()|*)!=0] | ead/archdesc/descgrp/altformavail[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/altformavail | ead/archdesc/altformavail | ead/archdesc/descgrp/altformavail">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level originalsloc element.-->
  <xsl:template name="archdesc-originalsloc">
    <xsl:if
      test="ead/archdesc/originalsloc[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/originalsloc[string-length(text()|*)!=0] | ead/archdesc/descgrp/originalsloc[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/originalsloc | ead/archdesc/originalsloc | ead/archdesc/descgrp/originalsloc">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level prefercite element.-->
  <xsl:template name="archdesc-prefercite">
    <xsl:if
      test="ead/archdesc/prefercite[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/prefercite[string-length(text()|*)!=0] | ead/archdesc/descgrp/prefercite[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/prefercite | ead/archdesc/prefercite | ead/archdesc/descgrp/prefercite">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level acqinfo element.-->
  <xsl:template name="archdesc-acqinfo">
    <xsl:if test="ead/archdesc/acqinfo[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/acqinfo[string-length(text()|*)!=0] | ead/archdesc/descgrp/acqinfo[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/acqinfo | ead/archdesc/acqinfo | ead/archdesc/descgrp/acqinfo">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level procinfo element.-->
  <xsl:template name="archdesc-processinfo">
    <xsl:if
      test="ead/archdesc/processinfo[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/processinfo[string-length(text()|*)!=0] | ead/archdesc/descgrp/processinfo[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/processinfo | ead/archdesc/processinfo | ead/archdesc/descgrp/processinfo">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level appraisal element.-->
  <xsl:template name="archdesc-appraisal">
    <xsl:if
      test="ead/archdesc/appraisal[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/appraisal[string-length(text()|*)!=0] | ead/archdesc/descgrp/appraisal[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/appraisal | ead/archdesc/appraisal | ead/archdesc/descgrp/appraisal">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in30">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--This template rule formats a top-level accruals element.-->
  <xsl:template name="archdesc-accruals">
    <xsl:if test="ead/archdesc/accruals[string-length(text()|*)!=0] | ead/archdesc/archdescgrp/accruals[string-length(text()|*)!=0] | ead/archdesc/descgrp/accruals[string-length(text()|*)!=0]">
      <xsl:for-each select="ead/archdesc/archdescgrp/accruals | ead/archdesc/accruals | ead/archdesc/descgrp/accruals">
        <h4 class="bod-in15">
          <a name="{generate-id(head)}">
            <strong>
              <xsl:apply-templates select="head" />
            </strong>
          </a>
        </h4>
        <xsl:for-each select="p">
          <p class="bod-in25">
            <xsl:apply-templates select="." />
          </p>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
  <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
  <xsl:template name="dsc">
    <xsl:if test="ead/archdesc/dsc">
      <xsl:for-each select="ead/archdesc/dsc">
        <xsl:call-template name="dsc-analytic" />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="dsc-analytic">
    <h2>
        <xsl:text>Detailed Description of the Collection </xsl:text>
    </h2>
    <p class="bod-in25">
      <em>
        <xsl:apply-templates select="p" />
      </em>
    </p>
    <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
    <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
    <!-- Process each c01.-->
    <xsl:for-each select="c01">
      <table width="100%">
        <tr>
          <td width="12%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="7%"></td>
          <td width="6%"></td>
          <td width="6%"></td>
          <td width="6%"></td>
        </tr>
        <xsl:for-each select="did">
          <xsl:choose>
            <xsl:when test="./child::container">
              <xsl:call-template name="showbox-c01-box-only" />
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td colspan="14">
                  <h3>
                    <xsl:call-template name="component-did" />
                  </h3>
                </td>
              </tr>
              <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
                <xsl:for-each select="abstract | note">
                  <tr>
                    <td></td>
                    <td colspan="13" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="scopecontent | bioghist | arrangement">
          <xsl:for-each select="head">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <strong>
                  <xsl:apply-templates select="." />
                </strong>
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="p">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="list/item">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="dao">
          <tr>
            <td></td>
            <td colspan="13" valign="top">
              <xsl:call-template name="dao" />
            </td>
          </tr>
        </xsl:for-each>
        <xsl:for-each select="controlaccess">
          <xsl:for-each select="head">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <strong>
                  <xsl:apply-templates select="." />
                </strong>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td></td>
            <td colspan="13" valign="top">
              <xsl:apply-templates select="p" />
            </td>
          </tr>
          <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
            <tr>
              <td></td>
              <td></td>
              <td colspan="13" valign="top">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="./controlaccess">
            <tr>
              <td></td>
              <td></td>
              <td colspan="12" valign="top">
                <strong>
                  <xsl:apply-templates select="head" />
                </strong>
              </td>
            </tr>
            <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="relatedmaterial | separatedmaterial">
          <xsl:for-each select="head">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <strong>
                  <xsl:apply-templates select="." />
                </strong>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td></td>
            <td colspan="13" valign="top">
              <xsl:apply-templates select="p" />
            </td>
          </tr>
          <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
            <tr>
              <td></td>
              <td></td>
              <td colspan="12" valign="top">
                <xsl:apply-templates select="p" />
              </td>
            </tr>
            <xsl:for-each select="note">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="archref | bibref">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
          <xsl:for-each select="head">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <strong>
                  <xsl:apply-templates select="." />
                </strong>
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="p">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="table">
            <tr>
              <td></td>
              <td colspan="13" valign="top">
                <xsl:apply-templates select="." />
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
        <!-- Proceses each c02.-->
        <xsl:for-each select="c02">
          <xsl:for-each select="did">
            <xsl:variable name="cntr-number" select="container[@type][1]" />
            <xsl:variable name="cntr-type" select="container[1]/@type" />
            <xsl:choose>
              <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                <xsl:call-template name="hidebox-c02-box-only" />
              </xsl:when>
              <!-- If the box number did appear in a previous component, hide it here. -->
              <xsl:otherwise>
                <xsl:call-template name="showbox-c02-box-only" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <!-- Process any remaining c02 elements of the type specified.-->
          <xsl:for-each select="scopecontent | bioghist | arrangement">
            <xsl:for-each select="head">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <strong>
                    <xsl:apply-templates select="." />
                  </strong>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="p">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="list/item">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:for-each select="dao">
            <tr>
              <td></td>
              <td></td>
              <td colspan="12" valign="top">
                <xsl:call-template name="dao" />
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="controlaccess">
            <xsl:for-each select="head">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <strong>
                    <xsl:apply-templates select="." />
                  </strong>
                </td>
              </tr>
            </xsl:for-each>
            <tr>
              <td></td>
              <td></td>
              <td colspan="12" valign="top">
                <xsl:apply-templates select="p" />
              </td>
            </tr>
            <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="./controlaccess">
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <strong>
                    <xsl:apply-templates select="head" />
                  </strong>
                </td>
              </tr>
              <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:for-each select=" relatedmaterial | separatedmaterial">
            <xsl:for-each select="head">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <strong>
                    <xsl:apply-templates select="." />
                  </strong>
                </td>
              </tr>
            </xsl:for-each>
            <tr>
              <td></td>
              <td></td>
              <td colspan="12" valign="top">
                <xsl:apply-templates select="p" />
              </td>
            </tr>
            <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:apply-templates select="p" />
                </td>
              </tr>
              <xsl:for-each select="note ">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="archref | bibref">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
            <xsl:for-each select="head">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <strong>
                    <xsl:apply-templates select="." />
                  </strong>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="p">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="table">
              <tr>
                <td></td>
                <td></td>
                <td colspan="12" valign="top">
                  <xsl:apply-templates select="." />
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
          <!-- Processes each c03.-->
          <xsl:for-each select="c03">
            <xsl:for-each select="did">
              <xsl:variable name="cntr-number" select="container[@type][1]" />
              <xsl:variable name="cntr-type" select="container[1]/@type" />
              <xsl:choose>
                <xsl:when test="../preceding::did[1][container[@type][1]=$cntr-number] and ./preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                  <xsl:call-template name="hidebox-c03-box-only" />
                </xsl:when>
                <!-- If the box number did appear in a previous component, hide it here. -->
                <xsl:otherwise>
                  <xsl:call-template name="showbox-c03-box-only" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
            <!-- Process any remaining c03 elements of the type specified.-->
            <xsl:for-each select="scopecontent | bioghist | arrangement">
              <xsl:for-each select="head">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <strong>
                      <xsl:apply-templates select="." />
                    </strong>
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="p">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="list/item">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="dao">
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:call-template name="dao" />
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="controlaccess">
              <xsl:for-each select="head">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <strong>
                      <xsl:apply-templates select="." />
                    </strong>
                  </td>
                </tr>
              </xsl:for-each>
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:apply-templates select="p" />
                </td>
              </tr>
              <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="./controlaccess">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <strong>
                      <xsl:apply-templates select="head" />
                    </strong>
                  </td>
                </tr>
                <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="relatedmaterial | separatedmaterial">
              <xsl:for-each select="head">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <strong>
                      <xsl:apply-templates select="." />
                    </strong>
                  </td>
                </tr>
              </xsl:for-each>
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td colspan="11" valign="top">
                  <xsl:apply-templates select="p" />
                </td>
              </tr>
              <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:apply-templates select="p" />
                  </td>
                </tr>
                <xsl:for-each select="note ">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="archref | bibref">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
              <xsl:for-each select="head">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <strong>
                      <xsl:apply-templates select="." />
                    </strong>
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="p">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="table">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="11" valign="top">
                    <xsl:apply-templates select="." />
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
            <!-- Processes each c04.-->
            <xsl:for-each select="c04">
              <xsl:for-each select="did">
                <xsl:variable name="cntr-number" select="container[@type][1]" />
                <xsl:variable name="cntr-type" select="container[1]/@type" />
                <xsl:choose>
                  <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                    <xsl:call-template name="hidebox-c04-box-only" />
                  </xsl:when>
                  <!-- If the box number did appear in a previous component, hide it here. -->
                  <xsl:otherwise>
                    <xsl:call-template name="showbox-c04-box-only" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <!-- Process any remaining c04 elements of the type specified.-->
              <xsl:for-each select="scopecontent | bioghist | arrangement">
                <xsl:for-each select="head">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <strong>
                        <xsl:apply-templates select="." />
                      </strong>
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="p">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="list/item">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:for-each>
              <xsl:for-each select="dao">
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:call-template name="dao" />
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="controlaccess">
                <xsl:for-each select="head">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <strong>
                        <xsl:apply-templates select="." />
                      </strong>
                    </td>
                  </tr>
                </xsl:for-each>
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:apply-templates select="p" />
                  </td>
                </tr>
                <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="./controlaccess">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <strong>
                        <xsl:apply-templates select="head" />
                      </strong>
                    </td>
                  </tr>
                  <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
              <xsl:for-each select="relatedmaterial | separatedmaterial">
                <xsl:for-each select="head">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <strong>
                        <xsl:apply-templates select="." />
                      </strong>
                    </td>
                  </tr>
                </xsl:for-each>
                <tr>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="10" valign="top">
                    <xsl:apply-templates select="p" />
                  </td>
                </tr>
                <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:apply-templates select="p" />
                    </td>
                  </tr>
                  <xsl:for-each select="note ">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="archref | bibref">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
              <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
                <xsl:for-each select="head">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <strong>
                        <xsl:apply-templates select="." />
                      </strong>
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="p">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="table">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="10" valign="top">
                      <xsl:apply-templates select="." />
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:for-each>
              <!-- Processes each c05-->
              <xsl:for-each select="c05">
                <xsl:for-each select="did">
                  <xsl:variable name="cntr-number" select="container[@type][1]" />
                  <xsl:variable name="cntr-type" select="container[1]/@type" />
                  <xsl:choose>
                    <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                      <xsl:call-template name="hidebox-c05-box-only" />
                    </xsl:when>
                    <!-- If the box number did appear in a previous component, hide it here. -->
                    <xsl:otherwise>
                      <xsl:call-template name="showbox-c05-box-only" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
                <!-- Process any remaining c05 elements of the type specified.-->
                <xsl:for-each select="scopecontent | bioghist | arrangement">
                  <xsl:for-each select="head">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <strong>
                          <xsl:apply-templates select="." />
                        </strong>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="p">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="list/item">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="dao">
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:call-template name="dao" />
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="controlaccess">
                  <xsl:for-each select="head">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <strong>
                          <xsl:apply-templates select="." />
                        </strong>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:apply-templates select="p" />
                    </td>
                  </tr>
                  <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="./controlaccess">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <strong>
                          <xsl:apply-templates select="head" />
                        </strong>
                      </td>
                    </tr>
                    <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="relatedmaterial | separatedmaterial">
                  <xsl:for-each select="head">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <strong>
                          <xsl:apply-templates select="." />
                        </strong>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="9" valign="top">
                      <xsl:apply-templates select="p" />
                    </td>
                  </tr>
                  <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <xsl:apply-templates select="p" />
                      </td>
                    </tr>
                    <xsl:for-each select="note ">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="archref | bibref">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
                  <xsl:for-each select="head">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <strong>
                          <xsl:apply-templates select="." />
                        </strong>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="p">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="table">
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="9" valign="top">
                        <xsl:apply-templates select="." />
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
                <!-- Processes each c06-->
                <xsl:for-each select="c06">
                  <xsl:for-each select="did">
                    <xsl:variable name="cntr-number" select="container[@type][1]" />
                    <xsl:variable name="cntr-type" select="container[1]/@type" />
                    <xsl:choose>
                      <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                        <xsl:call-template name="hidebox-c06-box-only" />
                      </xsl:when>
                      <!-- If the box number did appear in a previous component, hide it here. -->
                      <xsl:otherwise>
                        <xsl:call-template name="showbox-c06-box-only" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                  <!-- Process any remaining c06 elements of the type specified.-->
                  <xsl:for-each select="scopecontent | bioghist | arrangement">
                    <xsl:for-each select="head">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <strong>
                            <xsl:apply-templates select="." />
                          </strong>
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="p">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="list/item">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                  <xsl:for-each select="controlaccess">
                    <xsl:for-each select="dao">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:call-template name="dao" />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="head">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <strong>
                            <xsl:apply-templates select="." />
                          </strong>
                        </td>
                      </tr>
                    </xsl:for-each>
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <xsl:apply-templates select="p" />
                      </td>
                    </tr>
                    <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="./controlaccess">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <strong>
                            <xsl:apply-templates select="head" />
                          </strong>
                        </td>
                      </tr>
                      <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:for-each>
                  <xsl:for-each select="relatedmaterial | separatedmaterial">
                    <xsl:for-each select="head">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <strong>
                            <xsl:apply-templates select="." />
                          </strong>
                        </td>
                      </tr>
                    </xsl:for-each>
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="8" valign="top">
                        <xsl:apply-templates select="p" />
                      </td>
                    </tr>
                    <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:apply-templates select="p" />
                        </td>
                      </tr>
                      <xsl:for-each select="note ">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="archref | bibref">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:for-each>
                  <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
                    <xsl:for-each select="head">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <strong>
                            <xsl:apply-templates select="." />
                          </strong>
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="p">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="table">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="8" valign="top">
                          <xsl:apply-templates select="." />
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                  <!-- Processes each c07.-->
                  <xsl:for-each select="c07">
                    <xsl:for-each select="did">
                      <xsl:variable name="cntr-number" select="container[@type][1]" />
                      <xsl:variable name="cntr-type" select="container[1]/@type" />
                      <xsl:choose>
                        <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                          <xsl:call-template name="hidebox-c07-box-only" />
                        </xsl:when>
                        <!-- If the box number did appear in a previous component, hide it here. -->
                        <xsl:otherwise>
                          <xsl:call-template name="showbox-c07-box-only" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                    <!-- Process any remaining c07 elements of the type specified.-->
                    <xsl:for-each select=" scopecontent | bioghist | arrangement">
                      <xsl:for-each select="head">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <strong>
                              <xsl:apply-templates select="." />
                            </strong>
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="p">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="list/item">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="dao">
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:call-template name="dao" />
                        </td>
                      </tr>
                    </xsl:for-each>
                    <xsl:for-each select="controlaccess">
                      <xsl:for-each select="head">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <strong>
                              <xsl:apply-templates select="." />
                            </strong>
                          </td>
                        </tr>
                      </xsl:for-each>
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:apply-templates select="p" />
                        </td>
                      </tr>
                      <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="./controlaccess">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <strong>
                              <xsl:apply-templates select="head" />
                            </strong>
                          </td>
                        </tr>
                        <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="5" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="relatedmaterial | separatedmaterial">
                      <xsl:for-each select="head">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <strong>
                              <xsl:apply-templates select="." />
                            </strong>
                          </td>
                        </tr>
                      </xsl:for-each>
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="7" valign="top">
                          <xsl:apply-templates select="p" />
                        </td>
                      </tr>
                      <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:apply-templates select="p" />
                          </td>
                        </tr>
                        <xsl:for-each select="note ">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="archref | bibref">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
                      <xsl:for-each select="head">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <strong>
                              <xsl:apply-templates select="." />
                            </strong>
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="p">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="table">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="7" valign="top">
                            <xsl:apply-templates select="." />
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                    <!-- Processes each c08.-->
                    <xsl:for-each select="c08">
                      <xsl:for-each select="did">
                        <xsl:variable name="cntr-number" select="container[@type][1]" />
                        <xsl:variable name="cntr-type" select="container[1]/@type" />
                        <xsl:choose>
                          <xsl:when test="preceding::did[1][container[@type][1]=$cntr-number] and preceding::did[1][container[1]/@type=$cntr-type] or not(./container)">
                            <xsl:call-template name="hidebox-c08-box-only" />
                          </xsl:when>
                          <!-- If the box number did appear in a previous component, hide it here. -->
                          <xsl:otherwise>
                            <xsl:call-template name="showbox-c08-box-only" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                      <!-- Process any remaining c08 elements of the type specified.-->
                      <xsl:for-each select=" scopecontent | bioghist | arrangement">
                        <xsl:for-each select="head">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <strong>
                                <xsl:apply-templates select="." />
                              </strong>
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="p">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="list/item">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                      </xsl:for-each>
                      <xsl:for-each select="dao">
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:call-template name="dao" />
                          </td>
                        </tr>
                      </xsl:for-each>
                      <xsl:for-each select="controlaccess">
                        <xsl:for-each select="head">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <strong>
                                <xsl:apply-templates select="." />
                              </strong>
                            </td>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:apply-templates select="p" />
                          </td>
                        </tr>
                        <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="5" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="./controlaccess">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="5" valign="top">
                              <strong>
                                <xsl:apply-templates select="head" />
                              </strong>
                            </td>
                          </tr>
                          <xsl:for-each select="subject | corpname | persname | famname | genreform | title | geogname | occupation | function">
                            <tr>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td colspan="4" valign="top">
                                <xsl:apply-templates select="." />
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                      <xsl:for-each select="relatedmaterial | separatedmaterial">
                        <xsl:for-each select="head">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <strong>
                                <xsl:apply-templates select="." />
                              </strong>
                            </td>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td></td>
                          <td colspan="6" valign="top">
                            <xsl:apply-templates select="p" />
                          </td>
                        </tr>
                        <xsl:for-each select="./relatedmaterial | ./separatedmaterial ">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="5" valign="top">
                              <xsl:apply-templates select="p" />
                            </td>
                          </tr>
                          <xsl:for-each select="note ">
                            <tr>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td colspan="5" valign="top">
                                <xsl:apply-templates select="." />
                              </td>
                            </tr>
                          </xsl:for-each>
                          <xsl:for-each select="archref | bibref">
                            <tr>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td></td>
                              <td colspan="5" valign="top">
                                <xsl:apply-templates select="." />
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                      <xsl:for-each select="note | accessrestrict | userestrict | phystech | prefercite | acqinfo | originalsloc | processinfo | odd">
                        <xsl:for-each select="head">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <strong>
                                <xsl:apply-templates select="." />
                              </strong>
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="p">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                        <xsl:for-each select="p">
                          <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td colspan="6" valign="top">
                              <xsl:apply-templates select="." />
                            </td>
                          </tr>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </table>
      <br />
      <hr />
      <br />
    </xsl:for-each>
  </xsl:template>
  <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
  <!--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-->
  <!-- Shows the container numbers for a c01.-->
  <xsl:template name="showbox-c01-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <span style="font-size: small">
            <strong>
              <xsl:value-of select="@type" />
            </strong>
          </span>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <span style="font-size: small">
              <strong>
                <xsl:value-of select="@type" />
              </strong>
            </span>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td colspan="11" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td colspan="10" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the container numbers for a c02.-->
  <xsl:template name="showbox-c02-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <span style="font-size: small">
            <strong>
              <xsl:value-of select="@type" />
            </strong>
          </span>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <span style="font-size: small">
              <strong>
                <xsl:value-of select="@type" />
              </strong>
            </span>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td colspan="10" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td colspan="9" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c02.-->
  <xsl:template name="hidebox-c02-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td colspan="10" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td colspan="9" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the box number for a c03.-->
  <xsl:template name="showbox-c03-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <span style="font-size: small">
            <strong>
              <xsl:value-of select="@type" />
            </strong>
          </span>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <span style="font-size: small">
              <strong>
                <xsl:value-of select="@type" />
              </strong>
            </span>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td colspan="9" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="8" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c03.-->
  <xsl:template name="hidebox-c03-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td colspan="9" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="8" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the container number for a c04.-->
  <xsl:template name="showbox-c04-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <strong>
            <span style="font-size: small">
              <xsl:value-of select="@type" />
            </span>
          </strong>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <strong>
              <span style="font-size: small">
                <xsl:value-of select="@type" />
              </span>
            </strong>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td colspan="8" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="7" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c04.-->
  <xsl:template name="hidebox-c04-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td colspan="8" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="7" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the box number for a c05.-->
  <xsl:template name="showbox-c05-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <strong>
            <span style="font-size: small">
              <xsl:value-of select="@type" />
            </span>
          </strong>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <strong>
              <span style="font-size: small">
                <xsl:value-of select="@type" />
              </span>
            </strong>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="7" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="6" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c05.-->
  <xsl:template name="hidebox-c05-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="7" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="6" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the container number for a c06.-->
  <xsl:template name="showbox-c06-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <strong>
            <span style="font-size: small">
              <xsl:value-of select="@type" />
            </span>
          </strong>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <strong>
              <span style="font-size: small">
                <xsl:value-of select="@type" />
              </span>
            </strong>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="6" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="5" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c06.-->
  <xsl:template name="hidebox-c06-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="6" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="5" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the box number for a c07.-->
  <xsl:template name="showbox-c07-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <strong>
            <span style="font-size: small">
              <xsl:value-of select="@type" />
            </span>
          </strong>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <strong>
              <span style="font-size: small">
                <xsl:value-of select="@type" />
              </span>
            </strong>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="5" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="4" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c07.-->
  <xsl:template name="hidebox-c07-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="5" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="4" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- Shows the box number for a c08.-->
  <xsl:template name="showbox-c08-box-only">
    <tr>
      <td>
        <xsl:for-each select="container[@type][1]">
          <strong>
            <span style="font-size: small">
              <xsl:value-of select="@type" />
            </span>
          </strong>
        </xsl:for-each>
        <xsl:for-each select="container[@type][2]">
          <td>
            <strong>
              <span style="font-size: small">
                <xsl:value-of select="@type" />
              </span>
            </strong>
          </td>
        </xsl:for-each>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <xsl:if test="container[@type][1]">
          <xsl:apply-templates select="container[@type][1]" />
        </xsl:if>
      </td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="4" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="3" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--Hides the container number for a c08.-->
  <xsl:template name="hidebox-c08-box-only">
    <tr>
      <td></td>
      <td valign="top">
        <xsl:if test="container[@type][2]">
          <xsl:apply-templates select="container[@type][2]" />
        </xsl:if>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="4" valign="top">
        <xsl:call-template name="component-did" />
      </td>
    </tr>
    <xsl:if test="abstract[string-length(text()|*)!=0] | note[string-length(text()|*)!=0]">
      <xsl:for-each select="abstract | note">
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="3" valign="top">
            <xsl:apply-templates select="." />
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
  <!--Displays unittitle and date information for a component level did.-->
  <xsl:template name="component-did">
    <xsl:if test="unitid">
      <xsl:for-each select="unitid">
        <xsl:if test="@label">
          <strong>
            <xsl:value-of select="@label" />
          </strong>
          <xsl:text>  </xsl:text>
        </xsl:if>
        <xsl:apply-templates />
      </xsl:for-each>
      <br />
    </xsl:if>
    <xsl:choose>
      <xsl:when test="unittitle/unitdate">
        <xsl:for-each select="unittitle">
          <xsl:if test="@label">
            <strong>
              <xsl:value-of select="@label" />
            </strong>
            <xsl:text>  </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="text()|*[not(self::unitdate)]" />
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="./unitdate" />
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="unittitle">
          <xsl:if test="@label">
            <strong>
              <xsl:value-of select="@label" />
            </strong>
            <xsl:text>  </xsl:text>
          </xsl:if>
          <xsl:apply-templates />
        </xsl:for-each>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="unitdate" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="dao">
      <br />
      <xsl:call-template name="dao" />
    </xsl:for-each>
    <xsl:for-each select="physdesc | materialspec | origination">
      <br />
      <xsl:if test="@label">
        <strong>
          <xsl:value-of select="@label" />
        </strong>
        <xsl:text>  </xsl:text>
      </xsl:if>
      <xsl:apply-templates />
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:if test="physloc">
      <xsl:for-each select="physloc">
        <xsl:if test="@label">
          <strong>
            <xsl:value-of select="@label" />
          </strong>
          <xsl:text>  </xsl:text>
        </xsl:if>
        <xsl:apply-templates />
      </xsl:for-each>
      <br />
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
