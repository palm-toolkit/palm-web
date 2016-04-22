 <@layout.global classStyle="layout-top-nav skin-blue-light overflow-visible">

 	<@content.contentWrapper>
 		<section class="content" style="padding:0">
			<div class ="row">
 			<#include "widgetLayoutMainContent.ftl" />
			</div>
		</section>
 	</@content.contentWrapper>

<#--
	<script type="text/javascript">
    	$(function(){
        	$('.wrapper').slimScroll({
				height: "100%",
	        	size: "3px",
   				touchScrollStep: 50
			});
    	});
	</script>
 -->
</@layout.global>