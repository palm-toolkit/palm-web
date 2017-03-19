<#-- EVOLUTION TAB -->
function tabVisEvolution(uniqueVisWidget, url, widgetElem, tabContent)
{
	$.getJSON( url , function( data ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
				
		if(data.oldVis=="false")
		{
			if( data.map.list.length == 0 )
			{
				if(objectType == "publication" )
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No topics satisfy the specified criteria!" );
				else
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No interests satisfy the specified criteria!" );
				return false;
			}
					
			var tabEvolutionContainer = $( widgetElem ).find( "#tab_Evolution" );
			tabEvolutionContainer.html("");
					
			var evolutionSection = $( '<div/>' )
			tabEvolutionContainer.append(evolutionSection);	
			
			var newSect = $( '<div/>' ).attr("id","svgContainer")
								.on("click",function()
								{
									hidemenudiv('menu')
								})
			evolutionSection.append(newSect);	
			evolutionSection.addClass('evolutionSection overflow-height')
									
			$(".evolutionSection").slimscroll({
				height: "69vh",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
            });
					
			drawDimpleChart(data.map.list, data.map.topicIdMap);
		}	
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}

function drawDimpleChart(data, topicIdMap)
{
	var numberOfTopics = dimple.getUniqueValues(data, "Topic");
	if(numberOfTopics.length * 40.5 > 510)
		height = numberOfTopics.length * 40.5
	else
		height = 510
					
	var svg = dimple.newSvg("#chartTab", "100%", height);
	var chart = new dimple.chart(svg, data);
	
	var y;
	var y_attr = [];
			
	if(objectType == "topic")
	{
		y_attr = "Publication Count"
		y_order =  "Publication Count"
		s_attr = "Interest"
		chart_type = dimple.plot.line
		desc = false;
		y = chart.addMeasureAxis("y", y_attr);
	}
	else
	{
		y_attr = ["Topic", "Name"];
		y_order = "Topic";
		s_attr = "Name";
		chart_type = dimple.plot.bubble
		desc = true;
		y = chart.addCategoryAxis("y", y_attr);
	}
			
	y.addOrderRule(y_order, desc );
	chart.addCategoryAxis("x", "Year");
	var s = chart.addSeries(s_attr, chart_type);
				
	chart.draw();
	y.shapes.selectAll("text")
	  .call(wrap, 30);
			
	$('#chartTab').contents().appendTo("#svgContainer");
			
	svg.selectAll("circle")
		.on("click",function(e)
		{
			obj = {
						type:"evolution",
						clientX:d3.event.clientX,
						clientY:d3.event.clientY,
						itemName:e.y,
						topicId:topicIdMap[e.y]
				  };
								
			showmenudiv(obj,'menu');
			d3.event.stopPropagation(); 
		})
}
		