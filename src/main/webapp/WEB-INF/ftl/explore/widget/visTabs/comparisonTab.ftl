<#-- COMPARISON TAB -->
function tabVisComparison(uniqueVisWidget, url, widgetElem, tabContent)
{
	$.getJSON( url , function( data ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
			
		if(data.oldVis=="false")
		{
			var tabComparisonContainer = $( widgetElem ).find( "#tab_Comparison" );
			tabComparisonContainer.html("");
				
			var extraContainer = $( '<div/>' ).addClass('height67')
			tabComparisonContainer.append(extraContainer)
	
			var vennContainer = $( '<div/>' ).attr("id","vennContainer").addClass('height67 fleft width70p');
			var listContainer = $( '<div/>' ).attr("id","listContainer").addClass('height67 fright width30p');
				
			extraContainer.append(vennContainer);
			extraContainer.append(listContainer);
				
			var innerListContainer = $( '<div/>' ).attr("id","innerListContainer").addClass('overflow-height')
			listContainer.append(innerListContainer);
				
			$("#innerListContainer").slimscroll({
				height: "67vh",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			//alwaysVisible: true
			});
				
			var vennD = $( '<div/>' ).attr("id","venn").addClass('height67');
			vennContainer.append(vennD);
			var vennListC = $( '<div/>' );
			innerListContainer.append(vennListC);
			var clickFlag = "false";
			var selectedVenn = "";
			var chart = venn.VennDiagram()
			dataComp = data.map.comparisonList
				
			var div = d3.select("#venn")
			div.datum(dataComp).call(chart);
			
			div.on("click", function(d,i)
							{
								hidehoverdiv('divtoshow')
				  				hidehoverdiv('divhold');
								hidemenudiv('menu')
								vennListC.html("");
								var s  = d3.selectAll("path")
								s.style("stroke-width", 0)
						            .style("fill-opacity", d.sets.length == 1 ? .25 : .0)
						            .style("stroke-opacity", 0);
							})
				
			var tooltip = d3.select("body").append("div")
			    .attr("class", "venntooltip");
			
			div.selectAll("path")
			    .style("stroke-opacity", 0)
			    .style("stroke", "#fff")
			    .style("stroke-width", 0)
				
			div.selectAll("g")
			    .on("mouseover", function(d, i) 
			    {
			        <#-- sort all the areas relative to the current item -->
			        venn.sortAreas(div, d);
				
			        <#-- Display a tooltip with the current size -->
			        tooltip.transition().duration(400).style("opacity", .9);
			        
			        if(objectType == "researcher" && visType == "researchers")
			        	str = "co-authors"
					else if((objectType == "researcher" || objectType == "conference" || objectType == "circle") && visType == "topics")
						str = "interests"
			        else
			        	str = visType;	
			        	
			        tooltip.text(d.size + " "+ str);
				        
			        <#-- highlight the current path -->
			        var selection = d3.select(this).transition("tooltip").duration(400);
			        selection.select("path")
			        	.style("stroke","black")
			            .style("stroke-width", 3)
			            .style("fill-opacity", d.sets.length == 1 ? .4 : .1)
			            .style("stroke-opacity", 1);
			    })
		  	  .on("mousemove", function(d,i) 
		  	  {
			      tooltip.style("left", (d3.event.pageX) + "px")
		                 .style("top", (d3.event.pageY - 28) + "px");
			  })
		    .on("mouseout", function(d, i) 
		    {
		        tooltip.transition().duration(400).style("opacity", 0);
				        
		        if(selectedVenn!=d.altLabel)
		        {
			        var selection = d3.select(this).transition("tooltip").duration(400);
			        selection.select("path")
					            .style("stroke-width", 0)
					            .style("fill-opacity", d.sets.length == 1 ? .25 : .0)
					            .style("stroke-opacity", 0);
		        }    
		    })
			.on("click", function(d,i)
			{
				selectedVenn = d.altLabel;
				vennListC.html("");
				vennList(vennListC, d.list, d.idsList)
						
				var s  = d3.selectAll("path").filter(function(x) 
				{ 
					return d.altLabel!=x.altLabel; });
					s.style("stroke-width", 0)
			         .style("stroke-opacity", 0);
				    
				    d3.event.stopPropagation();    
				})
			}	
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}
		
function vennList(vennListC, nameList, idsList)
{
	<#-- build the researcher list -->
	var sortedNamesList = nameList.sort(function(a, b) 
	{
		return sortList(a.name, b.name);
	})

	$.each( sortedNamesList, function( index, item)
	{
		var vennDiv = $( '<div/>' )
							.addClass( 'author cursor-p' )
							.attr({ 'id' : item.id });
		
		var vennNav = $( '<div/>' )
							.addClass( 'nav' );
			
		var vennDetail = $( '<div/>' )
							.addClass( 'detail' )
							.append(
								$( '<div/>' )
								.addClass( 'name capitalize' )
								.html( (index+1)+") "+item.name )
							);
		vennDiv
			.append(
						vennNav
			)
			.append(
						vennDetail
			)
			.on('mouseover',blue)
			.on('mouseout',originalColor)
			.on('click', function(d)
			{ 
				obj = {
						  type:"comparisonListItem",
				          clientX:d.clientX,
				          clientY:d.clientY,
				          itemId:item.id,
				          itemName:item.name,
				          pubUrl:item.url,
				          objectType:visType.substring(0,visType.length-1)
					};
				if(visType == "researchers" || visType == "conferences")
				{
					if(item.isAdded)
						showmenudiv(obj, 'menu')
					else
						showhoverdiv(obj, 'divtoshow', item.name.toUpperCase() + " is currently not added to PALM")
				}		
				else
						showmenudiv(obj, 'menu')
			});
		
		if(visType == "researchers" || visType == "conferences")
		{	
			if( !item.isAdded )
				vennDiv.addClass( "text-gray" );
		}

		vennListC
				.append( 
						vennDiv
					);
	});
}