<#if templateService.isWidgetActive( "menu_documentation" )>
<span id="menu-documentation" class="footer-item urlstyle" title="Documentation" data-url="<@spring.url '/menu/documentation' />" >
	Documentation
</span>
</#if>

<#if templateService.isWidgetActive( "menu_api" )>
<span id="menu-api" class="footer-item urlstyle" title="APIs" data-url="<@spring.url '/menu/api' />" >
	APIs
</span>
</#if>

<#if templateService.isWidgetActive( "menu_introduction" )>
<span id="menu-introduction" class="footer-item urlstyle" title="Introduction" data-url="<@spring.url '/menu/introduction' />" >
	Introduction
</span>
</#if>

<span class="footer-item">
	<a href="http://learntech.rwth-aachen.de/" target="_blank">i9-RWTH Aachen</a>
</span>

<script>
$(function(){
	$( "#menu-introduction,#menu-api,#menu-documentation" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
	});
});
</script>