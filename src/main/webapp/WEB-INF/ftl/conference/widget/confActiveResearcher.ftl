<style>
#widget-${wUniqueName} .box-body svg {
  font-family: Abel,"Helvetica Neue",Helvetica,Arial,sans-serif;
  font-size: 15px;
}

#widget-${wUniqueName} .box-body path {
  fill: none;
}

#widget-${wUniqueName} .box-body .episode, #widget-${wUniqueName} .box-body .node, #widget-${wUniqueName} .box-body .detail text, #widget-${wUniqueName} .box-body .all-episodes {
  cursor: pointer;
}


#widget-${wUniqueName} .box-body .detail a text:hover, #widget-${wUniqueName} .box-body text .all-episodes:hover {
  text-decoration: underline;
}

#widget-${wUniqueName} ..box-body .episode > rect{
	fill : #666;
}

#widget-${wUniqueName} .light-gradient-stop-color-1{
	stop-color : #d4d4d4;	
}
#widget-${wUniqueName} .light-gradient-stop-color-2{
	stop-color : #e6e6e6;	
}

#widget-${wUniqueName} .dark-gradient-stop-color-1{
	stop-color : #f39c12;	
}
#widget-${wUniqueName} .dark-gradient-stop-color-2{
	stop-color : #e6e6e6;	
}
</style>
<div class="box-body no-padding">
	<div class="filter-criteria key-researchers-criteria">
		<div class="container">
  			<span class="title font-small"> Based On: </span>
  			<div class="dropdown">
    			<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of publications <span class="caret"></span> </button>
    			<ul class="dropdown-menu">
      				<li><a href="#">Resercher's H-index</a></li>
      				<li><a href="#">Publications' Citations</a></li>
    			</ul>
  			</div>
		</div>
	</div>
</div>
<#include "/resPublication.ftl">
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

	$.activeResearchers.init("${wUniqueName}", "Educational Data Mining 2013","http://data.linkededucation.org/resource/lak/conference/edm2013", "<@spring.url '' />", getCurrentUser() );
	$.activeResearchers.data("<@spring.url '/resources/json/activeScholar.json' />");
	
	var options ={
	<#--		source : "<@spring.url '/researcher/publicationList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				v
				});

				<#-- append everything to  -->
			<#--	mainContainer.append( timeLineContainer );
		} -->
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

function getCurrentUser(){
			<#if currentUser??>
				return true;
			<#else>
				return false;
			</#if>	
}
	
</script>