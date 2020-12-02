<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0">



   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Search forms stylesheet                                                -->
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

   <!-- ====================================================================== -->
   <!-- Global parameters                                                      -->
   <!-- ====================================================================== -->

   <xsl:param name="freeformQuery"/>

   <!-- ====================================================================== -->
   <!-- Form Templates                                                         -->
   <!-- ====================================================================== -->

   <!-- main form page -->
   <xsl:template match="crossQueryResult" mode="form" exclude-result-prefixes="#all">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
         <head>
            <title>LexML : Formulários de Pesquisa</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>

<script>
function stringReplace(form) {
  var replaceStr = form.keyword.value;
  var pattern = /\;/g;
  form.keyword.value = replaceStr.replace(pattern, " ");

  if (trim(form.keyword.value, " ").length == 0)	 {
    window.location.href = "search?browse-all=yes";
	return false;
  }
}

function stringReplace2(form) {
  var replaceStr = form.keyword.value;
  var pattern = /\;/g;
  form.keyword.value = replaceStr.replace(pattern, " ");

}

function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}

function rtrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}


</script>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="searchPage">
               <div class="forms">
                  <table>
                     <tr>
                        <td class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}"><a href="search?smode=simple">Palavras e Frases</a></td>
                        <td class="{if(matches($smode,'advanced')) then 'tab-select' else 'tab'}"><a href="search?smode=advanced">Pesquisa Avançada</a></td>
                       <!-- <td class="{if(matches($smode,'freeform')) then 'tab-select' else 'tab'}"><a href="search?smode=freeform">Pesquisa Lógica</a></td> -->
                       <!-- <td class="{if(matches($smode,'browse')) then 'tab-select' else 'tab'}"><a href="search?smode=browse">Visualizar</a></td> -->
                     </tr>
                     <tr>
                        <td colspan="4">
                           <div class="form">
                              <xsl:choose>
                                 <xsl:when test="matches($smode,'simple')">
                                    <xsl:call-template name="simpleForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'advanced')">
                                    <xsl:call-template name="advancedForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'freeform')">
                                    <xsl:call-template name="freeformForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'browse')">
                                    <table>
                                       <tr>
                                          <td>
                                             <p>Visualizar todos os documentos:</p>
                                          </td>
                                       </tr>
                                       <tr>
                                          <td>
                                             <xsl:call-template name="browseLinks"/>
                                          </td>
                                       </tr>
                                    </table>
                                 </xsl:when>
                              </xsl:choose>
                           </div>
                        </td>
                     </tr>
                  </table>
               </div>
            </div>
            <xsl:copy-of select="$brand.footer"/>
         </body>
      </html>
   </xsl:template>

   <!-- simple form -->
   <xsl:template name="simpleForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table>
            <tr>
               <td>
                  <input type="text" name="keyword" size="40" value="{$keyword}"/>
                  <xsl:text>&#160;</xsl:text>
                  <input onclick="return stringReplace(form)" type="submit" value="Pesquise"/><xsl:text>&#160;&#160;</xsl:text>
                  <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Limpe"/>
               </td>
            </tr>
            <tr>
               <td>
                  <table class="sampleTable">
                     <tr>
                        <td colspan="2">Exemplos:</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">código</td>
                        <td class="sampleDescrip">Pesquisa a palavra "código"</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">código civil</td>
                        <td class="sampleDescrip">Pesquisa as palavras "código" e "civil"</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">"código civil"</td>
                        <td class="sampleDescrip">Pesquisa a frase "código civil"</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">imov*</td>
                        <td class="sampleDescrip">Pesquisa palavras iniciadas pelo radical "imov" (ex.:  "imóvel" e "imóveis").</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">UF??</td>
                        <td class="sampleDescrip">Pesquisa palavras iniciadas pelo radical "UF" seguidas de dois caracteres (ex: "UFPB" e "UFMG")</td>
                     </tr>
                  </table>
               </td>
            </tr>
         </table>
      </form>
   </xsl:template>

   <!-- advanced form -->
   <xsl:template name="advancedForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table class="top_table">
            <tr>
               <td>
                  <!-- <table class="left_table" border="1">
                     <tr>
                        <td colspan="3">
                           <h4>Entire Text</h4>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td colspan="2">
                           <input type="text" name="text" size="30" value="{$text}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td colspan="2">
                           <xsl:choose>
                              <xsl:when test="$text-join = 'or'">
                                 <input type="radio" name="text-join" value=""/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or" checked="checked"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <input type="radio" name="text-join" value="" checked="checked"/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text>these words</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Exclude</b></td>
                        <td>
                           <input type="text" name="text-exclude" size="20" value="{$text-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Proximity</b></td>
                        <td>
                           <select size="1" name="text-prox">
                              <xsl:choose>
                                 <xsl:when test="$text-prox = '1'">
                                    <option value=""></option>
                                    <option value="1" selected="selected">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '2'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2" selected="selected">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '3'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3" selected="selected">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '4'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4" selected="selected">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '5'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5" selected="selected">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '10'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '20'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20" selected="selected">20</option>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <option value="" selected="selected"></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </select>
                           <xsl:text> word(s)</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Section</b></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="$sectionType = 'head'">
                                 <input type="radio" name="sectionType" value=""/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head" checked="checked"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation"/><xsl:text> citations </xsl:text>
                              </xsl:when>
                              <xsl:when test="$sectionType = 'note'">
                                 <input type="radio" name="sectionType" value=""/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation" checked="checked"/><xsl:text> citations </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <input type="radio" name="sectionType" value="" checked="checked"/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation"/><xsl:text> citations </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </td>
                     </tr>
                  </table> -->
               </td>
               <td>
                  <table class="right_table" >
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Todos os Campos</b></td>
						<td>
                           <input type="text" name="keyword" size="50" value="{$keyword}"/>
                        </td>
                     </tr>
                  <!--   <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Excluindo</b></td>
                        <td>
                           <input type="text" name="keyword-exclude" size="40" value="{$keyword-exclude}"/>
                        </td>
                     </tr> -->
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Sigla</b></td>
                        <td>
                           <input type="text" name="acronimo" size="30" value="{$acronimo}"/>  exceto <input type="text" name="acronimo-exclude" size="20" value="{$acronimo-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Categoria do Documento</b></td>
                        <td>
                          <select name="f1-tipoDocumento">
                             <option value="">Todas</option>
                             <option value="Legislação">Legislação</option>
                             <option value="Jurisprudência">Jurisprudência</option>
                             <option value="Proposições&#160;Legislativas">Proposições&#160;Legislativas</option>
                             <option value="Doutrina">Doutrina</option>
                             <option value="Publicação&#160;Oficial">Publicação&#160;Oficial</option>
                             <option value="Outras&#160;Manifestações">Outras&#160;Manifestações</option>
                           </select>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Tipo do Documento</b></td>
                        <td>
                           <input type="text" name="tipoDocumento" size="30" value="{$tipoDocumento}"/>  exceto <input type="text" name="tipoDocumento-exclude" size="20" value="{$tipoDocumento-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Localidade</b></td>
                        <td>
                           <input type="text" name="localidade" size="30" value="{$localidade}"/> exceto <input type="text" name="localidade-exclude" size="20" value="{$localidade-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Esfera da Autoridade Emitente</b></td>
                        <td>
                          <select name="f2-autoridade">
                             <option value="">Todas</option>
                             <option value="Federal">Federal</option>
                             <option value="Estadual">Estadual</option>
                             <option value="Distrital">Distrital</option>
                             <option value="Municipal">Municipal</option>
                           </select>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Autoridade Emitente</b></td>
                        <td>
                           <input type="text" name="autoridade" size="30" value="{$autoridade}"/>  exceto <input type="text" name="autoridade-exclude" size="20" value="{$autoridade-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Número</b></td>
                        <td>
                           <input type="text" name="descritor" size="30" value="{$descritor}"/> exceto <input type="text" name="descritor-exclude" size="20" value="{$descritor-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Título</b></td>
                        <td>
                           <input type="text" name="title" size="30" value="{$title}"/> exceto <input type="text" name="title-exclude" size="20" value="{$title-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Apelido / Nome Popular</b></td>
                        <td>
                           <input type="text" name="apelido" size="30" value="{$apelido}"/> exceto <input type="text" name="apelido-exclude" size="20" value="{$apelido-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Ementa</b></td>
                        <td>
                           <input type="text" name="description" size="30" value="{$description}"/>  exceto <input type="text" name="description-exclude" size="20" value="{$description-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Assunto / Indexação</b></td>
                        <td>
                           <input type="text" name="subject" size="30" value="{$subject}"/>  exceto <input type="text" name="subject-exclude" size="20" value="{$subject-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>URN</b></td>
                        <td>
                           <input type="text" name="urn" size="30" value="{$urn}"/>  exceto <input type="text" name="urn-exclude" size="20" value="{$urn-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Do ano</b></td>
                        <td>
                           <input type="text" name="year" size="4" value="{$year}"/>
                           <xsl:text> até </xsl:text>
                           <input type="text" name="year-max" size="4" value="{$year-max}"/>
                        </td>
                     </tr>

                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label"><b>Doutrina</b></td>
                        <td>&#160;</td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label">Autor</td>
                        <td>
                           <input type="text" name="doutrinaAutor" size="30" value="{$doutrinaAutor}"/>  exceto <input type="text" name="doutrinaAutor-exclude" size="20" value="{$doutrinaAutor-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label">Classificação <a href="http://pt.wikipedia.org/wiki/Classifica%C3%A7%C3%A3o_decimal_de_direito">CDDir</a></td>
                        <td>
                           <input type="text" name="doutrinaClasse" size="30" value="{$doutrinaClasse}"/>  exceto <input type="text" name="doutrinaClasse-exclude" size="20" value="{$doutrinaClasse-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label">Idioma</td>
                        <td>
                           <input type="text" name="doutrinaLingua" size="30" value="{$doutrinaLingua}"/>  exceto <input type="text" name="doutrinaLingua-exclude" size="20" value="{$doutrinaLingua-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="col_label" title="utilize as siglas AGU, CAM, CLD, MJU, MTE, PGR, PRO, SEN, STF, STJ, STM, TCD, TJD e TST">Biblioteca</td>
                        <td>
                           <input type="text" name="doutrinaBiblioteca" size="30" value="{$doutrinaBiblioteca}"/>  exceto <input type="text" name="doutrinaBiblioteca-exclude" size="20" value="{$doutrinaBiblioteca-exclude}"/>
                        </td>
                     </tr>
                     <!-- <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Tipo</b></td>
                        <td>
                           <select size="1" name="type">
                              <option value="">All</option>
                              <option value="ead">EAD</option>
                              <option value="html">HTML</option>
                              <option value="word">Word</option>
                              <option value="nlm">NLM</option>
                              <option value="pdf">PDF</option>
                              <option value="tei">TEI</option>
                              <option value="text">Text</option>
                           </select>
                        </td>
                     </tr> -->
                     <tr>
                        <td colspan="3">&#160;</td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td>&#160;</td>
                        <td>
                           <input type="hidden" name="smode" value="advanced"/>
                           <input type="submit" onclick="return stringReplace2(form)" value="Pesquise"/><xsl:text>&#160;&#160;</xsl:text>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}?smode=advanced'" value="Limpe"/>
                        </td>
                     </tr>
                  </table>
               </td>
            </tr>
          <!--  <tr>
               <td colspan="2">
                  <table class="sampleTable">
                     <tr>
                        <td colspan="3">Exemplos:</td>
                     </tr>
                     <tr>
                        <td/>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search full text for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td>Exclude</td>
                        <td class="sampleQuery">race</td>
                        <td class="sampleDescrip">Exclude results which contain the term 'race'</td>
                     </tr>
                     <tr>
                        <td>Proximity</td>
                        <td><form action=""><select><option>5</option></select></form></td>
                        <td class="sampleDescrip">Match the full text terms, only if they are 5 or fewer words apart</td>
                     </tr>
                     <tr>
                        <td>Section</td>
                        <td><form action=""><input type="radio" checked="checked"/>headings</form></td>
                        <td class="sampleDescrip">Match the full text terms, only if they appear in document 'headings' (e.g. chapter titles)</td>
                     </tr>
                     <tr>
                        <td>Title</td>
                        <td class="sampleQuery">"south africa"</td>
                        <td class="sampleDescrip">Search for the phrase 'south africa' in the 'title' field</td>
                     </tr>
                     <tr>
                        <td>Year(s)</td>
                        <td><form action="">from <input type="text" value="2000" size="4"/> to <input type="text" value="2005" size="4"/></form></td>
                        <td class="sampleDescrip">Search for documents whose date falls in the range from '2000' to '2005'</td>
                     </tr>
                  </table>
               </td>
            </tr> -->
         </table>
      </form>
   </xsl:template>

   <!-- free-form form -->
   <xsl:template name="freeformForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table>
            <tr>
               <td>
                  <p><i>Experimental feature:</i> "Freeform" complex query supporting -/NOT, |/OR, &amp;/AND, field names, and parentheses.</p>
                  <input type="text" name="freeformQuery" size="40" value="{$freeformQuery}"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="Search"/>
                  <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
               </td>
            </tr>
            <tr>
               <td>
                  <table class="sampleTable">
                     <tr>
                        <td colspan="2">Examples:</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa</td>
                        <td class="sampleDescrip">Search keywords (full text and metadata) for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south &amp; africa</td>
                        <td class="sampleDescrip">(same)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south AND africa</td>
                        <td class="sampleDescrip">(same; note 'AND' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:south africa</td>
                        <td class="sampleDescrip">Search title for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">creator:moodley title:africa</td>
                        <td class="sampleDescrip">Search creator for 'moodley' AND title for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south | africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' OR 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south OR africa</td>
                        <td class="sampleDescrip">(same; note 'OR' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa -south</td>
                        <td class="sampleDescrip">Search keywords for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa NOT south</td>
                        <td class="sampleDescrip">(same; note 'NOT' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa -south</td>
                        <td class="sampleDescrip">Search title for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa subject:-politics</td>
                        <td class="sampleDescrip">
                           Search items with 'africa' in title but not 'politics' in subject.
                           Note '-' must follow ':'
                        </td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:-south</td>
                        <td class="sampleDescrip">Match all items without 'south' in title</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">-africa</td>
                        <td class="sampleDescrip">Match all items without 'africa' in keywords</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south (africa OR america)</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND either 'africa' OR 'america'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa OR america</td>
                        <td class="sampleDescrip">(same, due to precedence)</td>
                     </tr>
                  </table>
               </td>
            </tr>
         </table>
      </form>
   </xsl:template>

</xsl:stylesheet>
