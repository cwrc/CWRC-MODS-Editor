<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<!--<xsl:template match="section/title">
	<div class="title">
		<img src="hdr-logo-small.png" class="small.logo"/>
		<h2><xsl:value-of select="."/></h2>
	</div>
</xsl:template>-->
  <xsl:param name="html.stylesheet">css/stylesheet.css</xsl:param>
  <xsl:param name="html.stylesheet.type">text/css</xsl:param>         
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.autolabel.max.depth" select="3"/>

  <xsl:param name="section.label.includes.component.label" select="1"/>

</xsl:stylesheet>
