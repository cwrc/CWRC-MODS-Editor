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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3">
	<xsl:output method="xml"/>
	<xsl:template match="*">
		<xsl:element name="{translate(name(), ':', '_')}">
			<xsl:apply-templates select="@* | * | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mods:*">
		<xsl:element name="mods_{local-name()}">
			<xsl:apply-templates select="@* | * | text()[normalize-space(.) != '']"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{translate(name(), ':', '_')}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="mods:typeOfResource/@collection | mods:typeOfResource/@manuscript">
		<xsl:attribute name="{name()}"><xsl:choose><xsl:when test=". = 'yes'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<!-- collapse dates into single element with type attribute -->
	<xsl:template match="mods:dateIssued | mods:dateCreated | mods:dateCaptured | mods:dateValid | mods:dateModified | mods:copyrightDate | mods:dateOther">
		<temp_date>
			<xsl:attribute name="temp_type"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:apply-templates select="@* | * | text()[normalize-space(.) != '']"/>
		</temp_date>
	</xsl:template>
	<!--  preserve whitespace in nonSort element -->
	<xsl:template match="mods:nonSort">
		<mods_nonSort>
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="translate(., ' ', '+')"/>
		</mods_nonSort>
	</xsl:template>
</xsl:stylesheet>
