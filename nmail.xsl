<?xml version="1.0" encoding="utf8"?>

<!--
 ! nmail v0.1
 ! Author : adrien@malingrey.fr
 !
 ! Scan targets with nmap,
 ! compare with previous scan
 ! and send result by mail
 ! 
 ! Depends : nmap (with ndiff) and xsltproc
 !-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="utf8" indent="no" />
<xsl:strip-space elements="*" />

<xsl:template match="*/nmaprun">
    <xsl:message>
        <xsl:text>Scan with </xsl:text>
        <xsl:value-of select="@scanner" />
        <xsl:text> v</xsl:text>
        <xsl:value-of select="@version" />
        <xsl:text> on </xsl:text>
        <xsl:value-of select="@startstr" />
        <xsl:text>
Command: </xsl:text>
        <xsl:value-of select="@args" />
    </xsl:message>
</xsl:template>

<xsl:template match="hostdiff/a/host[status/@state = 'up']">
    <xsl:text>⚠️ Host </xsl:text>
    <xsl:choose>
        <xsl:when test="hostnames/hostname">
            <xsl:value-of select="hostnames/hostname/@name" />
            <xsl:text> (</xsl:text>
            <xsl:value-of select="address/@addr" />
            <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="address/@addr" />
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text> is down! ⚠️
</xsl:text>
</xsl:template>

<xsl:template match="hostdiff/b/host[status/@state = 'up']">
    <xsl:text>New host detected : </xsl:text>
    <xsl:choose>
        <xsl:when test="hostnames/hostname">
            <xsl:value-of select="hostnames/hostname/@name" />
            <xsl:text> (</xsl:text>
            <xsl:value-of select="address/@addr" />
            <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="address/@addr" />
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="hostdiff/host/ports/portdiff/a/port[state/@state = 'open']">
    <xsl:text>⚠️ Service </xsl:text>
    <xsl:value-of select="service/@name" />
    <xsl:text> on </xsl:text>
    <xsl:value-of select="../../../../address/@addr" />
    <xsl:text>:</xsl:text>
    <xsl:value-of select="@portid" />
    <xsl:text> is down! ⚠️
</xsl:text>
</xsl:template>

<xsl:template match="hostdiff/host/ports/portdiff/b/port[state/@state = 'open']">
    <xsl:text>New service detected: </xsl:text>
    <xsl:value-of select="service/@name" />
    <xsl:text> on </xsl:text>
    <xsl:value-of select="../../../../address/@addr" />
    <xsl:text>:</xsl:text>
    <xsl:value-of select="@portid" />
    <xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>