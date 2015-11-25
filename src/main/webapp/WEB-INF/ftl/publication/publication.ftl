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

	<#-- add new publication -->
	<div id="new-publication-circle">
		<i class="fa fa-plus bg-red shadow-dialog" data-url="<@spring.url '/publication/add' />" title="Add new publication"></i>
	</div>

<script>
$(function(){

	$( "#new-publication-circle>i" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , {}, "Add New Publication");
	});
	
});
</script>
 	
</@layout.global>