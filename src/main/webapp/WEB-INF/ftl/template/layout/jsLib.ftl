<#-- external -->
<#-- simplifies javascript programming -->
<#--<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>-->
<script src="<@spring.url '/resources/scripts/jquery-ui-1.9.2.custom.js' />"></script>
<#--<script src="<@spring.url '/resources/scripts/jquery.dialogextend.js' />"></script>-->

<#-- jQuery 2.1.3 -->
<#--<script src="<@spring.url '/resources/plugins/jQuery/jQuery-2.1.3.min.js' />" type="text/javascript"></script>-->

<#-- jQuery fileupload -->
<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />" type="text/javascript"></script>

<#-- jQuery UI 1.11.4 -->
<script src="<@spring.url '/resources/plugins/jQueryUI/jquery-ui.min.js' />" type="text/javascript"></script>

<#-- Bootstrap 3.3.2 JS -->
<script src="<@spring.url '/resources/bootstrap/js/bootstrap.min.js' />" type="text/javascript"></script>

<#-- Bootstrap-select v1.7.2 -->
<script src="<@spring.url '/resources/bootstrap/js/bootstrap-select.min.js' />" type="text/javascript"></script>

<#-- FastClick -->
<script src="<@spring.url '/resources/plugins/fastclick/fastclick.min.js' />" type="text/javascript"></script>

<#-- Sparkline -->
<script src="<@spring.url '/resources/plugins/sparkline/jquery.sparkline.min.js' />" type="text/javascript"></script>

<#-- iCheck -->
<script src="<@spring.url '/resources/plugins/icheck/icheck.min.js' />" type="text/javascript"></script>

<#-- SlimScroll 1.3.0 -->
<script src="<@spring.url '/resources/plugins/slimscroll/jquery.slimscroll.min.js' />" type="text/javascript"></script>

<#-- used for load D3 visualization library -->
<script src="<@spring.url '/resources/scripts/d3.min.js' />"></script>
<script src="<@spring.url '/resources/scripts/visualization/d3.layout.cloud.js' />" type="text/javascript"></script>
<#--<script src="<@spring.url '/resources/scripts/visualization/d3.v3.min.js' />" type="text/javascript"></script>-->
<script src="<@spring.url '/resources/scripts/visualization/d3.geo.projection.v0.min.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/datamaps.world.min.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/jit-yc.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/jquery.simplemodal.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/topojson.v1.min.js' />" type="text/javascript"></script>

<#-- used for uploading file via ajax, etc-->
<#--<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />"></script>-->

<#-- internal javascript library -->
<script>
	<#-- get the basepath of the project, that will be used in javascript file -->
	var baseUrl = "<@spring.url '' />";
</script>

<script type="text/javascript" src="<@spring.url '/resources/scripts/palm.js' />"></script>

<#if link?? & link == "administration">
	<script type="text/javascript" src="<@spring.url '/resources/scripts/palm.administration.js' />"></script>
</#if>

<#if activeMenu??>
	<script>
		<#list activeMenu?split("-") as x>
			<#if x_index == 0>
				var $menu = $( "section.sidebar li[data-link='${x}']" );
				$menu.addClass( "active" );
				<#-- load content -->
				getContentViaAjax( $menu.find( "a" ).attr( "href" ), "section.content .row");
			<#else>
				var $subMenu =$menu.find( "li[data-link='${x}']" );
				$subMenu.addClass( "active" );
				<#-- load content -->
				getContentViaAjax( $subMenu.find( "a" ).attr( "href" ), "section.content .row");
			</#if>
		</#list>  
	</script>
</#if>