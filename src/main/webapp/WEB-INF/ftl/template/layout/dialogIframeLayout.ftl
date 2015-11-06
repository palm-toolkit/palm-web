 <@layout.global classStyle="layout-top-nav skin-blue-light">

 	<@content.contentWrapper>
 		<section class="content" style="padding:0">
			<div class ="row">
 			<#include "widgetLayoutMainContent.ftl" />
			</div>
		</section>
 	</@content.contentWrapper>

	<script type="text/javascript">
    	$(function(){
        	$('body').slimScroll();
    	});
	</script>
 	
</@layout.global>