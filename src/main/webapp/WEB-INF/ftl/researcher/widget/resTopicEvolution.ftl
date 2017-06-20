<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">	
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter top col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Top : </span>
  				 <div class="btn-group" data-toggle="">
                	<label class="radio-inline">
                    	<input type="radio" id="top5" name="top" value="5" /> 5
                	</label> 
                	<label class="radio-inline active">
                    	<input type="radio" id="top10" name="top" value="10" checked="checked" /> 10
               	 	</label> 
                	<label class="radio-inline">
                    	<input type="radio" id="q158" name="top" value="15"/> 15
                	</label> 
           		</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-12  col-sm-12">
				<div class="callout callout-warning" style="display:none">
				    <h4></h4>
				    <p></p>
				</div>
				<div class="nav-tabs-custom" style="display:none">
			        <ul class="nav nav-tabs"> </ul>
			        
			    <div id="legendContainer" class="legendContainer">
					<svg id="legend"></svg>
					
				</div>
				<div class="legend-buttons">
						<div id="showAll" class="legend-button">
							<input name="showAllButton" class="btn btn-xs btn-info" type="button" value="Show All" onclick="$.TOPIC_EVOLUTION.chart.legend.showAll()" />
						</div>
						<div id="clearAll" class="legend-button">
							<input name="clearAllButton" class="btn btn-xs btn-default" type="button" value="Hide All" onclick="$.TOPIC_EVOLUTION.chart.legend.hideAll()" />
						</div>
				</div>
				<div id="tooltipContainer" class="tooltipContainer">				
				</div>
			    <div class="tab-content" id="tab_evolution"></div>
			</div>
		</div>
	</div>
</div>

<script>
	$( function(){
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/topicEvolution' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var calloutWarning 		= $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".callout-warning" );
				var tabContainer 		= $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".nav-tabs-custom" );
				var tabHeaderContainer 	= tabContainer.find( ".nav" ).first();
				var tabContentContainer = tabContainer.find( ".tab-content" ).first();

				<#-- clean target container -->
				calloutWarning.hide();
				tabContainer.hide();
				tabHeaderContainer.html( "" );
				tabContentContainer.html( "" );
				
				if( typeof data.termvalues === "undefined" || data.termvalues.length == 0){
					alertCallOutWarning( "Publication contain no topicModel", "Topics mining only performed on complete publication with abstract" );
					return false;
				}
				<#-- show tab -->
				tabContainer.show();

				<#-- add visualization -->
				
				$.PALM.visualizations.record ( {
					data 	: data, 
					widgetUniqueName : "${wUniqueName}", 
					width	: 960,
					height	: 400
				});
				
				topic_evolution();
								
				function topic_evolution( ){	 
					var vars  = $.TOPIC_EVOLUTION.variables ;
					var width = $("#widget-" + "${wUniqueName}" + " .visualization-main").width() > $.PALM.visualizations.width ?
						$.PALM.visualizations.width : $("#widget-" + "${wUniqueName}" + " .visualization-main").width() ;
					
					vars.width 	 = width  - vars.margin.left - 4 * vars.margin.right;
					vars.height2 = $.PALM.visualizations.height - vars.margin2.top - vars.margin2.bottom;
					vars.height  = $.PALM.visualizations.height - vars.margin.top  - vars.margin.bottom;
					
					vars.widget  = d3.select("#widget-" + "${wUniqueName}");
					
					vars.margin2.top = $.PALM.visualizations.height - 70;
										  
					var processedData = $.TOPIC_EVOLUTION.processData ( $.PALM.visualizations.data );
					var filteredData  = $.TOPIC_EVOLUTION.filterData ( processedData );
	
					vars.data = $.PALM.visualizations.data;
					$.TOPIC_EVOLUTION.chart.draw( filteredData, "#tab_evolution" );	
				}
				
				<#-- show callout if error happened -->
				function alertCallOutWarning( titleCallOut, messageCallout ){
					tabContainer.hide();
					calloutWarning.show();
					
					calloutWarning.find( "h4" ).html( titleCallOut );
					calloutWarning.find( "p" ).html( messageCallout );
					
					return false;
				}
			}<#-- end of onrefresh done -->
		
		};<#-- end of options -->
		
		<#-- filter topics -->
		$("#widget-${wUniqueName}" + " .top input[name=top]").on("click", function(){
			$.TOPIC_EVOLUTION.chart.base.filterBy.top( $(this).val() );			
		});
		
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