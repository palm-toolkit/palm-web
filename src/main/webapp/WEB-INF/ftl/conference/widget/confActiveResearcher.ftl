<style>
#widget-${wUniqueName} .box-body svg {
  font-family: Abel,"Helvetica Neue",Helvetica,Arial,sans-serif;
  font-size: 15px;
}

#widget-${wUniqueName} .box-body .links path {
  fill: none;
}

#widget-${wUniqueName} .box-body .episode, #widget-${wUniqueName} .box-body .node, #widget-${wUniqueName} .box-body .detail text, #widget-${wUniqueName} .box-body .all-episodes {
  cursor: pointer;
}


#widget-${wUniqueName} .box-body .detail a text:hover, #widget-${wUniqueName} .box-body text .all-episodes:hover {
  text-decoration: underline;
}

#widget-${wUniqueName} .episode text {
	fill : #0073b7;
}

#widget-${wUniqueName} .episode.clicked text {
	font-weight : bold;
}

#widget-${wUniqueName} .light-gradient-stop-color-1{
	stop-color : #d4d4d4  ;	<#-- #000 -->
}
#widget-${wUniqueName} .light-gradient-stop-color-2{
	stop-color : #eee;	<#-- rgb(102, 102, 102) -->
}

#widget-${wUniqueName} .dark-gradient-stop-color-1{
	stop-color : #c0cfd8;	
}
#widget-${wUniqueName} .dark-gradient-stop-color-2{
	stop-color : #e6e6e6;	
}

#widget-${wUniqueName} .clicked-gradient-stop-color-1{
	stop-color : #d2c7b0;	
}
#widget-${wUniqueName} .clicked-gradient-stop-color-2{
	stop-color : #eee;	
}

#widget-${wUniqueName} .light-color{
	stroke : #999;
}
#widget-${wUniqueName} .dark-color{
	stroke : #0073b7;
}
#widget-${wUniqueName} .clicked-color{
	stroke :  #f39c12;
}
#widget-publications-${wUniqueName}	{
	position: relative;
    height: 100%;
}
#widget-publications-${wUniqueName}>div{
    height: 100%;
}

</style>
<div class="box-body no-padding container-fluid">
		<div class="container-box filter-box key-researchers-criteria row">
			<div class="filter col-md-4">
  				<span class="title font-small col-md-3"> Based On: </span>
  				<div class="dropdown col-md-9">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of publications <span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li><a href="#">Resercher's H-index</a></li>
      					<li><a href="#">Publications' Citations</a></li>
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