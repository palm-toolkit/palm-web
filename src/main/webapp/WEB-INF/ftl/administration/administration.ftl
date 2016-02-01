 <@layout.global>
 
 	<@content.header>

		<#include "headerPage.ftl" />
		
 	</@content.header>
 	
 	<@content.leftSidebar>

		<#include "administrationLeftContent.ftl" />
		
 	</@content.leftSidebar>
 	
 	<@content.contentWrapper>
 	
 		<section class="content">
 			<div class="row">
 			<#-- ajax content goes here -->
 			</div>
		</section>
		
		<script>
		<#-- add slim scroll -->
		$(function(){
	      $(".content-list, .content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		});
		</script>
		
 	</@content.contentWrapper>
 	
</@layout.global>