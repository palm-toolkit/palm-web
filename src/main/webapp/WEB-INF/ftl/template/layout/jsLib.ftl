<script>
	<#-- get the basepath of the project, that will be used in javascript file -->
	var baseUrl = "<@spring.url '' />";
</script>

<!-- external -->
<!-- simplifies javascript programming -->
<!--<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>
<script src="<@spring.url '/resources/scripts/jquery-ui-1.9.2.custom.js' />"></script>
<script src="<@spring.url '/resources/scripts/jquery.dialogextend.js' />"></script>-->

<!-- jQuery 2.1.3 -->
<script src="<@spring.url '/resources/plugins/jQuery/jQuery-2.1.3.min.js' />"></script>

<!-- Bootstrap 3.3.2 JS -->
<script src="<@spring.url '/resources/bootstrap/js/bootstrap.min.js' />" type="text/javascript"></script>

<!-- FastClick -->
<script src="<@spring.url '/resources/plugins/fastclick/fastclick.min.js' />" type="text/javascript"></script>

<!-- AdminLTE App -->
<script src="<@spring.url '/resources/adminLTE/js/app.min.js' />" type="text/javascript"></script>

<!-- Sparkline -->
<script src="<@spring.url '/resources/plugins/sparkline/jquery.sparkline.min.js' />" type="text/javascript"></script>

<!-- iCheck -->
<script src="<@spring.url '/resources/plugins/icheck/icheck.min.js' />" type="text/javascript"></script>

<!-- SlimScroll 1.3.0 -->
<script src="<@spring.url '/resources/plugins/slimscroll/jquery.slimscroll.min.js' />" type="text/javascript"></script>

<!-- used for load D3 visualization library -->
<script src="<@spring.url '/resources/scripts/d3.min.js' />"></script>

<#-- used for uploading file via ajax, etc-->
<#--<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />"></script>-->

<#-- internal javascript library -->
<script type="text/javascript" src="<@spring.url '/resources/scripts/palm.js' />"></script>