<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-padding container-fluid">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter col-md-4 col-sm-8">
  				<span class="title font-small col-md-3  col-sm-3"> Published : </span>
  				<div id="slider" class="col-md-9 col-sm-9">
    				
    					<div class="body col-md-8 col-sm-8"></div>
    					<div class="min"></div>
    					<div class="max"></div>
    			
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4  col-sm-4">
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
		var currentUser = <#if currentUser??>"${currentUser.author.id}"<#else>{}</#if> ;
		$.activityStatus.getData( url, id, currentUser , $.activityStatus.init);
	<#--	$.activityStatus.readDataFromJSON( url, id );-->
		<#-- unique options in each widget -->
		var options ={};
		
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