<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div id="tree-container" class="tree-container" style="height:360px">
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.tree-container").slimscroll({
			height: "500px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/academicEventTree' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				<#--$.PALM.popUpMessage.create( "loading coauthor list" );-->
						},
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".tree-container" );
							<#-- remove previous list -->
							targetContainer.html( "" );
				
				<#-- check and destroy first if exist -->
				try {
					$("#tree-container").fancytree("destroy");
				}catch(err) {}
				
				<#-- create tree -->
				$("#tree-container").fancytree({
					extensions: ["childcounter"],
				  	source: data.evenTree,
					childcounter: {
				        deep: true,
				        onlyCountLeafChild:true,
				        hideZeros: true,
				        hideExpanded: true
				    },
				    activate: function(event, data){ // allow re-loads
			            var node = data.node,
			                orgEvent = data.originalEvent;
			            if( node.data.href !== ""){
			             	var href = "<@spring.url '/' />" + node.data.href;
			             	if( !node.data.added && node.data.position < 3 )
			             		href += "&add=yes";
			                window.location = href;
			            }
			        },
			       	renderNode: function(event, data) {
			        	<#--Optionally tweak data.node.span-->
			        	var node = data.node;
			        	if( !node.data.added && node.data.position < 3 ){
			          		node.extraClasses = "text-gray";
        					node.renderTitle();
			        	}
			      	}
				});			
							
							
			 }<#-- end of on refresh done -->
		};
		
		<#if user.author??>
			options.queryString = "?id=${currentUser.author.id}";
		</#if>
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#-- user.author.id exist, triger ajax call -->
		<#if currentUser.author??>
			$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		<#else>
			$("#boxbody${wUniqueName} .box-content").html( "No conferences found. Please link yourself to a researcher on PALM" );
		</#if>
	});
</script>