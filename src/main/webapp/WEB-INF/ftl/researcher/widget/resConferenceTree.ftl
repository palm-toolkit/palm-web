<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div id="tree-container" class="tree-container" style="height:360px">
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.tree-container").slimscroll({
			height: "300px",
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
				    },activate: function(event, data){ // allow re-loads
			            var node = data.node,
			                orgEvent = data.originalEvent;
			            if( node.data.href !== ""){
			                window.location = "<@spring.url '/' />" + node.data.href;
			            }
			        }
				});			
							
							
						}<#-- end of on refresh done -->
		};
		
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