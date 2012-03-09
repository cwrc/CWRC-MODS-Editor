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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" >
<!-- preprocess MODS records for binding into the form

NOTE: this runs after strip-namespaces.xsl, so all MODS elements are in the form "mods_xxx" -->

<xsl:output method="xml" indent="yes" encoding="utf-8"/>

<!-- identity transformation -->
<xsl:template match="* | @* | text()">
	<xsl:copy>
		<xsl:apply-templates select="* | @* | text()"/>
	</xsl:copy>
</xsl:template>

<!-- convert yes/no values into true/false, so that they can be handled by boolean widgets -->
	<xsl:template match="mods_typeOfResource/@collection | mods_typeOfResource/@manuscript">
		<xsl:attribute name="{name()}"><xsl:choose><xsl:when test=". = 'yes'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<!-- collapse various date elements into single element with type attribute -->
	<xsl:template match="mods_dateIssued | mods_dateCreated | mods_dateCaptured | mods_dateValid | mods_dateModified | mods_copyrightDate | mods_dateOther">
		<temp_date>
			<xsl:attribute name="temp_type"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:apply-templates select="@* | * | text()[normalize-space(.) != '']"/>
		</temp_date>
	</xsl:template>
   
   
   <!-- convert tei elements to text -->
   <xsl:template match="*[starts-with(name(), 'tei_')]">
      <xsl:text>&lt;tei:</xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:apply-templates select="@*" mode="text"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:copy-of select="text()"/>
      <xsl:text>&lt;/tei:</xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:text>&gt;</xsl:text>      
   </xsl:template>
   <xsl:template match="@*" mode="text">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>="</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"</xsl:text>
   </xsl:template>
</xsl:stylesheet>
