<div id="boxbody-${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box similarity-criteria row">
			<div class="filter groupedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-5  col-sm-5"> Similarity Based On: </span>
  				<div class="dropdown col-md-6 col-sm-6">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Topics of Interest</button>	
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-12  col-sm-12"></div>
			<div class="visualization-details col-md-5 col-sm-5 hidden"></div>
		</div>
	</div>
</div>

<script>
	$( function(){
		<#-- add slim scroll -->
    <#--   $("#boxbody-${wUniqueName} .box-content").slimscroll({
			height: "500px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
	 -->   
	    <#-- generate unique id for progress log -->
		var uniquePidSimilarResearchers = $.PALM.utility.generateUniqueId();	
				
		<#-- source : "<@spring.url '/researcher/similarAuthorList' />", -->
	    <#-- unique options in each widget -->

		var options = {};
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>

 <#-- !! The similar authors algorithm is not retriving always the results. Fixing the algorithm was not part of my work, hence
I used the data from a JSON file for Ulrik Schroeder, Mohamed Amine Chatti and  Matthias Jarke for testing purposes !!-->

		var jsonURL = "<@spring.url '/resources/json/similar.json' />";
		 $.getJSON( jsonURL, function(result){
		 	if ( result[ targetId ] != null){
		 		var data = result[ targetId ];
		 		var targetContainer = $( "#boxbody-${wUniqueName}" ).find( ".visualization-main" );
					targetContainer.html( "" );
						
				if( data.count == 0 ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Similar Researchers!", "Researcher does not have any similar researchers on PALM (insufficient data)" );
					return false;
				}	
						
				$.PALM.visualizations.record ( {
					data 	: data, 
					widgetUniqueName : "${wUniqueName}", 
					width	: 960,
					height	: 400,
					url 	: "<@spring.url '' />"
				});	
											
				if( data.count > 0 ){ 
					<#-- remove any remaing tooltip -->
					$( "body .tooltip" ).remove(); 				
					similar_researchers();
				} 
		
				$( "#widget-${wUniqueName}" ).find(".overlay").remove();
		 	}
		 	else {
		 		options ={
					source : "<@spring.url '/researcher/similarAuthorListTopicLevel' />",
					query: "",
					queryString : "",
					page:0,
					maxresult:50,
					onRefreshStart: function(  widgetElem  ){
						<#-- show pop up progress log -->
						$.PALM.popUpMessage.create( "loading similar researchers list", {uniqueId: uniquePidSimilarResearchers, popUpHeight:40, directlyRemove:false , polling:false});
					},
					onRefreshDone: function(  widgetElem , data ){
						var targetContainer = $( "#boxbody-${wUniqueName}" ).find( ".visualization-main" );
							targetContainer.html( "" );
						
						console.log(data);
						if( data.count == 0 ){
							$.PALM.callout.generate( targetContainer , "warning", "Empty Similar Researchers!", "Researcher does not have any similar researchers on PALM (insufficient data)" );
							return false;
						}	
						
						$.PALM.visualizations.record ( {
							data 	: data, 
							widgetUniqueName : "${wUniqueName}", 
							width	: 960,
							height	: 400,
							url 	: "<@spring.url '' />"
						});	
											
						if( data.count > 0 ){ 
							<#-- remove any remaing tooltip -->
							$( "body .tooltip" ).remove(); 
							 similar_researchers();
						} 
		
						$.PALM.popUpMessage.remove( uniquePidSimilarResearchers );
						
					}					
				};
		 	}
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
		
		function similar_researchers(){
			var vars = $.SIMILAR.variables;
			vars.widget = d3.select( "#widget-${wUniqueName}" );
			vars.mainContainer = $( "#widget-${wUniqueName}" + " .visualization-main" );
			vars.detailsContainer = $( "#widget-${wUniqueName}" + " .visualization-details" );
			vars.width		   = vars.mainContainer.width();
			vars.height		   = $.PALM.visualizations.height;
			vars.radius 	   = Math.min( vars.width / 2 - vars.margin.left - vars.margin.right , vars.height - vars.margin.top - vars.margin.bottom );	
			
			vars.mainContainer.empty();
							
			$.SIMILAR.create();
			$( "#widget-${wUniqueName}" ).find(".overlay").remove();
		}			
	} );
</script>