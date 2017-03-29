<div id="boxbody-${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter basedOn col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Based on : </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Publications' Citations<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
    					<li class="selected" data-value="cited"><a href="#">Publications' Citations</a></li>
      					<li><a href="#" data-value="venue">Publication's Venue Rank</a></li>  					
    				</ul>
  				</div>
			</div>
			<div class="filter orderedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Ordered by: </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">CoAuthor H-index<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li class="selected" data-value="hindex"><a href="#">CoAuthor H-index</a></li>
      					<li data-value="collaborations"><a href="#" >Number of collaborations</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter top col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Top : </span>
  				 <div class="btn-group" data-toggle="">
                	<label class="radio-inline">
                    	<input type="radio" id="top5" name="top" value="5" /> 5
                	</label> 
                	<label class="radio-inline active">
                    	<input type="radio" id="top10" name="top" checked="checked" value="10" /> 10
               	 	</label> 
                	<label class="radio-inline">
                    	<input type="radio" id="q158" name="top" value="15" /> 15
                	</label> 
            </div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4"></div>
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
							
				if( data.count > 0 ){
					<#-- remove any remaing tooltip -->
						$( "body .tooltip" ).remove(); 

					<#-- build the researcher graph -->

						createCoauthorsGraph("#boxbody-${wUniqueName} .visualization-main ", data, chartHeight);
						
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