<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   exclude-result-prefixes="xd"
   version="1.0">
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Created on:</xd:b> Mar 2, 2012</xd:p>
         <xd:p><xd:b>Author:</xd:b> peterbinkley</xd:p>
         <xd:p></xd:p>
      </xd:desc>
   </xd:doc>
   <xsl:output method="xml"/>
   <xsl:param name="fedora"/>
      
      <xsl:template match="/">
         <request xmlns="http://cocoon.apache.org/webdav/1.0"
            xmlns:d="DAV:"
            target="webdav://{$fedora}/objects/nextPID?format=xml"
            method="POST">
         </request>
      </xsl:template>
   
</xsl:stylesheet>