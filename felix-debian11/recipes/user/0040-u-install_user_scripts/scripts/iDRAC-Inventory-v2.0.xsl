<!--
$xmlstarlet tr iDRAC-Inventory-v2.0.xsl 10.240.2.230-7QCLV03-HardwareInventory.xml
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="text"/>
	
	<xsl:template match="/">
		<xsl:call-template name="t2"/>
	</xsl:template>
	
	<xsl:template name="t1">
		<xsl:for-each select="//Inventory/Component">
			<xsl:text>COMPONENT CLASSNAME: </xsl:text>
			<xsl:value-of select="@Classname"/>
			<xsl:text> (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="t2">
		<xsl:for-each select="//Inventory/Component[@Classname='DCIM_iDRACCardView']">
			<xsl:text>COMPONENT: DCIM_iDRACCardView (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY[@NAME='URLString']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		
		
		<xsl:for-each select="//Inventory/Component[@Classname='DCIM_SystemView']">
			<xsl:text>COMPONENT: DCIM_SystemView (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY[@NAME='Model']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		
		<xsl:for-each select="//Inventory/Component[@Classname='DCIM_CPUView']">
			<xsl:text>COMPONENT: DCIM_CPUView (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY[@NAME='Model']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
			<xsl:for-each select="PROPERTY[@NAME='NumberOfProcessorCores']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
			<xsl:for-each select="PROPERTY[@NAME='NumberOfEnabledThreads']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		
		<xsl:for-each select="//Inventory/Component[@Classname='DCIM_MemoryView']">
			<xsl:text>COMPONENT: DCIM_MemoryView (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY[@NAME='Model']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
			<xsl:for-each select="PROPERTY[@NAME='Size']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		
		<xsl:for-each select="//Inventory/Component[@Classname='DCIM_PhysicalDiskView']">
			<xsl:text>COMPONENT: DCIM_PhysicalDiskView (key=</xsl:text>
			<xsl:value-of select="@Key"/>
			<xsl:text>)</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="PROPERTY[@NAME='SizeInBytes']">
				<xsl:text>    NAME: </xsl:text>
				<xsl:value-of select="@NAME"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    VALUE: </xsl:text>
				<xsl:value-of select="VALUE"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>    DISPLAY_VALUE: </xsl:text>
				<xsl:value-of select="DisplayValue"/>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
