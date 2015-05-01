<#macro global>
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Personal Academic Learner Model</title>
		<meta name="keywords" content="Personal Academic Learner Model" />
		<meta name="description" content="Personal Academic Learner Model" />
		<#include "cssStyle.ftl" />
	</head>
	
	<body>
	
		<#include "header.ftl" />
	
		<!-- Main Content -->
		<div id="main">
			<#nested />
		</div>
		
		<#include "dialogList.ftl" />
		<#include "jsLib.ftl" />
	</body>

</html>

</#macro>