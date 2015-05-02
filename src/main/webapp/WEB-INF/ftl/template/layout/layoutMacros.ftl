<#macro global>
<!DOCTYPE html>
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Personal Academic Learner Model</title>
		<meta name="keywords" content="Personal Academic Learner Model" />
		<meta name="description" content="Personal Academic Learner Model" />
		<#-- all styles -->
		<#include "cssStyle.ftl" />
	</head>
	
	<body class="skin-blue">
		<div class="wrapper">
		
			<#include "header.ftl" />
			
			<#-- content -->
			<#nested />
			
			<#-- javascript call at the end, avoiding resource blocking-->
			<#include "jsLib.ftl" />
			
		</div>
	</body>

</html>
</#macro>