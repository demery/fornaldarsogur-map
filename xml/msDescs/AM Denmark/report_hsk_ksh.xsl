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
  
  <!-- Load all mss containing hsk -->
  <xsl:variable name="bshDocuments" select="$fasDocuments[//title[@ref/contains(., 'hsk')]]"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>Report</title>
      </head>
      <body>  
        <p>Total number of documents: <xsl:value-of select="count($allDocuments)"/></p>
        <p>Number of XML documents: <xsl:value-of select="count($xmlDocuments)"/></p>
        <p>Number of XML documents conatining fas: <xsl:value-of select="count($fasDocuments)"/></p>
        <p>Number of mss containing hsk: <xsl:value-of select="count($bshDocuments)"></xsl:value-of></p>
        
       
        <p> shelfmark of all sagas containing hsk and thsv:
          <xsl:for-each select="$bshDocuments">
            <xsl:choose>
              <xsl:when test="//title[@ref/contains(., 'ksh')]"><xsl:value-of select="//msDesc//idno"/><br/></xsl:when>
            <xsl:otherwise/>
            </xsl:choose>
          </xsl:for-each>
          <br/></p>
        
        
        <p>Distinct values of all last item numbers in the fas documents and their frequency:  </p><p>      
          <xsl:variable name="last-number" select="$bshDocuments//msItem[not(following-sibling::msItem)]/@n"></xsl:variable>
          <xsl:variable name="distinct-last-numbers" select="distinct-values($bshDocuments//msItem[not(following-sibling::msItem)]/@n)"/>
          <ul>
            <xsl:for-each select="$distinct-last-numbers">
              <xsl:sort select="."/>
              <xsl:variable name="current-last-number" select="."></xsl:variable>
              <li><xsl:value-of select="."/><xsl:text> - </xsl:text>
                <xsl:value-of select="count($bshDocuments//msItem[not(following-sibling::msItem)][@n=$current-last-number])"></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul></p>
        
        
        
     
        
        <!--  <ul>
            <xsl:for-each select="$xmlDocuments//msItem[@class='fas']/title[@ref='hsk']">
              
               <!-\- <xsl:when test="parent::msItem/parent::msContents/msItem[@class='fas']/title[@ref='ksh']">-\->
                <li><xsl:value-of select="ancestor::msDesc//idno"/></li>
             
              
              
            </xsl:for-each>
            
          </ul>-->

      </body>
    </html>
  </xsl:template>
  

</xsl:stylesheet>