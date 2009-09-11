<?xml version="1.0" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xmcda="http://www.decision-deck.org/2009/XMCDA-2.0.0">
	
<xsl:output method="html" encoding="ISO-8859-1" />

<xsl:key name="critID" match="performance" use="criterionID"/>

<xsl:template match="/">
	<HTML>	
		<HEAD>
			<TITLE>XMCDA Scheme</TITLE>
			<!-- <LINK REL="stylesheet" TYPE="text/css" HREF="cssStyle.css"/> -->
			<STYLE type="text/css">CSS_STYLES</STYLE>
		</HEAD>
		<BODY>
			<DIV CLASS="XMCDA">
				<xsl:apply-templates/>
			</DIV>
		</BODY>
	</HTML>
</xsl:template>


<xsl:template match="projectReference">
	<DIV CLASS="projectReference">
		<DIV CLASS="title"><xsl:value-of select="title" /></DIV>
		<DIV CLASS="subTitle"><xsl:value-of select="subTitle" /></DIV>
		<DIV CLASS="subSubTitle"><xsl:value-of select="subSubTitle" /></DIV>
		<xsl:if test="version">
			<DIV CLASS="subSubTitle">Version <xsl:value-of select="version"/></DIV>
		</xsl:if>
		<xsl:for-each select="author">
			<DIV CLASS="author"><xsl:value-of select="." /></DIV>
		</xsl:for-each>
	</DIV>
</xsl:template>


<xsl:template match="methodMessages">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Method messages</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<xsl:for-each select="./*">
			<xsl:choose>
				<xsl:when test="self::logMessage">
					<xsl:choose>
						<xsl:when test="@mcdaConcept">
							<xsl:value-of select="@mcdaConcept"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@name">
									<xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									LOG
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>	
					 : <xsl:value-of select="text"/><BR/>
					<xsl:apply-templates select="description"/>
				</xsl:when>
				<xsl:when test="self::errorMessage">
					<FONT COLOR="red">
					<xsl:choose>
						<xsl:when test="@mcdaConcept">
							<xsl:value-of select="@mcdaConcept"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@name">
									<xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									ERROR
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					</FONT> : <xsl:value-of select="text"/><BR/>
					<xsl:apply-templates select="description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@mcdaConcept">
							<xsl:value-of select="@mcdaConcept"/> :<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@name">
									<xsl:value-of select="@name"/> :<xsl:text> </xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="text"/><BR/>
					<xsl:apply-templates select="description"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</DIV>
</xsl:template>


<xsl:template match="methodParameters">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
		<xsl:choose>
			<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
			<xsl:otherwise>Method parameters</xsl:otherwise>
		</xsl:choose>
		</DIV>
		<DIV CLASS="methodParameters">
			<xsl:if test="@name">
					<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
			</xsl:if>
			<UL>
				<xsl:for-each select="./approach">
					<LI>Approach: <value-of select="."/></LI>
				</xsl:for-each>
				<xsl:for-each select="./problematique">
					<LI>Problematique: <value-of select="."/></LI>
				</xsl:for-each>
				<xsl:for-each select="./methodology">
					<LI>Methodoly: <value-of select="."/></LI>
				</xsl:for-each>
				<xsl:for-each select="./parameter">
					<LI><B><xsl:value-of select="@name"/></B> = <xsl:value-of select="." /></LI>
				</xsl:for-each>
			</UL>
		</DIV>
	</DIV>
</xsl:template>


<xsl:template match="description">
	<DIV CLASS="description">
		<xsl:for-each select="./*">
			<xsl:choose>
				<xsl:when test="self::title"><DIV CLASS="itemDescription">Title : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::subTitle"><DIV CLASS="itemDescription">Subtitle : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::subSubTitle"><DIV CLASS="itemDescription">Subsubtitle : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::user"><DIV CLASS="itemDescription">User : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::author"><DIV CLASS="itemDescription">Author : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::version"><DIV CLASS="itemDescription">Version : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::creationDate"><DIV CLASS="itemDescription">Creation : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::lastModificationDate"><DIV CLASS="itemDescription">Last modification : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::shortName"><DIV CLASS="itemDescription">Short name : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::comment"><DIV CLASS="itemDescription">Comment : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::abstract"><DIV CLASS="itemDescription">Abstract : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::keywords"><DIV CLASS="itemDescription">Keywords : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::bibliography"><DIV CLASS="itemDescription">Bibliography : <xsl:value-of select="."/></DIV></xsl:when>
				<xsl:when test="self::stakeholders"><DIV CLASS="itemDescription">Stakeholders : <xsl:value-of select="."/></DIV></xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</DIV>
</xsl:template>


<xsl:template match="alternatives">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:if test="@name">
				<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
			</xsl:if>
			<xsl:apply-templates select="description"/>
			<UL>
				<xsl:for-each select="alternative">
					<LI>
						Id : <B><xsl:value-of select="@id"/></B><BR/>
						<xsl:choose>
							<xsl:when test="@name">
								Name : <xsl:value-of select="@name"/><BR/>
							</xsl:when>
							<xsl:when test="active">
								<I>Active : <xsl:value-of select="active"/></I><BR/>
							</xsl:when>
						</xsl:choose>
						<xsl:apply-templates select="description"/>
					</LI>
				</xsl:for-each>
			</UL>
		</DIV>				
	</DIV>
</xsl:template>


<xsl:template match="alternativesSet">
	{
		<xsl:variable name="nbElt" select="count(element)"/>
		<xsl:for-each select="element">
			<xsl:value-of select="alternativeID"/>
			<xsl:if test="position() &lt; $nbElt">, </xsl:if>
		</xsl:for-each>
		<xsl:text> </xsl:text>
	}
</xsl:template>


<xsl:template match="alternativesSets">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives Sets</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:apply-templates select="description"/>
			<UL>
				<LI>
					<xsl:apply-templates select="alternativesSet"/>
				</LI>
			</UL>
		</DIV>
	</DIV>
</xsl:template>	


<xsl:template match="attributes">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:if test="@name">
				<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
			</xsl:if>
			<xsl:apply-templates select="description"/>
			<UL>
				<xsl:for-each select="attribute">
					<LI>
						Id : <B><xsl:value-of select="@id"/></B><BR/>
						<xsl:choose>
							<xsl:when test="@name">
								Name : <xsl:value-of select="@name"/><BR/>
							</xsl:when>
							<xsl:when test="active">
								<I>Active : <xsl:value-of select="active"/></I><BR/>
							</xsl:when>
							<xsl:when test="scale">
								<I>Scale : <xsl:apply-templates select="scale"/></I><BR/>
							</xsl:when>
							<!--<xsl:when test="attributeFunction">
								<I>Attribute function : !!!!!!!!!!!!</I><BR/>
							</xsl:when>
							<xsl:when test="thresholds">
								<I>Thresholds : <xsl:apply-templates select="thresholds"/></I><BR/>
							</xsl:when>
							<xsl:when test="attributeReference">
								<I>Attribute reference : !!!!!!!!!!!!!!!!</I><BR/>
							</xsl:when>
							<xsl:when test="criterionReference">
								<I>Criterion reference : !!!!!!!!!!!!!!!!</I><BR/>
							</xsl:when>-->
						</xsl:choose>
						<xsl:apply-templates select="description"/>
					</LI>
				</xsl:for-each>
			</UL>
		</DIV>				
	</DIV>
</xsl:template>


<xsl:template match="attributesSet">
	{
		<xsl:variable name="nbElt" select="count(element)"/>
		<xsl:for-each select="element">
			<xsl:value-of select="AttributeID"/>
			<xsl:if test="position() &lt; $nbElt">, </xsl:if>
		</xsl:for-each>
		<xsl:text> </xsl:text>
	}
</xsl:template>


<xsl:template match="attributesSets">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes sets</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:apply-templates select="description"/>
			<UL>
				<LI>
					<xsl:apply-templates select="attributesSet"/>
				</LI>
			</UL>
		</DIV>
	</DIV>
</xsl:template>


<xsl:template match="criteria">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:if test="@name">
				<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
			</xsl:if>
			<xsl:apply-templates select="description"/>
			<UL>
				<xsl:for-each select="criterion">
					<LI>
						Id : <B><xsl:value-of select="@id"/></B><BR/>
						<xsl:choose>
							<xsl:when test="@name">
								Name : <xsl:value-of select="@name"/><BR/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="scale">
								Scale : <xsl:apply-templates select="scale"/><BR/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="active">
								<I>Active : <xsl:value-of select="active"/></I><BR/>
							</xsl:when>
						</xsl:choose>

						<xsl:apply-templates select="description"/>
					</LI>
				</xsl:for-each>
			</UL>
		</DIV>
	</DIV>
</xsl:template>
		

<xsl:template match="criteriaSet">
	{
		<xsl:variable name="nbElt" select="count(element)"/>
		<xsl:for-each select="element">
			<xsl:value-of select="criterionID"/>
			<xsl:if test="position() &lt; $nbElt">, </xsl:if>
		</xsl:for-each>
		<xsl:text> </xsl:text>
	}
</xsl:template>	


<xsl:template match="criteriaSets">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria sets</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:apply-templates select="description"/>
			<UL>
				<LI>
					<xsl:apply-templates select="criteriaSet"/>
				</LI>
			</UL>
		</DIV>
	</DIV>
</xsl:template>


<xsl:template match="categories">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:if test="@name">
				<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
			</xsl:if>
			<xsl:apply-templates select="description"/>
			<UL>
				<xsl:for-each select="category">
					<LI><B><xsl:value-of select="@name"/></B>: <xsl:value-of select="@id"/>
					<xsl:apply-templates select="description"/></LI>
				</xsl:for-each>
			</UL>
		</DIV>
	</DIV>
</xsl:template>


<xsl:template match="categoriesSet">
	{
		<xsl:variable name="nbElt" select="count(element)"/>
		<xsl:for-each select="element">
			<xsl:value-of select="categoryID"/>
			<xsl:if test="position() &lt; $nbElt">, </xsl:if>
		</xsl:for-each>
		<xsl:text> </xsl:text>
	}
</xsl:template>


<xsl:template match="categoriesSets">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories sets</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<DIV CLASS="sousbloc">
			<xsl:apply-templates select="description"/>
			<UL>
				<LI>
					<xsl:apply-templates select="categoriesSet"/>
				</LI>
			</UL>
		</DIV>
	</DIV>

</xsl:template>


<xsl:template match="performanceTable">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Performance table</xsl:otherwise>
			</xsl:choose>
		</DIV>
		
		<xsl:apply-templates select="description"/>
			
			
		<xsl:variable name="numTable" select="position()"/>
		<xsl:choose>
			<xsl:when test="@id"><DIV CLASS="classSubTitle"><xsl:value-of select="@id"/></DIV></xsl:when>
		</xsl:choose>
		
		<xsl:apply-templates select="description"/>
		
		<xsl:variable name="listCrit" select="alternativePerformances/performance/criterionID[not(.=following::criterionID)]"/>
		
		<TABLE CELLSPACING='1'>
			<TR>
				<TD></TD>
				<xsl:for-each select="$listCrit">
					<TD CLASS="header"><xsl:value-of select="."/></TD>
				</xsl:for-each>
			</TR>
			<xsl:for-each select="alternativePerformances/alternativeID[not(.=following::alternativeID)]">
				<xsl:variable name="altID" select="."/>
				<TR>
					<TD CLASS="header"><xsl:value-of select="$altID"/></TD>
					<xsl:for-each select="$listCrit">
						<xsl:variable name="critID" select="."/>
						<TD><xsl:apply-templates select="../../../alternativePerformances[alternativeID=$altID]/performance[criterionID=$critID]/value"/>
						</TD>
					</xsl:for-each>

				</TR>
			</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<xsl:template match="hierarchy">
	<xsl:value-of select="."/>
</xsl:template>


<!-- CRITERIA RELATED -->


<xsl:template match="criterionValue">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criterion value</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:if test="@name">
			<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="criterionID"><xsl:value-of select="criterionID"/></xsl:when>
			<xsl:when test="criteriaSetID"><xsl:value-of select="criteriaSetID"/></xsl:when>
			<xsl:when test="criteriaSet"><xsl:apply-templates select="criteriaSet"/></xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="value"/><BR/>
	</DIV>
</xsl:template>


<xsl:template match="criteriaValues">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria values</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<TABLE CELLSPACING='1'>
		<xsl:for-each select="criterionValue">
			<TR>
				<TD>
					<xsl:choose>
						<xsl:when test="criterionID"><xsl:value-of select="criterionID"/></xsl:when>
						<xsl:when test="criteriaSetID"><xsl:value-of select="criteriaSetID"/></xsl:when>
						<xsl:when test="criteriaSet"><xsl:apply-templates select="criteriaSet"/></xsl:when>
					</xsl:choose>
				</TD>
				<TD align="char" char=".">
					<xsl:apply-templates select="value"/>
				</TD>
			</TR>
		</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<xsl:template match="criteriaComparisons">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria comparisons</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<UL>
			<xsl:for-each select="./pairs">
				<xsl:for-each select="./pair">
				<LI>
				<xsl:choose>
					<xsl:when test="initial/criterionID"><xsl:value-of select="./initial/criterionID"/></xsl:when>
					<xsl:when test="initial/criteriaSetID"><xsl:value-of select="./initial/criteriaSetID"/></xsl:when>
					<xsl:when test="initial/criteriaSet"><xsl:apply-templates select="./initial/criteriaSet"/> </xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="../../comparisonType='geq'">
						>=
					</xsl:when>
					<xsl:when test="../../comparisonType='eq'">
						=
					</xsl:when>
					<xsl:when test="../../comparisonType='leq'">
						&lt;=
					</xsl:when>
					<xsl:when test="../../comparisonType='neq'">
						!=
					</xsl:when>
					<xsl:when test="../../comparisonType='gtr'">
						>
					</xsl:when>
					<xsl:when test="../../comparisonType='less'">
						&lt;
					</xsl:when>	
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="../../comparisonType">
								<xsl:text> </xsl:text><xsl:value-of select="../../comparisonType"/><xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>R<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="terminal/criterionID"><xsl:value-of select="./terminal/criterionID"/></xsl:when>
					<xsl:when test="terminal/criteriaSetID"><xsl:value-of select="./terminal/criteriaSetID"/></xsl:when>
					<xsl:when test="terminal/criteriaSet"><xsl:apply-templates select="./terminal/criteriaSet"/> </xsl:when>
				</xsl:choose>
				<xsl:text> </xsl:text> (<xsl:apply-templates select="value"/>)
				</LI>
				</xsl:for-each>
			</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="criteriaLinearConstraints">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria linear constraints</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<UL>
			<xsl:for-each select="constraint">
				<LI>
					<xsl:for-each select="element">
						<xsl:if test="coefficient &gt; 0">+</xsl:if>
						<xsl:value-of select="coefficient"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="criterionID"><xsl:value-of select="criterionID"/></xsl:when>
							<xsl:when test="criteriaSetID"><xsl:value-of select="criteriaSetID"/></xsl:when>
							<xsl:when test="criteriaSet"><xsl:apply-templates select="criteriaSet"/></xsl:when>
						</xsl:choose>
						<xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="operator='geq'">>=</xsl:when>
						<xsl:when test="operator='eq'">=</xsl:when>
						<xsl:when test="operator='leq'">&lt;=</xsl:when>	
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="rhs"/>
				</LI>
			</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="criteriaMatrix">
<!-- Pour le moment, on suppose les données données dans l'ordre-->
<!-- On suppose aussi que c'est le même ordre sur lignes et colonnes et qu'en plus, on a toutes les valeurs...-->
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Criteria matrix</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text><xsl:apply-templates select="valuation"/>
		</DIV>
		<xsl:apply-templates select="description"/>
		<TABLE>
			<TR>
				<TD><xsl:text> </xsl:text></TD>
				<xsl:for-each select="./row">
					<TD CLASS="header">
						<xsl:choose>
							<xsl:when test="./criterionID"><xsl:value-of select="./criterionID"/></xsl:when>
							<xsl:when test="./criteriaSetID"><xsl:value-of select="./criteriaSetID"/></xsl:when>
							<xsl:when test="./criteriaSet"><xsl:apply-templates select="./criteriaSet"/></xsl:when>
						</xsl:choose>
					</TD>
				</xsl:for-each>
			</TR>
			<xsl:for-each select="./row">
				<TR>
					<TD CLASS="header">
						<xsl:choose>
							<xsl:when test="./criterionID"><xsl:value-of select="./criterionID"/></xsl:when>
							<xsl:when test="./criteriaSetID"><xsl:value-of select="./criteriaSetID"/></xsl:when>
							<xsl:when test="./criteriaSet"><xsl:apply-templates select="./criteriaSet"/></xsl:when>
						</xsl:choose>
					</TD>
					<xsl:for-each select="./column">
						<TD><xsl:apply-templates select="value"/></TD>
					</xsl:for-each>
				</TR>
			</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<!-- ATTRIBUTES RELATED -->


<xsl:template match="attributeValue">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attribute value</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:if test="@name">
			<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="attributeID"><xsl:value-of select="attributeID"/></xsl:when>
			<xsl:when test="attributesSetID"><xsl:value-of select="attributesSetID"/></xsl:when>
			<xsl:when test="attributesSet"><xsl:apply-templates select="attributesSet"/></xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="value"/><BR/>
	</DIV>
</xsl:template>


<xsl:template match="attributesValues">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes values</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<TABLE CELLSPACING='1'>
			<xsl:for-each select="attributeValue">
				<TR>
					<TD>
						<xsl:choose>
							<xsl:when test="attributeID"><xsl:value-of select="attributeID"/></xsl:when>
							<xsl:when test="attributesSetID"><xsl:value-of select="attributesSetID"/></xsl:when>
							<xsl:when test="attributesSet"><xsl:apply-templates select="attributesSet"/></xsl:when>
						</xsl:choose>
					</TD>
					<TD align="char" char=".">
						<xsl:apply-templates select="value"/>
					</TD>
				</TR>
			</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<xsl:template match="attributesComparisons">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes comparisons</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<xsl:apply-templates select="valuation"/>
		<UL>
		<xsl:for-each select="./pairs">
			<xsl:for-each select="./pair">
			<LI>
			<xsl:choose>
				<xsl:when test="initial/attributeID"><xsl:value-of select="./initial/attributeID"/></xsl:when>
				<xsl:when test="initial/attributesSetID"><xsl:value-of select="./initial/attributesSetID"/></xsl:when>
				<xsl:when test="initial/attributesSet"><xsl:apply-templates select="attributesSet"/> </xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="../../comparisonType='geq'">>=</xsl:when>
				<xsl:when test="../../comparisonType='eq'">=</xsl:when>
				<xsl:when test="../../comparisonType='leq'">&lt;=</xsl:when>
				<xsl:when test="../../comparisonType='neq'">!=</xsl:when>
				<xsl:when test="../../comparisonType='gtr'">></xsl:when>
				<xsl:when test="../../comparisonType='less'">&lt;</xsl:when>	
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="../../comparisonType">
							<xsl:text> </xsl:text><xsl:value-of select="../../comparisonType"/><xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> </xsl:text>R<xsl:text> </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="terminal/attributeID"><xsl:value-of select="./terminal/attributeID"/></xsl:when>
				<xsl:when test="terminal/attributesSetID"><xsl:value-of select="./terminal/attributesSetID"/></xsl:when>
				<xsl:when test="terminal/attributesSet"><xsl:apply-templates select="attributesSet"/></xsl:when>
			</xsl:choose>
			<xsl:text> </xsl:text> (<xsl:apply-templates select="value"/>)
			</LI>
			</xsl:for-each>
		</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="attributesLinearConstraints">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes linear constraints</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<UL>
			<xsl:for-each select="constraint">
				<LI>
					<xsl:for-each select="element">
						<xsl:if test="coefficient &gt; 0">+</xsl:if>
						<xsl:value-of select="coefficient"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="attributeID"><xsl:value-of select="attributeID"/> </xsl:when>
							<xsl:when test="attributesSetID"> <xsl:value-of select="attributesSetID"/> </xsl:when>
							<xsl:when test="attributesSet"> <xsl:apply-templates select="attributesSet"/> </xsl:when>
						</xsl:choose>
						<xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="operator='geq'">>=</xsl:when>
						<xsl:when test="operator='eq'">=</xsl:when>
						<xsl:when test="operator='leq'">&lt;=</xsl:when>	
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="rhs"/>
				</LI>
			</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="attributesMatrix">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Attributes matrix</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:value-of select="."/>
	</DIV>
</xsl:template>


<!-- ALTERNATIVES RELATED -->


<xsl:template match="alternativeValue">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternative value</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:if test="@name">
			<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="alternativeID"><xsl:value-of select="alternativeID"/></xsl:when>
			<xsl:when test="alternativesSetID"><xsl:value-of select="alternativesSetID"/></xsl:when>
			<xsl:when test="alternativesSet"><xsl:apply-templates select="alternativesSet"/></xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="value"/><BR/>
	</DIV>
</xsl:template>


<xsl:template match="alternativesValues">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives values</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<TABLE CELLSPACING='1'>
			<xsl:for-each select="alternativeValue">
				<TR>
					<TD>
						<xsl:choose>
							<xsl:when test="alternativeID"><xsl:value-of select="alternativeID"/></xsl:when>
							<xsl:when test="alternativesSetID"><xsl:value-of select="alternativesSetID"/></xsl:when>
							<xsl:when test="alternativesSet"><xsl:apply-templates select="alternativesSet"/></xsl:when>
						</xsl:choose>
					</TD>
					<TD align="char" char=".">
						<xsl:apply-templates select="value"/>
					</TD>
				</TR>
			</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<xsl:template match="alternativesComparisons">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives comparisons</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<xsl:apply-templates select="valuation"/>
		<UL>
		<xsl:for-each select="./pairs">
			<xsl:for-each select="./pair">
			<LI>
			<xsl:choose>
				<xsl:when test="initial/alternativeID"><xsl:value-of select="./initial/alternativeID"/></xsl:when>
				<xsl:when test="initial/alternativesSetID"><xsl:value-of select="./initial/alternativesSetID"/></xsl:when>
				<xsl:when test="initial/alternativesSet"><xsl:apply-templates select="alternativesSet"/> </xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="../../comparisonType='geq'">>=</xsl:when>
				<xsl:when test="../../comparisonType='eq'">=</xsl:when>
				<xsl:when test="../../comparisonType='leq'">&lt;=</xsl:when>
				<xsl:when test="../../comparisonType='neq'">!=</xsl:when>
				<xsl:when test="../../comparisonType='gtr'">></xsl:when>
				<xsl:when test="../../comparisonType='less'">&lt;</xsl:when>	
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="../../comparisonType">
							<xsl:text> </xsl:text><xsl:value-of select="../../comparisonType"/><xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> </xsl:text>R<xsl:text> </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="terminal/alternativeID"><xsl:value-of select="./terminal/alternativeID"/></xsl:when>
				<xsl:when test="terminal/alternativesSetID"><xsl:value-of select="./terminal/alternativesSetID"/></xsl:when>
				<xsl:when test="terminal/alternativesSet"><xsl:apply-templates select="alternativesSet"/></xsl:when>
			</xsl:choose>
			<xsl:text> </xsl:text> (<xsl:apply-templates select="value"/>)
			</LI>
			</xsl:for-each>
		</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="alternativesLinearConstraints">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives linear constraints</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<UL>
			<xsl:for-each select="constraint">
				<LI>
					<xsl:for-each select="element">
						<xsl:if test="coefficient &gt; 0">+</xsl:if>
						<xsl:value-of select="coefficient"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="alternativeID"><xsl:value-of select="alternativeID"/> </xsl:when>
							<xsl:when test="alternativesSetID"> <xsl:value-of select="alternativesSetID"/> </xsl:when>
							<xsl:when test="alternativesSet"> <xsl:apply-templates select="alternativesSet"/> </xsl:when>
						</xsl:choose>
						<xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="operator='geq'">>=</xsl:when>
						<xsl:when test="operator='eq'">=</xsl:when>
						<xsl:when test="operator='leq'">&lt;=</xsl:when>	
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="rhs"/>
				</LI>
			</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="alternativesMatrix">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives matrix</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:value-of select="."/>
	</DIV>
</xsl:template>


<!-- CATEGORIES RELATED -->


<xsl:template match="categoriesProfiles">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
				<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories profiles</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<UL><xsl:apply-templates select="categoryProfile"/></UL>
	</DIV>
</xsl:template>


<xsl:template match="categoryProfile">
	<LI>
		Category profile id : <xsl:value-of select="@id"/><BR/>
		<xsl:apply-templates select="description"/>
		<xsl:choose>
			<xsl:when test="central">central profile on category <xsl:value-of select="central/categoryID"/></xsl:when>
			<xsl:when test="limits">
				limit profile between <xsl:value-of select="limits/lowerCategory"/> (lower category) and <xsl:value-of select="limits/upperCategory"/> (upper category)
			</xsl:when>
		</xsl:choose>
	</LI>
</xsl:template>


<xsl:template match="categoriesContents">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories contents</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:value-of select="."/>
	</DIV>
</xsl:template>


<xsl:template match="alternativesAffectations">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Alternatives affectations</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="description"/>
		</DIV>
		<UL><xsl:apply-templates select="alternativeAffectation"/></UL>
	</DIV>
</xsl:template>


<xsl:template match="alternativeAffectation">
	<LI>
		<xsl:choose>
			<xsl:when test="./alternativeID"><xsl:value-of select="./alternativeID"/></xsl:when>
			<xsl:when test="./categoriesSetID"><xsl:value-of select="./categoriesSetID"/></xsl:when>
			<xsl:when test="./alternativesSet"> alternatives set <xsl:apply-templates select="alternativesSet"/> </xsl:when>
		</xsl:choose>
		 -> 
		 <xsl:choose>
			<xsl:when test="./categoryID"><xsl:value-of select="./categoryID"/></xsl:when>
			<xsl:when test="./alternativesSetID"><xsl:value-of select="./alternativesSetID"/></xsl:when>
			<xsl:when test="./categoriesSet"> categories set <xsl:apply-templates select="categoriesSet"/> </xsl:when>
			<xsl:when test="./categoriesInterval"><xsl:apply-templates select="categoriesInterval"/></xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="description"/>
	</LI>
</xsl:template>


<xsl:template match="categoryValue">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Category value</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:if test="@name">
			<DIV CLASS="classSubTitle"><xsl:value-of select="@name"/></DIV>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="categoryID"><xsl:value-of select="categoryID"/></xsl:when>
			<xsl:when test="categorieSetID"><xsl:value-of select="categoriesSetID"/></xsl:when>
			<xsl:when test="categoriesSet"><xsl:apply-templates select="categoriesSet"/></xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="value"/><BR/>
	</DIV>
</xsl:template>


<xsl:template match="categoriesValues">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories values</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<TABLE CELLSPACING='1'>
			<xsl:for-each select="categoryValue">
				<TR>
					<TD>
						<xsl:choose>
							<xsl:when test="categoryID"><xsl:value-of select="categoryID"/></xsl:when>
							<xsl:when test="categoriesSetID"><xsl:value-of select="categoriesSetID"/></xsl:when>
							<xsl:when test="categoriesSet"><xsl:apply-templates select="categoriesSet"/></xsl:when>
						</xsl:choose>
					</TD>
					<TD align="char" char=".">
						<xsl:apply-templates select="value"/>
					</TD>
				</TR>
			</xsl:for-each>
		</TABLE>
	</DIV>
</xsl:template>


<xsl:template match="categoriesComparisons">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories comparisons</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<xsl:apply-templates select="valuation"/>
		<UL>
		<xsl:for-each select="./pairs">
			<xsl:for-each select="./pair">
			<LI>
			<xsl:choose>
				<xsl:when test="initial/categoryID"><xsl:value-of select="./initial/categoryID"/></xsl:when>
				<xsl:when test="initial/categoriesSetID"><xsl:value-of select="./initial/categoriesSetID"/></xsl:when>
				<xsl:when test="initial/categoriesSet"><xsl:apply-templates select="categoriesSet"/> </xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="../../comparisonType='geq'">>=</xsl:when>
				<xsl:when test="../../comparisonType='eq'">=</xsl:when>
				<xsl:when test="../../comparisonType='leq'">&lt;=</xsl:when>
				<xsl:when test="../../comparisonType='neq'">!=</xsl:when>
				<xsl:when test="../../comparisonType='gtr'">></xsl:when>
				<xsl:when test="../../comparisonType='less'">&lt;</xsl:when>	
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="../../comparisonType">
							<xsl:text> </xsl:text><xsl:value-of select="../../comparisonType"/><xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> </xsl:text>R<xsl:text> </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="terminal/categoryID"><xsl:value-of select="./terminal/categoryID"/></xsl:when>
				<xsl:when test="terminal/categoriesSetID"><xsl:value-of select="./terminal/categoriesSetID"/></xsl:when>
				<xsl:when test="terminal/categoriesSet"><xsl:apply-templates select="categoriesSet"/></xsl:when>
			</xsl:choose>
			<xsl:text> </xsl:text> (<xsl:apply-templates select="value"/>)
			</LI>
			</xsl:for-each>
		</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="categoriesLinearConstraints">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories linear constraints</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<UL>
			<xsl:for-each select="constraint">
				<LI>
					<xsl:for-each select="element">
						<xsl:if test="coefficient &gt; 0">+</xsl:if>
						<xsl:value-of select="coefficient"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="categoryID"><xsl:value-of select="categoryID"/></xsl:when>
							<xsl:when test="categoriesSetID"><xsl:value-of select="categoriesSetID"/></xsl:when>
							<xsl:when test="categoriesSet"><xsl:apply-templates select="categoriesSet"/></xsl:when>
						</xsl:choose>
						<xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="operator='geq'">>=</xsl:when>
						<xsl:when test="operator='eq'">=</xsl:when>
						<xsl:when test="operator='leq'">&lt;=</xsl:when>	
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="rhs"/>
				</LI>
			</xsl:for-each>
		</UL>
	</DIV>
</xsl:template>


<xsl:template match="categoriesMatrix">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories matrix</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:value-of select="."/>
	</DIV>
</xsl:template>


<!-- OTHER TEMPLATES -->


<xsl:template match="criteriaScales">
	<DIV CLASS="classSubTitle">Criteria scales : <xsl:value-of select="@name"/></DIV>
	<xsl:apply-templates select="description"/>
	<xsl:apply-templates select="criterionScale"/>
</xsl:template>


<xsl:template match="criterionScale">
	<DIV CLASS="classSubSubTitle"><xsl:value-of select="@name"/></DIV>
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match="criterionFunction">
	Function associated to criterion <xsl:value-of select="criterionID"/> : <xsl:apply-templates select="function"/>
</xsl:template>


<xsl:template match="categoriesInterval">
	[<xsl:value-of select="lowerBound"/> ; <xsl:value-of select="upperBound"/>]
</xsl:template>


<xsl:template match="categoriesRanks">
	<DIV CLASS="bloc">
		<DIV CLASS="classTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Categories ranks</xsl:otherwise>
			</xsl:choose>
		</DIV>
		<xsl:value-of select="."/>
	</DIV>
</xsl:template>


<xsl:template match="thresholds">
	<DIV CLASS="sousbloc">
		<DIV CLASS="classSubTitle">
			<xsl:choose>
				<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
				<xsl:otherwise>Thresholds</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="criterionID"> on criterion <xsl:value-of select="criterionID"/></xsl:when>
				<xsl:when test="criteriaSetID"> on critera set <xsl:value-of select="criteriaSetID"/></xsl:when>
				<xsl:when test="criteriaSet"> on criteria set <xsl:apply-templates select="criteriaSet"/></xsl:when>
			</xsl:choose>
		</DIV>
		<xsl:apply-templates select="description"/>
		<UL><xsl:apply-templates select="threshold"/></UL>
	</DIV>
</xsl:template>


<xsl:template match="threshold">
	<LI>
		<xsl:choose>
			<xsl:when test="@mcdaConcept"><xsl:value-of select="@mcdaConcept"/></xsl:when>
			<xsl:otherwise>Threshold</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
				<xsl:when test="criterionID"> on criterion <xsl:value-of select="criterionID"/></xsl:when>
				<xsl:when test="criteriaSetID"> on critera set <xsl:value-of select="criteriaSetID"/></xsl:when>
				<xsl:when test="criteriaSet"> on criteria set <xsl:apply-templates select="criteriaSet"/></xsl:when>
			</xsl:choose> : 
		<xsl:apply-templates select="function"/>
		<xsl:apply-templates select="description"/>
	</LI>
</xsl:template>


<xsl:template match="scale">
	<xsl:choose>
		<xsl:when test="quantitative">
			[ <xsl:value-of select="./quantitative/minimum"/> ; <xsl:value-of select="./quantitative/maximum"/> ]
		</xsl:when>
		<xsl:when test="qualitative">
			[
			<xsl:for-each select="./qualitative/rankedLabel">
				<xsl:value-of select="label"/>(<xsl:value-of select="rank"/>) 
			</xsl:for-each>
			]
		</xsl:when>
		<xsl:when test="nominal">
			[
			<xsl:for-each select="./nominal/label">
				<xsl:value-of select="."/><xsl:text> </xsl:text>
			</xsl:for-each>
			]
		</xsl:when>
	</xsl:choose>
	<xsl:apply-templates select="description"/>
</xsl:template>


<xsl:template match="function">
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match="constant">
	Constant function : <I>y</I> = <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="linear">
	Linear function : <I>y</I> = <xsl:value-of select="slope"/> <I>x</I> + <xsl:value-of select="intercept"/>
</xsl:template>


<xsl:template match="piecewiseLinear">
	Piecewise Linear function : <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="points">
	Set : { <xsl:for-each select="point">(<xsl:value-of select="abscissa"/>,<xsl:value-of select="ordinate"/>) </xsl:for-each>}
</xsl:template>


<xsl:template match="element">
	<xsl:choose>
		<xsl:when test="alternativeID"><xsl:value-of select="alternativeID"/></xsl:when>
		<xsl:when test="criterionID"><xsl:value-of select="criterionID"/></xsl:when>
	</xsl:choose>
	<xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="value">
	<xsl:choose>
		<xsl:when test="integer">
			<xsl:value-of select="round(number(./integer))"/>
		</xsl:when>
		<xsl:when test="real">
			<xsl:value-of select="format-number(number(./real), '0.##')"/>
		</xsl:when>
		<xsl:when test="interval">
			[ <xsl:apply-templates select="./interval/lowerBound/*"/> ; <xsl:apply-templates select="./interval/upperBound/*"/> ]
		</xsl:when>
		<xsl:when test="rational">
			<xsl:value-of select="./rational/numerator"/>/<xsl:value-of select="./rational/denominator"/>
		</xsl:when>
		<xsl:when test="label">
			<xsl:value-of select="./label"/>
		</xsl:when>
		<xsl:when test="rankedLabel">
			<xsl:value-of select="./rankedLabel/label"/>(<xsl:value-of select="./rankedLabel/rank"/>)
		</xsl:when>
		<xsl:when test="boolean">
			<xsl:value-of select="./boolean"/>
		</xsl:when>
		<xsl:when test="NA">
			<xsl:value-of select="./NA"/>
		</xsl:when>
		<xsl:when test="image">
			<BR/><CENTER><img src='data:image/png;base64,{./image}' alt='image'/></CENTER><BR/>
		</xsl:when>
		<xsl:when test="imageRef">
			<BR/><CENTER><img src='{./imageRef}' alt='image'/></CENTER><BR/>
		</xsl:when>
	</xsl:choose>
</xsl:template>


<xsl:template match="numericValue">
	<xsl:choose>
		<xsl:when test="integer">
			<xsl:value-of select="./integer"/>
		</xsl:when>
		<xsl:when test="real">
			<xsl:value-of select="real"/>
		</xsl:when>
		<xsl:when test="rational">
			<xsl:value-of select="./rational/numerator"/>/<xsl:value-of select="./rational/denominator"/>
		</xsl:when>
		<xsl:when test="NA">
			<xsl:value-of select="./NA"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>


<xsl:template match="comparisonType">
	<i>Relation</i> : <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
