 <@layout.global classStyle="layout-top-nav skin-blue-light">
 	 	
 	<@content.header>

		<#include "headerHome.ftl" />
		
 	</@content.header>
 	
 	<@content.contentWrapper>
 	
		<div class="row center-content padding-home-content">
		
            <@widget.widget wSize="LARGE" wTitle="CONFERENCE" wId="conference" wClassContainer="padding0" wClassBox="border0"/>
            
		</div>
          		
 	</@content.contentWrapper>
 	
</@layout.global>