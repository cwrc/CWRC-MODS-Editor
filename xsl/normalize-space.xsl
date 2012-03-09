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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="* | @* | text()">
	<xsl:copy>
		<xsl:apply-templates select="* | @* | text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="text()[normalize-space(.) = '']"/>
<xsl:template match="text()">
	<xsl:if test="preceding-sibling::node()">
	<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:value-of select="normalize-space(.)"/>
	<xsl:if test="following-sibling::node()">
	<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>
