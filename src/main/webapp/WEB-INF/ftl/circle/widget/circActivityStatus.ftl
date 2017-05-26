<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
	<#if currentUser.author??>
		<#assign author = currentUser.author.id >
	</#if>
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-padding container-fluid">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter col-md-5 col-sm-10">
  				<span class="title font-small col-md-3  col-sm-4"> Published : </span>
  				<div id="slider" class="col-md-7 col-sm-8">
    				
    					<div class="body col-md-12 col-sm-12"></div>
    					<div class="min"></div>
    					<div class="max"></div>
    			
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4  col-sm-4">
				<span class="title-visualization-details"></span>
				<#include "/resPublication.ftl">
			</div>
		</div>
</div>
<div class="box-footer"></div>

<script>
	$( function(){
		
		<#-- add slim scroll -->  
	      $("#boxbody${wUniqueName}>.content-list").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
	    
		var url = "<@spring.url '' />";
		var id  = "${wUniqueName}";
		var currentUser = <#if author??>"${author}"<#else>{}</#if> ;
					
	<#--	$.activityStatus.getData( url, id, currentUser , $.activityStatus.init);-->
	<#--	$.activityStatus.readDataFromJSON( url, id );-->
		<#-- unique options in each widget -->
		
		var options ={
			source : "<@spring.url '/circle/researcherList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
				
			},
			onRefreshDone: function(  widgetElem , response ){
				var mainContainer = $("#widget-${wUniqueName} .visualization-main");
				mainContainer.html( "" );
				
				console.log(response);
				if( typeof response === 'undefined' || response.status != "ok" || typeof response.researchers === 'undefined'){
					$.PALM.callout.generate( mainContainer , "warning", "Empty Members !", "The circle does not have any member on PALM database" );
					return false;
				}
				
				
				var visData = response.researchers.filter( function (d, i){
					
					if (d.citedBy != undefined && d.citedBy > 0 && d.publicationsNumber != undefined && d.publicationsNumber > 0 	)
						return d;
				});
				
				$.activityStatus.init ( url, id, currentUser, visData );
			}
			};
		
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