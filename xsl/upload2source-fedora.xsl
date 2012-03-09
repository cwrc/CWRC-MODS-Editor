<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0"
   xmlns:session="http://apache.org/cocoon/session/1.0" exclude-result-prefixes="source session">
   <xsl:output method="xml" indent="yes"/>
   <xsl:param name="fedora"/>
   <xsl:template match="/upload">
      <document>
         <xsl:copy-of select="document/@id"/>
         <!-- source writer: writes to file -->
         <!--
		<source:insert>
			<source:source>repo/documents.xml</source:source>
			<source:path>/collection/documents</source:path>
			<source:replace>document[@id="<xsl:value-of select="document/@id"/>"]</source:replace>
			<source:fragment>
				<xsl:apply-templates select="/upload/document"/>
			</source:fragment>
		</source:insert>
		-->
         
         <xsl:variable name="targeturi"
            select="concat('webdav://', $fedora, '/objects/', 
            /upload/document/@id, '/datastreams/MODS')"/>
         <!-- webdav -->
         <request xmlns="http://cocoon.apache.org/webdav/1.0" xmlns:jx="http://apache.org/cocoon/templates/jx/1.0" xmlns:d="DAV:"
            target="{$targeturi}" method="PUT">
            <header name="Content-type" value="text/xml; charset=UTF-8"/>
            <body>
               <document xmlns="">
                  <xsl:copy-of select="/upload/document/@*[name() != 'new']"/>
                  <xsl:apply-templates select="/upload/document/*" mode="webdav"/>
               </document>
            </body>
         </request>
         <result>
            <xsl:copy-of select="/upload/document"/>
         </result>
      </document>
   </xsl:template>

   <xsl:template match="document">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <!-- must we get the elements in order, so that they'll validate against the schema?-->
         <xsl:copy-of select="*"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*" mode="webdav">
      <xsl:element name="{local-name()}">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="* | text()" mode="webdav"/>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
