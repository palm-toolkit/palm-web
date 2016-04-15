<#--
<span class="footer-item urlstyle">
	Documentation
</span>
-->

<span id="menu-api" class="footer-item urlstyle" title="APIs" data-url="<@spring.url '/menu/api' />" >
	APIs
</span>

<span id="menu-introduction" class="footer-item urlstyle" title="Introduction" data-url="<@spring.url '/menu/introduction' />" >
	Introduction
</span>

<span class="footer-item">
	<a href="http://learntech.rwth-aachen.de/" target="_blank">i9-RWTH Aachen</a>
</span>

<script>
$(function(){
	$( "#menu-introduction,#menu-api" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
	});
});
</script>