<?xml version="1.0" encoding="UTF-8"?>

<!-- TO DO
   1) Build URLs correctly (dropping multiple slashes)
   2) Allow body bgcolor as a parameter, with default "white"
-->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:cirp="http://www.cirp.org/cirpxml"
    >

  <xsl:output method="xml" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      indent="no" encoding="UTF-8"/>

  <xsl:preserve-space elements="cirp:section"/>

  <xsl:variable name="pageTitle" select="/cirp:topic-index1/@title"/>
  <xsl:variable name="siteName" select="/cirp:topic-index1/@site-name"/>
  <xsl:variable name="hostName" select="/cirp:topic-index1/@site-hostname"/>
  <xsl:variable name="fileName" select="/cirp:topic-index1/@file-name"/> <!-- can be empty -->
  <xsl:variable name="siteURL" select="/cirp:topic-index1/@site-url"/>
  <xsl:variable name="urlPath" select="/cirp:topic-index1/@url-path"/>
  <xsl:variable name="urlParent" select="/cirp:topic-index1/@url-parent"/>
  <xsl:variable name="pageURL" select="concat('http://',$hostName,$urlPath,$fileName)"/>
  
  <xsl:variable name="newline">
	<xsl:text>
	</xsl:text>
  </xsl:variable>

  <xsl:key name="ref-index" match="cirp:ref1" use="@id"/>
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>
            <xsl:value-of select="$siteName"/>: <xsl:value-of select="$pageTitle"/>
         </title>
         <base href="{$pageURL}"/>
      </head>
      <xsl:element name="body">
        <xsl:attribute name="bgcolor">
          <xsl:choose> 
            <xsl:when test="/cirp:topic-index1/@bgcolor">
              <xsl:value-of select="/cirp:topic-index1/@bgcolor"/>
            </xsl:when>
            <xsl:otherwise>white</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </html>
  </xsl:template>

  <xsl:template match="cirp:header">
    <a href="{@href}">
      <img alt="{@alt}" src="{@img}" />
    </a>
    <br />
    <h1><xsl:value-of select="$pageTitle" /></h1>
  </xsl:template>
  
  <xsl:template match="cirp:trailer">
  <hr />
   <a href="{$urlParent}">Return to parent</a><br />
    <tt><xsl:value-of select="$pageURL"/></tt>
  </xsl:template>

<!-- To do: replace <xsl:choose> with mode -->
  <xsl:template match="cirp:ref1">
    <a name="{@id}" />
    <xsl:choose>
      <xsl:when test="@file">
      
    <xsl:variable name="article-data" select="document(@file)/cirp:item/cirp:pubdata"/>    
    <xsl:variable name="style" select="$article-data/@style"/>
    
   <!-- <debug><xsl:copy-of select="$article-data"/></debug> -->
    
      <xsl:choose>
  
       <xsl:when test="$style='use-citation'">
       <xsl:choose>
         <xsl:when test="@href">
         <a href="{@href}">
          <xsl:apply-templates select="$article-data/cirp:citation"/>
          </a>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$article-data/cirp:citation"/>
          </xsl:otherwise>            
          </xsl:choose>
       </xsl:when>
       
        <xsl:when test="$style='news'">
          <xsl:for-each select="$article-data/cirp:author">
            <xsl:value-of select="."/>,
          </xsl:for-each>
         <xsl:choose>
         <xsl:when test="@href">
         <a href="{@href}">
          <xsl:apply-templates select="$article-data/cirp:title"/>
          </a>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$article-data/cirp:title"/>
          </xsl:otherwise>            
          </xsl:choose>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates select="$article-data/cirp:journal"/>,
          <xsl:apply-templates select="$article-data/cirp:date"/>
        </xsl:when>
       
        <xsl:when test="$style='article'">
          <xsl:for-each select="$article-data/cirp:author">
            <xsl:value-of select="."/>;
          </xsl:for-each>

         <xsl:choose>
         <xsl:when test="@href">
         <a href="{@href}">
          <xsl:apply-templates select="$article-data/cirp:title"/>
          </a>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$article-data/cirp:title"/>
          </xsl:otherwise>            
          </xsl:choose>
                  
          <xsl:value-of select="$newline"/>
          <b><xsl:apply-templates select="$article-data/cirp:journal"/></b>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates select="$article-data/cirp:volume"/>.
        </xsl:when>
    
        <xsl:when test="$style='book'">
          <xsl:for-each select="$article-data/cirp:author">
            <xsl:value-of select="."/>,
          </xsl:for-each>
         <xsl:choose>
         <xsl:when test="@href">
         <a href="{@href}">
          <xsl:apply-templates select="$article-data/cirp:title"/>
          </a>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$article-data/cirp:title"/>
          </xsl:otherwise>            
          </xsl:choose>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates select="$article-data/cirp:publisher"/>,
          <xsl:apply-templates select="$article-data/cirp:date"/>
        </xsl:when>

        <xsl:when test="$style='letter'">
          <xsl:for-each select="$article-data/cirp:author">
            <xsl:value-of select="."/>.
          </xsl:for-each>
         <xsl:choose>
         <xsl:when test="@href">
         <a href="{@href}">
          <xsl:apply-templates select="$article-data/cirp:title"/>
          </a>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$article-data/cirp:title"/>
          </xsl:otherwise>            
          </xsl:choose>
          
          <xsl:value-of select="$newline"/>
          <b><xsl:apply-templates select="$article-data/cirp:journal"/></b>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates select="$article-data/cirp:volume"/>
    
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>	 <!-- no @file -->
     <xsl:choose>
       <xsl:when test="@href">
       <a href="{@href}">
        <xsl:apply-templates/>
       </a>
       </xsl:when>
       <xsl:otherwise>
         <xsl:apply-templates/>
        </xsl:otherwise>
       </xsl:choose>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="cirp:refs1">
    <xsl:apply-templates select="cirp:heading"/>
    <ol>
      <xsl:for-each select="cirp:ref1">
	    <li value="{@number}">
        <xsl:apply-templates select="."/>
      </li>
      </xsl:for-each>
    </ol>
  </xsl:template>

  <xsl:template match="cirp:heading">
    <h2>
      <xsl:value-of select="."/>
    </h2>
  </xsl:template>

  <xsl:template match="cirp:section">
    <div>
      <xsl:if test="@title">
        <h2><xsl:value-of select="@title"/></h2>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="cirp:separator">
    <div>
      <img alt="" src="/gif/hline.gif"/>
    </div>
  </xsl:template>


<!-- use cirp: namespace for these -->

  <xsl:template match="cirp:publisher">
    <xsl:apply-templates/>
  </xsl:template>
  
    <xsl:template match="cirp:date">
    <xsl:apply-templates/>.
  </xsl:template>
  
    <xsl:template match="cirp:title">
    <i><xsl:apply-templates/>.</i>
  </xsl:template>
  

<!--   ****************** -->

  <xsl:template match="cirp:footnote">
    <sup>
      <a href="#{key('ref-index',@ref)/@id}">
        <xsl:value-of select="key('ref-index',@ref)/@number"/>
      </a>
    </sup>
  </xsl:template>

  <xsl:template match="cirp:xref">
    [<a href="#{key('ref-index',@ref)/@id}">
	<xsl:value-of select="key('ref-index',@ref)/@number"/>
    </a>]
  </xsl:template>

  <xsl:template match="cirp:a">
    <a href="{key('ref-index',@ref)/@href}">
	    <xsl:apply-templates/>
    </a>
  </xsl:template>


<!-- this helps to convert things like "&amp;uuml;" to "&uuml;" in the final document --> 
  <xsl:template match="text()">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </xsl:template> 

<!-- Pass through every XHTML tag that may appear in a <body> -->
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
