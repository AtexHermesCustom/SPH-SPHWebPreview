<?xml version="1.0"?>
<!--
  File: sp-st.xsl

  History:
  20120312 1.0 aki (Atex): added css styles
  20120312 1.0 jpm (Atex): creation
-->

<xsl:stylesheet
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<!-- General Settings -->
<!-- imports -->

<!-- output is an xml file -->
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<xsl:apply-templates select="ncm-object/child-of-a-ncm-sp-object"/>
</xsl:template>
	
<xsl:template match="child-of-a-ncm-sp-object">
	<html>
		<head>
			<title>Web Preview</title>
			<link rel="stylesheet" type="text/css" href="css/sp-st.css"/>
		</head>
	</html>
	
	<!-- get objects: get only neutral objects -->
	<xsl:variable name="text-objs"
      select="ncm-object[ncm-type-property/object-type/@id='1' and variant_of_obj_id='0']"/>
	<xsl:variable name="headline-objs"
      select="ncm-object[ncm-type-property/object-type/@id='2' and variant_of_obj_id='0']"/>
    <xsl:variable name="caption-objs"
      select="ncm-object[ncm-type-property/object-type/@id='3' and variant_of_obj_id='0']"/>
	<xsl:variable name="header-objs"
      select="ncm-object[ncm-type-property/object-type/@id='4' and variant_of_obj_id='0']"/>
	<xsl:variable name="photo-objs"
      select="ncm-object[ncm-type-property/object-type/@id='6' and variant_of_obj_id='0']"/>
	<xsl:variable name="summary-objs"
      select="ncm-object[ncm-type-property/object-type/@id='14' and variant_of_obj_id='0']"/>
	<xsl:variable name="creditbox-objs"
      select="ncm-object[ncm-type-property/object-type/@id='16' and variant_of_obj_id='0']"/>

	
	<!-- output sp content -->
    <body background="img/bkground-st.jpg">
    
	<!-- false content: screenshot of webpage -->
	<div class="false-content">
	  <img src="img/faux-content-st.jpg"/>
	</div>
	
	<div class="story-content"> 

      <!-- headlines -->
	  <xsl:if test="count($headline-objs) &gt; 0">
	    <div class="HEADLINE">
          <xsl:for-each select="$headline-objs">
	        <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
    	    </xsl:for-each>
        </div>
	  </xsl:if>
	
	  <!-- summaries -->
	  <xsl:if test="count($summary-objs) &gt; 0">	 
	    <div class="SUMMARY">	 
          <xsl:for-each select="$summary-objs">
            <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </div>
	  </xsl:if>
	  
	  <!-- photos -->
	  <xsl:if test="count($photo-objs) &gt; 0">	 
	    <div class="PHOTO">
          <xsl:for-each select="$photo-objs">
            <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </div>
	  </xsl:if>
	  
       <!-- captions -->
	  <xsl:if test="count($caption-objs) &gt; 0">	   
	    <div class="CAPTION">
          <xsl:for-each select="$caption-objs">
            <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </div>
	  </xsl:if>
	  
      <!-- article text -->
	  <xsl:if test="(count($text-objs) &gt; 0) or (count($header-objs) &gt; 0)">	  
	    <div class="TEXT">
          <xsl:for-each select="$text-objs">
            <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="$header-objs"><!-- headers: include in text -->
            <xsl:call-template name="output-content">
              <xsl:with-param name="obj" select="."/>
            </xsl:call-template>
          </xsl:for-each>		  
        </div>
	  </xsl:if>
        
    </div>
</body>
	
</xsl:template>

<xsl:template name="output-content">
  <xsl:param name="obj"/>
  
  <xsl:variable name="obj-type" select="$obj/ncm-type-property/object-type/@name"/>
  <xsl:variable name="obj-type-id" select="$obj/ncm-type-property/object-type/@id"/>

  <xsl:message>obj name=<xsl:value-of select="$obj/name"/> (<xsl:value-of select="$obj-type"/>)</xsl:message>

  <!-- look for a web variant -->
  <xsl:variable name="web-var" select="$obj/variants-of-a-ncm-object/ncm-object[channel/@name='WEB']"/>
  <xsl:if test="$web-var/channel/@name='WEB'">
    <xsl:message>web variant=<xsl:value-of select="$web-var/name"/>, channel=<xsl:value-of select="$web-var/channel/@name"/></xsl:message>
  </xsl:if>

  <!-- object to export -->
  <xsl:variable name="export-obj">
    <xsl:choose>
      <xsl:when test="$web-var/channel/@name='WEB'"><!-- there's a web variant, use the web variant content -->
        <xsl:copy-of select="$web-var/node()"/>
      </xsl:when>
      <xsl:otherwise><!-- use the neutral object content -->
        <xsl:copy-of select="$obj/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:message>*** export-obj name=<xsl:value-of select="$export-obj/name"/>, channel=<xsl:value-of select="$export-obj/channel/@name"/></xsl:message>
  
  <xsl:comment>name=<xsl:value-of select="$export-obj/name"/>, type=<xsl:value-of select="$obj-type"/>, channel=<xsl:value-of select="$export-obj/channel/@name"/></xsl:comment>
  
  <xsl:choose>
    <xsl:when test="$obj-type-id='1'"><!-- text -->
      <xsl:call-template name="output-text">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/P"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='2'"><!-- headline -->
      <xsl:call-template name="output-headline">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/*/P"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='3'"><!-- caption -->
      <xsl:call-template name="output-caption">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/P"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='4'"><!-- header -->
      <xsl:call-template name="output-text">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/P"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='6'"><!-- photo -->
      <xsl:call-template name="output-image">
        <xsl:with-param name="content"
          select="$export-obj/content-property[@name='hermes_image']/file-property[@name='hermes_image']/medium-preview/@href"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='14'"><!-- summary -->
      <xsl:call-template name="output-summary">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/P"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$obj-type-id='16'"><!-- creditbox -->
      <xsl:call-template name="output-text">
        <xsl:with-param name="content" select="$export-obj/convert-property[@format='Xhtml']/HTML/BODY/P"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="output-text">
  <xsl:param name="content"/>

  <xsl:for-each select="$content">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="output-headline">
  <xsl:param name="content"/>
  
  <xsl:for-each select="$content">
    <p>
      <xsl:value-of select="."/>
	</p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="output-summary">
  <xsl:param name="content"/>
  
  <xsl:for-each select="$content">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="output-caption">
  <xsl:param name="content"/>
  
  <xsl:for-each select="$content">
    <p>
      <xsl:value-of select="."/>
	</p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="output-image">
  <xsl:param name="content"/>

  <img>
    <xsl:attribute name="src"><xsl:value-of select="$content"/></xsl:attribute>
  </img>
</xsl:template>

<xsl:template name="replace-string">
  <xsl:param name="in" as="xs:string"/>
  <xsl:param name="pat" as="xs:string"/>
  <xsl:param name="sub" as="xs:string"/>

  <xsl:if test="$in">
    <xsl:variable name="tokens" select="tokenize($in, $pat)"/>
    <xsl:for-each select="$tokens">
      <xsl:value-of select="."/>
      <xsl:if test="position() != last()"><xsl:value-of select="$sub"/></xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
