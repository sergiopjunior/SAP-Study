<?xml version="1.0"?> 
<xslt:stylesheet xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xslt:template match="XMLConfigSettings">
	<html>
		<HEAD>
			<TITLE><xslt:value-of select="FILEINFO/Type"/></TITLE>
			<link href="AB4Editor.css" rel="stylesheet" type="text/css"/>
		</HEAD>
		<BODY>
			<xslt:apply-templates select="FILEINFO"/>
			<xslt:apply-templates select="AUTOCORRECTION"/>
		</BODY>			
	</html>
</xslt:template>

<xslt:template match="FILEINFO">
	<h3>File information</h3>	
	<table width="400">
		<tr>
			<td class="TD-KEY">Author</td>
			<td><xslt:value-of select="Author"/></td>
		</tr>					
		<tr>
			<td class="TD-KEY">Data type</td>
			<td><xslt:value-of select="Type"/></td>
		</tr>	
		<tr>
			<td class="TD-KEY">Language</td>
			<td><xslt:value-of select="Language"/></td>
		</tr>	
		<tr>
			<td class="TD-KEY">Description</td>
			<td><xslt:value-of select="Desc"/></td>
		</tr>							
	</table>		
</xslt:template>	

<xslt:template match="AUTOCORRECTION">
	<h3>Language: English</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>№</td>
			<td>From</td>
			<td>To</td>
		</tr>
		<xslt:for-each select="ENGLISH/Correct">
			<tr class="TR-NORMAL">	
				<td class="TD-KEY"><xslt:value-of select="position()"/></td>				
				<td><xslt:value-of select="@from"/></td>
				<td><xslt:value-of select="@to"/></td>				
			</tr>									
		</xslt:for-each>		
	</table>
</xslt:template>	
</xslt:stylesheet>
