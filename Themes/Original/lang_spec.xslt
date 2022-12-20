<?xml version="1.0"?> 
<xslt:stylesheet xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xslt:template match="XMLConfigSettings">
	<html>
        <SCRIPT language='javascript'>function ToggleCode(id){el=document.all[id];if(el.style.display=="none"){el.style.display="";}else{el.style.display="none";}}</SCRIPT>
		<HEAD>
		<TITLE><xslt:value-of select="FILEINFO/Type"/></TITLE>
		<link href="AB4Editor.css" rel="stylesheet" type="text/css"/>
		</HEAD>
			<BODY>
				<xslt:apply-templates select="FILEINFO"/>
				<xslt:apply-templates select="SPECIFICATION"/>		
				<xslt:apply-templates select="COMPLEX_USING"/>		                                
				<xslt:apply-templates select="STRUCTURES"/>		
				<xslt:apply-templates select="FORMAT"/>	
				<xslt:apply-templates select="SYNTAXINFO"/>					
				<xslt:apply-templates select="COLORSYNTAX"/>
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

<xslt:template match="SPECIFICATION">
	<h3>Specification</h3>
	<table width="400">
            <tr class="TR-HEADER">
                <td>Parameter</td>
                <td>Value</td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Files Pattern</td>
                <td><xslt:value-of select="FilePattern"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>External Lexer Dll</td>
                <td><xslt:value-of select="LexerDll"/></td>
            </tr>			
            <tr class="TR-NORMAL">
                <td>CaseSensitive</td>
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@CaseSensitive"/>
				</xslt:call-template>								
            </tr>
            <tr class="TR-NORMAL">
                <td>Wrap Column</td>
                <td><xslt:value-of select="WrapCol"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>OpenClose</td>
                <td><xslt:value-of select="OpenClose"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Delimiters</td>
                <td><xslt:value-of select="Delimiters"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>LineEnd</td>
                <td><xslt:value-of select="LineEnd"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Operators</td>
                <td><xslt:value-of select="Operators"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Words</td>
                <td><xslt:value-of select="Words"/></td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Numbers</td>
                <td><xslt:value-of select="Numbers"/></td>
            </tr>           
            <xslt:apply-templates select="HierarchySeparator"/>		            
	</table>
</xslt:template>	

<xslt:template match="HierarchySeparator">
    <xslt:for-each select="Separator">
    <tr class="TR-NORMAL">
        <td>Hierarchy Separator <xslt:value-of select="@id"/></td>
        <td><xslt:value-of select="@text"/></td>
    </tr>    
    </xslt:for-each>		    
</xslt:template>

<xslt:template match="COMPLEX_USING">
	<h3>Complex Using Words</h3>
	<table width="400">
        <tr class="TR-HEADER">
            <td>N</td>
            <td>Word</td>
        </tr>        
         <xslt:for-each select="Word">
            <tr class="TR-NORMAL">
                <td class="TD-KEY"><xslt:value-of select="position()"/></td>
                <td><xslt:value-of select="@text"/></td>
            </tr>    
        </xslt:for-each>	        
	</table>
</xslt:template>	

<xslt:template match="STRUCTURES">
	<h3>Structures</h3>
	<table>
        <tr class="TR-HEADER">
            <td>N</td>
            <td>Open</td>
            <td>Middle</td>                
            <td>Close</td>                
            <td>Complex Using</td>                   
            <td>Has Name</td>                
            <td>Has Separator</td>                                   
        </tr>        
         <xslt:for-each select="Structure">
            <tr class="TR-NORMAL">
                <td class="TD-KEY"><xslt:value-of select="position()"/></td>
                <td><xslt:value-of select="@open"/></td>
                <td><xslt:value-of select="@middle"/></td>                
                <td><xslt:value-of select="@close"/></td>                
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@complex_using"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@has_name"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@separator"/>
				</xslt:call-template>								
            </tr>    
        </xslt:for-each>	        
	</table>
</xslt:template>	

<xslt:template match="FORMAT">
	<h3>Formatting Settings</h3>
	<table width="400">
            <tr class="TR-HEADER">
                <td>Parameter</td>
                <td>Value</td>
            </tr>
            <tr class="TR-NORMAL">
                <td>Default Indent</td>
                <td><xslt:value-of select="DefaultIndent"/></td>
            </tr>
	</table>
	<xslt:apply-templates select="FormatWords"/>		
</xslt:template>	

<xslt:template match="FormatWords">
	<h4>Format words</h4>
	<table width="400">
        <tr class="TR-HEADER">
            <td>N</td>
            <td>Word</td>
            <td>Indent</td>                
            <td>Next Line</td>
            <td>Till Next Tag</td>			
        </tr>        
         <xslt:for-each select="FormatWord">
            <tr class="TR-NORMAL">
                <td class="TD-KEY"><xslt:value-of select="position()"/></td>
                <td><xslt:value-of select="@word"/></td>
                <td><xslt:value-of select="@indent"/></td>                
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@next_line"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@till_next"/>
				</xslt:call-template>												
            </tr>    
        </xslt:for-each>	        
	</table>
</xslt:template>	

<xslt:template match="SYNTAXINFO">
	<h3>Syntax Information Settings</h3>
	<table width="400">
        <tr class="TR-HEADER">
            <td>N</td>
            <td>ID</td>			
            <td>Text description</td>
            <td>Underlining color</td>  
        </tr>        
         <xslt:for-each select="InfoType">
            <tr class="TR-NORMAL">
                <td class="TD-KEY"><xslt:value-of select="position()"/></td>
                <td><xslt:value-of select="@id"/></td>
                <td><xslt:value-of select="@name"/></td>                
				<xslt:call-template name="color" >
					<xslt:with-param name="td-color" select="@clr"/>
				</xslt:call-template>				
            </tr>    
        </xslt:for-each>	        
	</table>
</xslt:template>	

<xslt:template match="COLORSYNTAX">
	<h3>Color Syntax</h3>
	<table>
            <tr class="TR-HEADER">
                <td>N</td>
                <td>Name</td>
                <td>Dis. Style</td>                
                <td>Dis. Back Color</td>                
                <td>Bold</td>                
                <td>Italic</td>                                   
                <td>Underline</td>                                   
                <td>Color</td>                   
                <td>Back Color</td>
                <td>Img Index</td>                   
                <td>Keywords</td>                
                <td>Conditions</td>                
                <td>First Char</td>                
            </tr>
         <xslt:for-each select="TextType">
            <tr class="TR-NORMAL">
                <td class="TD-KEY"><xslt:value-of select="@id"/></td>
                <td><xslt:value-of select="@name"/></td>
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@dstyle"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@dbkclr"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@bold"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@italic"/>
				</xslt:call-template>								
				<xslt:call-template name="boolean" >
					<xslt:with-param name="value" select="@underline"/>
				</xslt:call-template>								
				<xslt:call-template name="color" >
					<xslt:with-param name="td-color" select="@clr"/>
				</xslt:call-template>				
				<xslt:call-template name="color" >
					<xslt:with-param name="td-color" select="@bkclr"/>
				</xslt:call-template>		
                <td><xslt:value-of select="@ImageIdx"/></td>						
                <td><xslt:apply-templates select="Keywords"/></td>
                <td><xslt:apply-templates select="Conditions"/></td>
                <td><xslt:value-of select="FirstChar"/></td>                      
            </tr>    
        </xslt:for-each>              
	</table>
</xslt:template>	

<xslt:template name="color">
    <xslt:param name="td-color" select="-1"/>	
	<xslt:choose>
		<xslt:when test="$td-color > 0">
			<td>
			 <xslt:attribute name="style">background:rgb(<xslt:value-of select="$td-color mod 256"/>,<xslt:value-of select="($td-color div 256) mod 256"/>,<xslt:value-of select="($td-color div 65536) mod 256"/>)</xslt:attribute>
			</td> 
		</xslt:when>
		<xslt:otherwise>
			<td><center>Automatic</center></td>
		</xslt:otherwise>
    </xslt:choose>
</xslt:template>

<xslt:template name="boolean">
    <xslt:param name="value" select="0"/>	
	<xslt:choose>
		<xslt:when test="$value > 0">
			<td><center>X</center></td>									
		</xslt:when>
		<xslt:otherwise>
			<td></td>
		</xslt:otherwise>
    </xslt:choose>
</xslt:template>

<xslt:template match="Keywords">
<xslt:variable name="id" select="generate-id()"/>		
<center><A href="javascript:ToggleCode('{$id}')">&lt;Keywords&gt;</A></center>
<DIV id='{$id}' style="DISPLAY: none">
    <table width="100%">    
        <xslt:for-each select="Keyword">
            <tr class="TR-NORMAL">
				<td class="TD-KEY"><xslt:value-of select="position()"/></td>				
                <td><xslt:value-of select="@text"/></td>
            </tr>    
        </xslt:for-each>		    
    </table>
</DIV>
</xslt:template>

<xslt:template match="Conditions">
<xslt:variable name="id" select="generate-id()"/>	
<center><A href="javascript:ToggleCode('{$id}')">&lt;Conditions&gt;</A></center>
<DIV id='{$id}' style='DISPLAY: none'>
    <table width="100%">    
		<tr class="TR-HEADER">
			<td>№</td>			
			<td>Start</td>
			<td>End</td>
		</tr>		
        <xslt:for-each select="Condition">
            <tr class="TR-NORMAL">
				<td class="TD-KEY"><xslt:value-of select="position()"/></td>
                <td><xslt:value-of select="@start"/></td>
                <td><xslt:value-of select="@end"/></td>				
            </tr>    
        </xslt:for-each>		    
    </table>
</DIV>
</xslt:template>
</xslt:stylesheet>
