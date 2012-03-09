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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fd="http://apache.org/cocoon/forms/1.0#definition" xmlns:doc="http://peel.library.ualberta.ca/modseditor/doc/1.0" exclude-result-prefixes="fd doc">
	<xsl:output method="html" indent="yes"/>
	<xsl:variable name="top-level-elements">|titleInfo|name|typeOfResource|genre|originInfo|language|physicalDescription|abstract|tableOfContents|targetAudience|note|subject|classification|relatedItem|identifier|location|accessCondition|part|extension|recordInfo|</xsl:variable>
	<xsl:template match="/">
		<html>
			<head>
				<title>Documentation: MODS Form Model</title>
				<link type="text/css" href="../css/mods-editor-doc.css" rel="stylesheet"/>
			</head>
			<body>
				<h1>Documentation: MODS Form Model</h1>
				<ul>
					<xsl:apply-templates select="*"/>
				</ul>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="fd:class | fd:repeater | fd:field | fd:union | fd:struct | fd:output | fd:submit">
		<xsl:variable name="this" select="local-name()"/>
		<xsl:variable name="thisid" select="@id"/>
		<li class="{$this}">
			<span class="{$this}">
				<xsl:value-of select="$this"/>
			</span>
			<xsl:text>: </xsl:text>
			<span class="id">
				<xsl:value-of select="@id"/>
			</span>
			<xsl:if test="$this = 'class'">
				<xsl:variable name="rawclassname" select="substring-before(@id, '-class')"/>
				<xsl:variable name="classname">
					<xsl:choose>
						<xsl:when test="$rawclassname='xidentifier'">identifier</xsl:when>
						<xsl:otherwise><xsl:value-of select="$rawclassname"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="contains($top-level-elements, concat('|', $classname, '|'))">
					<p class="doc-links">
						<span class="label">MODS Documentation:</span>
						<xsl:text> </xsl:text>
						<a href="http://www.loc.gov/standards/mods/mods-outline.html#{$classname}">outline</a>
						<xsl:text> | </xsl:text>
						<a href="http://www.loc.gov/standards/mods/v3/mods-userguide-elements.html#{$classname}">guidelines</a>
					</p>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="doc:doc"/>
			<xsl:choose>
				<xsl:when test="$this = 'class'">
					<a id="{$thisid}"/>
					<br/>
					<span class="label">Used by: </span>
					<xsl:for-each select="//fd:class[.//fd:new[@id=$thisid]]">
						<xsl:sort select="@id" data-type="string" order="ascending"/>
						<a href="#{@id}">
							<xsl:value-of select="@id"/>
						</a>
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$this = 'field'">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="fd:datatype/@base"/>
					<xsl:if test="fd:selection-list">
						<xsl:text>; </xsl:text>
						<span class="label">with selection list:</span>
						<xsl:text> </xsl:text>
						<xsl:for-each select="fd:selection-list/fd:item">
							<span class="selection-list-item">
								<xsl:choose>
									<xsl:when test="@value != ''">
										<xsl:value-of select="@value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
							<xsl:if test="position() != last()">
								<xsl:text> | </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="fd:label"/>
			<xsl:if test="fd:widgets/fd:new">
				<br/>
				<span class="label">Uses: </span>
				<xsl:for-each select="fd:widgets/fd:new">
					<xsl:sort select="@id" data-type="string" order="ascending"/>
					<a href="#{@id}">
						<xsl:value-of select="@id"/>
					</a>
					<xsl:if test="position() != last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<ul class="{$this}">
				<xsl:apply-templates select="fd:*[not(local-name() = 'label')]"/>
			</ul>
		</li>
	</xsl:template>
	<xsl:template match="text()"/>
	<xsl:template match="doc:doc">
		<div class="doc">
			<xsl:copy-of select="node()"/>
		</div>
	</xsl:template>
	<xsl:template match="fd:label">
		<xsl:text> [</xsl:text>
		<span class="label">Label</span>
		<xsl:text>: "</xsl:text>
		<span class="id">
			<xsl:value-of select="."/>
		</span>
		<xsl:text>"]</xsl:text>
	</xsl:template>
	<!-- suppress selection lists, so their labels don't get output (handled by for-each above) -->
	<xsl:template match="fd:selection-list | fd:row-action | fd:repeater-action"/>
</xsl:stylesheet>
