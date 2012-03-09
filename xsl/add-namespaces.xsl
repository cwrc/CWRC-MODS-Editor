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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	exclude-result-prefixes="mods">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/wrapper">
		<xsl:copy>
			<xsl:apply-templates select="*" />
		</xsl:copy>
	</xsl:template>
	<!-- normalize order of top-level elements -->
	<xsl:template match="mods_mods">
		<mods>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="mods_titleInfo" />
			<xsl:apply-templates select="mods_name" />
			<xsl:apply-templates select="mods_typeOfResource" />
			<xsl:apply-templates select="mods_genre" />
			<xsl:apply-templates select="mods_originInfo" />
			<xsl:apply-templates select="mods_language" />
			<xsl:apply-templates select="mods_physicalDescription" />
			<xsl:apply-templates select="mods_abstract" />
			<xsl:apply-templates select="mods_tableOfContents" />
			<xsl:apply-templates select="mods_targetAudience" />
			<xsl:apply-templates select="mods_note" />
			<xsl:apply-templates select="mods_subject" />
			<xsl:apply-templates select="mods_classification" />
			<xsl:apply-templates select="mods_relatedItem" />
			<xsl:apply-templates select="mods_identifier" />
			<xsl:apply-templates select="mods_location" />
			<xsl:apply-templates select="mods_accessCondition" />
			<xsl:apply-templates select="mods_extension" />
			<xsl:apply-templates select="mods_recordInfo" />
		</mods>
	</xsl:template>
	<xsl:template match="*">
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="contains(name(), '_')">
					<xsl:value-of select="substring-after(name(), '_')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="namespace">
			<xsl:choose>
				<xsl:when test="contains(name(), '_')">
					<xsl:value-of
						select="substring-before(name(), '_')" />
				</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace = 'mods'">
				<xsl:element name="{$name}">
					<xsl:apply-templates select="@* | * | text()" />
				</xsl:element>
			</xsl:when>
			<xsl:when test="$namespace = ''">
				<xsl:element name="nil:{$name}">
					<xsl:apply-templates select="@* | * | text()" />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$namespace}:{$name}">
					<xsl:apply-templates select="@* | * | text()" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:choose>
			<xsl:when test="contains(name(), '_')">
				<xsl:variable name="prefix" select="substring-before(name(), '_')"/>
				<xsl:variable name="name" select="substring-after(name(), '_')"/>
				<xsl:variable name="namespace">
					<xsl:choose>
						<xsl:when test="$prefix = 'xml'">http://www.w3.org/XML/1998/namespace</xsl:when>
						<xsl:when test="$prefix = 'xlink'">http://www.w3.org/1999/xlink</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="{$name}" namespace="{$namespace}">
					<xsl:value-of select="." />
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="{name()}" namespace="">
					<xsl:value-of select="." />
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="mods_nonSort">
		<xsl:element name="nonSort">
			<xsl:apply-templates select="@*" />
			<xsl:value-of select="translate(., '+', ' ')" />
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
