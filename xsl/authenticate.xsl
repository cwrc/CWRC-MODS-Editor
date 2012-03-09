<?xml version="1.0"?>
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
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- Get the name from the request paramter -->
<xsl:param name="ID"/>
<xsl:param name="password"/>

<xsl:template match="/">
<authentication>
<!-- for demo purposes we allow any user id, so we don't bother looking it up -->

<!-- 		<xsl:if test="/users/user[ID = $ID and @password = $password"> -->
			<ID><xsl:value-of select="$ID"/></ID>
<!--		</xsl:if> -->
		
 </authentication>  
</xsl:template>

</xsl:stylesheet>
