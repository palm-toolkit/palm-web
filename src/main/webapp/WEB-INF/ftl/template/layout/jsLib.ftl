<#-- external -->
<#-- simplifies javascript programming -->
<#--<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>-->
<script src="<@spring.url '/resources/scripts/jquery-ui-1.9.2.custom.js' />"></script>
<#--<script src="<@spring.url '/resources/scripts/jquery.dialogextend.js' />"></script>-->

<#-- jquery validation -->
<script src="<@spring.url '/resources/scripts/jquery.validate.min.js' />"></script>

<#-- jQuery 2.1.3 -->
<#--<script src="<@spring.url '/resources/plugins/jQuery/jQuery-2.1.3.min.js' />" type="text/javascript"></script>-->

<#-- jQuery fileupload -->
<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />" type="text/javascript"></script>

<#-- Combodate - used to generate date combobox -->
<script src="<@spring.url '/resources/scripts/combodate.js' />" type="text/javascript"></script>

<#-- gridster -->
<#--
<script src="<@spring.url '/resources/plugins/gridster/jquery.gridster.js' />" type="text/javascript"></script>
-->
<#-- jQuery UI 1.11.4 -->
<script src="<@spring.url '/resources/plugins/jQueryUI/jquery-ui.min.js' />" type="text/javascript"></script>

<#-- Bootstrap 3.3.2 JS -->
<script src="<@spring.url '/resources/bootstrap/js/bootstrap.min.js' />" type="text/javascript"></script>

<#-- input mask -->
<script src="<@spring.url '/resources/plugins/input-mask/jquery.inputmask.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/plugins/input-mask/jquery.inputmask.date.extensions.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/plugins/input-mask/jquery.inputmask.extensions.js' />" type="text/javascript"></script>

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
<script src="<@spring.url '/resources/scripts/d3.min.js' />" type="text/javascript"></script>
<#-- extended d3 library for reuse usege -->
<script src="<@spring.url '/resources/plugins/nv3d/nv.d3.js' />" type="text/javascript"></script>
<#-- d3 layout for text cloud -->
<script src="<@spring.url '/resources/scripts/visualization/d3.layout.cloud.js' />" type="text/javascript"></script>

<#-- used to provide rich tree visualization -->
<script src="<@spring.url '/resources/plugins/fancytree/jquery.fancytree.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/plugins/fancytree/src/jquery.fancytree.childcounter.js' />" type="text/javascript"></script>


<#-- d3 layout for maps - currently unused -->
<#--
<script src="<@spring.url '/resources/scripts/visualization/d3.geo.projection.v0.min.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/datamaps.world.min.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/jit-yc.js' />" type="text/javascript"></script>
<script src="<@spring.url '/resources/scripts/visualization/topojson.v1.min.js' />" type="text/javascript"></script>
-->

<#-- extended modal for jquery modal dialog -- unused -->
<#--
<script src="<@spring.url '/resources/scripts/visualization/jquery.simplemodal.js' />" type="text/javascript"></script>
-->
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
				<#if activeMenu?split("-")?size == 1>
				<#-- load content -->
				getContentViaAjax( $menu.find( "a" ).attr( "href" ), "section.content .row");
				</#if>
			<#else>
				var $subMenu =$menu.find( "li[data-link='${x}']" );
				$subMenu.addClass( "active" );
				<#-- load content -->
				getContentViaAjax( $subMenu.find( "a" ).attr( "href" ), "section.content .row");
			</#if>
		</#list> 
		<#-- modify address -->		
		history.pushState( null, "<#if link??>${link?capitalize}</#if> ${activeMenu}" , $.PALM.utility.removeURLParameter(window.location.href, "page") + "page=${activeMenu}");
	</script>
</#if>