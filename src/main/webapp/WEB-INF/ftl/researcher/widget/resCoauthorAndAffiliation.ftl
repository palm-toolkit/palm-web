<div id="boxbody-${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter groupedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-5  col-sm-5"> Group by : </span>
  				<div class="dropdown col-md-6 col-sm-6">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Affiliation<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
    					<li class="selected disabled" data-value="affiliation"><a href="#">Affiliation</a></li>
    					<li data-value="noGroup"><a href="#">None</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter orderedBy col-lg-5 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Order by: </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of collaborations<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li data-value="hindex"><a href="#">Co-author H-index</a></li>
      					<li class="selected disabled" data-value="coauthorTimes"><a href="#" >Number of collaborations</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter showInterests col-lg-3 col-md-5 col-sm-8">
  				<span class="title font-small col-md-9  col-sm-9">Show Topics :</span>
  				 <div class="btn-group" data-toggle="">               	
                    <input type="checkbox" id="showInterests" name="showInterests" checked="checked" /> 
            </div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4"> <#include "/resPublication.ftl"> </div>
		</div>
	</div>
</div>

<script>
$(function(){
	var chartHeight = 600;
	<#-- add slim scroll -->
	<#--$("#boxbody-${wUniqueName} .visualization-main").slimscroll({
		height: "600px",
		size: "6px", 
		allowPageScroll: true,
   		touchScrollStep: 50//,
   		//railVisible: true,
    	//alwaysVisible: true
	});-->
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
			
				$.PALM.visualizations.record ( {
					data 	: data, 
					widgetUniqueName : "${wUniqueName}", 
					width	: 960,
					height	: 600,
					url		: "<@spring.url '' />"
				});	
							
				if( data.count > 0 ){
				<#-- remove any remaing tooltip -->
					$( "body .tooltip" ).remove(); 

				<#-- build the researcher graph -->						
					coauthors_graph();	
				}
				
				$.PALM.popUpMessage.remove( uniquePidCoauthors );
				
				function coauthors_graph(){
					var vars  = $.COAUTHOR.variables;
					var mainContainer = $( "#widget-${wUniqueName} .visualization-main");
					
					vars.width  = mainContainer.width();
					vars.height = $.PALM.visualizations.height;				
					vars.widget = d3.select( "#widget-${wUniqueName}" );		
					vars.containerID = "#boxbody-${wUniqueName} .visualization-main ";
					
					mainContainer.html("");
					
					$.COAUTHOR.graph.create();				
				}
			}
		};
	
	<#-- order coauthors by-->
		$("#widget-${wUniqueName}" + " .orderedBy .dropdown-menu li").on("click", function(){
			if ( !$(this).hasClass("selected") ){
				var $groupBySelected = $("#widget-${wUniqueName}" + " .groupedBy .dropdown-menu li.selected");
				
				$(this).parent().children("li").removeClass("selected disabled");
				$(this).addClass("selected disabled");
				$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
				$.COAUTHOR.graph.orderBy( $(this).data("value"), $groupBySelected.data("value") );
			}
		});
	
	<#-- group coauthors by-->
		$("#widget-${wUniqueName}" + " .groupedBy .dropdown-menu li").on("click", function(){
			if ( !$(this).hasClass("selected") ){
				var $orderBySelected = $("#widget-${wUniqueName}" + " .orderedBy .dropdown-menu li.selected");
				
				$(this).parent().children("li").removeClass("selected disabled");
				$(this).addClass("selected disabled");
				$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
				$.COAUTHOR.graph.orderBy( $orderBySelected.data("value"), $(this).data("value") );
			}
		});	
	<#-- show topics -->
		$("#widget-${wUniqueName}" + " .showInterests #showInterests").on("change", function(){		
			$.COAUTHOR.graph.showInterests(this.checked );
			
		});
		
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