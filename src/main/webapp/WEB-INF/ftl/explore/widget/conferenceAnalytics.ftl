<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div class="conference-list">
    </div>
    
    <div id="authBasicSvg" class="authBasicSvg" style="width:100%;height:100%">
    <svg>
    </svg>
    </div>
    
    <div id="autOtherInfo" style="width:100%;overflow:hidden"></div>
</div>

<script>
	$( function(){

		var options ={
			source : "<@spring.url '/explore/conference' />"}
			
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
	});
</script>