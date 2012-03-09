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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="dummy" xmlns:y="proto-xsl"
   xmlns:fd="http://apache.org/cocoon/forms/1.0#definition" xmlns:ft="http://apache.org/cocoon/forms/1.0#template"
   xmlns:fi="http://apache.org/cocoon/forms/1.0#instance" xmlns:jx="http://apache.org/cocoon/templates/jx/1.0" xmlns:str="http://exslt.org/strings"
   exclude-result-prefixes="str" extension-element-prefixes="str">
   <xsl:output method="xml" indent="yes"/>
   <!-- use namespace-alias to allow us to specify xsl elements in a dummy namespace, so they won't be interpreted as part 
of this stylesheet -->
   <xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl"/>
   <!-- convenience variables -->
   <xsl:variable name="brace1">{</xsl:variable>
   <xsl:variable name="brace2">}</xsl:variable>

   <xsl:variable name="validation" select="/localize/validation"/>
   <!-- 

main stylesheet element 

-->
   <xsl:template match="/">
      <x:stylesheet version="1.0" xmlns:y="proto-xsl" xmlns:fd="http://apache.org/cocoon/forms/1.0#definition"
         xmlns:ft="http://apache.org/cocoon/forms/1.0#template" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance"
         xmlns:jx="http://apache.org/cocoon/templates/jx/1.0" xmlns:fb="http://apache.org/cocoon/forms/1.0#binding">
         <x:namespace-alias xmlns:xsl="http://www.w3.org/1999/XSL/Transform" stylesheet-prefix="y" result-prefix="x"/>
         <!-- identity transformation -->
         <x:template match="* | @* | text() | comment()">
            <x:copy>
               <x:apply-templates select="* | @* | text() | comment()"/>
            </x:copy>
         </x:template>

         <xsl:apply-templates select="$validation/field"/>


         <xsl:apply-templates select="*"/>
         <!-- add templates to mods_style.xsl -->
         <x:template match="x:stylesheet">
            <x:copy>
               <x:comment>localizer: <xsl:value-of select="/localize/@id"/></x:comment>
               <x:copy-of select="* | @* | text() "/>
               <xsl:apply-templates select="//xslt"/>
            </x:copy>
         </x:template>
      </x:stylesheet>
   </xsl:template>

   <xsl:template match="validation/field">
      <x:template match="fd:class[@id='{@class}-class']//fd:field[@id='{@id}']">
         <x:copy>
            <x:apply-templates select="* | @* | text() | comment()"/>
            <x:comment>Localization: added validation rule</x:comment>
            <fd:validation>
               <xsl:copy-of select="*"/>
            </fd:validation>
         </x:copy>
      </x:template>
   </xsl:template>

   <xsl:template match="*">
      <xsl:apply-templates select="*"/>
   </xsl:template>
   <!-- 

Suppression

-->
   <!-- handle top-level classes -->
   <xsl:template match="suppress">
      <xsl:comment>&#x0a;Suppress classes and fields&#x0a;</xsl:comment>
      <xsl:apply-templates select="*"/>
   </xsl:template>
   <xsl:template match="suppress/class">
      <xsl:comment>Remove <xsl:value-of select="."/> class.</xsl:comment>
      <x:template match="*[@id='{.}-class' or @id='{.}-group']"/>
   </xsl:template>
   <xsl:template match="suppress/instance">
      <!-- TODO figure out whether mode is needed here -->
      <xsl:param name="mode"/>
      <xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
      <xsl:variable name="instance" select="."/>
      <xsl:comment>Remove "<xsl:value-of select="$instance"/>" instance from class <xsl:choose>
            <xsl:when test="$mode != ''">
               <xsl:value-of select="$mode"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$class"/>
            </xsl:otherwise>
         </xsl:choose>.</xsl:comment>

      <x:template match="fd:class[@id='{$class}-class']//fd:new[@id='{$instance}-class']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$instance"/>-class instance.</x:comment>
      </x:template>
      <x:template match="fb:class[@id='{$class}-class']//fb:new[@id='{$instance}-class']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$instance"/>-class instance.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:new[@id='{$instance}-class']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$instance"/>-class instance.</x:comment>
      </x:template>
   </xsl:template>
   <xsl:template match="suppress/field">
      <xsl:param name="mode"/>
      <xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
      <xsl:variable name="field" select="."/>
      <xsl:comment>Remove "<xsl:value-of select="$field"/>" field from class <xsl:choose>
            <xsl:when test="$mode != ''">
               <xsl:value-of select="$mode"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$class"/>
            </xsl:otherwise>
         </xsl:choose>.</xsl:comment>
      <x:template match="fd:class[@id='{$class}-class']//fd:field[@id='{$field}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$field"/> field.</x:comment>
      </x:template>
      <x:template match="fb:class[@id='{$class}-class']//fb:value[@id='{$field}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$field"/> value.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:widget[@id='{$field}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$field"/> widget.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:widget-label[@id='{$field}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$field"/> widget-label.</x:comment>
      </x:template>
   </xsl:template>
   <xsl:template match="suppress/repeater">
      <xsl:param name="mode"/>
      <xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
      <xsl:variable name="repeater" select="."/>
      <xsl:comment>Remove "<xsl:value-of select="repeater"/>" repeater from class <xsl:choose>
            <xsl:when test="$mode != ''">
               <xsl:value-of select="$mode"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$class"/>
            </xsl:otherwise>
         </xsl:choose>.</xsl:comment>
      <x:template match="fd:class[@id='{$class}-class']//fd:repeater[@id='{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$repeater"/> repeater.</x:comment>
      </x:template>
      <x:template match="fd:class[@id='{$class}-class']//fd:repeater-action[@id='add-to-{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed add-to-<xsl:value-of select="$repeater"/> repeater-action.</x:comment>
      </x:template>
      <x:template match="fb:class[@id='{$class}-class']//fb:repeater[@id='{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$repeater"/> repeater.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:repeater[@id='{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$repeater"/> repeater.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:widget[@id='add-to-{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed add-to-<xsl:value-of select="$repeater"/> widget.</x:comment>
      </x:template>
      <x:template match="ft:class[@id='{$class}-class']//ft:widget-label[@id='{$repeater}']">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <x:comment>Localization: removed <xsl:value-of select="$repeater"/> widget-label.</x:comment>
      </x:template>
   </xsl:template>



   <!-- 

Selection lists

Add a selection list to a given element: for example, specify a list of types for notes. We assume that the element 
is specified within a class (e.g. textfield-class for notes), and that we only want to add the list to a given 
instantiation of that class (i.e. a given <xx:new id="textfield-class"/>). We therefore have to copy the contents of the class 
to replace the <new> element, and add the selection list while we are copying.

We will need other options to add the selection list to the class as a whole rather than to a single instantiation, and to add
selection lists to elements that aren't in a class.
-->
   <!-- simplest case: change the class e.g. common-language-->
   <xsl:template match="selectionlist">
      <xsl:param name="mode"/>
      <xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
      <xsl:for-each select="field">
         <xsl:variable name="field" select="@id"/>
         <xsl:comment>Selection list for field "<xsl:value-of select="$field"/>" in class <xsl:choose>
               <xsl:when test="$mode != ''">
                  <xsl:value-of select="$mode"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$class"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:comment>
         <x:template match="fd:class[@id='{$class}-class']/fd:widgets//fd:field[@id='{$field}']">
            <xsl:if test="$mode != ''">
               <xsl:attribute name="mode">
                  <xsl:value-of select="$mode"/>
               </xsl:attribute>
            </xsl:if>
            <x:copy>
               <x:apply-templates select="*[not(local-name()='selection-list')] | @* | text() | comment()"/>
               <fd:selection-list>
                  <xsl:for-each select="item">
                     <fd:item value="{@value}">
                        <!-- use copy-of to allow for e.g. i18n tags -->
                        <fd:label>
                           <xsl:copy-of select="* | text()"/>
                        </fd:label>
                     </fd:item>
                  </xsl:for-each>
               </fd:selection-list>
            </x:copy>
            <!-- TODO handle pre-existing validation rules, if we ever add any to the base templates -->
            <xsl:apply-templates select="validation">
               <xsl:with-param name="mode" select="$mode"/>
            </xsl:apply-templates>
         </x:template>
         <xsl:apply-templates select="styling">
            <xsl:with-param name="mode" select="$mode"/>
         </xsl:apply-templates>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="styling">
      <!-- note: parent is <field id="xxx"> and grandparent is <selectionlist class="yyy"> 
				so: field id is ../@id and class id is ../../@class
				TODO: take repeaters into account
		-->
      <xsl:param name="mode"/>
      <xsl:variable name="field" select="../@id"/>
      <xsl:variable name="class" select="../../@class | ancestor::subclass[1]/@class"/>
      <x:template match="ft:class[@id='{$class}-class']//ft:widget[@id='{$field}']/fi:styling">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <!-- if the new <styling> element has no attributes, suppress the <fi:styling> element in output -->
         <x:comment>Localization: modified styling</x:comment>
         <xsl:if test="@*">
            <fi:styling>
               <xsl:copy-of select="@*"/>
            </fi:styling>
         </xsl:if>
      </x:template>
   </xsl:template>
   <xsl:template match="selectionlist/validation">
      <!-- note: parent is <field id="xxx"> and grandparent is <selectionlist class="yyy"> 
         so: field id is ../@id and class id is ../../@class
         TODO: take repeaters into account
      -->
      <xsl:param name="mode"/>
      <xsl:variable name="field" select="../@id"/>
      <xsl:variable name="class" select="../../@class | ancestor::subclass[1]/@class"/>
      <x:template match="fd:class[@id='{$class}-class']//fd:field[@id='{$field}']/fd:validation">
         <xsl:if test="$mode != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$mode"/>
            </xsl:attribute>
         </xsl:if>
         <!-- if the new <validation> element has no attributes or subelements, suppress the <fd:validation> element in output -->
         <x:comment>Localization: modified validation</x:comment>
         <xsl:if test="@* | *">
            <fd:validation>
               <xsl:copy-of select="@* | *"/>
            </fd:validation>
         </xsl:if>
      </x:template>
   </xsl:template>
   <xsl:template match="subclass">
      <xsl:variable name="class" select="@class"/>
      <xsl:variable name="userclasses" select="@userclasses"/>
      <!-- if source class name is "foo" for use by "bar" and "yip", subclass name will be "foo-subclass-bar-yip" -->
      <xsl:variable name="subclass" select="concat($class, '-subclass-', translate(normalize-space($userclasses), ' ', '-'))"/>
      <xsl:comment>Subclass of <xsl:value-of select="$class"/> for use by <xsl:value-of select="$userclasses"/>
      </xsl:comment>
      <xsl:comment>identity transformation for this subclass</xsl:comment>
      <x:template match="* | @* | text() | comment()" mode="{$subclass}">
         <x:copy>
            <x:apply-templates select="* | @* | text() | comment()" mode="{$subclass}"/>
         </x:copy>
      </x:template>
      <!-- cause the new subclass to be inserted instead of the old class -->
      <xsl:for-each select="str:tokenize($userclasses)">
         <x:template
            match="fd:class[@id='{.}-class']//fd:new[@id='{$class}-class'] | fb:class[@id = '{.}-class']//fb:new[@id='{$class}-class'] | ft:class[@id = '{.}-class']//ft:new[@id='{$class}-class']">
            <x:copy>
               <x:attribute name="id">
                  <xsl:value-of select="$subclass"/>
               </x:attribute>
            </x:copy>
         </x:template>
      </xsl:for-each>
      <!-- suppress fields -->
      <xsl:if test="suppress">
         <xsl:comment>Suppress fields</xsl:comment>
         <xsl:apply-templates select="suppress"/>
      </xsl:if>
      <!-- insert selection lists -->
      <xsl:if test="selectionlist">
         <xsl:comment>Insert selection lists</xsl:comment>
         <xsl:apply-templates select="selectionlist">
            <xsl:with-param name="mode" select="$subclass"/>
         </xsl:apply-templates>
      </xsl:if>
      <!--  handle insert -->
      <xsl:if test="insert">
         <xsl:comment>Insert section</xsl:comment>
         <xsl:apply-templates select="insert"/>
      </xsl:if>
   </xsl:template>
   <!-- suppress a given field from a given instance of a given class:
		This is done by generating a new version of the class, modified as required, and causing that version to be instantiated where required instead
		of the original version. -->
   <xsl:template match="subclass/suppress">
      <xsl:variable name="class" select="../@class"/>
      <xsl:variable name="userclasses" select="../@userclasses"/>
      <!-- if source class name is "foo" for use by "bar" and "yip", subclass name will be "foo-subclass-bar-yip" -->
      <xsl:variable name="subclass" select="concat($class, '-subclass-', translate(normalize-space($userclasses), ' ', '-'))"/>
      <x:template match="fd:class[@id='{$class}-class'] | fb:class[@id = '{$class}-class'] | ft:class[@id = '{$class}-class']">
         <x:copy>
            <x:apply-templates select="* | @* | text() | comment()"/>
         </x:copy>
         <x:comment>Localization: Subclass of <xsl:value-of select="$class"/> for use by <xsl:value-of select="$userclasses"/>
         </x:comment>
         <x:copy>
            <x:apply-templates select="@*[name() != 'id']"/>
            <x:attribute name="id">
               <xsl:value-of select="$subclass"/>
            </x:attribute>
            <x:apply-templates select="* | text() | comment()" mode="{$subclass}"/>
         </x:copy>
      </x:template>
      <xsl:apply-templates select="field">
         <xsl:with-param name="mode" select="$subclass"/>
      </xsl:apply-templates>
   </xsl:template>
   <!-- handle insert -->
   <xsl:template match="path">
      <xsl:param name="namespace"/>
      <xsl:for-each select="*">
         <xsl:choose>
            <!--  TODO: document use of "new" -->
            <xsl:when test="name() = 'repeater' or name() = 'new'">
               <xsl:value-of select="$namespace"/>
               <xsl:text>:</xsl:text>
               <xsl:value-of select="name()"/>
               <xsl:text>[@id='</xsl:text>
               <xsl:value-of select="@id"/>
               <xsl:text>']</xsl:text>
            </xsl:when>
            <xsl:when test="name() = 'widget'">
               <xsl:choose>
                  <xsl:when test="$namespace = 'fd'">fd:field</xsl:when>
                  <xsl:when test="$namespace = 'fb'">fb:value</xsl:when>
                  <xsl:when test="$namespace = 'ft'">
                     <xsl:choose>
                        <!-- use @template-element to anchor the insertion on a different template element, e.g. ft:widget-label -->
                        <xsl:when test="@template-element != ''">
                           <xsl:value-of select="@template-element"/>
                        </xsl:when>
                        <xsl:otherwise>ft:widget</xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
               </xsl:choose>
               <xsl:text>[@id='</xsl:text>
               <xsl:value-of select="@id"/>
               <xsl:text>']</xsl:text>
            </xsl:when>
         </xsl:choose>
         <xsl:if test="position() != last()">//</xsl:if>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="insert">
      <xsl:variable name="class">
         <xsl:choose>
            <xsl:when test="@class">
               <xsl:value-of select="@class"/>
            </xsl:when>
            <xsl:when test="ancestor::subclass">
               <xsl:value-of select="ancestor::subclass/@class"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="subclass">
         <xsl:if test="ancestor::subclass">
            <xsl:value-of select="concat($class, '-subclass-', translate(normalize-space(ancestor::subclass/@userclasses), ' ', '-'))"/>
         </xsl:if>
      </xsl:variable>
      <xsl:comment> Insert section: <xsl:value-of select="@class"/>. </xsl:comment>
      <xsl:apply-templates select="model">
         <xsl:with-param name="namespace">fd</xsl:with-param>
         <xsl:with-param name="class" select="$class"/>
         <xsl:with-param name="subclass" select="$subclass"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="binding">
         <xsl:with-param name="namespace">fb</xsl:with-param>
         <xsl:with-param name="class" select="$class"/>
         <xsl:with-param name="subclass" select="$subclass"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="template">
         <xsl:with-param name="namespace">ft</xsl:with-param>
         <xsl:with-param name="class" select="$class"/>
         <xsl:with-param name="subclass" select="$subclass"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template match="insert/model | insert/binding | insert/template">
      <xsl:param name="namespace"/>
      <xsl:param name="class"/>
      <xsl:param name="subclass"/>
      <xsl:variable name="path">
         <xsl:apply-templates select="../path">
            <xsl:with-param name="namespace" select="$namespace"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="position" select="../path/@position"/>
      <xsl:variable name="class" select="$class"/>
      <x:template match="{$namespace}:class[@id='{$class}-class']//{$path}">
         <xsl:if test="$subclass != ''">
            <xsl:attribute name="mode">
               <xsl:value-of select="$subclass"/>
            </xsl:attribute>
         </xsl:if>
         <!-- position is "before" or "after" -->
         <xsl:if test="$position='before'">
            <x:comment>insert section: <xsl:value-of select="$class"/>
            </x:comment>
            <xsl:apply-templates select="*" mode="insert"/>
            <x:comment>end of insert section: <xsl:value-of select="$class"/>
            </x:comment>
         </xsl:if>
         <x:copy>
            <x:apply-templates select="* | @* | text()"/>
         </x:copy>
         <xsl:if test="$position='after'">
            <x:comment>insert section: <xsl:value-of select="$class"/>
            </x:comment>
            <xsl:apply-templates select="*" mode="insert"/>
            <x:comment>end of insert section: <xsl:value-of select="$class"/>
            </x:comment>
         </xsl:if>
      </x:template>
   </xsl:template>
   <xsl:template match="* | @* | text()" mode="insert">
      <xsl:copy>
         <xsl:apply-templates select="* | @* | text()" mode="insert"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="jx:*/@*" mode="insert">
      <!-- convert jx attributes to xsl:attribute elements, to avoid problems with brace brackets (which get interpreted as xsl escaped values if they are
			in normal attributes -->
      <x:attribute name="{name()}">
         <xsl:value-of select="."/>
      </x:attribute>
   </xsl:template>
   <!-- add templates to mods_styling.xsl -->
   <xsl:template match="xslt">
      <xsl:copy-of select="*"/>
   </xsl:template>
</xsl:stylesheet>
