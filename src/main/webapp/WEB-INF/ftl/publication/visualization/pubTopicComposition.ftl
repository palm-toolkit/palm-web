<div id="boxbody${wId}" class="box-body" style="overflow:hidden">
	
	<div class="callout callout-warning" style="display:none">
	    <h4></h4>
	    <p></p>
	</div>
                  
	<div class="nav-tabs-custom" style="display:none">
        <ul class="nav nav-tabs">
        </ul>
        <div class="tab-content">
        </div>
     </div>


</div>

<script>
	$( function(){
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/publication/topic' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){

var calloutWarning = $( widgetElem ).find( "#boxbody${wId}" ).find( ".callout-warning" );
var tabContainer = $( widgetElem ).find( "#boxbody${wId}" ).find( ".nav-tabs-custom" );
var tabHeaderContainer = tabContainer.find( ".nav" ).first();
var tabContentContainer = tabContainer.find( ".tab-content" ).first();

<#-- clean target container -->
calloutWarning.hide();
tabContainer.hide();
tabHeaderContainer.html( "" );
tabContentContainer.html( "" );

if( data.status != "ok" )
	alertCallOutWarning( "An error occurred", "Failed to show publication topic composition" );
	
if( typeof data.topics === "undefined" || data.topics.length == 0)
	alertCallOutWarning( "Publication contain no topics", "Topics mining only performed on complete publication with abstract" );

<#-- show tab -->
tabContainer.show();

$.each( data.topics, function( index, item){
	<#-- tab header -->
	var tabHeaderText = capitalizeFirstLetter( item.extractor );
	var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tab_" + tabHeaderText, "data-toggle":"tab" , "aria-expanded" : "true"})
							.html( tabHeaderText )
						);
		
	<#-- tab content -->
	var tabContent = $( '<div/>' )
						.attr({ "id" : "tab_" + tabHeaderText })
						.addClass( "tab-pane" );

	if( index == 0 ){
		tabHeader.addClass( "active" );
		tabContent.addClass( "active" );
	}
		
	<#-- append tab header and content -->
	tabHeaderContainer.append( tabHeader );
	tabContentContainer.append( tabContent );
	
	visualizeTermValue( item.termvalues, "#tab_" + tabHeaderText );
});

function capitalizeFirstLetter(string) {
	if( string.lastIndexOf("YAHOO", 0) === 0 )
		return "Yahoo";
    return string.charAt(0).toUpperCase() + string.toLowerCase().slice(1);
}

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
	var w = tabContainer.width();
	var h = 1/2 * w;
	var r = 1/3 * h;
	var ir = 1/3 * r;
	var textOffset = 14;
	var tweenDuration = 250;
	
	<#-- set max height -->
	var widgetHeight = w * 2 / 3;
	if( widgetHeight < 300)
		widgetHeight = 300;
	$("#boxbody${wId}").css( "max-height" , widgetHeight + "px" );
	
	<#-- OBJECTS TO BE POPULATED WITH DATA LATER -->
	var lines, valueLabels, nameLabels;
	var pieData = [];    
	var oldPieData = [];
	var filteredPieData = [];
	
	<#-- D3 helper function to populate pie slice parameters from array data -->
	var donut = d3.layout.pie().value(function(d){
	  return d.value;
	});
	
	<#-- D3 helper function to create colors from an ordinal scale -->
	var color = d3.scale.category20();
	
	<#-- D3 helper function to draw arcs, populates parameter "d" in path object -->
	var arc = d3.svg.arc()
	  .startAngle(function(d){ return d.startAngle; })
	  .endAngle(function(d){ return d.endAngle; })
	  .innerRadius(ir)
	  .outerRadius(r);
	  
	<#-- // CREATE VIS & GROUPS // -->
	var vis = d3.select( svgContainer )
	  .append("div")
      .classed("svg-container", true) //container class to make it responsive
	  .append("svg:svg")
	  //.attr("width", w)
	  //.attr("height", h)
	  //responsive SVG needs these 2 attributes and no width and height attr
   	  .attr("preserveAspectRatio", "xMinYMin meet")
      .attr("viewBox", "0 0 " + w + " " + h)
      //class to make it responsive
      .classed("svg-content-responsive", true)
	  .classed( "d3-pie-chart", true);
	
	<#-- GROUP FOR ARCS/PATHS -->
	var arc_group = vis.append("svg:g")
	  .attr("class", "arc")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");
	
	<#-- GROUP FOR LABELS -->
	var label_group = vis.append("svg:g")
	  .attr("class", "label_group")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");
	
	<#-- GROUP FOR CENTER TEXT -->  
	var center_group = vis.append("svg:g")
	  .attr("class", "center_group")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");
	
	<#-- PLACEHOLDER GRAY CIRCLE -->
	var paths = arc_group.append("svg:circle")
	    .attr("fill", "#EFEFEF")
	    .attr("r", r);
	    
	<#-- // CENTER TEXT // -->

	<#-- WHITE CIRCLE BEHIND LABELS -->
	var whiteCircle = center_group.append("svg:circle")
	  .attr("fill", "white")
	  .attr("r", ir);
	
	<#-- "TOTAL" LABEL -->
	var totalLabel = center_group.append("svg:text")
	  .attr("class", "label")
	  .attr("dy", -5)
	  .attr("text-anchor", "middle") // text-align: right
	  .text("TOTAL");
	
	<#-- TOTAL TRAFFIC VALUE -->
	var totalValue = center_group.append("svg:text")
	  .attr("class", "total")
	  .attr("dy", 7)
	  .attr("text-anchor", "middle") // text-align: right
	  .text("Waiting...");
	  
	<#-- run the visualization -->
	update();
	update();
	  
	<#-- to run each time data is generated -->
	function update() {
	
	  streakerDataAdded = termValueMap;
	
	  oldPieData = filteredPieData;
	  pieData = donut(streakerDataAdded);
	
	  var totalOctets = 0;
	  filteredPieData = pieData.filter(filterData);
	  function filterData(element, index, array) {
	    element.name = streakerDataAdded[index].term;
	    element.value = streakerDataAdded[index].value;
	    totalOctets += element.value;
	    return (element.value > 0);
	  }
	
	  if(filteredPieData.length > 0 && oldPieData.length > 0){
	
	    <#-- REMOVE PLACEHOLDER CIRCLE -->
	    arc_group.selectAll("circle").remove();
	
	    totalValue.text(function(){
	      var kb = totalOctets;
	      return kb.toFixed(2);
	      //return bchart.label.abbreviated(totalOctets*8);
	    });
	
	    <#-- DRAW ARC PATHS -->
	    paths = arc_group.selectAll("path").data(filteredPieData);
	    paths.enter().append("svg:path")
	      .attr("stroke", "white")
	      .attr("stroke-width", 0.5)
	      .attr("fill", function(d, i) { return color(i); })
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", pieTween);
	    paths
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", pieTween);
	    paths.exit()
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", removePieTween)
	      .remove();
	
	    <#-- DRAW TICK MARK LINES FOR LABELS -->
	    lines = label_group.selectAll("line").data(filteredPieData);
	    lines.enter().append("svg:line")
	      .attr("x1", 0)
	      .attr("x2", 0)
	      .attr("y1", -r-3)
	      .attr("y2", -r-8)
	      .attr("stroke", "gray")
	      .attr("transform", function(d) {
	        return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
	      });
	    lines.transition()
	      .duration(tweenDuration)
	      .attr("transform", function(d) {
	        return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
	      });
	    lines.exit().remove();
	
	    <#-- DRAW LABELS WITH VALUES -->
	    valueLabels = label_group.selectAll("text.value").data(filteredPieData)
	      .attr("dy", function(d){
	        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
	          return 5;
	        } else {
	          return -7;
	        }
	      })
	      .attr("text-anchor", function(d){
	        if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
	          return "beginning";
	        } else {
	          return "end";
	        }
	      })
	      .text(function(d){
	        var percentage = d.value;
	        return percentage.toFixed(2);
	      });
	
	    valueLabels.enter().append("svg:text")
	      .attr("class", "value")
	      .attr("transform", function(d) {
	        return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
	      })
	      .attr("dy", function(d){
	        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
	          return 5;
	        } else {
	          return -7;
	        }
	      })
	      .attr("text-anchor", function(d){
	        if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
	          return "beginning";
	        } else {
	          return "end";
	        }
	      }).text(function(d){
	        var percentage = d.value;
	        return percentage.toFixed(2);
	      });
	
	    valueLabels.transition().duration(tweenDuration).attrTween("transform", textTween);
	
	    valueLabels.exit().remove();
	
	
	    <#-- DRAW LABELS WITH ENTITY NAMES -->
	    nameLabels = label_group.selectAll("text.units").data(filteredPieData)
	      .attr("dy", function(d){
	        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
	          return 17;
	        } else {
	          return 5;
	        }
	      })
	      .attr("text-anchor", function(d){
	        if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
	          return "beginning";
	        } else {
	          return "end";
	        }
	      }).text(function(d){
	        return d.name;
	      });
	
	    nameLabels.enter().append("svg:text")
	      .attr("class", "units")
	      .attr("transform", function(d) {
	        return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
	      })
	      .attr("dy", function(d){
	        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
	          return 17;
	        } else {
	          return 5;
	        }
	      })
	      .attr("text-anchor", function(d){
	        if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
	          return "beginning";
	        } else {
	          return "end";
	        }
	      }).text(function(d){
	        return d.name;
	      });
	
	    nameLabels.transition().duration(tweenDuration).attrTween("transform", textTween);
	
	    nameLabels.exit().remove();
	  }  
	}
	  
  	<#-- // FUNCTIONS // -->
	<#-- Interpolate the arcs in data space -->
	function pieTween(d, i) {
	  var s0;
	  var e0;
	  if(oldPieData[i]){
	    s0 = oldPieData[i].startAngle;
	    e0 = oldPieData[i].endAngle;
	  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
	    s0 = oldPieData[i-1].endAngle;
	    e0 = oldPieData[i-1].endAngle;
	  } else if(!(oldPieData[i-1]) && oldPieData.length > 0){
	    s0 = oldPieData[oldPieData.length-1].endAngle;
	    e0 = oldPieData[oldPieData.length-1].endAngle;
	  } else {
	    s0 = 0;
	    e0 = 0;
	  }
	  var i = d3.interpolate({startAngle: s0, endAngle: e0}, {startAngle: d.startAngle, endAngle: d.endAngle});
	  return function(t) {
	    var b = i(t);
	    return arc(b);
	  };
	}
	
	function removePieTween(d, i) {
	  s0 = 2 * Math.PI;
	  e0 = 2 * Math.PI;
	  var i = d3.interpolate({startAngle: d.startAngle, endAngle: d.endAngle}, {startAngle: s0, endAngle: e0});
	  return function(t) {
	    var b = i(t);
	    return arc(b);
	  };
	}
	
	function textTween(d, i) {
	  var a;
	  if(oldPieData[i]){
	    a = (oldPieData[i].startAngle + oldPieData[i].endAngle - Math.PI)/2;
	  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
	    a = (oldPieData[i-1].startAngle + oldPieData[i-1].endAngle - Math.PI)/2;
	  } else if(!(oldPieData[i-1]) && oldPieData.length > 0) {
	    a = (oldPieData[oldPieData.length-1].startAngle + oldPieData[oldPieData.length-1].endAngle - Math.PI)/2;
	  } else {
	    a = 0;
	  }
	  var b = (d.startAngle + d.endAngle - Math.PI)/2;
	
	  var fn = d3.interpolateNumber(a, b);
	  return function(t) {
	    var val = fn(t);
	    return "translate(" + Math.cos(val) * (r+textOffset) + "," + Math.sin(val) * (r+textOffset) + ")";
	  };
	}
	
}

	
		



			}<#-- end of onrefresh done -->
		};<#-- end of options -->
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	});<#-- end document ready -->
</script>