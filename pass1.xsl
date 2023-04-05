<?xml version="1.0" encoding="UTF-8"?>

<!--
 ! pass1.xslt
 !
 ! Input: topic-index document
 ! Uses: sitemap.xml
 !
 ! This stylesheet does three things:
 !
 ! 1) Resolves symbolic references (<ref> to <ref1>) by lookups in
 !    sitemap file. This results in a "file=" attribute on <ref1>.
 ! 2) Numbers all references by adding "number=" attribute to <ref1>
 ! 3) Removes reference to sitemap file from top level
 ! *) Passes everything else unchanged.
 !
-->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:cirp="http://www.cirp.org/cirpxml">

  <xsl:output method="xml"
      indent="no" encoding="UTF-8"/>

  <xsl:variable name="sitemap" select="document(/cirp:topic-index/@sitemap-file)"/>

  <xsl:preserve-space elements="cirp:section"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="cirp:topic-index">
    <xsl:element name="cirp:topic-index1">
      <xsl:for-each select="@*[not(name()='sitemap-file')]">
        <xsl:attribute name="{name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
 
  <xsl:template match="cirp:ref">

    <xsl:variable name="mapentry" select="$sitemap//mapentry[@id=current()/@id]"/>
 
    <xsl:element name="cirp:ref1">
      <xsl:attribute name="number">
	  <xsl:number level="any" count="//cirp:ref|html://cirp:external-ref" format="1"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:if test="$mapentry/@href">
        <xsl:attribute name="href">
          <xsl:value-of select="$mapentry/@href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="file">
        <xsl:value-of select="concat($sitemap/sitemap/@files-dir,'/',$mapentry/@file)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="cirp:external-ref">
    <xsl:element name="cirp:ref1">
       <xsl:attribute name="number">
	  <xsl:number level="any" count="//cirp:ref|html://cirp:external-ref" format="1"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:if test="@href">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cirp:refs">
    <xsl:element name="cirp:refs1">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
 
  <!-- pass through all other pass2 tags -->
  <xsl:template match="cirp:header|cirp:trailer|cirp:section|cirp:separator|cirp:a|cirp:xref|cirp:footnote|cirp:heading">
    <xsl:element name="{name()}">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
 

<!-- Pass through every XHTML tag that may appear in a <body> -->
<!-- (This is not working with the XHTML default namespace, for some reason) -->
  <xsl:template match="html:a|html:abbr|html:acronym|html:address|html:area|html:b|html:bdo|html:big|html:blockquote|html:br|html:button|html:caption|html:cite|html:code|html:col|html:colgroup|html:dd|html:del|html:dfn|html:div|html:dl|html:dt|html:ern|html:fieldset|html:form|html:h1|html:h2|html:h3|html:h4|html:h5|html:h6|html:hr|html:i|html:iframe|html:img|html:input|html:ins|html:kbd|html:label|html:legend|html:li|html:link|html:map|html:noframes|html:noscript|html:object|html:ol|html:optgroup|html:option|html:p|html:param|html:pre|html:q|html:samp|html:script|html:select|html:small|html:span|html:strong|html:sub|html:sup|html:table|html:tbody|html:td|html:textarea|html:tfoot|html:th|html:thead|html:tr|html:tt|html:ul|html:var">
    <xsl:element name="{name()}">
      <xsl:for-each select="@*">
	  <xsl:attribute name="{name()}">
	    <xsl:value-of select="."/>
	  </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
