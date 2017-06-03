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
					<div class="buttons">
						<div id="showAll">
							<input name="showAllButton" class="btn btn-xs btn-info" type="button" value="Show All" onclick="$.TOPIC_EVOLUTION.chart.legend.showAll()" />
						</div>
						<div id="clearAll">
							<input name="clearAllButton" class="btn btn-xs btn-default" type="button" value="Hide All" onclick="$.TOPIC_EVOLUTION.chart.legend.hideAll()" />
						</div>
					</div>
				</div>
				
				<div id="tooltipContainer" class="tooltipContainer">
					<div class="tooltip  hidden">
					 	<table></table>
					 </div>
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

var calloutWarning = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".callout-warning" );
var tabContainer = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".nav-tabs-custom" );
var tabHeaderContainer = tabContainer.find( ".nav" ).first();
var tabContentContainer = tabContainer.find( ".tab-content" ).first();

<#-- clean target container -->
calloutWarning.hide();
tabContainer.hide();
tabHeaderContainer.html( "" );
tabContentContainer.html( "" );

//if( data.status != "ok" )
//	alertCallOutWarning( "An error occurred", "Failed to show publication topic composition" );
	
if( typeof data.termvalues === "undefined" || data.termvalues.length == 0){
	alertCallOutWarning( "Publication contain no topicModel", "Topics mining only performed on complete publication with abstract" );
	return false;
}
<#-- show tab -->
tabContainer.show();

var jsonOutput = [];

for (var i = 0; i < data.termvalues.length; i++)
{
	var valuesTopic = data.termvalues[i].values;
	var keyTopic = data.termvalues[i].key;
	var colorTopic = data.termvalues[i].color;
	
	var valuesT = [];
	var k;
	for (k in valuesTopic) {
		valuesT.push({x: parseInt(k), y: parseFloat(valuesTopic[k])});
	}
	
	jsonOutput.push({
			values: valuesT, 
			key: keyTopic, 
			color: colorTopic});
}
<#-- add visualization -->
visualizeTermValue( data, "#tab_evolution", "${wUniqueName}");
<#--visualizeTermValue1( jsonOutput, "#tab_evolution");-->
document.getElementById("tab_evolution").style.height = "500px";
	

<#-- show callout if error happened -->
function alertCallOutWarning( titleCallOut, messageCallout ){
	tabContainer.hide();
	calloutWarning.show();
	
	calloutWarning.find( "h4" ).html( titleCallOut );
	calloutWarning.find( "p" ).html( messageCallout );
	
	return false;
}


function visualizeTermValue1( termValueMap, svgContainer )
{
	console.log(termValueMap);
    nv.addGraph(function() {
        chart = nv.models.lineChart()
            .options({
                duration: 300,
                useInteractiveGuideline: true
            })
        ;
        // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the parent chart, so need to chain separately
        chart.xAxis
            .axisLabel("Years")
            .staggerLabels(true)
        ;
        chart.yAxis
            .axisLabel('Topic Distribution')
            .tickFormat(function(d) {
                if (d == null) {
                    return 'N/A';
                }
                return d3.format(',.2f')(d);
            })
        ;
        d3.select('#tab_evolution').append('svg')
            .datum(termValueMap)
            .call(chart);
        nv.utils.windowResize(chart.update);
        return chart;
    });
	
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