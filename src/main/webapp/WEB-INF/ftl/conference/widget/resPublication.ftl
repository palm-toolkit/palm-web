<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="widget-publications-${wUniqueName}">
	<div id="publications-box-${wUniqueName}" class="box">
		<div class="box-header"> 
			<div class="box-title-container">
          		<h3 class="box-title">Publications: <span class="author_name"></span> </h3>
        	</div>
		</div>
		<div class="box-content">
		<div class="box-footer"> </div>
		</div>
	</div>	
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#publications-box-${wUniqueName} .box-content ").slimscroll({
			height : "95%",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });

		$("#publications-box-${wUniqueName} .box-content").css({"max-height": "600px", "height":"100%"});
	
		function getCurrentUser(){
			<#if currentUser??>
				return true;
			<#else>
				return false;
			</#if>	
		}
		
		var url = "<@spring.url '/resources/json/publicationList.json' />";
		d3.json(url, function(error, data){
			$.publicationList.init( data.status, "${wUniqueName}", "<@spring.url ''/>", getCurrentUser(), 0 );
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
			"selector": "#widget-publications-box-${wUniqueName}",
			"element": $( "#widget-publications-box-${wUniqueName}" ),
			"options": options
		});
	});<#-- end document ready -->
</script>