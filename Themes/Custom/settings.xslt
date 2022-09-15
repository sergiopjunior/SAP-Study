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
			<xslt:apply-templates select="General"/>
			<xslt:apply-templates select="Fonts_and_Colors"/>			
			<xslt:apply-templates select="Code_Completion"/>			
			<xslt:apply-templates select="Pretty_Print"/>						
			<xslt:apply-templates select="Keyboard"/>			
			<xslt:apply-templates select="Display"/>			
			<xslt:apply-templates select="Print"/>									
			<xslt:apply-templates select="FindReplace"/>									
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

<xslt:template match="General">
	<h3>General</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Undo After Save</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="UndoAfterSave"/>
			</xslt:call-template>																														
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Auto Save</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="Autosave"/>
			</xslt:call-template>																											
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">External After Save</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="R3AutoSave"/>
			</xslt:call-template>																								
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Local Auto Save</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="LocalAutoSave"/>
			</xslt:call-template>																					
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Time to Save</td>				
			<td><xslt:value-of select="TimeSave"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Help Language</td>				
			<td><xslt:value-of select="HelpLang"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Default programming language</td>				
			<td><xslt:value-of select="ProgLanguage"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Automatic language determination</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="LangDetermin"/>
			</xslt:call-template>																		
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Save On Exit</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="SaveOnExit"/>
			</xslt:call-template>																		
		</tr>											
	</table>
</xslt:template>	

<xslt:template match="Fonts_and_Colors">
	<h3>Fonts and Colors</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Font name</td>				
			<td><xslt:value-of select="Font/Name"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Font size</td>				
			<td><xslt:value-of select="Font/Size"/></td>				
		</tr>									
	</table>
</xslt:template>	

<xslt:template match="Code_Completion">
	<h3>Code Completion</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">AutoCompletion</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoCompletion"/>
			</xslt:call-template>															
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Auto Open complition list</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoOpen"/>
			</xslt:call-template>												
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Delay for Auto Open complition list</td>				
			<td><xslt:value-of select="TimeOpen"/></td>				
		</tr>			
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Use External dictionary</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="UseR3Dic"/>
			</xslt:call-template>									
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Use local dictionary</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="UseLocDic"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Use simple autocompletion</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="UseSimpleAutocomp"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Quick Info</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="QuickInfo"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Code Hints</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="CodeHints"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Chars should be saved to show Code Hints</td>				
			<td><xslt:value-of select="KKCharsNum"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Autohide ToolTip</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoHideToolTip"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">AutoHide delay for ToolTip</td>				
			<td><xslt:value-of select="AutoHideDelay"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Display current scope</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="CurrentScope"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Transparency of ToolTips (%)</td>				
			<td><xslt:value-of select="Transparency"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Display Quick Info on hovering</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="HoveringInfo"/>
			</xslt:call-template>						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Delay befor display Qick Info on hovering</td>				
			<td><xslt:value-of select="HoveringDelay"/></td>				
		</tr>									
	</table>
</xslt:template>	

<xslt:template match="Pretty_Print">
	<h3>Pretty Print</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Operand Case AutoReplace</td>				
			<td><xslt:value-of select="OperandCase"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Automatic Braces inserting</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoBrace"/>
			</xslt:call-template>
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Auto Indenting</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoIndent"/>
			</xslt:call-template>																												
		</tr>			
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Automatic Correcting of Caps</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="AutoCorrectCaps"/>
			</xslt:call-template>																									
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Auto Correction from dictionary</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="Autocorrect"/>
			</xslt:call-template>																						
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Tab Size</td>				
			<td><xslt:value-of select="TabSize"/></td>				
		</tr>			
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Tab Mode</td>				
			<td><xslt:value-of select="TabMode"/></td>				
		</tr>																															
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Trim Spaces in the end of lines</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="TrimSpace"/>
			</xslt:call-template>										
		</tr>																	
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Surround Selection</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="SurSelect"/>
			</xslt:call-template>										
		</tr>																	
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Double Rate for key repeat</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="DoubleRate"/>
			</xslt:call-template>							
		</tr>																	
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Enable Smart Tab</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="SmartTab"/>
			</xslt:call-template>							
		</tr>																	
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Format after every Paste</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="FrmtAfterPaste"/>
			</xslt:call-template>							
		</tr>																	
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Enable Optimal Fill</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="OptimalFill"/>
			</xslt:call-template>							
		</tr>																	
	</table>
</xslt:template>	

<xslt:template match="Keyboard">
	<h3>Keyboard settings</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Current Key Schema</td>				
			<td><xslt:value-of select="KeySchema"/></td>				
		</tr>									
	</table>
</xslt:template>	

<xslt:template match="Display">
	<h3>Display settings</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Selection Margin</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="SelectMargin"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Line Numbers</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="LineNumbers"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Indicator Margin</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="IndicatMargin"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Vertical Scroll bar</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="VertSB"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Horizontal Scroll bar</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="HorizSB"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Show Status Bar</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="StatusBar"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Highlight Current Line</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="HlightCurLine"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">View white Space</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="ViewSpace"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">View Page Width</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="ViewPageWidth"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">View Structure Separators</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="StructureSeparators"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Enable Smooth Scroll</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="SmoothScroll"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Smooth Scroll Factor</td>				
			<td><xslt:value-of select="SmoothScrollFactor"/></td>				
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Word Wrap type</td>				
			<td><xslt:value-of select="WordWrap"/></td>				
		</tr>											
	</table>
</xslt:template>	

<xslt:template match="Print">
	<h3>Print settings</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Left Margin</td>				
			<td><xslt:value-of select="LeftMargin"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Right Margin</td>				
			<td><xslt:value-of select="RightMargin"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Bottom Margin</td>				
			<td><xslt:value-of select="BottomMargin"/></td>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Top Margin</td>				
			<td><xslt:value-of select="TopMargin"/></td>				
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Print Line Numbers</td>				
			<xslt:call-template name="boolean" >
				<xslt:with-param name="value" select="PrintLN"/>
			</xslt:call-template>				
		</tr>									
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Header Text</td>				
			<td><xslt:value-of select="HeaderText"/></td>				
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Header Style</td>				
			<td><xslt:value-of select="HeaderStyle"/></td>				
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Footer Text</td>				
			<td><xslt:value-of select="FooterText"/></td>				
		</tr>											
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Footer Style</td>				
			<td><xslt:value-of select="FooterStyle"/></td>				
		</tr>											
		
	</table>
</xslt:template>	

<xslt:template match="FindReplace">
	<h3>Find/Replace settings</h3>
	<table width="400">
		<tr class="TR-HEADER">
			<td>Parameter</td>
			<td>Value</td>
		</tr>
		<tr class="TR-NORMAL">	
			<td class="TD-KEY">Last Search flags</td>				
			<td><xslt:value-of select="SearchFlags"/></td>				
		</tr>									
	</table>
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

</xslt:stylesheet>
