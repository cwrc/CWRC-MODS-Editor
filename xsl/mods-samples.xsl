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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html"/>
	<xsl:template match="mods-samples">
		<html>
			<head>
				<title>MODS Editor Prototype</title>
				<style type="text/css">
					.yes {background: #afa;}
					.no {background: #faa;}
					.update {font-style: italic; font-size: small;}
					.link {text-align: center;}
					.localizer {border: 1px solid black; padding: 10px;}
					.localizer h3 {margin-top: 0px;}
					.localizer-links {border: 1px solid red; padding: 3px;}
					#sidebar {float: right; padding: 10px; border-left: 1px solid black; border-bottom: 1px solid black; margin: 0px 0px 0px 2em; width: 200px;}
					#sidebar h2 {margin-top: 0px;}
					#container {padding: 0px 10px; border-top: 1px solid black;}
					#header {background: #666600; color: #ffffff; margin: 0px; padding: 1em;}
					#header h1 {margin-top: 0px;}
					#footer {font-style: italic;}
					h2 {border-bottom: 1px solid black; margin-right: 300px;}
				</style>
			</head>
			<body>
				<div id="header">
				<h1>MODS Editor Prototype</h1>
				<p class="update">Last update: <xsl:value-of select="@last-update"/>
				</p>
				</div>
				<div id="container">
				<div id="sidebar">
					<h2>Top-level MODS Elements Included</h2>
					<table border="1">
						<xsl:apply-templates select="work/element"/>
					</table>
				</div>
				<xsl:copy-of select="intro/*"/>
				<xsl:apply-templates select="resources"/>
				<h2>Demo</h2>
				<table border="1">
					<tr>
						<th>Item</th>
						<th>MODS record</th>
						<th>Full form</th>
						<xsl:for-each select="localizer">
							<th>
								<xsl:text>Localized</xsl:text>
								<br/>
								<xsl:value-of select="@label"/>
								<xsl:text> form</xsl:text>
								<br/>
								<xsl:text>(see below)</xsl:text>
							</th>
						</xsl:for-each>
					</tr>
					<xsl:apply-templates select="item"/>
				</table>
				<xsl:apply-templates select="localizers-intro"/>
				<xsl:apply-templates select="localizer"/>
				</div>
				<div id="footer">
					Copyright 2005, 2007, 2008 University of Alberta Libraries; released under GPL 3.0
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="item">
		<xsl:variable name="this" select="@file"/>
		<tr>
			<td>
				<xsl:value-of select="@type"/>
			</td>
			<td class="link">
				<a href="view/{$this}.xml">xml</a>
			</td>
			<td class="link">
				<a href="edit/{$this}.html">form</a>
			</td>
			<xsl:for-each select="../localizer">
				<td class="link">
					<a href="edit/{$this}.html?localizer={@id}">form</a>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
	<xsl:template match="element">
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<td class="{@done}">
				<xsl:value-of select="@done"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="localizers-intro">
		<h2>Localizers</h2>
		<xsl:copy-of select="node()"/>
	</xsl:template>
	<xsl:template match="localizer">
		<div class="localizer">
			<h3>
				<xsl:value-of select="@label"/> Localizer</h3>
			<div class="localizer-links">
				<xsl:text>View: </xsl:text>
				<a href="localize/{@id}.xml">xml</a>
				<xsl:text> | </xsl:text>
				<a href="localize/{@id}.xsl">generated localizer xsl</a>
				<xsl:text> | </xsl:text>
				<a href="forms/mods_model.xml?localizer={@id}">localized model</a>
				<xsl:text> | </xsl:text>
				<a href="forms/mods_bind.xml?localizer={@id}">localized binding</a>
				<xsl:text> | </xsl:text>
				<a href="forms/mods_template.jx?localizer={@id}">localized template</a>
				<xsl:text> | </xsl:text>
				<a href="forms/mods_styling.xsl?localizer={@id}">localized styling xsl</a>
			</div>
			<xsl:copy-of select="description/node()"/>
		</div>
	</xsl:template>
	<xsl:template match="resources">
		<h2>Resources</h2>
		<ul>
			<xsl:for-each select="item">
				<li>
					<a href="{@link}">
						<xsl:value-of select="."/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
</xsl:stylesheet>
