<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	
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
			source : "<@spring.url '/publication/topicComposition' />",
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

if( data.status != "ok" )
	alertCallOutWarning( "An error occurred", "Failed to show publication topic composition" );
	
if( typeof data.topicModel === "undefined" || data.topicModel.length == 0){
	alertCallOutWarning( "Publication contain no topicModel", "Topics mining only performed on complete publication with abstract" );
	return false;
}
<#-- show tab -->
tabContainer.show();

$.each( data.topicModel, function( index, item){
	<#-- tab header -->
	var tabHeaderText = item.profile.replace( / /g, "_"  );
	var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tab_" + tabHeaderText.replace( / /g, "_"  ), "data-toggle":"tab" , "aria-expanded" : "true"})
							.html( tabHeaderText )
						);
		
	<#-- tab content -->
	var tabContent = $( '<div/>' )
						.attr({ "id" : "tab_" + tabHeaderText.replace( / /g, "_"  ) })
						.addClass( "tab-pane" );

	if( index == 0 ){
		tabHeader.addClass( "active" );
		tabContent.addClass( "active" );
	}
		
	<#-- append tab header and content -->
	tabHeaderContainer.append( tabHeader );
	tabContentContainer.append( tabContent );
	
	<#-- add service logo -->
<#--
	if( tabHeaderText === "Alchemy")
		tabContent.append( 
				$('<div/>')
				.css({"position":"relative","bottom":"10px"})
				.append(
					$('<div/>')
					.css({"position":"relative","bottom":"10px"})
					.append(
						$('<img/>').attr({"src":"http://www.alchemyapi.com/sites/default/files/Logo60Height.png"})
					)
				)
			);
-->
	if( tabHeaderText === "Opencalais")
		tabContent.append( 
				$('<div/>')
				.css({"position":"relative","height":"0","width":"100%"})
				.append(
					$('<div/>')
					.css({"position":"absolute","top":"0","right":"0","z-index":"5000"})
					.append(
						$('<a/>')
						.attr({"href":"http://opencalais.com","target":"_blank"})
						.append(
							$('<img/>')
							.css({"width":"250px"})
							.attr({"src":"http://www.opencalais.com/wp-content/themes/Frank-master/images/calais-logo.png"})
						)
					)
				)
			);
	
	<#-- add visualization -->
	visualizeTermValue( item.termvalues, "#tab_" + tabHeaderText );
	document.getElementById("tab_" + tabHeaderText).style.height = "500px";
	
});

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
		nv.addGraph(function() {
  		var chart = nv.models.pieChart()
	      .x(function(d) { 
	      	return d.term
	      })
	      .y(function(d) { 
	      	return d.value
	      })
	      .showLabels(true)     //Display pie labels
	      .labelThreshold(.00)  //Configure the minimum slice size for labels to show up
	      .labelType("percent") //Configure what type of data to show in the label. Can be "key", "value" or "percent"
	      .donut(true)          //Turn on Donut mode. Makes pie chart look tasty!
	      .donutRatio(0.35)     //Configure how big you want the donut hole size to be.
	      .showLegend(true)
	      .tooltips(false)
	      //.tooltipContent()
	      ;
		    d3.select(svgContainer)
		        .append( "svg" )
		        .datum( termValueMap )
		        .transition().duration(100)
		        .call(chart);
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