<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2005, 2007, 2008 University of Alberta Libraries  
    
This file is part of MODS Editor.

MODS Editor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MODS Editor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MODS Editor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:webdav="http://cocoon.apache.org/webdav/1.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="webdav source">
	<xsl:output method="html"/>
	<xsl:param name="baselink"/>
	<xsl:param name="documentURI"/>
	<xsl:param name="fsk"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>Upload result: Document <xsl:value-of select="wrapper/@id"/>
				</title>
				<style type="text/css">
				.status_2 {margin: 1em; border: solid green 1em; padding: 1em;}
				.status_4 {margin: 1em; border: solid red 1em; padding: 1em; background: pink;}
				.status_5 {margin: 1em; border: solid black 1em; padding: 1em; background: pink;}
			</style>
			</head>
			<body>
				<h2>Upload result: Document <xsl:value-of select="wrapper/@id"/>
				</h2>
				<div>
					<xsl:apply-templates select="/wrapper/sourceResult"/>
					<xsl:apply-templates select="/wrapper/webdav:response"/>
				</div>
				<!-- 
				<p>
					<a href="{$baselink}/item/edit/form?item={document/@id}">Re-edit document <xsl:value-of select="document/@id"/>
					</a>
					<br/>
					<a href="{$baselink}/item/edit/form?item=new">Add another document</a>
					<br/>
					<a href="{$baselink}/documents.html?source={document/@source}&amp;folder={document/@source-folder}&amp;edit=on">
						<xsl:text>Go to </xsl:text>
						<xsl:value-of select="document/@source"/>
						<xsl:text>, folder </xsl:text>
						<xsl:value-of select="document/@source-folder"/>
					</a>
				</p>
				-->
				<p>
					<a>
						<xsl:attribute name="href">/action/submit/resume?__fsk=<xsl:value-of select="$fsk" /></xsl:attribute>
						Return to deposit form
					</a>
				</p>
				<script type="text/javascript">
					window.location.href = '/action/submit/resume?__fsk=<xsl:value-of select="$fsk" />';
				</script>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="*">
		<b>
			<xsl:value-of select="name()"/>
		</b>: <xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<xsl:template match="sourceResult">
		<h3>Write File</h3>
		<xsl:choose>
			<xsl:when test="execution = 'success'">
				<p class="status_2">The MODS record was saved as <xsl:value-of select="source"/>.</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="status_5">The MODS record could not be saved as <xsl:value-of select="source"/>.</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="webdav:response">
		<h3>Webdav</h3>
		<xsl:value-of select="@method"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@target"/>
		<p class="status_{substring(webdav:status/@code, 1, 1)}">
			<b>Status:</b>
			<xsl:text> </xsl:text>
			<xsl:value-of select="webdav:status/@code"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="webdav:status/@msg"/>
		</p>
	</xsl:template>
</xsl:stylesheet>
