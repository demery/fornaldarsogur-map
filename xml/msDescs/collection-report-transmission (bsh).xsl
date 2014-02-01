<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">
  
  <!--  This is an example transformation used for reports.  
     It is intended to be run ON ITSELF, and to 
     load its target documents using collection().-->
  
  <xsl:output method="xhtml"/>
  
  <!-- We start by loading all the documents in the current directory.
    This will give us a variable containing a sequence. -->
  <xsl:variable name="allDocuments" select="collection('.?select=*.x*;recurse=yes')"/>
  
 <!-- <xsl:variable name="allDocuments" select="collection('.?select=*.xml')"/>-->
  
  <!-- We'll also create a variable for just the XML documents (if there are other docs in the same subfolder). -->
  
  <xsl:variable name="xmlDocuments" select="collection('.?select=*.xml;recurse=yes')"/>
  
  <!-- Load all the fas documents -->
  <xsl:variable name="fasDocuments" select="$xmlDocuments[//msItem[@class/contains(., 'fas')]]"/>
  
  <!-- Load all mss containing bsh -->
  <xsl:variable name="bshDocuments" select="$fasDocuments[//title[@ref/contains(., 'bsh')]]"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>Report</title>
      </head>
      <body>  
        <p>Total number of documents: <xsl:value-of select="count($allDocuments)"/></p>
        <p>Number of XML documents: <xsl:value-of select="count($xmlDocuments)"/></p>
        <p>Number of XML documents conatining fas: <xsl:value-of select="count($fasDocuments)"/></p>
       <!-- <p>Number of mss containing bsh: <xsl:value-of select="count($bshDocuments)"></xsl:value-of></p>-->
        <p>Number of msItems containing fas: <xsl:value-of select="count($fasDocuments//msItem[@class='fas'])"></xsl:value-of></p>
        <p>secound count of fas itams: <xsl:value-of select="count($fasDocuments//title[@ref])"></xsl:value-of></p>
    
    <p>Distinct values of personal names (key of name element with tyep="person"):
     
      <ul><xsl:for-each select="distinct-values($fasDocuments//name[@type='person']/@key)">
        <xsl:sort select="."></xsl:sort>
        <li><xsl:value-of select="."/></li>
     </xsl:for-each></ul>
     Distinct values of scribes (scribeRef of handNote):
      <ul><xsl:for-each select="distinct-values($fasDocuments//handNote/@scribeRef)">
        <xsl:sort select="."></xsl:sort>
        <li><xsl:value-of select="."/></li>
      </xsl:for-each></ul>
    </p>
        
<!--       <p>Distinct values of all last item numbers in the fas documents and their frequency:  </p><p>      
         <xsl:variable name="last-number" select="$fasDocuments//msItem[not(following-sibling::msItem)]/@n"></xsl:variable>
         <xsl:variable name="distinct-last-numbers" select="distinct-values($fasDocuments//msItem[not(following-sibling::msItem)]/@n)"/>
        <ul>
          <xsl:for-each select="$distinct-last-numbers">
            <xsl:sort select="."/>
            <xsl:variable name="current-last-number" select="."></xsl:variable>
            <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
              <xsl:value-of select="count($fasDocuments//msItem[not(following-sibling::msItem)][@n=$current-last-number])"></xsl:value-of>
            </li>
          </xsl:for-each>
        </ul></p>
        
        <p>Manuscript dates:</p>
        <p>Manuscripts from the 12th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '11')])"></xsl:value-of></p>
        <p>Manuscripts from the 13th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '12')])"></xsl:value-of></p>
        <p>Manuscripts from the 14th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '13')])"></xsl:value-of></p>
        <p>Manuscripts from the 15th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '14')])"></xsl:value-of></p>
        <p>Manuscripts from the 16th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '15')])"></xsl:value-of></p>
        <p>Manuscripts from the 17th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '16')])"></xsl:value-of></p>
        <p>Manuscripts from the 18th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '17')])"></xsl:value-of></p>
        <p>Manuscripts from the 19th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '18')])"></xsl:value-of></p>
        <p>Manuscripts from the 20th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '19')])"></xsl:value-of></p>
        
        <p>Manuscript dates (more detail):</p>
        <p>Manuscripts from the 12th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '11')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 12th c.:
          <xsl:variable name="distinct-places-tvel" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '11')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-tvel">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '11')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 13th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '12')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 13th c.:
          <xsl:variable name="distinct-places-thir" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '12')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-thir">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '12')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 14th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '13')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 14th c.:
          <xsl:variable name="distinct-places-fort" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '13')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-fort">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '13')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 15th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '14')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 15th c.:
          <xsl:variable name="distinct-places-fift" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '14')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-fift">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '14')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 16th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '15')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 16th c.:
          <xsl:variable name="distinct-places-sixt" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '15')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-sixt">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '15')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 17th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '16')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 17th c.:
          <xsl:variable name="distinct-places-seve" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '16')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-seve">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '16')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 18th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '17')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 18th c.:
          <xsl:variable name="distinct-places-eigt" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '17')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-eigt">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '17')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 19th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '18')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 19th c.:
          <xsl:variable name="distinct-places-nine" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '18')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-nine">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '18')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        <p>Manuscripts from the 20th c.: <xsl:value-of select="count($fasDocuments//origDate/@*[1][starts-with(., '19')])"></xsl:value-of></p>
        <p>Distinct places for mss from the 20th c.:
          <xsl:variable name="distinct-places-twen" select="distinct-values($fasDocuments//origPlace/@key[ancestor::origin/origDate/@*[1][starts-with(., '19')]])"/>
          <ul>
            <xsl:for-each select="$distinct-places-twen">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()][ancestor::origin//origDate/@*[1][starts-with(., '19')]])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
      
      <p>Places of origin:</p>
        <p>Distinct values of all places in the fas documents and their frequency:  </p><p>      
          
          <xsl:variable name="distinct-places" select="distinct-values($fasDocuments//origPlace/@key)"/>
          <ul>
            <xsl:for-each select="$distinct-places">
              <xsl:sort select="."/>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($fasDocuments//origPlace[@key=current()])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>-->
        
       
     <!--  <p> shelfmark of all mss from the 16th c.:
         <xsl:for-each select="$fasDocuments//origDate/@*[1][starts-with(., '15')]">
           <xsl:value-of select="//msDesc//idno"/><xsl:text>; </xsl:text>
          </xsl:for-each>
          <br/></p>-->
          <!-- b)<xsl:for-each select="$fasDocuments//origPlace[@key='']">
            <xsl:value-of select="ancestor::msDesc//idno"/>
          </xsl:for-each>
        </p>-->
      
      
      </body>
    </html>
  </xsl:template>
  
  
</xsl:stylesheet>