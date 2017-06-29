<div class="box-body no-padding container-fluid">
		<div class="container-box filter-box key-researchers-criteria row">
			<div class="filter basedOn col-md-6">
  				<span class="title font-small col-md-3"> Based On: </span>
  				<div class="dropdown col-md-6">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of publications <span class="caret"></span> </button>
    				<ul class="dropdown-menu">
    					<li data-value="nrPublications" class="selected" ><a href="#" >Number of publications</a></li>
      					<li data-value="hindex" ><a href="#" >Resercher's H-index</a></li>
      					<li data-value="nrCitations"><a href="#">Publications' Citations</a></li>
    				</ul>
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-12"></div>
			<div class="visualization-details hidden col-md-5 col-sm-5">
				<#include "/resPublication.ftl">
			</div>
		</div>
</div>
<div class="box-footer"></div>

<script>

$( function(){
	<#-- add slimscroll to widget body -->
	$("#widget-${wUniqueName} .box-content").slimscroll({
		height: "660px",
	    size: "6px",
		allowPageScroll: true,
   		touchScrollStep: 50,
   		railVisible: true,
    	alwaysVisible: true
	});

	<#-- generate unique id for progress log -->
	var uniquePidKeyResearchers = $.PALM.utility.generateUniqueId();
	<#-- show pop up progress log -->		
	$.PALM.popUpMessage.create( "loading key researchers list", {uniqueId: uniquePidKeyResearchers, popUpHeight:40, directlyRemove:true , polling:false});
	
	var options ={
			source : "<@spring.url '/venue/topResearchers' />",
			onRefreshStart: function( widgetElem ){
				
			},
			onRefreshDone: function(  widgetElem , data ){
				<#-- remove previous list -->
				var targetContainer = $( widgetElem ).find( ".visualization-main" );
				targetContainer.html( "" );
						
				if( data.status != "ok" ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Key Researchers!", "The conference does not have any researchers assigned on PALM (insufficient data)" );
					return false;
				}
				
				$.PALM.visualizations.record ( {
					data 	: data, 
					widgetUniqueName : "${wUniqueName}", 
					width	: 960,
					height	: 660,
					url		: "<@spring.url '' />",
					user	: <#if currentUser??> true <#else> false </#if>
				});
							
				if( data.participants.length > 0 )
					active_key_researchers( );					
	
				$.PALM.popUpMessage.remove( uniquePidKeyResearchers );				
					
				function active_key_researchers(widgetUniqueName, eventData, currentURL, isUserLogged){
					var vars = $.activeResearchers.variables;
					vars.containerId = "#widget-" + "${wUniqueName}";	
					vars.width  	 = $(vars.containerId + " .visualization-main" ).width();
					vars.height		 = $.PALM.visualizations.height;
					vars.radius 	 = Math.min( vars.width / 2 ,vars.height  );
					vars.L			 = {};	
					vars.widget  	 = d3.select(vars.containerId);
					
					$(vars.containerId + " .visualization-main" ).height( $.PALM.visualizations.height );
					$(vars.containerId + " .visualization-details" ).addClass( "hidden" );	
					
					$.PALM.visualizations.data = $.activeResearchers.data( );
					
					$.activeResearchers.visualise.chart( );		
				}
			}
		};
				<#-- append everything to  -->
			<#--	mainContainer.append( timeLineContainer );
		} -->
	

	<#-- order coauthors by-->
	$("#widget-${wUniqueName}" + " .basedOn .dropdown-menu li").on("click", function(){
		if ( !$(this).hasClass("selected") ){
			var $groupBySelected = $("#widget-${wUniqueName}" + " .groupedBy .dropdown-menu li.selected");
			
			$(this).parent().children("li").removeClass("selected disabled");
			$(this).addClass("selected disabled");
			$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
			$.activeResearchers.visualise.basedOn( $(this).data("value") );
		}
	});
	
	<#-- list close button was clicked -->	 
	$("#widget-${wUniqueName}" + " .btn.btn-box-tool").on("click", function(){
		$.activeResearchers.visualise.interactions.closeList( );
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
});


	
</script>

<script src="<@spring.url '/resources/scripts/visualizations/tooltip.js' />" type="text/javascript"></script>
