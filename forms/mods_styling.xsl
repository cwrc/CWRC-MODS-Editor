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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance"
   xmlns:i18n="http://apache.org/cocoon/i18n/2.1" exclude-result-prefixes="fi i18n">


   <!--+ Include styling stylesheets, one for the widgets, the other one for the
      | page. As 'forms-advanced-field-styling.xsl' is a specialization of
      | 'forms-field-styling.xsl' the latter one is imported there. If you don't
      | want advanced styling of widgets, change it here!
      | See xsl:include as composition and xsl:import as extension/inheritance.
      +-->
   <xsl:include href="resource://org/apache/cocoon/forms/resources/forms-page-styling.xsl"/>
   <xsl:include href="resource://org/apache/cocoon/forms/resources/forms-advanced-field-styling.xsl"/>

   <!-- Location of the resources directory, where JS libs and icons are stored -->
   <xsl:param name="resources-uri">resources</xsl:param>

   <xsl:template match="head">
      <head>
         <xsl:apply-templates select="." mode="forms-page"/>
         <xsl:apply-templates select="." mode="forms-field"/>
         <xsl:apply-templates/>
      </head>
   </xsl:template>

   <xsl:template match="body">
      <body>
         <!--+ !!! If template with mode 'forms-page' adds text or elements
          |        template with mode 'forms-field' can no longer add attributes!!!
          +-->
         <xsl:apply-templates select="." mode="forms-page"/>
         <xsl:apply-templates select="." mode="forms-field"/>
         <xsl:apply-templates/>
      </body>
   </xsl:template>

   <!--
    fi:group of type tabs
		- copied from forms-page-styling.xsl
		- modified to add submit button to tabs div
  -->
   <xsl:template match="fi:group[fi:styling/@type='tabs']">
      <!-- find the currently selected tab.
         Thoughts still needed here, such as autogenerating a field in the
         forms transformer to hold this state.
    -->
      <xsl:variable name="active">
         <xsl:variable name="value" select="normalize-space(fi:state/fi:*/fi:value)"/>
         <xsl:choose>
            <xsl:when test="$value">
               <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- copy the "state-widget" attribute for use in for-each -->
      <xsl:variable name="state-widget" select="fi:state/fi:*/@id"/>

      <xsl:variable name="id">
         <xsl:choose>
            <xsl:when test="@id">
               <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="generate-id()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <div id="{$id}" title="{fi:hint}">
         <!-- add an hidden input for the state -->
         <xsl:if test="$state-widget">
            <input type="hidden" id="{$state-widget}" name="{$state-widget}" value="{$active}"/>
         </xsl:if>
         <!-- div containing the tabs -->
         <div class="forms-tabArea forms tabArea">
            <xsl:for-each select="fi:items/fi:*">
               <xsl:variable name="pos" select="position() - 1"/>
               <!-- MODS Editor: replace span with div, to get vertical menu -->
               <div id="{$id}_tab_{$pos}" onclick="forms_showTab('{$id}', {$pos}, {last()}, '{$state-widget}')">
                  <xsl:attribute name="class">
                     <xsl:text>forms-tab forms tab</xsl:text>
                     <xsl:if test="$active = $pos"> forms-activeTab active</xsl:if>
                  </xsl:attribute>
                  <xsl:copy-of select="fi:label/node()"/>
                  <xsl:if test="fi:items/*//fi:validation-message">
                     <span class="forms-validation-message forms validation-message">&#160;!&#160;</span>
                  </xsl:if>
               </div>
            </xsl:for-each>
            <!-- added by pbinkley 2007-12-13 -->
            <div class="submit">
               <input title="" name="success" type="submit" id="success" value="Submit" class="forms action active"/>
            </div>

         </div>
         <!-- a div for each of the items -->
         <xsl:for-each select="fi:items/fi:*">
            <xsl:variable name="pos" select="position() - 1"/>
            <div class="forms-tabContent forms tabContent" id="{$id}_items_{$pos}">
               <xsl:if test="$active != $pos">
                  <xsl:attribute name="style">display:none</xsl:attribute>
               </xsl:if>
               <xsl:apply-templates select="."/>
            </div>
         </xsl:for-each>
      </div>
      <!-- The tabbed elements can have an attribute formsOnShow containing some javascript to be executed
         when a tab gets shown. -->
      <xsl:call-template name="formsOnShow">
         <xsl:with-param name="id" select="$id"/>
         <xsl:with-param name="active" select="$active"/>
      </xsl:call-template>
   </xsl:template>

   <!--+
      | fi:action
	copied form forms-field-styling.xsl
		- modified to add javascript call to CountUp or CountDown when row added or deleted, to update count in tabs div
      +-->
   <xsl:template match="fi:action">
      <!-- note: @id will be like add-to-originInfos or originInfos.0.deleteWidget or originInfos.0.insertWidget

	sub-widget id's are like: originInfos.0.places.0.placeterms.0.insertWidget or 

	so: maximum permissible number of periods is two.
-->
      <xsl:variable name="dots" select="string-length(@id) - string-length(translate(@id, '.', ''))"/>
      <xsl:variable name="type">
         <xsl:choose>
            <xsl:when test="contains(@id, 'insertWidget') and $dots &lt;= 2">up</xsl:when>
            <xsl:when test="contains(@id, 'deleteWidget') and $dots &lt;= 2">down</xsl:when>
            <xsl:when test="starts-with(@id, 'add-to-')">up</xsl:when>
            <xsl:otherwise>error</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="repeater">
         <xsl:choose>
            <xsl:when test="contains(@id, 'insertWidget')">
               <xsl:value-of select="substring-before(@id, '.')"/>
            </xsl:when>
            <xsl:when test="contains(@id, 'deleteWidget')">
               <xsl:value-of select="substring-before(@id, '.')"/>
            </xsl:when>
            <xsl:when test="starts-with(@id, 'add-to-')">
               <xsl:value-of select="substring-after(@id, 'add-to-')"/>
            </xsl:when>
            <xsl:otherwise>error</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <input id="{@id}" type="submit" name="{@id}" title="{fi:hint}" i18n:attr="value">
         <xsl:if test="$type != 'error' and $repeater !='error'">
            <xsl:attribute name="onclick"><xsl:value-of select="$type"/>Count('<xsl:value-of select="$repeater"/>_count');</xsl:attribute>
         </xsl:if>
         <xsl:attribute name="value">
            <!-- all labels use i18n messages - in the model, they are all specified like
               <i18n:text key="common-textfield-class/type"/>
               To get attributes translated, we have to put the key in the value attribute, and designate
               that attribute for translation with i18n:attr="value" in the input element.
               -->
            <xsl:choose>
               <xsl:when test="fi:label/i18n:text">
                  <xsl:value-of select="fi:label/i18n:text/@key"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="fi.label/node()"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:apply-templates select="." mode="styling"/>
      </input>
   </xsl:template>

   <!--+
      | Generic fi:field : produce an <input>
      +-->
   <!--
   <xsl:template match="fi:field">
      <input name="{@id}" id="{@id}" value="{fi:value}" title="{fi:hint}" type="text">
         <xsl:apply-templates select="." mode="styling"/>
      </input>
      <xsl:if test="fi:hint != ''">
         <br/>
         <span class="hint"><xsl:copy-of select="fi:label/*"/>: <xsl:value-of select="normalize-space(fi:hint)"/></span>
      </xsl:if>
      <xsl:apply-templates select="." mode="common"/>
   </xsl:template>
   -->
   
   <xsl:template match="fi:help">
      <xsl:text>&#160;</xsl:text>
      <span class="hint"><xsl:copy-of select="node()"/></span>
   </xsl:template>


</xsl:stylesheet>
