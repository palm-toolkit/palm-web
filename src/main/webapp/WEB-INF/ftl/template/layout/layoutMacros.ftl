<#macro global classStyle="">
<!DOCTYPE html>
<html>

	<head>
		<meta charset=utf-8">
		<title>Personal Academic Learner Model</title>
		<meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
		<meta name="keywords" content="Personal Academic Learner Model" />
		<meta name="description" content="Personal Academic Learner Model" />
		<#-- all styles -->
		<#include "cssStyle.ftl" />
	</head>
	
	<body class="<#if classStyle != "">${classStyle}<#else>skin-blue-light</#if>">
		<div class="wrapper">
			
			<#-- content -->
			<#nested />
			
			<#-- javascript call at the end, avoiding resource blocking-->
			<#include "jsLib.ftl" />
			
		</div>
	</body>

</html>
</#macro>