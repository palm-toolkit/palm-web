 <@layout.global>
 
 	<@content.header>

		<#include "headerPage.ftl" />
		
 	</@content.header>
 	
 	<@content.leftSidebar>
		<#include "widgetLayoutSidebar.ftl" />
 	</@content.leftSidebar>
 	
 	<@content.contentWrapper>
 		<section class="content">
			<div class ="row">
 			<#include "widgetLayoutMainContent.ftl" />
			</div>
		</section>
 	</@content.contentWrapper>

<@security.authorize access="isAuthenticated()">
	<#-- add new event -->
	<div id="new-event-circle" class="new-circle" title="Add Conference/Journal" data-url="<@spring.url '/venue/add' />">
		<span class="fa-stack fa-lg bg-red">
			<i class="fa fa-globe fa-stack-1x-left"></i>
			<i class="fa fa-plus fa-stack-1x-right"></i>
		</span>
	</div>

<script>
$(function(){
	$( "#new-event-circle" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"460px"}, $(this).attr("title") );
	});
});
</script>
 </@security.authorize>

</@layout.global>