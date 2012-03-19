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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3"
xmlns:management="http://www.fedora.info/definitions/1/0/management/"
   xmlns:webdav="http://cocoon.apache.org/webdav/1.0" 
exclude-result-prefixes="mods webdav"
>
   <xsl:param name="uuid"/>
   <xsl:param name="repo"/>
   <xsl:param name="fedora"/>
   <xsl:param name="documentURI"/>
   
   <xsl:variable name="saveuuid">
      <xsl:choose>
         <xsl:when test="$uuid='new'">
            <xsl:value-of select="document('cocoon:/fedora-nextPID')/webdav:response/webdav:body/management:pidList/management:pid"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$uuid"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   
   <xsl:template match="/wrapper">
      <xsl:copy>
         <xsl:attribute name="uuid">
            <xsl:value-of select="$saveuuid"/>
         </xsl:attribute>
         <xsl:attribute name="repo">
            <xsl:value-of select="$repo"/>
         </xsl:attribute>
         <xsl:attribute name="fedora">
            <xsl:value-of select="$fedora"/>
         </xsl:attribute>
         <xsl:attribute name="documentURI">
            <xsl:value-of select="$documentURI"/>
         </xsl:attribute>
         <!-- copy the content for use later in the pipeline -->
         <xsl:apply-templates select="mods:mods" mode="mods"/>
         <xsl:choose>
            
            <xsl:when test="$uuid = 'new'">
               <request xmlns="http://cocoon.apache.org/webdav/1.0" xmlns:d="DAV:"
                  target="webdav://{$fedora}/objects/{$saveuuid}?format=info:fedora/fedora-system:FOXML-1.1&amp;logMessage=Created+by+MODS+editor"
                  method="POST">
                  <webdav:header name="Content-type" value="text/xml; charset=UTF-8"/>
                  <webdav:body>
                     

                  <foxml:digitalObject VERSION="1.1" PID="{$saveuuid}"
                     xsi:schemaLocation="info:fedora/fedora-system:def/foxml# http://www.fedora.info/definitions/1/0/foxml1-1.xsd"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:foxml="info:fedora/fedora-system:def/foxml#">
                     <foxml:objectProperties>
                        <foxml:property NAME="info:fedora/fedora-system:def/model#state" VALUE="Active"/>
                        <foxml:property NAME="info:fedora/fedora-system:def/model#label" VALUE="{$saveuuid}"/>
                        <foxml:property NAME="info:fedora/fedora-system:def/model#ownerId" VALUE=""/>
                     </foxml:objectProperties>
                     <foxml:datastream ID="RELS-EXT" STATE="A" CONTROL_GROUP="X" VERSIONABLE="true">
                        <foxml:datastreamVersion ID="RELS-EXT.0" LABEL="" MIMETYPE="text/xml">
                           <foxml:xmlContent>
                              <rdf:RDF xmlns:rel="info:fedora/fedora-system:def/relations-external#"
                                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:fedora-model="info:fedora/fedora-system:def/model#">
                                 <rdf:Description rdf:about="info:fedora/{$saveuuid}">
                                    <fedora-model:hasModel rdf:resource="info:fedora/rcbfwb:CMO-document"/>
                                    <rel:isMemberOf rdf:resource="info:fedora/rcbfwb:collection"/>
                                 </rdf:Description>
                              </rdf:RDF>
                           </foxml:xmlContent>
                        </foxml:datastreamVersion>
                     </foxml:datastream>
                     <foxml:datastream ID="MODS" STATE="A" CONTROL_GROUP="X" VERSIONABLE="true">
                        <foxml:datastreamVersion ID="MODS.0" LABEL="Record" MIMETYPE="text/xml">
                           <foxml:xmlContent>
                              <xsl:apply-templates select="mods:mods" mode="mods"/>
                           </foxml:xmlContent>
                        </foxml:datastreamVersion>
                     </foxml:datastream>
                     <foxml:datastream ID="DC" STATE="A" CONTROL_GROUP="X" VERSIONABLE="true">
                        <foxml:datastreamVersion ID="DC1.0" LABEL="Dublin Core Record for this object" MIMETYPE="text/xml"
                           FORMAT_URI="http://www.openarchives.org/OAI/2.0/oai_dc/">
                           <foxml:xmlContent>
                              <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/">
                                 <dc:title>
                                    <xsl:value-of select="mods:mods/mods:titleInfo[1]/mods:title[1]"/>
                                 </dc:title>
                                 <dc:identifier>
                                    <xsl:value-of select="$saveuuid"/>
                                 </dc:identifier>
                              </oai_dc:dc>
                           </foxml:xmlContent>
                        </foxml:datastreamVersion>
                     </foxml:datastream>
                  </foxml:digitalObject>
                  </webdav:body>

               </request>



            </xsl:when>
            
            <xsl:otherwise>
               
               <!-- prepare PUT of MODS record -->
               <webdav:request xmlns:webdav="http://cocoon.apache.org/webdav/1.0" xmlns:d="DAV:" target="webdav://{$fedora}/objects/{$saveuuid}/datastreams/MODS"
                  method="PUT">
                  <webdav:header name="Content-type" value="text/xml; charset=UTF-8"/>
                  <webdav:body>
                     <xsl:copy-of select="mods:mods"/>
                  </webdav:body>
               </webdav:request>
               
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="* | @* | text()" mode="mods">
      <xsl:copy>
         <xsl:apply-templates select="* | @* | text()" mode="mods"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- insert new uuid in MODS -->
   <xsl:template match="mods:mods/mods:recordInfo/mods:recordIdentifier[. = 'new']">
      <xsl:copy>
         <xsl:value-of select="$saveuuid"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="mods:mods" mode="mods">
      <xsl:copy>
         <xsl:apply-templates select="* | @* | text()" mode="mods"/>
         <xsl:if test="not(mods:recordInfo)">
            <mods:recordInfo>
               <mods:recordIdentifier><xsl:value-of select="$saveuuid"/></mods:recordIdentifier>
            </mods:recordInfo>
         </xsl:if>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="mods:mods/mods:recordInfo" mode="mods">
      <xsl:copy>
         <xsl:apply-templates select="* | @* | text()" mode="mods"/>
         <xsl:if test="not(mods:recordIdentifier)">
            <mods:recordIdentifier>
               <xsl:value-of select="$saveuuid"/>
            </mods:recordIdentifier>
         </xsl:if>
      </xsl:copy>
      
   </xsl:template>
   
</xsl:stylesheet>
