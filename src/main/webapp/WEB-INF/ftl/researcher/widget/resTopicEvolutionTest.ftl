<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	
	<div class="callout callout-warning" style="display:none">
	    <h4></h4>
	    <p></p>
	</div>
                  
	<div class="nav-tabs-custom" style="display:none">
        <ul class="nav nav-tabs">
        </ul>
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
visualizeTermValue( jsonOutput, "#tab_evolution" );
document.getElementById("tab_evolution").style.height = "500px";
	

<#-- show callout if error happened -->
function alertCallOutWarning( titleCallOut, messageCallout ){
	tabContainer.hide();
	calloutWarning.show();
	
	calloutWarning.find( "h4" ).html( titleCallOut );
	calloutWarning.find( "p" ).html( messageCallout );
	
	return false;
}

function visualizeTermValue( termValueMap, svgContainer )
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