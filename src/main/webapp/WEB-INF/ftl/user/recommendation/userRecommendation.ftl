<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<table width="100%" border="0">
		<tr valign="top">
			<td>
				<div class="box-filter" style="width:450px !important; float: center !important;">
					<div class="box-filter-option" ></div>
					<button class="btn btn-block btn-default box-filter-button btn-xs" onclick="$( this ).prev().slideToggle( 'slow' )">
						<i class="fa fa-filter pull-left"></i>
						<span>Algorithm</span>
					</button>
				</div>
			  	<div class="content-graph" style="height:550px !important;">
			    </div>
			</td>
			<td width="50px" style="text-align: center; background-color: #fafafa;">
				<button type="button" onclick="togglePubTab()"  
				class="btn btn-block btn-default box-filter-button btn-xs"
				style="width:50px; height: 600px; float: right; margin-top: 0.5em;">
						Details
				</button>
			</td>
			<td id="pub_tab" width="20%" style="display: none; background-color: #fafafa;">
				<div id="pub_details" class="Scrollable" style="float: right; width: 450px; max-height: 600px; 
				padding: 8px; overflow-x: block; overflow-y: scroll;">	
				</div>
			</td>
    	</tr>
    </table>
</div>

<script>

function togglePubTab() {
	var tab = document.getElementById("pub_tab");
	$( tab ).slideToggle( 'fast' );
	//tab.style.display = (tab.style.display == "none") ? "table-cell" : "none";
}

$('.Scrollable').on('DOMMouseScroll mousewheel', function(ev) {
    var $this = $(this),
        scrollTop = this.scrollTop,
        scrollHeight = this.scrollHeight,
        height = $this.height(),
        delta = (ev.type == 'DOMMouseScroll' ?
            ev.originalEvent.detail * -40 :
            ev.originalEvent.wheelDelta),
        up = delta > 0;

    var prevent = function() {
        ev.stopPropagation();
        ev.preventDefault();
        ev.returnValue = false;
        return false;
    }

    if (!up && -delta > scrollHeight - height - scrollTop) {
        // Scrolling down, but this will take us past the bottom.
        $this.scrollTop(scrollHeight);
        return prevent();
    } else if (up && delta > scrollTop) {
        // Scrolling up, but this will take us past the top.
        $this.scrollTop(0);
        return prevent();
    }
});

	var algorithmID = "interest";
	function updateTestRecommendations(){
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/user/recommendation?requestStep=4&creatorId=co_authors&query=' />",
			query: "",
			queryString : algorithmID,
			page:0,
			maxresult:50,
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".content-graph" );
							var targetContainerFilter = $( widgetElem ).find( ".box-filter" );
							var detailsContainer = document.getElementById( "pub_details" );

							<#-- remove previous graph -->
							targetContainer.html( "" );
							targetContainerFilter.show();
							targetContainerFilter.find( ".box-filter-option" ).html( "" );
							targetContainerFilter.find( ".box-filter-button" ).find( "span" ).html( "Recommendation Algorithm" );
							
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							<#-- create dropdown algorithm profile -->
							var algorithmProfileDropDown = 
								$( '<select/>' )
								.attr({ "id": "algorithm_profile"})
								.addClass( "selectpicker btn-xs" )
								.css({ "max-width": "210px"})
								.on( "change", function(){ getRecommendationAlogrithm( $( this ).val() ) } );
								
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
							targetContainerFilter.find( ".box-filter-option" ).append( algorithmProfileContainer );
							
							getRecommendationAlogrithm("");
							
function getRecommendationAlogrithm ( algo ) {
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
			url : "<@spring.url '/user/recommendation?creatorId=publication&query=' />" + algo,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( cdata ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidRecommendationCloud );
				
				if (cdata.pub_recommendation.count > 0) {
					console.log("console recommendation:", cdata.pub_recommendation.count);
					targetContainer.html( "" );
					update(cdata.pub_recommendation);
				}
			}
		});
	}
	algorithmProfileDropDown.selectpicker( 'refresh' );
}
							update(data.pub_recommendation);
							
function update(pub_data) {
							if( pub_data.count > 0 ){
							
								var width = targetContainer.width();
								var height = targetContainer.height();
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
								  .linkDistance(50)
								  .charge(-300)
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

								var svg = d3.selectAll( ".content-graph" )
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
								
																
function zoomed() {
  svg.attr("transform", "translate(" + d3.event.translate + ")");
}

								
								//console.log("pub data: ", pub_data);
								//var edges = [];
								//pub_data.links.forEach(function(e) {
								//    var sourceNode = e.source.id,
								//        targetNode = e.target.id;
								//
								//    edges.push({
								//        source: sourceNode,
								//        target: targetNode,
								//        weight: e.weight
								//    });
								//});

								//console.log("edges data: ", edges);

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
								    .links(pub_data.links)
								    .nodes(pub_data.nodes)
								    .start();
								    
								var drag = d3.behavior.drag()
								    .origin(function(d) { return d; })
								    .on("dragstart", dragstarted)
								    .on("drag", dragged)
								    .on("dragend", dragended);
								    
								var groups = d3.nest()
											  .key(function(d) { return d.group; })
											  .map(pub_data.nodes);
								
								
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
      							
      							node = g//.append("svg:g")
	  								//.attr("class", "center_group")
	  								.selectAll(".node")
									.data(pub_data.nodes)
									.enter()
									.append("g")
									.attr("class", "node")
								    //.attr("cx", function(d) { return d.x; })
								    //.attr("cy", function(d) { return d.y; })
									//.attr("id", function(d){ return d.id })
									//.attr("r", function (d){ return d.group/1500 || 5;})
    								//.style("fill", function(d, i) { return fill(d.group/1500 || 5); })
    								//.style("stroke", function(d, i) { return d3.rgb(fill(i || 3)).darker(2); })
									.call(force.drag);
									<#--.attr("transform", function(d) { return "translate(" + d.group/1500*d.id + ")"; })
									.call(d3.behavior.drag()
									          .on("drag", dragmove)); -->
								node.on("dblclick.zoom", function(d) { d3.event.stopPropagation();
									var dcx = (width/2-d.x*zoom.scale());
									var dcy = (height/2-d.y*zoom.scale());
									zoom.translate([dcx,dcy]);
									 g.attr("transform", "translate("+ dcx + "," + dcy  + ")scale(" + zoom.scale() + ")");
									});
      							
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
      							
      							  var circle = node.append("path")
									.attr("d", d3.svg.symbol()
									.size(function(d) { return Math.PI*Math.pow(size(d.group)||nominal_base_node_size,2); })
									.type(function(d) { return d3.svg.symbolTypes[(d.type % d3.svg.symbolTypes.length)]; }))
									.style(tocolor, function(d) {
										if (isNumber(d.group) && d.group>=0) return color(d.group);
										else return default_node_color; })
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
										if(d.type == '3' || d.type == '2') 
											return d.title; 
									})
										.style("text-anchor", "middle");
								else 
									text.attr("dx", function(d) {return (size(d.group)||nominal_base_node_size);})
										.text(function(d) { 
										if(d.type == '3' || d.type == '2') 
											return d.title; 
										});
										
								node.on("mouseover", function(d) {
									//set_highlight(d);
									})
								  .on("mousedown", function(d) { d3.event.stopPropagation();
								  	focus_node = d;
									//set_focus(d)
									addPublicationDetails(d);
									if (highlight_node === null) set_highlight(d)
								}	).on("mouseout", function(d) {
										exit_highlight();
								}	);
								
								d3.selectAll( ".content-graph" ).on("mouseup",  
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
          						
          						function addPublicationDetails(d)
          						{
          							$( detailsContainer ).html( "" );
	          						var pubItem = $.grep( pub_data.publications, function( e ) { 
											return d.title == e.title; 
										} );
									
									<#-- If not publication, return -->
									if( pubItem[0] == null )
										return;
									
									<#-- Add title header -->
									var titleLabel = $( '<h3/>' )
											.addClass( "timeline-header" )
											.html( "Title: " );
									$( detailsContainer ).append( titleLabel );
          							
          							<#-- Add title content -->
									var cleanTitle = pubItem[0].title.replace(/[^\w\s]/gi, '');
									titleContent = $( '</p>' )
										.addClass( "timeline-header" )
										.append( "<strong><a href='<@spring.url '/publication' />?id=" + pubItem[0].id + "&title=" + cleanTitle +"'>" + pubItem[0].title + "</a></strong>" );
									$( detailsContainer ).append( titleContent );
									
									<#-- Add interest header -->
									var interestLabel = $( '<h3/>' )
											.addClass( "timeline-header" )
											.html( "Interest: " );
									$( detailsContainer ).append( interestLabel );
          							
          							<#-- Add interest content -->
									var cleanTitle = pubItem[0].title.replace(/[^\w\s]/gi, '');
									interestContent = $( '</p>' )
										.addClass( "timeline-header" )
										.html( "" + pubItem[0].interest );
									$( detailsContainer ).append( interestContent );
									
          							<#-- Add abstract -->
									if ( pubItem[0].abstract != null && pubItem[0].abstract != "null" )
									{
										<#-- Add abstract header -->
										var abstractLabel = $( '<h3/>' )
												.addClass( "timeline-header" )
												.html( "Abstract: " );
										$( detailsContainer ).append( abstractLabel );
										
	          							<#-- Add abstract content -->
										abstractContent = $( '</p>' )
											.addClass( "timeline-header" )
											.html( "" + pubItem[0].abstract );
										$( detailsContainer ).append( abstractContent );
									}
									
          							<#-- Add author -->
									if ( pubItem[0].author != null && pubItem[0].author != "null" )
									{
										<#-- Add author header -->
										var authorLabel = $( '<h3/>' )
												.addClass( "timeline-header" )
												.html( "Authors: " );
										$( detailsContainer ).append( authorLabel );
										
	          							<#-- Add author content -->
										authorContent = $( '</p>' )
											.addClass( "timeline-header" )
											.html( "" + pubItem[0].author );
										$( detailsContainer ).append( authorContent );
									}
									
          							<#-- Add keywords -->
									if ( pubItem[0].keywords != null && pubItem[0].keywords != "null" )
									{
										<#-- Add keywords header -->
										var keywordLabel = $( '<h3/>' )
												.addClass( "timeline-header" )
												.html( "Keyword(s): " );
										$( detailsContainer ).append( keywordLabel );
										
	          							<#-- Add keywords content -->
										keywordContent = $( '</p>' )
											.addClass( "timeline-header" )
											.html( "" + pubItem[0].keyword );
										$( detailsContainer ).append( keywordContent );
									}
									
									<#-- Show the detail panel -->
									var tab = document.getElementById("pub_tab");
									$( tab ).show();
								}
          						
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
										if(d.type == '3' || d.type == '2') 
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
										.size(function(d) { return Math.PI*Math.pow(size(d.group)*base_radius/nominal_base_node_size||base_radius,2); })
										.type(function(d) { return d3.svg.symbolTypes[(d.type % d3.svg.symbolTypes.length)]; }))
											
										//circle.attr("r", function(d) { return (size(d.size)*base_radius/nominal_base_node_size||base_radius); })
									if (!text_center) text.attr("dx", function(d) { return (size(d.group)*base_radius/nominal_base_node_size||base_radius); });
										
									var text_size = nominal_text_size;
									if (nominal_text_size*zoom.scale()>max_text_size) text_size = max_text_size/zoom.scale();
									text.style("font-size",text_size + "px");
									
									g.attr("transform", "translate(" + d3.event.translate + ")"); //scale(" + d3.event.scale + ")
								});
          						
          						svg.call(zoom);
          						resize();
          						
          						d3.selectAll( ".content-graph" ).on("resize", resize);
          						
          						force.on("tick", function() {  	
									node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									text.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									  
									link.attr("x1", function(d) { return d.source.x; })
										.attr("y1", function(d) { return d.source.y; })
										.attr("x2", function(d) { return d.target.x; })
										.attr("y2", function(d) { return d.target.y; });
											
									node.attr("cx", function(d) { return d.x; })
										.attr("cy", function(d) { return d.y; });
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
								function ticked(e) {

								  // Push different nodes in different directions for clustering.
								  <#-- var k = 6 * e.alpha;
								  nodes.forEach(function(o, i) {
								    o.y += i & 1 ? k : -k;
								    o.x += i & 2 ? k : -k;
								  });
								
								  var k = e.alpha * .1;
								  pub_data.nodes.forEach(function(n) {
								    var center = groups[n.group][0];
								    n.x += (center.x - n.x) * k * .5;
								    n.y += (center.y - n.y) * k;
								  });--> 
								  node.attr("cx", function(d) { return d.x; })
								      .attr("cy", function(d) { return d.y; }); 
								      
								  link.attr('x1', function(d) { return d.source.x; })
							            .attr('y1', function(d) { return d.source.y; })
							            .attr('x2', function(d) { return d.target.x; })
							            .attr('y2', function(d) { return d.target.y; });
								}

								<#--function ticked() {
								    node
								        .attr("cx", function(d) { return d.x; })
								        .attr("cy", function(d) { return d.y; });
								} -->

							}
							else{
								$.PALM.callout.generate( targetContainer, "warning", "No publication found." , "" );
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