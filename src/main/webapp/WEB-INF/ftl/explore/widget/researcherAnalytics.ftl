<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_researchers" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_network">
				<a href="#tab_network" data-toggle="tab" aria-expanded="true">
					Network
				</a>
			</li>
			<li id="header_group">
				<a href="#tab_group" data-toggle="tab" aria-expanded="true">
					Group
				</a>
			</li>
			<li id="header_researcher_list">
				<a href="#tab_researcher_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_researcher_comparison">
				<a href="#tab_researcher_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_network" class="tab-pane">
				<div id="canvas"></div>
			</div>
			<div id="tab_group" class="tab-pane">
				<div id="legend" style="width: 25%; float:left">
				</div>
	
				<div id="clusters" style="width: 75%; float:right">
				</div>			
			</div>
			<div id="tab_researcher_list" class="tab-pane" active>
				<div class="content-list">
				</div>
			</div>
			<div id="tab_researcher_comparison" class="tab-pane">
			</div>
        </div>
	</div>
</div>
<style>
#tab_network {
	  width: 50vw;
	  height: 35vh;
	  position: relative;
}    

#canvas {
      color: #fff;
      background: #fff;
	  position: absolute;
	  width: 100%;
	  height: 100%;
}
.label {
      position: absolute;
      top: 10px;
      left: 10px;
      z-index: 1;
      font-family: sans-serif;
    }
</style>
<script>
	$( function(){
	
			<#-- add slimscroll to widget body -->
		$("#boxbody-${wUniqueName} #tab_va_researchers").slimscroll({
			height: "40vh",
	        size: "5px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });
	
	
		<#-- initialize sigma.js renderer for gephi-->
			s = new sigma({
	            renderer: {
	              container: document.getElementById('canvas'),
	              type: 'canvas'
	            },
	            settings: sigma.setting
	        });
	

		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();
		
		id="none";
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/explore/coAuthorsGephi' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading Researchers...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){	
			<#-- switch tab -->
			$('a[href="#tab_group"]').tab('show');
				
			<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidResearcherWidget );
			
				var tabContainer = $( widgetElem ).find( "#boxbody-${wUniqueName}" ).find( ".nav-tabs-custom" );
				
				var researcherLegend = $( widgetElem ).find( "#legend" ).first();
				researcherLegend.html("");
				
				var researcherClusters = $( widgetElem ).find( "#clusters" ).first();
				researcherClusters.html("");
				
				
				<#-- gephi network -->
				url = "<@spring.url '/resources/gexf/'/>" + data.filename;
				console.log("file received: " + data.filename);
	
				sigma.parsers.gexf( url ,s,function() {
					s.refresh();
					s.bind('clickNode', function(e){
						console.log(e.type, e.data.node.label, e.data.captor.ctrlKey);
					})
				}); 
				s.refresh();
	
				url="";


				<#-- Cluster Tab -->

				var url1 = "<@spring.url '/explore/coAuthorsCluster' />"+"?id="+id;

				console.log("ID ID ID ID : "+ id);

				$.getJSON( url1 , function( data ) {
  							
  					console.log(data.coauthors);
  					
  					vis_researcherualizeClusters(data.coauthors, tabContainer);
  							
				}); <#-- json-->
				
				<#-- List Tab -->
				$.getJSON( "<@spring.url '/explore/researchers' />" , function( data ) {
				
  							var targetContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );

							<#-- remove previous list -->
							targetContainer.html( "" );
  							
							<#-- callout -->
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no researchers found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'author' )
										.attr({ 'id' : item.id });
										
									var researcherNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var researcherDetail =
									$( '<div/>' )
										.addClass( 'detail' )
										.append(
											$( '<div/>' )
												.addClass( 'name' )
												.html( item.name )
										);
										
									researcherDiv
										.append(
											researcherNav
										).append(
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDiv.css("display","none");
										data.count--;
									}
									
									if( typeof item.status != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'status' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-briefcase icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.status )
											)
										);
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);
									if( typeof item.publicationsNumber != 'undefined'){
										var citedBy = 0;
										if( typeof item.citedBy !== "undefined" )
											citedBy = item.citedBy;
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + citedBy )
										);
									}
										
									if( typeof item.photo != 'undefined'){
										researcherNav
											.append(
											$( '<div/>' )
												.addClass( 'photo' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.photo })
												)
											);
									} else {
										researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									}

									targetContainer
										.append( 
											researcherDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = researcherDiv.find( "img:first" );
											if( imageAuthor.width() > 30 )
												imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);
									

								}); <#-- for each-->
							} <#-- if-->
						}); <#-- json-->
				
				
				}
		};
		
		function vis_researcherualizeClusters(data, tabContainer){
		
			var margin = {top: -5, right: -5, bottom: -5, left: -5};
			
			var color = d3.scale.ordinal()
    						.range(customColors); 
    
			var width = tabContainer.width()* 2;
			var height = width/1.5;
		
			var zoom = d3.behavior.zoom()
						.scaleExtent([-10, 10])
						.on("zoom", zoomed);
						
			clusters = new Array(getClusters(data));      
			
			nodes = data.map(function(d) {
				  var ind = d.cluster,
			      r = 20,
			      new_data = {cluster: ind, radius: r, name: d.name, clusterTerms : d.clusterTerms};
				  if (!clusters[ind]) {clusters[ind] = new_data;}
				  return new_data;
				});
				
			
			d3.layout.pack()
			    .sort(null)
			    .size([width, height])
			    .children(function(d) { return d.values; })
			    .value(function(d) { return d.radius * d.radius; })
			    .nodes({values: d3.nest()
			      .key(function(d) { return d.cluster; })
			      .entries(nodes)});	
				
			force = d3.layout.force()
							.nodes(nodes)
						    .size([width, height/2.5])
						    .gravity(0.02) 
						    .charge(0)
						    .on("tick", tick)
						    .start();

			var legend = d3.select("#legend").append("svg")

			// again rebind for legend
			var legendG = legend.selectAll(".legend") 
			  .data(clusters)
			  .enter().append("g")
			  .attr("transform", function(d,i){
			    return "translate(" + (5) + "," + (i * 15 + 20) + ")"; // place each legend on the right and bump each one down 15 pixels
			  })
			  .attr("class", "legend");   
			
			legendG.append("rect") // make a matching color rect
			  .attr("width", 10)
			  .attr("height", 10)
			  .attr("fill", function(d, i) {
			    return color(d.cluster);
			  });
			
			legendG.append("text") // add the text
			  .text(function(d){
			  console.log("clusterTerms: " + d.clusterTerms);
			    return d.clusterTerms;
			  })
			  // .style("font-size", 6)
			  .attr("y", 10)
			  .attr("x", 14);
						

			vis_researcher = d3.select("#clusters")
					  .append("div")
				      .classed("svg-container", true)
				      .call(zoom) //container class to make it responsive
					  .append("svg:svg")
				   	  .attr("preserveAspectRatio", "xMinYMin meet")
				      .attr("viewBox", "0 0 " + width + " " + height)
				      .classed("svg-content-responsive", true)
				      .classed( "researcher_cluster", true);
			
			var rect2 = vis_researcher.append("rect")
						    .attr("width", width)
						    .attr("height", height)
						    .style("fill", "none")
						    .style("pointer-events", "all");
		
			
		
			node = vis_researcher.selectAll(".node")
					      .data(nodes)
					      .enter().append("circle")
						  .style("fill", function(d) { return color(d.cluster); })
						  .on("click",function(d){console.log("clicked:"+d.cluster);})
			
			node.append("title")
			      .text(function(d) { return d.name; });
			
			node.transition()
			    .duration(750)
			    .delay(function(d, i) { return i * 5; })
			    .attrTween("r", function(d) {
			      var i = d3.interpolate(0, d.radius);
			      return function(t) { return d.radius = i(t); };
			    });
			    
		    groups = d3.nest().key(function(d) { return d.cluster }).entries(nodes);

			console.log(groups.length);
			groupPath = function(d) {
			   var fakePoints = [];
			    if (d.values.length == 2)
			    {
			        //[dx, dy] is the direction vector of the line
			        var dx = d.values[1].x - d.values[0].x;
			        var dy = d.values[1].y - d.values[0].y;
			
			        //scale it to something very small
			        dx *= 0.00001; dy *= 0.00001;
			
			        //orthogonal directions to a 2D vector [dx, dy] are [dy, -dx] and [-dy, dx]
			        //take the midpoint [mx, my] of the line and translate it in both directions
			        var mx = (d.values[0].x + d.values[1].x) * 0.5;
			        var my = (d.values[0].y + d.values[1].y) * 0.5;
			        fakePoints = [ [mx + dy, my - dx],
			                      [mx - dy, my + dx]];
			        //the two additional points will be sufficient for the convex hull algorithm
			    }
			       
			   return "M" + d3.geom.hull(d.values.map(function(d) { return [d.x, d.y]; })
			       .concat(fakePoints))  //do not forget to append the fakePoints to the group data
			       .join("L") + "Z";
			};
			
			
			groupFill = function(d,i) { return color(d.values[0].cluster); };
					    
	    
					      		  
		}
		
		function getClusters(data){
		var groups = [];
		
		      for(var i=0; i<data.length; i++){
		          if(groups.indexOf(data[i].cluster) == -1){
		                  groups.push(data[i].cluster);
		          }
		      }
		  return groups.length;
		}
		
		function tick(e) {
		  node
		     .each(cluster(10 * e.alpha * e.alpha))
		      .each(collide(.5))
		      .attr("cx", function(d) { return d.x; })
		      .attr("cy", function(d) { return d.y; });
		      
		      
		         vis_researcher.selectAll("path")
    .data(groups)
      .attr("d", groupPath)
    .enter().insert("path", "circle")
      .style("fill", groupFill)
      .style("stroke", groupFill)
      .style("stroke-width", 60)
      .style("stroke-linejoin", "round")
      .style("opacity", .2)
      .attr("d", groupPath)
      .on("click", function(d){
        console.log(d.values[0].cluster);
      });
		}
		
		// Move d to be adjacent to the cluster node.
		function cluster(alpha) {
		  return function(d) {
		    var cluster = clusters[d.cluster];
		    if (cluster === d) return;
		    var x = d.x - cluster.x,
		        y = d.y - cluster.y,
		        l = Math.sqrt(x * x + y * y),
		        r = d.radius + cluster.radius;
		    if (l != r) {
		      l = (l - r) / l * alpha;
		      d.x -= x *= l;
		      d.y -= y *= l;
		      cluster.x += x;
		      cluster.y += y;
		    }
		  };
		}
		
		// Resolves collisions between d and all other circles.
		function collide(alpha) {
		  var quadtree = d3.geom.quadtree(nodes);
		 
		 	var padding = 1.5; <#-- separation between same-color nodes -->
    		var clusterPadding = 20; <#-- separation between different-color nodes -->
    		var maxRadius = 10;
		 
		  return function(d) {
		    var r = d.radius + maxRadius + Math.max(padding, clusterPadding),
		        nx1 = d.x - r,
		        nx2 = d.x + r,
		        ny1 = d.y - r,
		        ny2 = d.y + r;
		    quadtree.visit(function(quad, x1, y1, x2, y2) {
		      if (quad.point && (quad.point !== d)) {
		        var x = d.x - quad.point.x,
		            y = d.y - quad.point.y,
		            l = Math.sqrt(x * x + y * y),
		            r = d.radius + quad.point.radius + (d.cluster === quad.point.cluster ? padding : clusterPadding);
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
		
		function zoomed() {
		  vis_researcher.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
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
	
</script>