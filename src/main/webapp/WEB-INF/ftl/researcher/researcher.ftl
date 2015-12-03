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

	<#-- add new researcher -->
	<div id="new-author-circle" class="new-circle" title="Add a Researcher" data-url="<@spring.url '/researcher/add' />">
		<span class="fa-stack fa-lg bg-red">
			<i class="fa fa-user fa-stack-1x-left"></i>
			<i class="fa fa-plus fa-stack-1x-right"></i>
		</span>
	</div>

<script>
$(function(){
	$( "#new-author-circle" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"416px"}, $(this).attr("title") );
	});
});
</script>
 	
</@layout.global>