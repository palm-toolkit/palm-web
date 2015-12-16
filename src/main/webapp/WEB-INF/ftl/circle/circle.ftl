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

	<#-- add new event -->
	<div id="new-circle" class="new-circle" title="Add New Circle" data-url="<@spring.url '/circle/add' />">
		<span class="fa-stack fa-lg bg-red">
			<i class="fa fa-circle-o fa-stack-1x-left"></i>
			<i class="fa fa-plus fa-stack-1x-right"></i>
		</span>
	</div>

<script>
$(function(){
	$( "#new-circle" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"82%", "popUpWidth" : "90%"}, $(this).attr("title") );
	});
});
</script>
 	
</@layout.global>