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
				<xslt:apply-templates select="HOTKEYSCHEMA"/>		
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

<xslt:template match="HOTKEYSCHEMA">
	<h3>Schema name:  <xslt:value-of select="@name"/></h3>
	<table>
		<tr class="TR-HEADER">
			<td>ID</td>
			<td>Verbose Name</td>
			<td>Description</td>
			<td>Shift</td>
			<td>Ctrl</td>
			<td>Alt</td>			
			<td>Key</td>						
		</tr>
	<xslt:apply-templates select="HOTKEY"/>
	</table>
</xslt:template>	

<xslt:template match="HOTKEY">
	<xslt:for-each select="Shortcut">
		<tr class="TR-NORMAL">
		<xslt:choose>
			<xslt:when test="position() = 1">
				<td class="TD-KEY"><xslt:value-of select="..//@id"/></td>
				<td><xslt:value-of select="..//VerbID"/></td>	
				<td><xslt:value-of select="..//Descr"/></td>					
			</xslt:when>
			<xslt:otherwise>
				<td colspan ="3" ></td>
			</xslt:otherwise>				
		</xslt:choose>		
		<td><xslt:if test="@Shift='1'"><center>Shift</center></xslt:if></td>	
		<td><xslt:if test="@Ctrl='1'"><center>Ctrl</center></xslt:if></td>
		<td><xslt:if test="@Alt='1'"><center>Alt</center></xslt:if></td>
		<xslt:choose>
			<xslt:when test="number(@Key) = 8">
                        <td><center>BackSpace</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 9">
                        <td><center>Tab</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 13">
                        <td><center>Enter</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 32">
                        <td><center>Space</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 33">
                        <td><center>PageUp</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 34">
                        <td><center>PageDown</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 35">
                        <td><center>End</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 36">
                        <td><center>Home</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 37">
                        <td><center>Left</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 38">
                        <td><center>Up</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 39">
                        <td><center>Right</center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) = 40">
                        <td><center>Down</center></td>
			</xslt:when>     
			<xslt:when test="number(@Key) = 45">
                        <td><center>Insert</center></td>
			</xslt:when>                                                      
			<xslt:when test="number(@Key) = 46">
                        <td><center>Delete</center></td>
			</xslt:when>                         
			<xslt:when test="number(@Key) = 106">
                        <td><center>Num *</center></td>
			</xslt:when>                                                                                                                         
			<xslt:when test="number(@Key) = 107">
                        <td><center>Num +</center></td>
			</xslt:when>                                                                         
			<xslt:when test="number(@Key) = 109">
                        <td><center>Num -</center></td>
			</xslt:when>                                                                         
			<xslt:when test="number(@Key) = 111">
                        <td><center>Num /</center></td>
			</xslt:when>                                                                         
			<xslt:when test="number(@Key) = 226">
                        <td><center>&lt;</center></td>
			</xslt:when>                                                                         
			<xslt:when test="number(@Key) &gt; 111 and number(@Key) &lt; 123">
                        <td><center><xslt:value-of select="concat('F', string(number(@Key) - 111))"/></center></td>
			</xslt:when>                                            
			<xslt:when test="number(@Key) &gt; 159">
                        <td><center><xslt:value-of disable-output-escaping="yes" select="concat('&#38;#', string(number(@Key) - 128),';')"/></center></td>
			</xslt:when>                                            
			<xslt:otherwise>
                        <td><center><xslt:value-of disable-output-escaping="yes" select="concat('&#38;#', @Key,';')"/></center></td>
			</xslt:otherwise>				
		</xslt:choose>	                
		</tr>									
	</xslt:for-each>		
</xslt:template>	

</xslt:stylesheet>
