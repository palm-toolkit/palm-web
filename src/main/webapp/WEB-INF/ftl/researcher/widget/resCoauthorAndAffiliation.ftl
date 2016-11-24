<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
</div>
<script>
$(function(){
	<#-- add slim scroll -->
	$("#boxbody-${wUniqueName}>.coauthor-list").slimscroll({
		height: "300px",
		size: "6px",
		allowPageScroll: true,
   		touchScrollStep: 50//,
   		//railVisible: true,
    	//alwaysVisible: true
	});
	<#-- generate unique id for progress log -->
		var uniquePidCoauthors = $.PALM.utility.generateUniqueId();	
	<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/coAuthorList' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading coauthor list", {uniqueId: uniquePidCoauthors, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( ".coauthor-list" );
				<#-- remove previous list -->
				targetContainer.html( "" );
							
				if( data.count == 0 ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Co-Authors!", "Researcher does not have any co-authors on PALM (insufficient data)" );
					return false;
				}
							
				if( data.count > 0 ){
					<#-- remove any remaing tooltip -->
						$( "body .tooltip" ).remove(); 

					<#-- build the researcher graph -->
						createCoauthorsGraph("#boxbody-${wUniqueName} .coauthor-list", data);
						
				}
				else{
				<#-- no coauthor -->
					<#--
						$pageDropdown.append("<option value='0'>0</option>");
						$( widgetElem ).find( "span.total-page" ).html( 0 );
						$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
						$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
						$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
					-->			
				}
				$.PALM.popUpMessage.remove( uniquePidCoauthors );
			}
		};
	
	<#-- register the widget-->
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