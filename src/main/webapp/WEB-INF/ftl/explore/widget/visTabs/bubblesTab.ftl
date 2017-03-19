<#-- BUBBLES TAB -->
function tabVisBubbles(uniqueVisWidget, url, widgetElem, tabContent)
{
	$.getJSON( url , function( dataBubble ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
			
		if(dataBubble.oldVis=="false")
		{
			var bubblesTab = $( widgetElem ).find( "#tab_Bubbles" );
			bubblesTab.html("");
						
			if( dataBubble.map.list.length == 0 )
			{
				if(objectType == "publication" )
					$.PALM.callout.generate( bubblesTab , "warning", "No data found!!", "No topics satisfy the specified criteria!" );
				else
					$.PALM.callout.generate( bubblesTab , "warning", "No data found!!", "No interests satisfy the specified criteria!" );
				return false;
			}
						
			visBubbles(dataBubble.map.list, dataBubble.dataList);
		}
	}).fail(function() 
	{
		$.PALM.popUpMessage.remove( uniquePid );
	});
}

function visBubbles(data, namesList)
{
	var color = d3.scale.ordinal().range(customColors),
    diameter = 500;
			    
	var zoom = d3.behavior.zoom()
				.scaleExtent([0, 15])
				.on("zoom", zoomedBubbles);    
			    
	var bubble = d3.layout.pack()
			      .value(function(d) { return d3.sum(d[1]); })
			      .sort(function(a, b) {
					    return -(a.value - b.value);
					})
			      .size([diameter, diameter])
			      .padding(1.5),
			    arc = d3.svg.arc().innerRadius(0),
			    pie = d3.layout.pie();
			
	svg = d3.select("#tab_Bubbles").append("svg")
			    .attr("width", diameter)
			    .attr("height", diameter)
			    .attr("class", "bubble")
	            .append("g")
			    .call(zoom).append("g")
			    .on("click",function()
			    {
			    	hidehoverdiv('divtoshow');
			  		hidehoverdiv('divhold');
					hidemenudiv('menu')
			    })
			    
    var rect2 = svg.append("rect")
			    .attr("width", diameter)
			    .attr("height", diameter)
			    .style("fill", "none")
			    .style("pointer-events", "all"); 
		
	var container = svg.append("g");
	
	container.append("g")
			
	var nodes = container.selectAll("g.node")
			    .data(bubble.nodes({children: data}).filter(function(d) { return !d.children; }));
		
	nodes.enter().append("g")
			    .attr("class", "node")
			    .attr("transform", function(d) { return "translate(" + (d.x + 50) + "," + (d.y - 40) + ")"; })
				.on("click", function(d)
				{
					obj = {
							type:"bubble",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							itemName:d[0],
							topicId:d[2]
						};
									
					showmenudiv(obj,'menu'); 
					d3.event.stopPropagation();       	
				} )
				.on("mouseover",function(d,i)
				{
					d3.select(this).style("cursor", "pointer")
					obj = {
							type:"bubble",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							name:namesList[i]
						};
					if(namesList.length<2)					
						showhoverdiv(obj,'divhold', d[0]);		    	
			    })
			    .on("mousemove",function(d,i)
			    {
					d3.select(this).style("cursor", "pointer")
					obj = {
							type:"bubble",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							name:namesList[i]
						};
					if(namesList.length<2)					
						showhoverdiv(obj,'divhold', d[0]);		    	
			    })
			    .on("mouseout",function(d,i)
			    {
			    	hidehoverdiv('divtoshow');
			  		hidehoverdiv('divhold');
			    })      			  
			
	arcGs = nodes.selectAll("g.arc")
	    		.data(function(d) 
	    		{
			      return pie(d[1]).map(function(m) { m.r = d.r; return m; });
			    })
	    
	var arcEnter = arcGs.enter().append("g").attr("class", "arc");
			
	arcEnter.append("path")
	    .attr("d", function(d) 
	    {
		    arc.outerRadius(d.r);
		    return arc(d);
	    })
	    .style("fill", function(d, i) { return color(i); })
	    .on("mouseover",function(d,i)
	    {
	    	d3.select(this).style("cursor", "pointer")
			obj = {
					type:"bubble",
					clientX:d3.event.clientX,
					clientY:d3.event.clientY,
					name:namesList[i]
				};
			if(namesList.length>1)				
				showhoverdiv(obj,'divhold',namesList[i]);		    	
	    })
	    .on("mousemove",function(d,i)
	    {
	    	d3.select(this).style("cursor", "pointer")
			obj = {
					type:"bubble",
					clientX:d3.event.clientX,
					clientY:d3.event.clientY,
					name:namesList[i]
				};
			if(namesList.length>1)				
				showhoverdiv(obj,'divhold',namesList[i]);		    	
	    })
	    .on("mouseout",function(d,i)
	    {
	    	hidehoverdiv('divtoshow');
	  		hidehoverdiv('divhold');
	    })    
			
	nodes.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .text(function(d) { return [d[0]]; })
      .style("font-size", function(d) 
      {
			if(this.getComputedTextLength()!=0)
			{
				var size = Math.min(2 * d.r, (2 * d.r - 1) / this.getComputedTextLength() * 10);
				if(d[0].split(' ').length == 1)
			  		size = size/2;
			  	return size + "px";
			}
			else
			{
				var size = Math.min(2 * d.r, (2 * d.r - 1) / 120 * 10);
				//if(d[0].split(' ').length == 1)
			  	//	size = size/1.5;
			  	return size + "px";
			 } 	 
     })
}
		
function zoomedBubbles() 
{
	svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
}