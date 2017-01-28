<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
	</div>
</div>

<#--
<div class="box-footer">
</div>
-->
<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} .box-content").slimscroll({
			height: "660px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });

		function getCurrentUser(){
			<#if currentUser??>
				return true;
			<#else>
				return false;
			</#if>	
		}
		
		var url = "<@spring.url '/resources/json/publicationList.json' />";
		d3.json(url, function(error, originJsonObject){
			var data = originJsonObject;
			$.publicationList.init( data, "${wUniqueName}", "<@spring.url ''/>", getCurrentUser() );
		} );
	
		<#-- set widget unique options -->
		var options ={
	<#--		source : "<@spring.url '/researcher/publicationList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				v
				});

				<#-- append everything to  -->
			<#--	mainContainer.append( timeLineContainer );
		} -->
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
	});<#-- end document ready -->
</script>