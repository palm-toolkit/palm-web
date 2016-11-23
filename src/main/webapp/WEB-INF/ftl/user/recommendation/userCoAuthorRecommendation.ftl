<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<div class="coAuthor-box-filter" style="width:450px !important;center !important;">
		<div class="coAuthor-box-filter-option" ></div>
		<button class="btn btn-block btn-default coAuthor-box-filter-button btn-xs" onclick="$( this ).prev().slideToggle( 'slow' )">
			<i class="fa fa-filter pull-left"></i>
			<span>Algorithm</span>
		</button>
	</div>
  	<div class="coauthor-content-graph" style="height:750px !important;">
    </div>
</div>

<script>

		<#-- generate unique id for progress log -->
		var uniquePidRecommendationCloud = $.PALM.utility.generateUniqueId();
		
		var coAlgorithmID = "interest";
		
		var allNodes = [];
		var allLinks = [];
		
	function CoAuthors(){
		
		<#-- generate unique id for progress log -->
		var uniquePidRecommendationCloud = $.PALM.utility.generateUniqueId();
		
	<#-- unique options in each widget -->
		var options = {
			source : "<@spring.url '/user/recommendation?requestStep=1&creatorId=publication&query=' />",
			query: "",
			queryString : coAlgorithmID,
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Extracting recommendations", { uniqueId:uniquePidRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
						},
			onRefreshDone: function(  widgetElements, data  ){
			
				allNodes = [];
				allLinks = [];
				
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				var target = $( widgetElements ).find( ".coauthor-content-graph" );
				var targetContainerFilter = $( widgetElements ).find( ".coAuthor-box-filter" );
				
				<#-- remove previous graph -->
				target.html( "" );
				targetContainerFilter.show();
				targetContainerFilter.find( ".coAuthor-box-filter-option" ).html( "" );
				targetContainerFilter.find( ".coAuthor-box-filter-button" ).find( "span" ).html( "Recommendation Algorithm" );
							
							
				var $pageDropdown = $( widgetElements ).find( "select.page-number" );
				$pageDropdown.find( "option" ).remove();
				
				<#-- create dropdown algorithm profile -->
							var algorithmProfileDropDown = 
								$( '<select/>' )
								.attr({ "id": "algorithm_profile"})
								.addClass( "selectpicker btn-xs" )
								.css({ "max-width": "210px"})
								.on( "change", function(){ getCoAuthorRecommendationAlogrithm( $( this ).val() ) } );
								
							<#-- interest algorithm profile container -->
							var algorithmProfileContainer = 
								$( "<div/>" )
								.css({ "margin":"0 10px 0 0"})
								.append(
									$( "<span/>" ).html( "Algorithm : " )
								).append(
									algorithmProfileDropDown
								);
							
							<#-- append to container -->
							targetContainerFilter.find( ".coAuthor-box-filter-option" ).append( algorithmProfileContainer );
							
							getCoAuthorRecommendationAlogrithm("");
							
function getCoAuthorRecommendationAlogrithm ( algo ) {
	if( algo == "" )
	{
		algorithmProfileDropDown.html( "" );
		
		algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : "interest"  })
								.html( "Interest Network" )
							);
		algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : "c3d"  })
								.html( "3D Co-Author Network" )
							);
		algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : "c2d"  })
								.html( "2D Co-Author Network" )
							);
	}
	else {
		algorithmID = algo;
		$.PALM.popUpMessage.create( "Extracting recommendations", { uniqueId:uniquePidRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
				
		$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation?requestStep=4&creatorId=publication&query=' />" + algo,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( cdata ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				if (cdata.coauthor_recommendation.count > 0) {
					//console.log("console recommendation:", cdata.pub_recommendation.count);
					target.html( "" );
					updatecoAuthorRecommendation(cdata.pub_recommendation);
				}
			}
		});
	}
	algorithmProfileDropDown.selectpicker( 'refresh' );
}
							//updatecoAuthorRecommendation(data.pub_recommendation);
							
							if (data.pub_recommendation.count > 0) {
													
		$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation?requestStep=2&creatorId=publication&query=' />" + coAlgorithmID,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( c2data ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				if (c2data.pub_recommendation.count > 0) {
					//console.log("console recommendation:", c2data.pub_recommendation.count);
					target.html( "" );
					//updatecoAuthorRecommendation(c2data.pub_recommendation);
					

<#--$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation?requestStep=3&creatorId=publication&query=' />" + coAlgorithmID,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( c3data ){
				<#-- remove  pop up progress log 
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				if (c3data.pub_recommendation.count > 0) {
					//console.log("console recommendation:", cdata.pub_recommendation.count);
					target.html( "" );
					updatecoAuthorRecommendation(c3data.pub_recommendation);-->	

$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation?requestStep=4&creatorId=publication&query=' />" + coAlgorithmID,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( c4data ){
				<#-- remove  pop up progress log -->	
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				if (c4data.pub_recommendation.count > 0) {
					//console.log("console recommendation:", cdata.pub_recommendation.count);
					target.html( "" );
					//updatecoAuthorRecommendation(c4data.pub_recommendation);
					
					
				<#-- Updating the test recommendation widget -->
				//updateTestRecommendations();
				}
			}
		});	

					
				<#--}
			}
		});-->				

				}
			}
		});
								
			
		
		}
							
function updatecoAuthorRecommendation(pub_data) {
				if( allNodes.length > 0 || pub_data.count > 0 ){
					
					if ( allNodes.length <= 0 ) {
						allNodes = pub_data.nodes;
						allLinks = pub_data.links;
					} else {
						allNodes = allNodes.concat(pub_data.nodes);
						allLinks = allLinks.concat(pub_data.links);
					}
								var width = target.width();
								var height = target.height();
								var color = d3.scale.category20();
								var fill = d3.scale.category10();
								var focus_node = null, highlight_node = null;
								
								var text_center = false;
								var outline = false;
	
								var min_score = 0;
								var max_score = 1;

								//var color = d3.scale.linear()
								//  .domain([min_score, (min_score+max_score)/2, max_score])
								//  .range(["lime", "yellow", "red"]);
								
								var highlight_color = "blue";
								var highlight_trans = 0.1;
								
								var size = d3.scale.pow().exponent(1)
								  .domain([1,100])
								  .range([8,24]);

								var force = d3.layout.force()
								  .linkDistance(60)
								  .charge(-30)
								  //.gravity(0)
    							  //.charge(0)
								  .size([width,height]);
								  
								var default_node_color = "#ccc";
								//var default_node_color = "rgb(3,190,100)";
								var default_link_color = "#888";
								var nominal_base_node_size = 8;
								var nominal_text_size = 15;
								var max_text_size = 24;
								var nominal_stroke = 1.5;
								var max_stroke = 4.5;
								var max_base_node_size = 36;
								var min_zoom = 0.1;
								var max_zoom = 3;

								var projection = d3.geo.mercator()
								  					.center([(width) / 2, (height)/2	])
								  					.scale(50000)
								  					.translate([(width) / 2, (height)/2]);
								
								var path = d3.geo.path()
											.projection(projection);
								
								//var zoom = d3.behavior.zoom()
								//   	 				.translate(projection.translate())
								//   	 				.scale(projection.scale())
								//   	 				.scaleExtent([50000, 50000])
								//   	 				.on("zoom", zoomed);

								var svg = d3.selectAll( ".coauthor-content-graph" )
									  .append("div")
								      .classed("svg-container", true) //container class to make it responsive
									  .append("svg:svg")
									  .attr("width", width)
									  .style("height", height)
									  //responsive SVG needs these 2 attributes and no width and height attr
								   	  .attr("preserveAspectRatio", "xMinYMin meet")
								      //.attr("viewBox", "0 0 " + width + " " + height + 'px')
								      //class to make it responsive
								      .classed("svg-content-responsive", true);
								      //.style("cursor","move")
									  //.call(zoom)
									  //.append("g");
								$("svg").css({top: 0, left: 0, position:'absolute'});
								var zoom = d3.behavior.zoom().scaleExtent([min_zoom,max_zoom])
								var g = svg.append("g");
								svg.style("cursor","move");
								
								//update(data.coauthor_recommendation);
																
function zoomed() {
  svg.attr("transform", "translate(" + d3.event.translate + ")");
}

//function update(pub_data) {

      						//var force = d3.layout.force()
							//				    .nodes(pub_data.nodes)
							//				    .links(pub_data.links)
							//				    .on("tick", ticked)
							//				    .size([width, height])
							//				    .start();
							//force.linkDistance(height/2);
							
								var linkedByIndex = {};
							    pub_data.links.forEach(function(d) {
									linkedByIndex[d.source + "," + d.target] = true;
							    });
							    
							    function isConnected(a, b) {
							        return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index] || a.index == b.index;
							    }
							
								function hasConnections(a) {
									for (var property in linkedByIndex) {
											s = property.split(",");
											if ((s[0] == a.index || s[1] == a.index) && linkedByIndex[property])
												return true;
									}
									return false;
								}
															    
								force
								    .nodes(pub_data.nodes)
								    .links(pub_data.links)
								    .start();
								    
								var drag = d3.behavior.drag()
								    .origin(function(d) { return d; })
								    .on("dragstart", dragstarted)
								    .on("drag", dragged)
								    .on("dragend", dragended);
								    
								var groups = d3.nest()
											  .key(function(d) { return d.group; })
											  .map(pub_data.nodes)
																
								//node.append("title")
      							//	.text(function(d) { return d.title; });
      							
      							//link = svg.append("svg:g")
      							//	.selectAll(".link")
      							//	.data(pub_data.links)
      							//	.enter().append("line")
    							//	.attr("class", "link")
    							//	.style("stroke-width",1.5)
								//	.style("stroke", function(d) { 
								//		return color(d.group);
								//	})
								//	.call(force.drag);
								
								var link = g.selectAll(".link")
								    .data(pub_data.links)
								    .enter().append("line")
								    .attr("class", "link")
									.style("stroke-width",nominal_stroke)
									.style("stroke", function(d) { 
									if (isNumber(d.group) && d.group>=0) return color(d.group);
									else return default_link_color; })
      							
      							nodeco = g//.append("svg:g")
	  								//.attr("class", "center_group")
	  								.selectAll(".node")
									.data(pub_data.nodes)
									.enter()
									.append("g")
									.attr("class", "node")
								    //.attr("cx", function(d) { console.log("cx: ", ((d.group * 10) % 5));
								    //return ((d.group * 10) % 5); })
								    //.attr("cy", function(d) { return d.y; })
									//.attr("id", function(d){ return d.id })
									//.attr("r", function (d){ return d.group/1500 || 5;})
    								//.style("fill", function(d, i) { return fill(d.group/1500 || 5); })
    								//.style("stroke", function(d, i) { return d3.rgb(fill(i || 3)).darker(2); })
    								//each(function(d) { console.log("cx: ", ((d.group * 10) % 5));
								    //return ((d.group * 10) % 5); })
								    //.each(function(d) {
									//		//d.y += (d.y) * alpha;
									//		d.x += ((d.group) % 11);})
									.call(force.drag);
									<#--.attr("transform", function(d) { return "translate(" + d.group/1500*d.id + ")"; })
									.call(d3.behavior.drag()
									          .on("drag", dragmove)); 
								nodeco.on("dblclick.zoom", function(d) { d3.event.stopPropagation();
									var dcx = (width/2-d.x*zoom.scale());
									var dcy = (height/2-d.y*zoom.scale());
									zoom.translate([dcx,dcy]);
									 g.attr("transform", "translate("+ dcx + "," + dcy  + ")scale(" + zoom.scale() + ")");
									});-->
									
      							var tocolor = "fill";
								var towhite = "stroke";
								if (outline) {
									tocolor = "stroke"
									towhite = "fill"
								}
      							
      							//svg.style("opacity", 1e-6)
								//  .transition()
								//    .duration(1000)
								//    .style("opacity", 1);
      							
      							  var circle = nodeco.append("path")
									.attr("d", d3.svg.symbol()
									.size( 200 ) //function(d) { return Math.PI*Math.pow(size(d.group)||nominal_base_node_size,2); })
									.type(function(d) { return d.type; }))
									.style(tocolor, function(d) {
										if (isNumber(d.group)) return color(d.group*10);
										else return default_node_color; 
									})
									//.attr("r", function(d) { return size(d.size)||nominal_base_node_size; })
									.style("stroke-width", nominal_stroke)
									.style(towhite, "white");
									
								var text = g.selectAll(".text")
								    .data(pub_data.nodes)
								    .enter().append("text")
								    .attr("dy", ".35em")
									.style("font-size", nominal_text_size + "px")
								if (text_center)
									text.text(function(d) {
										if(d.type == 'square') 
											return d.title; 
									})
										.style("text-anchor", "middle");
								else 
									text.attr("dx", function(d) {return (size(d.group)||nominal_base_node_size);})
										.text(function(d) { 
										if(d.type == 'square') 
											return d.title; 
										});
								
								//Toggle stores whether the highlighting is on
								var toggle = 0;
								
								nodeco
									.on("dblclick", function(d) { //d3.event.stopPropagation();
										  	focus_node = d;
											set_focus(d)
											if (toggle == 0){
												set_highlight(d);
												toggle = 1;
											} else {
												exit_highlight();
												toggle = 0;
											}
										});
									<#--.on("mouseover", function(d) {
											set_highlight(d);
										})
									.on("mouseout", function(d) {
											exit_highlight();
										});-->
								
								d3.selectAll( ".coauthor-content-graph" ).on("mouseup",  
									function() {
										if (focus_node!==null)
										{
											focus_node = null;
											if (highlight_trans<1)
											{
												circle.style("opacity", 1);
								  				text.style("opacity", 1);
								  				link.style("opacity", 1);
											}
										}
										if (highlight_node === null) exit_highlight();
									});
          						
          						function exit_highlight()
								{
									highlight_node = null;
									if (focus_node===null)
									{
										svg.style("cursor","move");
										if (highlight_color!="white")
									{
								  	circle.style(towhite, "white");
									text.style("font-weight", "normal")
										.text(function(d) {
										if(d.type == 'square') 
											return d.title; 
										});
									link.style("stroke", function(o) {return (isNumber(o.group) && o.group>=0)?color(o.group):default_link_color});
								 		}	
									}
								}
          						
          						function set_focus(d)
								{	
									if (highlight_trans<1)  {
									    circle.style("opacity", function(o) {
									    	return isConnected(d, o) ? 1 : highlight_trans;
									    });
										text.style("opacity", function(o) {
									    	return isConnected(d, o) ? 1 : highlight_trans;
									    })
									    	.text(function(d) { return '\u2002'+d.title; });		
									    link.style("opacity", function(o) {
									    	return o.source.index == d.index || o.target.index == d.index ? 1 : highlight_trans;
									    });		
									}
								}
          						
          						function set_highlight(d)
								{
									svg.style("cursor","pointer");
									if (focus_node!==null) d = focus_node;
									highlight_node = d;
								
									if (highlight_color!="white")
									{
										circle.style(towhite, function(o) {
								                return isConnected(d, o) ? highlight_color : "white";});
										text.style("font-weight", function(o) {
								                return isConnected(d, o) ? "bold" : "normal";});
								        link.style("stroke", function(o) {
											return o.source.index == d.index || o.target.index == d.index ? highlight_color : ((isNumber(o.group) && o.group>=0)?color(o.group):default_link_color);
											});
									}
								}
								
								
								  zoom.on("zoom", function() {
  
									var stroke = nominal_stroke;
									if (nominal_stroke*zoom.scale()>max_stroke) stroke = max_stroke/zoom.scale();
									link.style("stroke-width",stroke);
									circle.style("stroke-width",stroke);
										   
									var base_radius = nominal_base_node_size;
									if (nominal_base_node_size*zoom.scale()>max_base_node_size) base_radius = max_base_node_size/zoom.scale();
									circle.attr("d", d3.svg.symbol()
										.size( 200 )//function(d) { return Math.PI*Math.pow(size(d.group)*base_radius/nominal_base_node_size||base_radius,2); })
										.type(function(d) { return d.type; }))
											
										//circle.attr("r", function(d) { return (size(d.size)*base_radius/nominal_base_node_size||base_radius); })
									if (!text_center) text.attr("dx", function(d) { return (size(d.group)*base_radius/nominal_base_node_size||base_radius); });
										
									var text_size = nominal_text_size;
									if (nominal_text_size*zoom.scale()>max_text_size) text_size = max_text_size/zoom.scale();
									text.style("font-size",text_size + "px");
									
									g.attr("transform", "translate(" + d3.event.translate + ")"); //scale(" + d3.event.scale + ")
								});
          						
          						svg.call(zoom);
          						resize();
          						
          						d3.selectAll( ".coauthor-content-graph" ).on("resize", resize);
								
          						force.on("tick", function(e) {  	
									nodeco.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									text.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									  
									<#--var k = e.alpha * .1;
									nodeco.each(function(n) {
									    var center = groups[n.group][0];
									    console.log("center: ", center);
									    n.x += (center.x - n.x) * k;
									    n.y += (center.y - n.y) * k;
									});-->
									
									link.attr("x1", function(d) { return d.source.x; })
										.attr("y1", function(d) { return d.source.y; })
										.attr("x2", function(d) { return d.target.x; })
										.attr("y2", function(d) { return d.target.y; });
									
									var alpha = .2 * e.alpha;
									nodeco
										.attr("cx", function(d) { return d.x; })
										.attr("cy", function(d) { return d.y; });
										//.each(function(d) {
										//				    d.y += (d.y) * alpha;
										//				    d.x += (d.x) * alpha;
										//				  });
										
																            
							      //recCircle
								  //	.each(gravity(.2 * e.alpha));
								  //    .each(collide(.5))
								  //    .attr("cx", function(d) { return d.x; })
								  //    .attr("cy", function(d) { return d.y; });
								});
								function resize() {
								    var w = window.innerWidth, h = window.innerHeight;
									svg.attr("width", w).attr("height", h);
								    
									force.size([force.size()[0]+(w-width)/zoom.scale(),force.size()[1]+(h-height)/zoom.scale()]).resume();
								    width = w;
									height = h;
								}
								
								function isNumber(n) {
								  return !isNaN(parseFloat(n)) && isFinite(n);
								}	
								
function dragmove(d) {
  var x = d3.event.x;
  var y = d3.event.y;
  d3.select(this).attr("transform", "translate(" + x + "," + y + ")");
}
									
								<#-- var simulation = d3.forceSimulation()
									.force("link", d3.forceLink().id(function(d) { return d.id; }))
									.force("charge", d3.forceManyBody())
    								.force("center", d3.forceCenter(width / 2, height / 2));
								
								d3.json(data.pub_recommendation, function(error, graph) {
									if(error) throw error;
									
									var node = svg.append("svg:g")
										.attr("class", "nodes")
										.selectAll("circle")
										.data(data.pub_recommendation.nodes)
										.enter().append("circle")
										.attr("r", 5)
										.attr("fill", function(d) { return color(d.group); });
										
									node.append("title")
      									.text(function(d) { return d.title; });
      									
      								simulation
      									.nodes(graph.nodes)
      									.on("tick", ticked);
      									
      								function ticked() {

									    node
									        .attr("cx", function(d) { return d.x; })
									        .attr("cy", function(d) { return d.y; });
									}
								}); -->
								
								<#--function dragstarted(d) {
								  if (!d3.event.active) simulation.alphaTarget(0.3).restart();
								  d.fx = d.x;
								  d.fy = d.y;
								}
								
								function dragged(d) {
								  d.fx = d3.event.x;
								  d.fy = d3.event.y;
								}
								
								function dragended(d) {
								  if (!d3.event.active) simulation.alphaTarget(0);
								  d.fx = null;
								  d.fy = null;
								} -->
								function dragstarted(d) {
								  d3.event.sourceEvent.stopPropagation();
								  d3.select(this).classed("dragging", true);
								}
								
								function dragged(d) {
								  d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
								}
								
								function dragended(d) {
								  d3.select(this).classed("dragging", false);
								}
								
								// Move nodes toward cluster focus.
								function gravity(alpha) {
								  return function(d) {
								    d.y += (d.cy - d.y) * alpha;
								    d.x += (d.cx - d.x) * alpha;
								  };
								}
								
								var padding = 6, // separation between nodes
								    maxRadius = 12;
								
								// Resolve collisions between nodes.
								function collide(alpha) {
								  var quadtree = d3.geom.quadtree(link);
								  return function(d) {
								    var r = d.group + maxRadius + padding,
								        nx1 = d.x - r,
								        nx2 = d.x + r,
								        ny1 = d.y - r,
								        ny2 = d.y + r;
								    quadtree.visit(function(quad, x1, y1, x2, y2) {
								      if (quad.point && (quad.point !== d)) {
								        var x = d.x - quad.point.x,
								            y = d.y - quad.point.y,
								            l = Math.sqrt(x * x + y * y),
								            r = d.group + quad.point.radius + (d.color !== quad.point.color) * padding;
								        if (l < r) {
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
							}
							else{
								$.PALM.callout.generate( target, "warning", "No CoAuthor found." , "" );
							}
					}
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
		
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
	};
</script>