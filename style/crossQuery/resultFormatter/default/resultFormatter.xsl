<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">

   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Query result formatter stylesheet                                      -->
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

   <!--
      Copyright (c) 2008, Regents of the University of California
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

   <!-- this stylesheet implements very simple search forms and query results.
      Alpha and facet browsing are also included. Formatting has been kept to a
      minimum to make the stylesheets easily adaptable. -->

   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->

   <xsl:import href="../common/resultFormatterCommon.xsl"/>
   <xsl:include href="searchForms.xsl"/>

   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->

   <xsl:output method="xhtml" indent="no"
      encoding="UTF-8" media-type="text/html; charset=UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>

   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->

   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
  <!-- <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/> -->
   <xsl:param name="icon.path" select="'icons/default/'"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>

   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->

   <xsl:template match="/" exclude-result-prefixes="#all">
      <xsl:choose>
         <!-- robot response -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:apply-templates select="crossQueryResult" mode="robot"/>
         </xsl:when>
         <xsl:when test="$smode = 'showBag'">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- book bag -->
         <xsl:when test="$smode = 'addToBag'">
            <span>Adicionado</span>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <!-- no output needed -->
         </xsl:when>
         <xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when>
         <xsl:when test="$smode='emailFolder'">
            <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
         </xsl:when>
         <!-- similar item -->
         <xsl:when test="$smode = 'moreLike'">
            <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
         </xsl:when>
         <!-- modify search -->
         <xsl:when test="contains($smode, '-modify')">
            <xsl:apply-templates select="crossQueryResult" mode="form"/>
         </xsl:when>
         <!-- browse pages -->
         <xsl:when test="$browse-title or $browse-creator">
            <xsl:apply-templates select="crossQueryResult" mode="browse"/>
         </xsl:when>
         <!-- show results -->
         <xsl:when test="crossQueryResult/query/*/*">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- show form -->
         <xsl:otherwise>
            <xsl:apply-templates select="crossQueryResult" mode="form"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Results Template                                                       -->
   <!-- ====================================================================== -->

   <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">

      <!-- modify query URL -->
      <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'advanced-modify'"/>
      <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>

      <html xml:lang="en" lang="en">
         <head>
            <title>LexML : Resultados</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
            <script type="text/javascript" src="js/lexml-portal.js"></script>
            <link rel="stylesheet" href="css/lexml-portal.css" type="text/css"/>

            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support  -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/>
            <script src="script/yui/connection-min.js" type="text/javascript"></script>
         </head>
         <body>


            <!-- header -->
            <xsl:copy-of select="$brand.header"/>

            <!-- result header -->
            <div class="resultsHeader">
               <table border="0">
                  <tr>
                     <td colspan="2" class="right">
                        <xsl:if test="$smode != 'showBag'">
                           <xsl:variable name="bag" select="session:getData('bag')"/>
                           <a href="{$crossqueryPath}?smode=showBag">Cesta de Itens</a>
<!--
                           (<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)
-->
                           <xsl:text>&#160;|&#160;</xsl:text>
                        </xsl:if>
                        <xsl:if test="$smode != 'showBag'">
                           <a href="{$crossqueryPath}?{$modifyString}">
                              <xsl:text>Modificar Pesquisa</xsl:text>
                           </a>
                           <xsl:text>&#160;|&#160;</xsl:text>
                        </xsl:if>
                        <!-- <a href="{$xtfURL}{$crossqueryPath}">-->
						 <a href="javascript:history.back()">P�gina Anterior</a>
						 <xsl:text>&#160;|&#160;</xsl:text>
						 <a href="/">
                           <xsl:text>P�gina Inicial</xsl:text>
                        </a>
						<xsl:text>&#160;|&#160;</xsl:text>
                        <a href="{$crossqueryPath}?smode=advanced">
                           <xsl:text>Pesquisa Avan�ada</xsl:text>
                        </a>
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>Retornar para resultado da pesquisa</xsl:text>
                           </a>
                        </xsl:if>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="2">
                        <xsl:choose>
                           <xsl:when test="$smode='showBag'">
                             <!-- <a>
                                 <xsl:attribute name="href">javascript://</xsl:attribute>
                                 <xsl:attribute name="onclick">
                                    <xsl:text>javascript:window.open('</xsl:text><xsl:value-of
                                       select="$xtfURL"/>search?smode=getAddress<xsl:text>','popup','width=500,height=200,resizable=no,scrollbars=no')</xsl:text>
                                 </xsl:attribute>
                                 <xsl:text>E-mail dos Itens da Cesta</xsl:text>
                              </a> -->
                           </xsl:when>
                           <xsl:otherwise>
                              <div class="query">
                                 <div class="label">
                                    <b><xsl:value-of select="if($browse-all) then 'Visualizar' else 'Pesquisa'"/>:</b>
                                 </div>
                                 <xsl:call-template name="format-query"/>
                              </div>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
                  <xsl:if test="//spelling">
                     <tr>
                        <td>
                           <xsl:call-template name="did-you-mean">
                              <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                              <xsl:with-param name="spelling" select="//spelling"/>
                           </xsl:call-template>
                        </td>
                        <td class="right">&#160;</td>
                     </tr>
                  </xsl:if>
                  <tr>
                     <td>
                        <b><xsl:value-of select="if($smode='showBag') then 'Cesta de Itens' else 'Resultados'"/>:</b>&#160;
                        <xsl:variable name="items" select="@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items = 1">
                              <span id="itemCount">1</span>
                              <xsl:text> Item</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <span id="itemCount">
                                 <xsl:value-of select="$items"/>
                              </span>
                              <xsl:text> Itens</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="right">
                        <!-- <xsl:text>Visualizar por </xsl:text> -->
                        <xsl:call-template name="browseLinks"/>
                     </td>
                  </tr>
                  <xsl:if test="docHit">
                     <tr>
                        <td>
                           <form method="get" action="{$xtfURL}{$crossqueryPath}">
                              <b>Ordenar por:&#160;</b>
                              <xsl:call-template name="sort.options"/>
                              <xsl:call-template name="hidden.query">
                                 <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                              </xsl:call-template>
                              <xsl:text>&#160;</xsl:text>
                              <input type="submit" value="Ok"/>
                           </form>
                        </td>
                        <td class="right">
                           <xsl:call-template name="pages"/>
                        </td>
                     </tr>
                  </xsl:if>
               </table>
            </div>

            <!-- results -->
            <xsl:choose>
               <xsl:when test="docHit">
                  <div class="results">
                     <table>
                        <tr>
                           <xsl:if test="not($smode='showBag')">
                              <td class="facet">
                                 <!-- <xsl:apply-templates select="facet[@field='facet-subject']"/> -->
                                 <xsl:apply-templates select="facet[@field='facet-tipoDocumento']"/>
                                 <xsl:apply-templates select="facet[@field='facet-localidade']"/>
                                 <xsl:apply-templates select="facet[@field='facet-autoridade']"/>
                                 <xsl:if test="facet[@field='facet-doutrinaClasse' and @totalDocs &gt; 0]">
                                     <div class="facetName" style="display:block; ">Doutrina</div>
                                 </xsl:if>
                                     <div class=" ">
                                   <xsl:apply-templates select="facet[@field='facet-doutrinaClasse']"/>
                                   <xsl:apply-templates select="facet[@field='facet-doutrinaLingua']"/>
                                 <!--  <div class="expandable-content">  -->
                                   <xsl:apply-templates select="facet[@field='facet-doutrinaAutor']"/>
                                   <xsl:apply-templates select="facet[@field='facet-doutrinaBiblioteca']"/>
                                   <xsl:apply-templates select="facet[@field='facet-doutrinaBibDigital']"/>
                                 <!-- </div> -->
                                 <xsl:apply-templates select="facet[@field='facet-date']"/>
                                 <!--  <div class="expandable-content">  -->
                                   <xsl:apply-templates select="facet[@field='facet-acronimo']"/>
                                 <!-- </div> -->
				 </div>
                              </td>
                           </xsl:if>
                           <td class="docHit">
                              <xsl:apply-templates select="docHit"/>
                           </td>
                        </tr>
                        <xsl:if test="@totalDocs > $docsPerPage">
                           <tr>
                              <td colspan="2" class="center">
                                 <xsl:call-template name="pages"/>
                              </td>
                           </tr>
                        </xsl:if>
                     </table>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <div class="results">
                     <table>
                        <tr>
                           <td>
                              <xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <p>Sua cesta de itens esta vazia.</p>
                                    <p>Clique em no link de 'Adicionar' em um ou mais itens do <a href="{session:getData('queryURL')}">Resultado da Pesquisa</a>.</p>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <p>Desculpe, nenhum resultado encontrado...</p>
                                    <p>Tente modificar sua pesquisa:</p>
                                    <div class="forms">
                                       <xsl:choose>
                                          <xsl:when test="matches($smode,'advanced')">
                                             <xsl:call-template name="advancedForm"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:call-template name="simpleForm"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </div></xsl:otherwise>
                              </xsl:choose>
                           </td>
                        </tr>
                     </table>
                  </div>
               </xsl:otherwise>
            </xsl:choose>

            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>
                        <!-- controles do expandable -->

            <script>
              incluirExpandable(".expandable-content");
            </script>


         </body>
      </html>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Bookbag Templates                                                      -->
   <!-- ====================================================================== -->

   <xsl:template name="getAddress" exclude-result-prefixes="#all">
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail itens da cesta: Obter e-mail</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="getAddress">
               <h2>E-mail itens da cesta</h2>
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <xsl:text>e-mail: </xsl:text>
                  <input type="text" name="email"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="reset" value="CLEAR"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="SUBMIT"/>
                  <input type="hidden" name="smode" value="emailFolder"/>
               </form>
            </div>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">

      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>

      <!-- Change the values for @smtpHost and @from to those valid for your domain -->
      <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail"
         xsl:extension-element-prefixes="mail"
         smtpHost="smtp.yourserver.org"
         useSSL="no"
         from="admin@yourserver.org"
         to="{$email}"
         subject="XTF: My Bookbag">
Sua cesta de itens:
<xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>
      </mail:send>

      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail Lista: OK</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body onload="autoCloseTimer = setTimeout('window.close()', 1000)">
            <xsl:copy-of select="$brand.header"/>
            <h1>E-mail Lista </h1>
            <b>A lista de itens foi enviada.</b>
         </body>
      </html>

   </xsl:template>

   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
         <xsl:variable name="path" select="@path"/>
         <xsl:variable name="url">
            <xsl:value-of select="$xtfURL"/>
            <xsl:choose>
               <xsl:when test="matches(meta/display, 'dynaxml')">
                  <xsl:call-template name="dynaxml.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="rawDisplay.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
Item # <xsl:value-of select="$num"/>:
<xsl:value-of select="meta/creator"/>. <xsl:value-of select="meta/title"/>. <xsl:value-of select="meta/year"/>.
[<xsl:value-of select="$url"/>]

      </xsl:for-each>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->

   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">

      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z S�MBOLO'"/>

      <html xml:lang="en" lang="en">
         <head>
            <title>LexML : Resultado da Pesquisa</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support  -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/>
            <script src="script/yui/connection-min.js" type="text/javascript"></script>
         </head>
         <body>

            <!-- header -->
            <xsl:copy-of select="$brand.header"/>

            <!-- result header -->
            <div class="resultsHeader">
               <table>
                  <tr>
                     <td colspan="2" class="right">
                        <xsl:variable name="bag" select="session:getData('bag')"/>
                        <a href="{$xtfURL}{$crossqueryPath}?smode=showBag">Cesta de Itens</a>
                        (<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <b>Visualizar por:&#160;</b>
                        <xsl:choose>
                           <xsl:when test="$browse-title">T�tulo</xsl:when>
                           <xsl:when test="$browse-creator">Autor</xsl:when>
                           <xsl:otherwise>Todos os itens</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="right">
						 <a href="javascript:history.back()">Página Anterior</a>
						 <xsl:text>&#160;|&#160;</xsl:text>
                        <a href="{$xtfURL}">
                           <xsl:text>P�gina Inicial</xsl:text>
                        </a>
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>Retornar ao resultado da pesquisa</xsl:text>
                           </a>
                        </xsl:if>
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <b>Resultados:&#160;</b>
                        <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items &gt; 1">
                              <xsl:value-of select="$items"/>
                              <xsl:text> Itens</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$items"/>
                              <xsl:text> Item</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="right">
                        <xsl:text>Visualizar por: </xsl:text>
                        <xsl:call-template name="browseLinks"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="2" class="center">
                        <xsl:call-template name="alphaList">
                           <xsl:with-param name="alphaList" select="$alphaList"/>
                        </xsl:call-template>
                     </td>
                  </tr>

               </table>
            </div>

            <!-- results -->
            <div class="results">
               <table>
                  <tr>
                     <td>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </table>
            </div>

            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>

         </body>
      </html>
   </xsl:template>

   <xsl:template name="browseLinks">
      <xsl:choose>
         <xsl:when test="$browse-all">
            <xsl:text>Visualizar Tudo</xsl:text>
<!--            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">T�tulo</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Autor</a>-->
         </xsl:when>
         <!-- <xsl:when test="$browse-title">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Tudo</a>
            <xsl:text> | T�tulo | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Autor</a>
         </xsl:when>
         <xsl:when test="$browse-creator">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Tudo</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">T�tuloo</a>
            <xsl:text>  | Autor</xsl:text>
         </xsl:when> -->
         <xsl:otherwise>
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Visualizar Tudo</a>
        <!--    <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">T�tulo</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Autor</a> -->
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Document Hit Template                                                  -->
   <!-- ====================================================================== -->

   <xsl:template match="docHit" exclude-result-prefixes="#all">

      <xsl:variable name="path" select="@path"/>

      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>

      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <div id="main_{@rank}" class="docHit">
         <table>
            <tr>
               <td class="col1">
                  <xsl:choose>
                     <xsl:when test="$sort = ''">
                        <b><xsl:value-of select="@rank"/></b>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <xsl:choose>
                  <xsl:when test="starts-with(meta/facet-tipoDocumento[1],'Doutrina')">
                     <td class="col2">&#160;
                     </td>
                     <td class="col3">&#160;
                     </td>
                  </xsl:when>
                  <xsl:otherwise>
                     <td class="col2">
                        <xsl:if test="$sort = 'localidade'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Localidade&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <xsl:choose>
                           <xsl:when test="meta/localidade">
                              <xsl:apply-templates select="meta/localidade[1]"/>
                           </xsl:when>
                           <xsl:otherwise>nenhuma</xsl:otherwise>
                        </xsl:choose>
               </td>
                  </xsl:otherwise>
               </xsl:choose>
               <td class="col4">
                  <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET',
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) {
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Retirar</a>
                           </span>
                        </xsl:when>
                        <xsl:otherwise>
                           <script type="text/javascript">
                              add_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Adicionando...";
                                 YAHOO.util.Connect.asyncRequest('GET',
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                    {  success: function(o) {
                                          span.innerHTML = o.responseText;
                                          ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Falha na inclus�o!'; }
                                    }, null);
                              };
                           </script>
                           <span id="add_{@rank}">
                              <a href="javascript:add_{@rank}()">Adicionar</a>
                           </span>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </td>
            </tr>
            <xsl:if test="not(starts-with(meta/facet-tipoDocumento[1],'Doutrina'))">
                  <xsl:for-each select="meta/autoridade">
                        <tr>
                           <td class="col1">
                              <xsl:text>&#160;</xsl:text>
                           </td>
                           <td class="col2">
                              <xsl:if test="$sort = 'creator'">
                                 <a name="{$anchor}"/>
                              </xsl:if>
                              <b>Autoridade&#160;&#160;</b>
                           </td>
                           <td class="col3">
                                <xsl:apply-templates select="."/>
                           </td>
                           <td class="col4">
                              <xsl:text>&#160;</xsl:text>
                           </td>
                        </tr>
                  </xsl:for-each>
            </xsl:if>

            <xsl:if test="starts-with(meta/facet-tipoDocumento[1],'Doutrina')">
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Tipo&#160;&#160;</b>
               </td>
               <td class="col3">
                    <xsl:value-of select="substring-after(meta/facet-tipoDocumento[1], 'Doutrina::')"/>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
            </xsl:if>
            <xsl:for-each select="meta/doutrinaAutor">
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <xsl:if test="$sort = 'creator'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Autor&#160;&#160;</b>
               </td>
               <td class="col3">
                    <xsl:apply-templates select="."/>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
            </xsl:for-each>
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <xsl:if test="$sort = 'title'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>T�tulo&#160;&#160;</b>
               </td>
               <td class="col3">
                  <a>
                     <xsl:attribute name="href">
                        <xsl:choose>
                           <xsl:when test="matches(meta/display, 'dynaxml')">
                              <xsl:call-template name="dynaxml.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:when>
                           <!-- <xsl:otherwise>
                              <xsl:call-template name="rawDisplay.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:otherwise> -->
                           <xsl:otherwise>
						      <xsl:text>/urn/</xsl:text><xsl:value-of select="meta/urn[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="meta/title">
                           <xsl:apply-templates select="meta/title[1]"/>
                        </xsl:when>
                        <xsl:otherwise>nenhuma</xsl:otherwise>
                     </xsl:choose>
                  </a>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:variable name="type" select="meta/type"/>
                 <!-- <span class="typeIcon">
                     <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span> -->
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
			<xsl:for-each  select="meta/apelido">
	            <tr>
	               <td class="col1">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	               <td class="col2">
	                  <b>&#160;&#160;</b>
	               </td>
	               <td class="col3">
	                    <xsl:apply-templates select="."/>
	               </td>
	               <td class="col4">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	            </tr>
			</xsl:for-each>
			<xsl:if test="meta/date">
	            <tr>
	               <td class="col1">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	               <td class="col2">
	                  <b>Data&#160;&#160;</b>
	               </td>
	               <td class="col3">
	                  <xsl:choose>
	                     <xsl:when test="meta/year and false"> <!-- desativado esta op��o para sempre mostrar a data -->
	                        <xsl:value-of select="replace(meta/year,'^.+ ','')"/>
	                     </xsl:when>
	                     <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="starts-with(meta/facet-tipoDocumento[1],'Doutrina')"><xsl:value-of select="meta/anosDoutrina"/></xsl:when>
                                <xsl:otherwise><xsl:apply-templates select="meta/dataRepresentativa[1]"/></xsl:otherwise>
                            </xsl:choose>
	                     </xsl:otherwise>
	                  </xsl:choose>
	               </td>
	               <td class="col4">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	            </tr>
			</xsl:if>
			<xsl:if test="meta/description[1]">
	            <tr>
	               <td class="col1">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	               <td class="col2">
	                  <b>Ementa&#160;&#160;</b>
	               </td>
	               <td class="col3">
	                    <xsl:apply-templates select="meta/description[1]"/>
	               </td>
	               <td class="col4">
	                  <xsl:text>&#160;</xsl:text>
	               </td>
	            </tr>
			</xsl:if>
            <xsl:if test="not(starts-with(meta/facet-tipoDocumento[1],'Doutrina'))">
                <xsl:for-each select="meta/urn">
    			<tr>
                   <td class="col1">
                      <xsl:text>&#160;</xsl:text>
                   </td>
                   <td class="col2">
                      <b>URN&#160;&#160;</b>
                   </td>
                   <td class="col3">
                        <xsl:apply-templates select="."/>
                   </td>
                   <td class="col4">
                      <xsl:text>&#160;</xsl:text>
                   </td>
                </tr>
    			</xsl:for-each>
              </xsl:if>
            <xsl:if test="meta/subject">
               <tr>
                  <td class="col1">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <b>Assuntos&#160;&#160;</b>
                  </td>
                  <td class="col3">
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td class="col4">
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if>
            <xsl:if test="starts-with(meta/facet-tipoDocumento[1],'Doutrina')">
                <xsl:for-each select="meta/doutrinaClasse">
          <tr>
                   <td class="col1">
                      <xsl:text>&#160;</xsl:text>
                   </td>
                   <td class="col2">
                      <b>Classifica��o&#160;&#160;</b>
                   </td>
                   <td class="col3">
                        <xsl:apply-templates select="."/>
                   </td>
                   <td class="col4">
                      <xsl:text>&#160;</xsl:text>
                   </td>
                </tr>
          </xsl:for-each>
              </xsl:if>
         <!--   <xsl:if test="snippet">
               <tr>
                  <td class="col1">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <b>Matches:&#160;&#160;</b>
                     <br/>
                     <xsl:value-of select="@totalHits"/>
                     <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                  </td>
                  <td class="col3" colspan="2">
                     <xsl:apply-templates select="snippet" mode="text"/>
                  </td>
               </tr>
            </xsl:if> -->

            <!-- "more like this"
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td class="col3" colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET',
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" }
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr> -->

         </table>
      </div>

   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Snippet Template (for snippets in the full text)                       -->
   <!-- ====================================================================== -->

   <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
      <xsl:text>...</xsl:text>
      <xsl:apply-templates mode="text"/>
      <xsl:text>...</xsl:text>
      <br/>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in the full text)                          -->
   <!-- ====================================================================== -->

   <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
      <xsl:variable name="path" select="ancestor::docHit/@path"/>
      <xsl:variable name="display" select="ancestor::docHit/meta/display"/>
      <xsl:variable name="hit.rank"><xsl:value-of select="ancestor::snippet/@rank"/></xsl:variable>
      <xsl:variable name="snippet.link">
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$snippet.link}" class="hit"><xsl:apply-templates/></a>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in meta-data fields)                       -->
   <!-- ====================================================================== -->

   <xsl:template match="term" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:otherwise>
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <!-- ====================================================================== -->
   <!-- More Like This Template                                                -->
   <!-- ====================================================================== -->

   <!-- results -->
   <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="docHit">
            <div class="moreLike">
               <ol>
                  <xsl:apply-templates select="docHit" mode="moreLike"/>
               </ol>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="moreLike">
               <b>N�o encontrou documentos similares.</b>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- docHit -->
   <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">

      <xsl:variable name="path" select="@path"/>

      <li>
         <xsl:apply-templates select="meta/creator[1]"/>
         <xsl:text>. </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="matches(meta/display, 'dynaxml')">
                     <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="rawDisplay.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="meta/title[1]"/>
         </a>
         <xsl:text>. </xsl:text>
         <xsl:apply-templates select="meta/year[1]"/>
         <xsl:text>. </xsl:text>
      </li>

   </xsl:template>

</xsl:stylesheet>
