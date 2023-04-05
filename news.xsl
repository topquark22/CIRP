<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      indent="no" encoding="UTF-8"/>

  <xsl:preserve-space elements="article"/>

  <xsl:variable name="description" select="/layout/head/description"/>
  <xsl:variable name="keywords"    select="/layout/head/keywords"/>
  <xsl:variable name="siteUrl"     select="/layout/head/site-url"/>
  <xsl:variable name="pageUrl"     select="/layout/head/page-url"/>
  <xsl:variable name="cssUrl"      select="/layout/head/css-url"/>

  <xsl:variable name="countries"   select="document('src/news/countries.xml')"/>

  <xsl:variable name="articles"    select="document('src/news/articles.xml')"/>

  <xsl:template match="head">
    <head>

      <xsl:element name="title">
        <xsl:value-of select="/layout/head/title"/>
      </xsl:element>

      <meta name="robots" content="index, follow" />

      <xsl:if test="$description">
        <xsl:element name="meta">
          <xsl:attribute name="name">description</xsl:attribute>
          <xsl:attribute name="content">
            <xsl:value-of select="$description"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>

      <xsl:if test="$keywords">
        <xsl:element name="meta">
          <xsl:attribute name="name">keywords</xsl:attribute>
          <xsl:attribute name="content">
            <xsl:value-of select="$keywords"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>

      <xsl:if test="$cssUrl">
        <xsl:element name="link">
          <xsl:attribute name="href">
            <xsl:value-of select="$cssUrl"/>
          </xsl:attribute>
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="type">text/css</xsl:attribute>
        </xsl:element>
      </xsl:if>

    </head>
  </xsl:template>

  <xsl:template match="/layout">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:comment> Generated from: <xsl:value-of select="/layout/head/version"/> </xsl:comment>
      <xsl:apply-templates select="head"/>
      <xsl:apply-templates select="body"/>
    </html>
  </xsl:template>

  <xsl:template match="thread">
    <xsl:element name="table">
      <xsl:attribute name="class">threadTable</xsl:attribute>
      <xsl:attribute name="summary"><xsl:value-of select="@id"/></xsl:attribute>
      <tr>
        <td>
          <p class="threadTitle">
            <xsl:apply-templates select="description"/>
          </p>
          <xsl:for-each select="article">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:element>
  </xsl:template>

  <xsl:template match="article">

    <xsl:variable name="thisArticle" select="$articles//article[@id = current()/@refid]"/>

    <xsl:choose>
      <xsl:when test="exactly-one($thisArticle)"> <!-- NOT WORKING -->

    <xsl:variable name="author"   select="$thisArticle/author"/>
    <xsl:variable name="source"   select="$thisArticle/source"/>
    <xsl:variable name="place"    select="$thisArticle/place"/>
    <xsl:variable name="country"  select="$thisArticle/country"/>
    <xsl:variable name="title"    select="$thisArticle/title"/>
    <xsl:variable name="subtitle" select="$thisArticle/subtitle"/>
    <xsl:variable name="language" select="$thisArticle/language"/>
    <xsl:variable name="spec"     select="$thisArticle/spec"/>
    <xsl:variable name="date"     select="$thisArticle/date"/>
    <xsl:variable name="dateStr"  select="$thisArticle/dateStr"/>
    <xsl:variable name="url"      select="$thisArticle/url"/>

    <p class="article">
      <xsl:if test="$author">
        <xsl:apply-templates select="$author"/>.
      </xsl:if>

      <span class="title">
      <xsl:element name="a">
     <xsl:choose>
       <xsl:when test="substring($url, 1, 7) = 'http://'">
        <xsl:attribute name="href">
        <xsl:value-of select="$url"/>
        </xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
       </xsl:when>
      <xsl:otherwise>
       <xsl:attribute name="href">
        <xsl:value-of select="concat($siteUrl, $url)"/>
      </xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$title"/>

      <xsl:if test="$subtitle">:
        <span class="subtitle"><xsl:apply-templates select="$subtitle"/></span>
      </xsl:if>
      </xsl:element>.
      </span>
      <xsl:element name="span">
        <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$source/@isBureau = 'true'">provider</xsl:when>
          <xsl:otherwise>source</xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates select="$source"/></xsl:element><xsl:if test="$spec">,
        <xsl:apply-templates select="$spec"/></xsl:if>.
      <xsl:if test="$place">
        <xsl:apply-templates select="$place"/>,
      </xsl:if>
      <xsl:if test="$country">
        <xsl:apply-templates select="$country"/>
      </xsl:if>

      <xsl:choose>
      <xsl:when test="$date">
        <xsl:value-of select="format-date($date, '[Fn], [Mn] [D], [Y]', 'en')"/>.
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$dateStr"/>.
      </xsl:otherwise>
      </xsl:choose>
    </p>

    </xsl:when>
      <xsl:otherwise>
        <span class="error">ERROR - ARTICLE "<xsl:value-of select="@refid"/>" DUPLICATED OR NOT FOUND</span>
      </xsl:otherwise>
      </xsl:choose>

  </xsl:template>

  <xsl:template match="country">
    <xsl:value-of select="$countries//country[country-code = current()]/country-name"/>.
  </xsl:template>

  <xsl:template match="timestamp"><xsl:value-of select="/layout/head/version"/></xsl:template>

  <xsl:template match="page-url"><xsl:value-of select="/layout/head/page-url"/>/</xsl:template>

<!-- this helps to convert things like "&amp;uuml;" to "&uuml;" in the final document -->
  <xsl:template match="text()">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </xsl:template>

<!-- Pass through every XHTML tag that may appear in a <body> -->
  <xsl:template match="a|abbr|acronym|address|area|b|bdo|big|blockquote|br|button|caption|cite|code|col|colgroup|dd|del|dfn|div|dl|dt|ern|fieldset|form|h1|h2|h3|h4|h5|h6|hr|i|iframe|img|input|ins|kbd|label|legend|li|link|map|noframes|noscript|object|ol|optgroup|option|p|param|pre|q|samp|script|select|small|span|strong|sub|sup|table|tbody|td|textarea|tfoot|th|thead|tr|tt|ul|var">
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
