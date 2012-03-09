<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- insert hidden "resource" field in login form, to enable redirect to the desired result -->
<xsl:output method="html" indent="yes"/>
<xsl:param name="resource"/>

<xsl:template match="* | @*">
	<xsl:copy>
		<xsl:apply-templates select="* | @* | text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="form">
	<xsl:copy>
		<xsl:apply-templates select="@*"/>
		<input name="resource" value="{$resource}" type="hidden"/>
		<xsl:apply-templates select="* | text()"/>
	</xsl:copy>
</xsl:template>
</xsl:stylesheet>
