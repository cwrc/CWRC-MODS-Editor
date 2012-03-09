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
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:param name="documentURI"/>
	<xsl:param name="repo"/>
	<xsl:template match="/wrapper">
		<xsl:copy>
			<!-- copy the content for use later in the pipeline -->
			<xsl:copy-of select="*"/>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source>
					<xsl:value-of select="$repo"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$documentURI"/>
					<xsl:text>.xml</xsl:text>
				</source:source>
				<source:fragment>
					<xsl:copy-of select="mods:mods" xmlns:mods="http://www.loc.gov/mods/v3"/>
				</source:fragment>
			</source:write>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
