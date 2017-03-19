<#-- SIMILARITY TAB -->
function tabVisSimilar(uniqueVisWidget, url, widgetElem, tabContent)
{
	$.getJSON( url , function( data ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
			
		if(data.oldVis=="false")
		{
			var similarTab = $( widgetElem ).find( "#tab_Similar" );
			similarTab.html("");
					
			if( data.map == null )
			{
				$.PALM.callout.generate( similarTab , "warning", "No data found!!", "Insufficient Data!" );
				return false;
			}
				
			if(data.map.names.length==0)
			{
				$.PALM.callout.generate( similarTab , "warning", "No data found!!", "No similar "+ visType + ", not enough information available" );
				return false;
			}
			else
			{
				var similarDiv = $('<div/>')
									.addClass("similarity")
									.css('overflow-y','scroll')
									
				similarTab.append(similarDiv);
						
				$(".similarity").slimscroll(
				{
					height: "67vh",
			        size: "5px",
		        	allowPageScroll: true,
		   			touchScrollStep: 50,
				});		
						
				var innerDiv = $('<div/>').attr('id','sim_tab')
						
				similarDiv.append(innerDiv)	
						
				<#-- http://bl.ocks.org/kiranml1/6872226 -->
				var grid = d3.range(15).map(function(i)
				{
					return {'x1':0,'y1':0,'x2':0,'y2':480};
				});
				
				var tickVals = grid.map(function(d,i)
				{
					if(i>0){ return i*10; }
					else if(i===0){ return "100";}
				});
				
				var xscale = d3.scale.linear()
									.domain([0,209])
									.range([0,822]);
				
				var yscale = d3.scale.linear()
									.domain([0,data.map.names.length])
									.range([0,580]);
				
				var colorScale = d3.scale.linear()
									.domain([0,data.map.names.length])
									.range(["#cdf0fd", "#d4d4d1"]);
					
				height = data.map.names.length * 50

				if(data.map.names.length <6)
					height = data.map.names.length * 40

				var canvas = d3.select('#sim_tab')
								.append('svg')
								.attr({'width':700,'height':height})
						
				canvas.on("click", function(e) 
				{ 
					hidemenudiv('menu'); 
					hidehoverdiv('divtoshow');
  					hidehoverdiv('divhold');
				})		
					
				var chart = canvas.append('g')
									.attr('id','bars')
									.selectAll('rect')
									.data(data.map.similarity)
									.enter()
									.append('rect')
									.attr('height',20)
									.attr({'x':0,'y':function(d,i){ return yscale(i)+19; }})
									.style('fill',function(d,i){ return colorScale(i); })
									.attr('width',function(d){ return 0; })
									.on("click", function(e, i)
									{
										if(visType == "publications")
											url = data.map.urls[i]
										else
											url = ""
												
										obj = {
												  type:"similarBar",
										          clientX:d3.event.clientX,
										          clientY:d3.event.clientY,
										          itemName:data.map.names[i],
										          authorId:data.map.ids[i],
										          pubUrl: url
											};
											
										showmenudiv(obj,'menu');
										d3.event.stopPropagation();
									})
									.on("mouseover", function(d,i)
									{
										d3.select(this).style("cursor", "pointer")
										if(objectType!="topic")
										{
											obj = {
													  type:"similarBar",
											          clientX:d3.event.clientX,
											          clientY:d3.event.clientY,
											          itemName:data.map.names[i],
											          authorId:data.map.ids[i]
												};
												
											var intarr = [] 
											intarr = Object.keys(data.map.interests[i])
											var count = 5;
											if(intarr.length<5)
												count = intarr.length
													
											var str = "Common interests [" + data.map.similarity[i] + "]: <br/>";

											if(objectType == "publication")
											str = "Common topics: <br/>";
											for(var i=0; i<count; i++)
												str = str +  "<br /> - " + intarr[i] 
											str = str + " ...."		
												
											showhoverdiv(obj,'divtoshow', str);
										}		
									})
			
				var transitext = d3.select('#bars')
									.selectAll('text')
									.data(data.map.names)
									.enter()
									.append('text')
									.attr({'x':function(d) {return 0; },'y':function(d,i){ return yscale(i)+32; }})
									.text(function(d,i)
									{
											return data.map.names[i]
									})
									.style({'fill':'black','font-size':'13px', 'font-weight':'bold'})
									.on("click", function(e, i)
									{
										if(visType == "publications")
											url = data.map.urls[i]
										else
											url = ""
												
										obj = {
												  type:"similarBar",
										          clientX:d3.event.clientX,
										          clientY:d3.event.clientY,
										          itemName:data.map.names[i],
										          authorId:data.map.ids[i],
										          pubUrl:url
											};
										
										showmenudiv(obj,'menu');
										d3.event.stopPropagation();
									})
									.on("mouseover", function(d,i)
									{
										d3.select(this).style("cursor", "pointer")
										if(objectType!="topic")
										{
											obj = {
													  type:"similarBar",
											          clientX:d3.event.clientX,
											          clientY:d3.event.clientY,
											          itemName:data.map.names[i],
											          authorId:data.map.ids[i]
												};
													
											var intarr = [] 
											intarr = Object.keys(data.map.interests[i])
											var count = 5;
											if(intarr.length<5)
												count = intarr.length
													
											var str = "Common interests [" + data.map.similarity[i] + "]: <br/>";
											if(objectType == "publication")
												str = "Common topics: <br/>";
											for(var i=0; i<count; i++)
												str = str +  "<br /> - " + intarr[i] 
											str = str + " ...."	
														
											showhoverdiv(obj,'divtoshow', str);
										}
									})
			
				var transit = d3.select("svg").selectAll("rect")
									    .data(data.map.similarity)
									    .transition()
									    .duration(1000) 
									    .attr("width", function(d) {return xscale(d/2.5); });
			}
		}			
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}