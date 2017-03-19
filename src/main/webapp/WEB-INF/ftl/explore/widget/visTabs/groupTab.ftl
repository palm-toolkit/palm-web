<#-- GROUP TAB -->
function tabVisGroup(uniqueVisWidget, url, widgetElem, tabContent, visType)
{
	$.getJSON( url , function( data ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
				
		if(data.oldVis=="false")
		{
			var mainWidget = $( widgetElem ).find( "#boxbody-${wUniqueName}" );
			var tabGroupContainer = $( widgetElem ).find( "#tab_Group" );
			tabGroupContainer.html("");
			
			if( data.map == null )
			{
				$.PALM.callout.generate( tabGroupContainer , "warning", "No data found!!", "Insufficient Data!" );
				return false;
			}
			
			clusteringOptions(tabContent, widgetElem, mainWidget, data.map)
			var groupSection = $( '<div/>' ).addClass("clusters")
			tabContent.append(groupSection);
			
			if(visType == "researchers")
			{
				data = data.map.coauthors;
				if( data == 0 || data == null )
				{
					tabContent.html("")
					$.PALM.callout.generate( tabGroupContainer , "warning", "No data found!!", "No authors satisfy the specified criteria!" );
					return false;
				}
				else
					visualizeCluster(data, mainWidget, visType);
			}					
			if(visType == "conferences")
			{
				data = data.map.conferences;
				if( data == 0 || data == null )
				{
					tabContent.html("")
					$.PALM.callout.generate( tabGroupContainer , "warning", "No data found!!", "No conferences satisfy the specified criteria!" );
					return false;
				}
				else
					visualizeCluster(data, mainWidget, visType);	
			}		
			if(visType == "publications")
			{
				data = data.map.publications;
				if( data == 0 || data == null )
				{
					tabContent.html("")
					$.PALM.callout.generate( tabGroupContainer , "warning", "No data found!!", "No publications satisfy the specified criteria!" );
					return false;
				}
				else
					visualizeCluster(data, mainWidget, visType);	
			}
		}	
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}

function visualizeCluster(data, tabContainer , visType)
{
	var margin = {top: 0, right: 100, bottom: 200, left: 100};

	var color = d3.scale.ordinal()
					.range(customColors); 
					
	var width = tabContainer.width();
	var height = width;   
	var packdim = width/1.5;
	
	if (data.length < 5)
		packdim = width/3
	if (data.length == 1)
		packdim = width/4	
		
	var zoom = d3.behavior.zoom()
				.scaleExtent([0, 20])
				.on("zoom", zoomed);
				
	clusters = new Array(getClusters(data)); 
			
	nodes = data.map(function(d) 
	{
		if (visType == "researchers")
	      	new_data = {cluster: d.cluster, radius: 10, id: d.id, name: d.name, clusterTerms : d.clusterTerms, nodeTerms : d.nodeTerms};
		if (visType == "publications")
	      	new_data = {cluster: d.cluster, radius: 10, id: d.id, name: d.name, url:d.url, clusterTerms : d.clusterTerms, nodeTerms : d.nodeTerms};
        if (visType == "conferences")
	      	new_data = {cluster: d.cluster, radius: 10, id: d.id, name: d.name, abr: d.abr, clusterTerms : d.clusterTerms, nodeTerms : d.nodeTerms};
		
		if (!clusters[d.cluster]) 
			clusters[d.cluster] = new_data;
			
		return new_data;
	});
	
	d3.layout.pack()
		    .sort(null)
		    .size([packdim, packdim])
		    .children(function(d) { return d.values; })
		    .value(function(d) { return d.radius * d.radius; })
		    .nodes(
		    {
		    	values: d3.nest()
	      				.key(function(d) 
      					{ 
      						return d.cluster; 
      					})
		      			.entries(nodes)
  			});	
			
	force = d3.layout.force()
					.nodes(nodes)
				    .size([width, height])
				    .gravity(0.02) 
				    .charge(0)
				    .on("tick", tick)
				    .start();

	vis_researcher = d3.select(".clusters").append("svg")
					    .attr("width", width)
					    .attr("height", height)
					    .append("g")
					    .call(zoom).append("g")
					    .on("click",function()
					    {
							hidemenudiv('menu');			
					    }); 
    
	var rect2 = vis_researcher.append("rect")
					    .attr("width", width)
					    .attr("height", height)
					    .style("fill", "none")
					    .style("pointer-events", "all"); 
			
	node = vis_researcher.selectAll(".node")
					      .data(nodes)
					      .enter()
			    		  .append("g")
					      .attr("class", "node")
					      .attr("transform", function(d) { return "translate(" + (margin.left + d.x) + "," + (margin.top + d.y) + ")"; })
						  .on("click", function(d)
						  {
					         obj = {
									type:"clusterItem",
									clientX:d3.event.clientX,
									clientY:d3.event.clientY,
									clusterItem: d.id,
									itemName:d.name,
									pubUrl: d.url,
									visType : visType 
								};
					         showmenudiv(obj,'menu');
					         d3.event.stopPropagation();
					      })
	      				  .on("mouseover",function(d) 
	      				  {
	      					d3.select(this).style("cursor", "pointer") 
	      					obj = {
									type:"clusterItem",
									clientX:d3.event.clientX,
									clientY:d3.event.clientY,
									clusterItem: d.id,
									itemName:d.name,
									visType : visType 
								};
				
							var str = d.name + "<br />";
							for(var i=0; i<d.nodeTerms.length; i++)
								str = str +  "<br /> - " + d.nodeTerms[i] 
							
				      		showhoverdiv(obj, 'divhold', str); 
				      	  }) 
				          .on("mouseout", function(e,i)
				          {
					 		  hidehoverdiv('divtoshow');
					          hidehoverdiv('divhold');
					  	  })
	
	node.append("circle")
	      .attr("r", function(d) { return d.r; })
	      .style("fill", function(d) { return color(d.cluster); })
	  
	g = node.append('g')
		.attr('transform', function(d)
		{ 
			if(visType == "researchers" )
				return 'translate(' + [- d.r + (0.3 * d.r) , - d.r + (0.4 * d.r)] + ')' 
		    if(visType == "conferences" )
		    	return 'translate(' + [- d.r + (0.35 * d.r) , - d.r + (0.3 * d.r)] + ')'
		    if(visType == "publications" )
		    	return 'translate(' + [- d.r + (0.33 * d.r) , - d.r + (0.5 * d.r)] + ')'
		});
			  
	g.append("foreignObject")
	    .attr("width", function(d){return 2 * d.r * Math.cos(Math.PI / 4)})
	    .attr("height", function(d){return 2 * d.r * Math.cos(Math.PI / 4)})
	    .append("xhtml:p")
	    .text( function(d){return d.name})    
	    .style("font-size", function(d){
	    	if(visType == "researchers" )
	    	{	
	    		if(d.name.split(' ').length > 2)
	    			return ((0.33 * d.r) - (d.name.split(' ').length )*1.3 ) + "px";
	    		return (0.33 * d.r) + "px";
	    	}
	    	if(visType == "conferences" )
	    		return (0.188 * d.r) + "px";
	    	if(visType == "publications" )
	    		return (0.13 * d.r) + "px";
	    })
		      
	node.transition()
		    .duration(750)
		    .delay(function(d, i) { return i * 5; })
		    .attrTween("r", function(d) {
		      var i = d3.interpolate(0, d.radius);
		      return function(t) { return d.radius = i(t); };
		    });
		 
	groups = d3.nest().key(function(d) { return d.cluster }).entries(nodes);

	groupPath = function(d) 
	{
		var fakePoints = [];
	    if (d.values.length == 2)
	    {
	        <#-- [dx, dy] is the direction vector of the line -->
	        var dx = d.values[1].x - d.values[0].x;
	        var dy = d.values[1].y - d.values[0].y;
		
	        <#-- scale it to something very small -->
	        dx *= 0.00001; dy *= 0.00001;
		
	        <#-- orthogonal directions to a 2D vector [dx, dy] are [dy, -dx] and [-dy, dx]
	        take the midpoint [mx, my] of the line and translate it in both directions -->
	        var mx = (d.values[0].x + d.values[1].x) * 0.5;
	        var my = (d.values[0].y + d.values[1].y) * 0.5;
	        fakePoints = [ [mx + dy, my - dx],
	                      [mx - dy, my + dx]];
	    }
		       
	   return "M" + d3.geom.hull(d.values.map(function(d) { return [d.x, d.y]; })
	       .concat(fakePoints))  
	       .join("L") + "Z";
	};
			    
	groupFill = function(d,i) { return color(d.values[0].cluster); };
			    
	vis_researcher.selectAll("path")
			    .data(groups)
				.attr("d", groupPath)
			    .enter().insert("path", "g")
				.attr("transform", function(d) { return "translate(" + (margin.left) + "," + (margin.top) + ")"; })
			    .style("fill", groupFill)
			    .style("stroke", groupFill)
			    .style("stroke-width", 100)
			    .style("stroke-linejoin", "round")
			    .style("opacity", .3)
			    .attr("d", groupPath)
			    .on("click", function(d)
			    {
			         var list = [];
			         for(var i=0; i< d.values.length; i++)
			         {
			         	list.push(d.values[i].id)
			         }
			         obj = {
								type:"cluster",
								clientX:d3.event.clientX,
								clientY:d3.event.clientY,
								clusterItems: list,
								itemName:"All " + visType + " in cluster" ,
								visType : visType 
							};
			         showmenudiv(obj,'menu');
			         d3.event.stopPropagation();
			      })
			     .on("mouseover",function(d) 
			     {
				     d3.select(this).style("cursor", "pointer")
				     var list = [];
				         for(var i=0; i< d.values.length; i++)
				         {
				         	list.push(d.values[i].id)
				         }
				     obj = {
								type:"cluster",
								clientX:d3.event.clientX,
								clientY:d3.event.clientY,
								clusterItems: list,
								visType : visType 
							}; 
							
					var str = "Interests of cluster: <br/>";
					if(objectType == "publication")
						str = "Topics of cluster: <br/>";
					for(var i=0; i<d.values[0].clusterTerms.length; i++)
						str = str +  "<br /> - " + d.values[0].clusterTerms[i] 
										
				     showhoverdiv(obj, 'divhold', str); 
			     }) 
			     .on("mouseout", function(e,i)
			     {
					hidehoverdiv('divtoshow');
		  			hidehoverdiv('divhold');
				})
}
		
function getClusters(data)
{
	var groups = [];
		
	for(var i=0; i<data.length; i++)
	{
    	if(groups.indexOf(data[i].cluster) == -1)
			groups.push(data[i].cluster);
  	}
	return groups.length;
}
		
function tick(e) 
{
	node
    	.each(cluster(10 * e.alpha * e.alpha))
      	.each(collide(.5))
	    .attr("cx", function(d) { return d.x; })
    	.attr("cy", function(d) { return d.y; });
}
	
<#-- Move d to be adjacent to the cluster node. -->
function cluster(alpha) 
{
	return function(d) 
	{
	    var cluster = clusters[d.cluster];
	    if (cluster === d) return;
    	var x = d.x - cluster.x,
        y = d.y - cluster.y,
        l = Math.sqrt(x * x + y * y),
        r = d.radius + cluster.radius;
    	if (l != r) 
		{
      		l = (l - r) / l * alpha;
	        d.x -= x *= l;
	        d.y -= y *= l;
	        cluster.x += x;
	        cluster.y += y;
    	}
  	};
}
			
<#-- Resolves collisions between d and all other circles -->
function collide(alpha) 
{
	var quadtree = d3.geom.quadtree(nodes);
 	var padding = 5.5; <#-- separation between same-color nodes -->
	var clusterPadding = 10; <#-- separation between different-color nodes -->
	var maxRadius = 100;
			 
	return function(d) 
	{
	    var r = d.radius + maxRadius + Math.max(padding, clusterPadding),
        nx1 = d.x - r,
        nx2 = d.x + r,
        ny1 = d.y - r,
        ny2 = d.y + r;

	    quadtree.visit(function(quad, x1, y1, x2, y2) 
	    {
			if (quad.point && (quad.point !== d)) 
			{
		        var x = d.x - quad.point.x,
	            y = d.y - quad.point.y,
	            l = Math.sqrt(x * x + y * y),
	            r = d.radius + quad.point.radius + (d.cluster === quad.point.cluster ? padding : clusterPadding);
		        if (l < r) 
		        {
			          l = (l - r) / l * alpha;
			          d.x -= x *= l;
			          d.y -= y *= l;
			          quad.point.x += x;
			          quad.point.y += y;
		        }
		      }
		      return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
	    });
	};
}
		
function zoomed() 
{
	vis_researcher.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
}
		
function clusteringOptions(tabContent, widgetElem, mainWidget, data)
{
	var clustering_div = $( '<div/>' )

	<#-- cluster algos list -->
	var listOfOptions = [ "X-Means", "K-Means", "FarthestFirst", "EM", "Hierarchical"];
	var select = $( '<select/>' )
						.attr({"id":"cluster_type","class":"form-control"})
						.css({"height":"30px", "width":"130px", "padding-top":"4px"})
										
	$.each(listOfOptions, function(index, value)
	{
		select.append(
				$( '<option/>' )
				.attr( "value", value )
				.html( value )
			)
	})
			
	select.val(data.algo).change();
	var cluster_type = $( '<div/>' )
							.css({"height":"5vh", "float":"left"})
							.addClass( "form-group" )
							.append(select)
							
	var cluster_type_options = $( '<div/>' )
							.css({"height":"5vh", "float":"left", "margin": "0px 0px 0px 5px"})
							.addClass( "form-group" )
									
	var cluster_type_options_apply = $( '<div/>' )
									.css({"height":"5vh","float":"left"})
									.addClass( "form-group" )
									.append(
										$('<input/>')
										.attr({
									        type: "button",
									        id: "cluster_button",
									        value: 'Apply Algorithm'
									    })
									    .addClass("apply-button btn btn-success btn-sm")
									    .on("click", function()
									    {
										    var cluster_drop_down = $( widgetElem ).find( "#cluster_type" );
										    var algo = cluster_drop_down.val();
										    seedVal = $( "#seed" ).val();
										    noOfClustersVal = $( "#no_of_clusters" ).val();
										    foldsVal = $( "#folds" ).val();
										    iterationsVal = $( "#iterations" ).val();
										    
											if(noOfClustersVal > 20)
										    {
										     	alert("maximum clusters possible: 20")
										    }
										    else if (iterationsVal < 1)
										    {
										    	alert("Minimum Iterations: 1")
										    }
										    else
										    {
												<#-- generate unique id for progress log -->
												var uniqueVisWidget = $.PALM.utility.generateUniqueId();
					
										    	$.PALM.popUpMessage.create( "Executing clustering algorithm ", { uniqueId:uniqueVisWidget, popUpHeight:40, directlyRemove:false , polling:false});
											     
											    url = "<@spring.url '/explore/clusterAlternateAlgo' />"+"?dataSetIds="+data.dataSet+"&type="+objectType+"&visType="+visType+"&algo="+algo+"&idList="+ids+"&seedVal="+seedVal+"&noOfClustersVal="+noOfClustersVal+"&foldsVal="+foldsVal+"&iterationsVal="+iterationsVal;
				
										    	$.getJSON( url , function( data ) 
										    	{
										    		$.PALM.popUpMessage.remove( uniqueVisWidget );
													if( data == 0 || data == null )
													{
														$.PALM.callout.generate( tabGroupContainer , "warning", "No data found!!", "No authors satisfy the specified criteria!" );
														return false;
													}
													else
													{
														var clustersContainer = $( widgetElem ).find( ".clusters" );
														clustersContainer.html("");
														if(visType == "researchers")
															visualizeCluster(data.coauthors, mainWidget, visType);
														if(visType == "conferences")
															visualizeCluster(data.conferences, mainWidget, visType);
														if(visType == "publications")
															visualizeCluster(data.publications, mainWidget, visType);
														
														if( $( "#seed" ).val() == "" )
															$( "#seed" ).val(data.seedVal) 
														if( $( "#no_of_clusters" ).val() == "" )
															$( "#no_of_clusters" ).val(data.noOfClustersVal) 
														if( $( "#folds" ).val() == "" )
															$( "#folds" ).val(data.foldsVal) 
														if( $( "#iterations" ).val() == "" )
															$( "#iterations" ).val(data.iterationsVal) 
										    		}
										    	});
										    }	
									    })
									)						
			
	 seed = $( '<span/>' ).html("Seed:")
						.append('&nbsp;')
						.append(
							$('<input/>')
							.attr("id" , "seed")
							.addClass('text-field-cluster')
							.attr("value", data.seedVal)
							.bind('keyup paste', function()
							{
						        this.value = this.value.replace(/[^0-9]/g, '')
							})
						 )
						 
	var cl_name = "Clusters:"					 
	if(data.algo == "X-Means")
		cl_name = "Min. clusters:"
		
	 no_of_clusters = $( '<span/>' ).html(cl_name)
						.append('&nbsp;')
						.append(
							$('<input/>')
							.attr("id" , "no_of_clusters")
							.addClass('text-field-cluster')
							.attr("value", data.noOfClustersVal)
							.attr("min","0")
							.attr("max","20")
							.bind('keyup paste', function(){
						        this.value = this.value.replace(/[^0-9]/g, '')
							})
						 )
			
	 folds = $( '<span/>' ).html("Folds:")
							.append('&nbsp;')
							.append(
								$('<input/>')
								.attr("id" , "folds")
								.addClass('text-field-cluster')
								.attr("value", data.foldsVal)
								.bind('keyup paste', function()
								{
							        this.value = this.value.replace(/[^0-9]/g, '')
								})
							 )
			
	 iterations = $( '<span/>' ).html("Iterations:")
								.append('&nbsp;')
								.append(
									$('<input/>')
									.attr("id" , "iterations")
									.addClass('text-field-cluster')
									.attr("value", data.iterationsVal)
									.bind('keyup paste', function()
									{
								        this.value = this.value.replace(/[^0-9]/g, '')
									})
								 )
			
	tabContent.append(clustering_div);
	clustering_div.append(cluster_type);
	clustering_div.append(cluster_type_options);
	clustering_div.append(cluster_type_options_apply);
	clusteringOptionsFields(cluster_type_options, "K-Means")
			
	var cluster_drop_down = $( widgetElem ).find( "#cluster_type" );
	var sel_cluster_type = document.getElementById('cluster_type');
	sel_cluster_type.onchange = function() 
								{
									var cluster_type_val = cluster_drop_down.val();
									cluster_type_options.html("")
									clusteringOptionsFields(cluster_type_options, cluster_type_val)	
								}
	return tabContent;
}
	
function clusteringOptionsFields(cluster_type_options, cluster_type_val)
{
	if(cluster_type_val == "K-Means")
	{
		cluster_type_options.append(seed);
		cluster_type_options.append(no_of_clusters);
	}	
	if(cluster_type_val == "X-Means")
	{
		cluster_type_options.append(seed);
		cluster_type_options.append(no_of_clusters);
		cluster_type_options.append(iterations);
	}
	if(cluster_type_val == "EM")
	{
		cluster_type_options.append(seed);
		cluster_type_options.append(iterations);
		cluster_type_options.append(folds);
	}
	if(cluster_type_val == "Hierarchical")
	{
		cluster_type_options.append(no_of_clusters);
	}
	if(cluster_type_val == "FarthestFirst")
	{
		cluster_type_options.append(seed);
		cluster_type_options.append(no_of_clusters);
	}

	return cluster_type_options;
}