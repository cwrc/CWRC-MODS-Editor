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
	xmlns="http://www.loc.gov/mods/v3"
	xmlns:mods="http://www.loc.gov/mods/v3">

	<xsl:output method="xml" indent="yes" />
	<xsl:param name="addSchema">false</xsl:param>
	<xsl:template match="/">
		<wrapper xmlns="">
			<xsl:choose>
				<xsl:when test="wrapper">
					<xsl:apply-templates select="wrapper/*" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*" />
				</xsl:otherwise>
			</xsl:choose>
		</wrapper>
	</xsl:template>
	<xsl:template match="mods">
		<mods xmlns="http://www.loc.gov/mods/v3"
			xmlns:xlink="http://www.w3.org/1999/xlink"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			version="{@version}">
			<xsl:if test="$addSchema = 'true'">
				<xsl:variable name="version"
					select="translate(@version, '.', '-')" />
				<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-</xsl:text><xsl:value-of
						select="$version" /><xsl:text>.xsd</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="*" />
		</mods>
	</xsl:template>
	<xsl:template match="*">
		<xsl:element name="{local-name()}"
			namespace="http://www.loc.gov/mods/v3">
			<xsl:apply-templates select="* | @* | text()" />
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*">
<!-- 		<xsl:attribute name="{name()}" xmlns="">
			<xsl:value-of select="." />
		</xsl:attribute>-->
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>
