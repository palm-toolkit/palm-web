<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding wvisualize">
  	<div class="visualize_widget" class="nav-tabs-custom"  oncontextmenu="return false;"></div>
	<div id="divtoshow" class="fix-pos display-none">test</div>
	<div id="divhold" class="fix-pos display-none">test</div>
	<div id="chartTab"></div>
	<div class="menu" id="menu">
		<ul>
			<li id="menu_header" value="placeholder"></li>
			<a id="append" href="#"><li>Add to Criteria</li></a>
			<a id="replace" href="#"><li>Replace Criteria By</li></a>
			<a id="openURL" href="#"><li>Go to URL</li></a>
		</ul>
	</div>
</div>
<script>
		
<#-- jquery -->
$( function()
{
	$("#introduction").slimscroll(
	{
		height: "70vh",
        size: "5px",
    	allowPageScroll: true,
		touchScrollStep: 50,
	});

	var visHeaderMenu = document.getElementById("widget-explore_visualize").getElementsByClassName("box-tools pull-right")[0];
	var fullscr= $('<button/>')
					.addClass('btn btn-box-tool toggle-expand-btn')
						.append(
							$('<i/>')
							.addClass('fa fa-expand')
						)
	fullscr.appendTo(visHeaderMenu)
	
	$(".toggle-expand-btn").click(function(e) 
	{
		$(this).closest('.box').toggleClass('panel-fullscreen');
		hidehoverdiv('divtoshow');
		hidehoverdiv('divhold');
		hidemenudiv('menu');
	});
		
	var visType = "";
	var defaultVisType = "";
	var objectType = "";
	var visList = [];
	var currentTab = 0;
	var pops_researchers = [];
	var pops_conferences = [];
	var pops_publications = [];
	var pops_topics = [];
	var pops_list = [];
	var visPopUpIds = [];
	var cameraX = 0;
	var cameraY = 0;
	var cameraRatio = 1;
	var visItem = "";
	currentTabName = "";
	var loadedList = [];
	var dataLoadedFlag = "0";
	var loadedLoc = [];
	var graphFile;
	var fullscreen = 0;
	var seedVal = 10;
    var noOfClustersVal = 2;
    var foldsVal = 2;
    var iterationsVal = 5;
		
	var options = {
		source : "<@spring.url '/explore/visualize' />",
		query: "",
		queryString : "",
		page:0,
		maxresult:50,
		onRefreshStart: function(  widgetElem  ){
		},
		onRefreshDone: function(  widgetElem , data )
		{
			var targetContainer = $( widgetElem ).find( ".visualize_widget" );

			loadedList = [];
			graphFile = "";

			names = data.dataList;
			ids = data.idsList;
			yearFilterPresent = data.yearFilterPresent;
			deleteFlag = data.deleteFlag;

			targetContainer.html("");			
			hidehoverdiv('divtoshow');
	  		hidehoverdiv('divhold');
			hidemenudiv('menu')
			
			<#-- update type of visualization depending on selection-->
			if(objectType == "")
			{
				objectType = data.type;
				visType = data.visType;
			}
			if(data.type!==objectType)
			{
				objectType = data.type;
				visType = data.visType;
			}
			if(data.type==objectType && visType!=data.visType && data.visType!="")
				visType = data.visType;
			
			<#-- if more than one item is in consideration -->	
			if(ids.length>1)
			{
				if(visType=="researchers")
				{
					visList = ["Network", "List", "Group", "Comparison"];
					if(objectType=="researcher")
						visList = ["Network", "List", "Group", "Similar", "Comparison"];
				}
				if(visType=="conferences"){
					visList = ["Locations", "List", "Group", "Comparison"];
					if(objectType=="conference")
						visList = ["Locations", "List", "Similar"]; <#--comparison doesn't make sense here-->
					if(objectType=="publication")
						visList = ["Locations", "List"]; <#--comparison doesn't make sense here-->
				}		
				if(visType=="publications"){
					visList = ["Timeline", "List", "Group", "Comparison"];
					if(objectType=="conference")
						visList = ["Timeline", "List", "Group"]; <#--comparison doesn't make sense here-->
					if(objectType=="publication")
						visList = ["Timeline", "Similar"]; <#--comparison doesn't make sense here-->
				}
				if(visType=="topics"){
					visList = ["Bubbles", "Evolution", "List", "Comparison"];
					if(objectType=="publication")
						visList = ["Bubbles", "List", "Comparison"];
					if(objectType=="topic")
						visList = ["Similar", "Evolution"];
				}
			}
			else
			{
				if(visType=="researchers")
				{
					visList = ["Network", "List", "Group"];
					if(objectType=="researcher")
						visList = ["Network", "List", "Group", "Similar"];
				}
				if(visType=="conferences")
				{
					visList = ["Locations", "List", "Group"];
					if(objectType=="publication")
						visList = ["Locations", "List"];
					if(objectType=="conference")
						visList = ["Locations", "List", "Similar"];
				}		
				if(visType=="publications")
				{
					visList = ["Timeline", "List", "Group"];
					if(objectType=="publication")
						visList = ["Similar"];
				}
				if(visType=="topics")
				{
					visList = ["Bubbles", "Evolution", "List"];
					if(objectType=="publication")
						visList = ["Bubbles", "List"];
					if(objectType=="topic")
						visList = ["Similar", "Evolution"];
				}
			}	
		
			<#-- create tabs according to visualization type-->
			var visualizationTabs = $( '<div/>' )
										.attr({"id":"tab_visualization"})
										.addClass( "nav-tabs-custom" )
	
			var visualizationTabsHeaders = $( '<ul/>' )
												.addClass( "nav nav-tabs" );
			visualizationTabsContents = $( '<div/>' )
											.addClass( "tab-content" );
	
			<#-- append tab header and content -->
			visualizationTabs.append( visualizationTabsHeaders ).append( visualizationTabsContents );
	
			if(ids.length!=0)
				<#-- set inner tab into main tab -->
				{targetContainer.html( visualizationTabs );}
	
			<#-- fill with types from visList -->
			$.each( visList , function( index, item )
			{
				<#-- tab header -->
				var tabHeaderText = item;
	
				<#-- tab content -->
				var tabContent = $( '<div/>' )
					.attr({ "id" : "tab_" + tabHeaderText })
					.addClass( "tab-pane" )

				<#include "headerToolTip.ftl" />
					
				var tabHeader = $( '<li/>' )
					.append(
						$( '<a/>' )
						.attr({ "href": "#tab_" + tabHeaderText, "data-toggle":"tab" , "aria-expanded" : "true", "title" : headerCaption[objectType + "-" + visType + "-" + item]})
						.html( tabHeaderText )
					);
					
			 	tabHeader.on("click",function(e){
			 		hidehoverdiv('divtoshow');
			 		hidehoverdiv('divhold');
			 		hidemenudiv('menu')

				<#-- hide filters in specific cases -->
				var other_filters = document.getElementById("other_filters")
					
				if(other_filters!=null)
				{
			 		if(e.target.text == "Comparison")
			 			other_filters.style.display = "none";
					else
						other_filters.style.display = "block";
		 		}
		 		
		 		var year_filter = document.getElementById("year_filter")
				if(year_filter!=null)
				{
			 		if(e.target.text == "Similar")
			 		{
			 			year_filter.style.display = "none";
			 			other_filters.style.visibility = "hidden";
			 			appButton.style.display = "none";
					}
					else
					{
						year_filter.style.display = "block";
						other_filters.style.visibility = "visible";
						appButton.style.display = "block";
					}	
		 		}
		 		
		 		currentTab = index;
		 		currentTabName = e.target.text;
				loadVis(data.type, visType, e.target.text, widgetElem, names, ids, tabContent, data.authoridForCoAuthors);
			});
	
				if(currentTab>visList.length-1)
					currentTab = 0;
					
				if( index == currentTab )
				{
					tabHeader.addClass( "active" );
					tabContent.addClass( "active" );
				}

				<#-- append tab header and content -->
				visualizationTabsHeaders.append( tabHeader );
				visualizationTabsContents.append( tabContent );
				if(item == visList[currentTab])
				{
					currentTabName = item;
					loadVis(data.type, visType, item, widgetElem, names, ids, tabContent, data.authoridForCoAuthors);
				}
			});
		}
	};
		
	<#-- load data n visualization only when that tab shows up, not before -->
	function loadVis(type, visType, visItem, widgetElem, names, ids, tabContent, authoridForCoAuthors)
	{
		if(visType != "researchers")
			visPopUpIds.push(pops_researchers);	
		if(visType != "conferences")
			visPopUpIds.push(pops_conferences);	
		if(visType != "publications")
			visPopUpIds.push(pops_publications);	
		if(visType != "topics")
			visPopUpIds.push(pops_topics);	
		if(visItem != "List")
			visPopUpIds.push(pops_list)
	
		for(var i=0;i<visPopUpIds.length;i++)
		{	
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( visPopUpIds[i] );
			visPopUpIds.splice(i,1);
		}
				
		<#-- generate unique id for progress log -->
		var uniqueVisWidget = $.PALM.utility.generateUniqueId();
		
		<#-- to show the gephi network again -->
		if(loadedList.indexOf(visItem)!= -1)
		{
			var reload="true";
			if( visItem=="Network")	
				tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, reload);
			if( visItem=="Locations")	
				tabVisLocations(uniqueVisWidget, url, widgetElem, tabContent, reload);	
		}
		if(loadedList.indexOf(visItem)== -1)
		{
			if(ids.length>0)
			{
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Loading "+visItem, { uniqueId:uniqueVisWidget, popUpHeight:40, directlyRemove:false , polling:false});
				if(visType == "researchers")
					pops_researchers.push(uniqueVisWidget);	
				if(visType == "conferences")
					pops_conferences.push(uniqueVisWidget);		
				if(visType == "publications")
					pops_publications.push(uniqueVisWidget);		
				if(visType == "topics")
					pops_topics.push(uniqueVisWidget);	
				if(visItem == "List")
					pops_list.push(uniqueVisWidget);
			}
	
			var url = "<@spring.url '/explore/visualize' />"+"?visTab="+visItem+"&type="+type+"&visType="+visType+"&dataList="+names+"&idList="+ids+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues+"&startYear="+startYear+"&endYear="+endYear+"&yearFilterPresent="+yearFilterPresent+"&deleteFlag="+deleteFlag+"&authoridForCoAuthors="+authoridForCoAuthors;
			if(visItem == "Network")
				tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, false);
			if(visItem == "Locations")
				tabVisLocations(uniqueVisWidget, url, widgetElem, tabContent, false);
			if(visItem == "Timeline")
				tabVisTimeline(uniqueVisWidget, url, widgetElem, tabContent);
			if(visItem == "Evolution")
				tabVisEvolution(uniqueVisWidget, url, widgetElem, tabContent);
			if(visItem == "Bubbles")
				tabVisBubbles(uniqueVisWidget, url, widgetElem, tabContent);
			if(visItem == "Group")
				tabVisGroup(uniqueVisWidget, url, widgetElem, tabContent, visType);
			if(visItem == "List")
				tabVisList(uniqueVisWidget, url, widgetElem, tabContent, visType, type);
			if(visItem == "Comparison")
				tabVisComparison(uniqueVisWidget, url, widgetElem, tabContent);
			if(visItem == "Similar")
				tabVisSimilar(uniqueVisWidget, url, widgetElem, tabContent);
		}		
		loadedList.push(visItem);
	}
			
	<#include "visTabs/networkTab.ftl" />
	<#include "visTabs/locationsTab.ftl" />
	<#include "visTabs/timelineTab.ftl" />
	<#include "visTabs/bubblesTab.ftl" />
	<#include "visTabs/evolutionTab.ftl" />
	<#include "visTabs/groupTab.ftl" />
	<#include "visTabs/listTab.ftl" />
	<#include "visTabs/comparisonTab.ftl" />
	<#include "visTabs/similarityTab.ftl" />	
			
	function wrap(text, width) 
	{
		text.each(function() 
		{
		    var text = d3.select(this),
		    words = text.text().split(/\s+/).reverse(),
			word,
			line = [],
			lineNumber = 0,
			lineHeight = 0.8, // ems
			y = text.attr("y"),
			dy = parseFloat(text.attr("dy")),
			tspan = text.text(null).append("tspan").attr("x", -3).attr("y", y).attr("dy", -dy + "em");
			while (word = words.pop()) 
			{
				line.push(word);
			    tspan.text(line.join(" "));
			    if (tspan.node().getComputedTextLength() > width) 
			    {
			        line.pop();
			        tspan.text(line.join(" "));
			        line = [word];
			        tspan = text.append("tspan").attr("x", -3).attr("y", y).attr("dy", ++lineNumber * lineHeight - dy + "em").text(word);
			    }
			}
		});
	}		
		
	<#--// register the widget-->
	$.PALM.options.registeredWidget.push({
		"type":"${wType}",
		"group": "${wGroup}",
		"source": "${wSource}",
		"selector": "#widget-${wUniqueName}",
		"element": $( "#widget-${wUniqueName}" ),
		"options": options
	});
	
	<#--// first time on load, list 50 researchers-->
	$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
	
});
	
<#-- javascript -->
function showhoverdiv(e,divid, text)
{
	if(divid != "divhold")
		hidemenudiv('menu')
				
	document.getElementById(divid).innerHTML = text;

    var left;
	var top;
			
	if(e.type == "similarBar" || e.type == "cluster" || e.type == "clusterItem" || e.type == "bubble")
	{
	    left  = (e.clientX - 10) + "px";
	    top  = (e.clientY  + 20) + "px";
    }
		    
    if(e.type == "clickNode" || e.type == "overEdge")
    {
	    left  = (e.data.captor.clientX) + "px";
	    top  = (e.data.captor.clientY) + "px";
    }
		    
     if(e.type == "clickLocation")
     {
	    left  = (e.clientX + 350) + "px";
	    top  = (e.clientY + 250) + "px";
     }
		    
	if(e.type == "comparisonListItem")
	{
	    left  = (e.clientX) + "px";
	    top  = (e.clientY) + "px";
    }
		    
    if(e.type == "listItem")
    {
	    left  = (e.clientX) + "px";
	    top  = (e.clientY) + "px";
    }
		    
    var div = document.getElementById(divid);
		
    div.style.left = left;
    div.style.top = top;
	div.style.display = "inline"
    return false;
}

function hidehoverdiv(divid)
{
    var div = document.getElementById(divid);
	div.style.display = "none"
    return false;
}

function showmenudiv(e,divid)
{
	hidehoverdiv('divtoshow')
    hidehoverdiv('divhold');
	fullscreen = document.getElementsByClassName("panel-fullscreen")[0]

	var left;
	var top;
	var collapse = $( "body" ).hasClass( "sidebar-collapse" );
			
	$('#menu_header').html(e.itemName)

	if(e.type == "clickNode")
		$('#menu_header').html(e.data.node.label)
	if(e.type == "clickEdge")
		$('#menu_header').html(e.data.edge.source + " & " + e.data.edge.target)
				
	if(e.type == "listItem" || e.type == "comparisonListItem" || e.type=="clickPublication" || e.type == "cluster" || e.type == "clusterItem" || e.type == "bubble" || e.type == "evolution")
	{
    	if(collapse || fullscreen != undefined)
		{
		    left  = (e.clientX);
		    top  = (e.clientY - 140);
	    }
	    else
	    {
	    	left  = (e.clientX - 330);
		    top  = (e.clientY - 140);
	    }
    }
		    
    if(e.type == "similarBar")
    {
    	if(collapse || fullscreen != undefined)
		{
		    left  = (e.clientX);
		    top  = (e.clientY - 145);
	    }
	    else
	    {
	    	left  = (e.clientX - 330);
		    top  = (e.clientY - 145);
	    }
    }
    
    if(e.type == "clickLocation")
    {
    	if(collapse || fullscreen != undefined)
		{
		    left  = (e.clientX - 50);
		    if(e.clientX > 700)
		    	left  = (e.clientX - 180);
	   		top  = (e.clientY + 100);
	    }
	    else
	    {
	    	left  = (e.clientX);
	   		top  = (e.clientY + 100);
	    }
    }
		    
    if(e.type == "clickNode" || e.type == "clickEdge")
    {
    	if(collapse || fullscreen != undefined)
		{
			left  = (e.data.captor.clientX);
		    top  = (e.data.captor.clientY  - 150);
	    }
	    else
	    {
		    left  = (e.data.captor.clientX - 350);
		    top  = (e.data.captor.clientY  - 150);
	    }
    }
	    
    if(fullscreen != undefined && e.type!="clickLocation")
    	top = top + 120;
	if(fullscreen != undefined && e.type=="clickLocation")
    	left = left + 140;
		    	
	top = top +  "px";
	left = left  + "px"
		    
    var div = document.getElementById(divid);
    div.style.left = left;
    div.style.top = top;
	div.style.display = "block";
			
	if(e.type == "clickNode")
	{
		<#-- do not show menu if the object is there in the setup already -->
		if(names.indexOf(e.data.node.label) != -1)
		{
			$(".menu").hide();
			showhoverdiv(e,'divhold', 'Already present in criteria panel')
		}
		else
		{
			$(".menu").show();
				
			<#-- append is invalid if the types are different -->
			if(visType.substring(0,visType.length-1)!=objectType)
			{
				$("#append").hide();
			}
			else
				$("#append").show();
		}	
	}
			
	if(e.type == "comparisonListItem")
	{
		if(ids.indexOf(e.itemId) != -1)
		{
			$(".menu").hide();
			showhoverdiv(e,'divtoshow', 'Already present in criteria panel')
		}	
		else
			$(".menu").show();
	}
			
	if(e.type == "clickEdge" || e.type == "similarBar" || e.type == "clickLocation" || e.type == "clickPublication" || e.type == "listItem" || e.type == "cluster" || e.type == "clusterItem" || e.type == "bubble" || e.type == "evolution")
		$(".menu").show();
			
	<#-- append is invalid if the types are different -->
	if(visType.substring(0,visType.length-1)!=objectType)
		$("#append").hide();
	else
		$("#append").show();
		
	if(visType != "publications" || e.pubUrl == undefined || e.pubUrl == "")
		$("#openURL").hide();
	else
		$("#openURL").show();	
				
	<#-- set the value of clicked node in the menu -->
	div.value = e;
    return false;
}

function hidemenudiv(divid)
{
	var div = document.getElementById(divid);
	div.style.display = "none"
    return false;
}
		
<#-- JQUERY -->
$('#append').click(function(e)
{
	var targetVal = [];
		
	if($(this).parent().parent()[0].value.type=="clickNode")
	{
		targetVal.push($(this).parent().parent()[0].value.data.node.attributes.authorid);
		itemAdd(targetVal,"researcher");
	}	
		
	if($(this).parent().parent()[0].value.type=="clickEdge")
	{
		if($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorisadded)
		targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorid);
		
		if($(this).parent().parent()[0].value.data.edge.attributes.targetauthorisadded)
		targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.targetauthorid);
		
		if(targetVal.length > 0)
			itemAdd(targetVal,"researcher");
	}
		
	if($(this).parent().parent()[0].value.type=="clickPublication")
	{
		targetVal.push($(this).parent().parent()[0].value.pubId);
		itemAdd(targetVal,"publication");
	}		
		
	if($(this).parent().parent()[0].value.type=="similarBar")
	{
		targetVal.push($(this).parent().parent()[0].value.authorId);
		itemAdd(targetVal,visType.substring(0,visType.length-1));
	}

	if($(this).parent().parent()[0].value.type=="clickLocation")
	{
		targetVal.push($(this).parent().parent()[0].value.eventGroupId);
		itemAdd(targetVal,"conference");
	}	
		
	if($(this).parent().parent()[0].value.type=="comparisonListItem")
	{
		targetVal.push($(this).parent().parent()[0].value.itemId);
		itemAdd(targetVal,$(this).parent().parent()[0].value.objectType);
	}
		
	if($(this).parent().parent()[0].value.type=="listItem")
	{
		targetVal.push($(this).parent().parent()[0].value.itemId);
		itemAdd(targetVal,$(this).parent().parent()[0].value.objectType);
	}
	
	if($(this).parent().parent()[0].value.type=="cluster")
	{
		for(var i=0;i<$(this).parent().parent()[0].value.clusterItems.length; i++)
		{
			targetVal.push($(this).parent().parent()[0].value.clusterItems[i]);
		}
		itemAdd(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
	}
		
	if($(this).parent().parent()[0].value.type=="clusterItem")
	{
		targetVal.push($(this).parent().parent()[0].value.clusterItem);
		itemAdd(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
	}
		
	if($(this).parent().parent()[0].value.type=="bubble")
	{
		targetVal.push($(this).parent().parent()[0].value.topicId);
		itemAdd(targetVal,"topic");
	}
		
	if($(this).parent().parent()[0].value.type=="evolution")
	{
		targetVal.push($(this).parent().parent()[0].value.topicId);
		itemAdd(targetVal,"topic");
	}
		
	 hidemenudiv('menu');
	 return false;
});
	
$('#replace').click(function(e)
{
	var targetVal = [];
	if($(this).parent().parent()[0].value.type=="clickNode")
	{
		targetVal.push($(this).parent().parent()[0].value.data.node.attributes.authorid);
		itemReplace(targetVal,"researcher");
	}	
		
	if($(this).parent().parent()[0].value.type=="clickEdge")
	{
		if($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorisadded)
		targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorid);
		
		if($(this).parent().parent()[0].value.data.edge.attributes.targetauthorisadded)
		targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.targetauthorid);
		
		if(targetVal.length > 0)
			itemReplace(targetVal,"researcher");
	}
	
	if($(this).parent().parent()[0].value.type=="clickPublication")
	{
		targetVal.push($(this).parent().parent()[0].value.pubId);
		itemReplace(targetVal,"publication");
	}		
	
	if($(this).parent().parent()[0].value.type=="similarBar")
	{
		targetVal.push($(this).parent().parent()[0].value.authorId);
		itemReplace(targetVal,visType.substring(0,visType.length-1));
	}
	
	if($(this).parent().parent()[0].value.type=="clickLocation")
	{
		targetVal.push($(this).parent().parent()[0].value.eventGroupId);
		itemReplace(targetVal,"conference");
	}
	
	if($(this).parent().parent()[0].value.type=="comparisonListItem")
	{
		targetVal.push($(this).parent().parent()[0].value.itemId);
		itemReplace(targetVal,$(this).parent().parent()[0].value.objectType);
	}
	
	if($(this).parent().parent()[0].value.type=="listItem")
	{
		targetVal.push($(this).parent().parent()[0].value.itemId);
		itemReplace(targetVal,$(this).parent().parent()[0].value.objectType);
	}
	
	if($(this).parent().parent()[0].value.type=="cluster")
	{
		for(var i=0;i<$(this).parent().parent()[0].value.clusterItems.length; i++)
		{
			targetVal.push($(this).parent().parent()[0].value.clusterItems[i]);
		}
		itemReplace(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
	}
	
	if($(this).parent().parent()[0].value.type=="clusterItem")
	{
		targetVal.push($(this).parent().parent()[0].value.clusterItem);
		itemReplace(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
	}
	
	if($(this).parent().parent()[0].value.type=="bubble")
	{
		targetVal.push($(this).parent().parent()[0].value.topicId);
		itemReplace(targetVal,"topic");
	}
	
	if($(this).parent().parent()[0].value.type=="evolution")
	{
		targetVal.push($(this).parent().parent()[0].value.topicId);
		itemReplace(targetVal,"topic");
	}
	
	hidemenudiv('menu');
	return false;
});
	
$('#openURL').click(function(e)
{
	window.open($(this).parent().parent()[0].value.pubUrl,'_blank');
	hidemenudiv('menu');
	return false;
});

function itemAdd(id, type)
{
	var queryString = "?id="+id+"&type="+type;
	$('#search_words').effect('highlight',{color:"black"}, 800);

	<#-- update search widget -->
	var searchWidget = $.PALM.boxWidget.getByUniqueName( 'explore_search' ); 
	searchWidget.options.queryString = queryString;
	$.PALM.boxWidget.refresh( searchWidget.element , searchWidget.options );
}

function itemReplace(id, type)
{
	var replace = true;
	var queryString = "?id="+id+"&type="+type+"&replace="+replace;
	$('#search_words').effect('highlight',{color:"black"}, 800);

	<#-- update search widget -->
	var searchWidget = $.PALM.boxWidget.getByUniqueName( 'explore_search' ); 
	searchWidget.options.queryString = queryString;
	$.PALM.boxWidget.refresh( searchWidget.element , searchWidget.options );
}

function sortList(a,b)
{
		a = a.toLowerCase();
		b = b.toLowerCase();
		return (a < b) ? -1 : (a > b) ? 1 : 0;
}
	
function blue()
{
	color = $( this ).parent().context.style.color;
	$( this ).parent().context.style.color="blue";
}	

function originalColor()
{
	$( this ).parent().context.style.color=color;
}
</script>