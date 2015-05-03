 <#--
 <@layout.global classStyle="layout-top-nav skin-blue-light">
 	
 	<@content.header>

		<#include "headerHome.ftl" />
		
 	</@content.header>
 	
</@layout.global>
-->
<#-- -->
<@layout.global>
 	

 	<@content.header>

		<#include "headerPage.ftl" />
		
 	</@content.header>
 	
 	<@content.leftSidebar>

		<#include "conferenceLeftContent.ftl" />
		
 	</@content.leftSidebar>
 	
 	<@content.contentWrapper>
 	
 		<#include "conferenceMainContent.ftl" />
		
 	</@content.contentWrapper>
 	
</@layout.global>