	<!-- internal missy css definition -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/palm.css' />" />
	<link rel="stylesheet" href="<@spring.url '/resources/styles/jquery-ui.css' />" />
	
	<script>
		<#-- get the basepath of the project, that will be used in javascript file -->
		var baseUrl = "<@spring.url '' />";
	</script>
	
	<!-- external -->
	<!-- simplifies javascript programming -->
	<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>
	<script src="<@spring.url '/resources/scripts/jquery-ui-1.9.2.custom.js' />"></script>
	<script src="<@spring.url '/resources/scripts/jquery.dialogextend.js' />"></script>
	
	<!-- used for load D3 visualization library -->
	<script src="<@spring.url '/resources/scripts/d3.min.js' />"></script>
	
	<#if link?? & link == 'sparqlview'>
		<!-- sparql -->
		<script src="<@spring.url '/resources/scripts/sparql.js' />"></script>
		<script src="<@spring.url '/resources/scripts/namespaces.js' />"></script>
		<script src="<@spring.url '/resources/scripts/snorql.js' />"></script>
	</#if>
	<#-- used for uploading file via ajax, etc-->
	<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />"></script>
	
	<#-- internal javascript library -->
	<script type="text/javascript" src="<@spring.url '/resources/scripts/palm.js' />"></script>