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
	<xsl:param name="webdav"/>
	<xsl:param name="documentURI"/>
	<xsl:template match="/wrapper">
		<xsl:copy>
			<!-- copy the content for use later in the pipeline -->
			<xsl:copy-of select="*"/>
			<!-- prepare POST of MODS record -->
			<webdav:request xmlns:webdav="http://cocoon.apache.org/webdav/1.0" xmlns:d="DAV:" target="{$webdav}/{$documentURI}.xml" method="POST">
				<webdav:header name="Content-type" value="text/xml; charset=UTF-8"/>
				<webdav:body>
					<xsl:copy-of select="mods:mods" xmlns:mods="http://www.loc.gov/mods/v3"/>
				</webdav:body>
			</webdav:request>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
