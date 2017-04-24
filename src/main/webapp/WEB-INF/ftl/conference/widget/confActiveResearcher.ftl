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
			<div class="visualization-details hidden col-md-4">
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
	
	var options ={
			source : "<@spring.url '/venue/topResearchers' />",
			onRefreshStart: function( widgetElem ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading key researchers list", {uniqueId: uniquePidKeyResearchers, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem , data ){
				<#-- remove previous list -->
				var targetContainer = $( widgetElem ).find( ".visualization-main" );
				targetContainer.html( "" );
						
				if( data.status != "ok" ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Key Researchers!", "The conference does not have any researchers assigned on PALM (insufficient data)" );
					return false;
				}
							
				if( data.participants.length > 0 ){
					$.activeResearchers.init("${wUniqueName}", data , "<@spring.url '' />", getCurrentUser() );					
				}else
					$.PALM.popUpMessage.remove( uniquePidKeyResearchers );
			}

				<#-- append everything to  -->
			<#--	mainContainer.append( timeLineContainer );
		} -->
	};

	<#-- order coauthors by-->
	$("#widget-${wUniqueName}" + " .basedOn .dropdown-menu li").on("click", function(){
		if ( !$(this).hasClass("selected") ){
			var $groupBySelected = $("#widget-${wUniqueName}" + " .groupedBy .dropdown-menu li.selected");
			
			$(this).parent().children("li").removeClass("selected disabled");
			$(this).addClass("selected disabled");
			$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
			$.activeResearchers.visualize.basedOn( $(this).data("value") );
		}
	});
	
	<#-- list close button was clicked -->	 
	$("#widget-${wUniqueName}" + " .btn.btn-box-tool").on("click", function(){
		$.activeResearchers.visualize.interactions.closeList( );
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

function getCurrentUser(){
			<#if currentUser??>
				return true;
			<#else>
				return false;
			</#if>	
}
	
</script>

<script src="<@spring.url '/resources/scripts/visualizations/tooltip.js' />" type="text/javascript"></script>
