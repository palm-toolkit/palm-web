<div id="boxbody${wId}" class="box-body">
	
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
						.addClass( "tab-pane" )
						.html( JSON.stringify( item.termvalues ) );

	if( index == 0 ){
		tabHeader.addClass( "active" );
		tabContent.addClass( "active" );
	}
		
	<#-- append tab header and content -->
	tabHeaderContainer.append( tabHeader );
	tabContentContainer.append( tabContent );
});

function visualizeTermValue(){
}

function capitalizeFirstLetter(string) {
	if( string.lastIndexOf("YAHOO", 0) === 0 )
		return "Yahoo";
    return string.charAt(0).toUpperCase() + string.slice(1);
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