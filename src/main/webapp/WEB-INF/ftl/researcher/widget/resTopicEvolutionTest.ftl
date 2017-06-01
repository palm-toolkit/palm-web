<style>
 
svg {
  font: 10px sans-serif;
}
 
.axis path,
.axis line {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.y.axis path {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.brush .extent {
  stroke: #fff;
  fill-opacity: .125;
  shape-rendering: crispEdges;
}

.line {
  fill: none;
  stroke-width : 1.5px;
}
.zoom {
  cursor: move;
  fill: transparent;
  pointer-events: all;
}
</style>
<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	
	<div class="callout callout-warning" style="display:none">
	    <h4></h4>
	    <p></p>
	</div>
                  
	<div class="nav-tabs-custom" style="display:none">
        <ul class="nav nav-tabs">
        </ul>
        
        <div id="legendContainer" class="legendContainer">
			<svg id="legend"></svg>
		</div>
		<div id="showAll">
			<input name="showAllButton" type="button" value="Show All" onclick="$.TOPIC_EVOLUTION.draw.legend.showAll()" />
		</div>
		<div id="clearAll">
			<input name="clearAllButton" type="button" value="Hide All" onclick="$.TOPIC_EVOLUTION.draw.legend.hideAll()" />
		</div>
        <div class="tab-content" id="tab_evolution">
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

<#-- add visualization -->
visualizeTermValue( data, "#tab_evolution", "${wUniqueName}");
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