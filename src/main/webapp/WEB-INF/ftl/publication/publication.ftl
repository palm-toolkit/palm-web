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

	<@content.footerWrapper>
		<#include "footer.ftl" />
	</@content.footerWrapper>

<@security.authorize access="isAuthenticated()">
	<#-- add new publication -->
	<div id="new-publication-circle" class="new-circle" title="Add new publication" data-url="<@spring.url '/publication/add' />">
		<span class="fa-stack fa-lg bg-red">
			<i class="fa fa-file-text-o fa-stack-1x-left"></i>
			<i class="fa fa-plus fa-stack-1x-right"></i>
		</span>
	</div>

<script>
$(function(){
	$( "#new-publication-circle" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"80%", "popUpWidth" : "90%", "popUpMargin": "3% auto"}, "Add New Publication");
	});
});
</script>
 </@security.authorize>

</@layout.global>