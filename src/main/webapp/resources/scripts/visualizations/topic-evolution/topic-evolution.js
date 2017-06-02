$.TOPIC_EVOLUTION = {
		variables : {
				margin : {top: 10, right: 10, bottom: 100, left: 40},
			    margin2 : {top: 430, right: 10, bottom: 20, left: 40},
			    width : 960,
			    height : 500,
			    color : d3.scaleOrdinal( d3.schemeCategory20 )
		},
		processData : function( data ){
			var processData = { elements : [], years : [] };

			for (var i = 0; i < data.termvalues.length; i++) {
				var valuesTopic = data.termvalues[i].values;
				var keyTopic 	= data.termvalues[i].key;
				var colorTopic 	= data.termvalues[i].color;
				
				var valuesT = [];
				var k;
				
				for (k in valuesTopic) {	
					var date = new Date(k);
	
					if ( isNaN( valuesTopic[k] ) ){
						valuesT.push({x: date, y: 0});
						
						if ( processData.years[ k ] == undefined )
							processData.years[ k ] =  1;
						else
							processData.years[ k ]  += 1;
					}
					else
						valuesT.push({x: date, y: parseFloat(valuesTopic[k])});	
				}
				
				processData.elements.push({
						values: valuesT, 
						key: keyTopic, 
						color: colorTopic,
				});
			}

			return processData;
		},
		filterData : function( data ){
			data.elements = data.elements.map( function( topic, i ){
				var filteredValues = topic.values.filter( function( v ){ return Object.keys( data.years ).indexOf( v.x.getFullYear().toString() ) < 0; }); 
				topic.values = filteredValues;
				return topic;
			});
			return data.elements;
		},
		chart : {
			draw : function( data, svgContainer ){
				this.base.content( data, svgContainer );
				this.legend.content( data );
				this.tooltip.content();
			},
			base : {
				content : function( data, svgContainer ){
					var vars = $.TOPIC_EVOLUTION.variables;
	
					var x  = d3.scaleTime().range([0, vars.width]),
					    x2 = d3.scaleTime().range([0, vars.width]),
					    y  = d3.scaleLinear().range([ vars.height, 0]),
					    y2 = d3.scaleLinear().range([ vars.height2, 0]);
					 
					var xAxis = d3.axisBottom(x),
					    xAxis2 = d3.axisBottom(x2),
					    yAxis = d3.axisLeft(y).tickSize( - vars.width );
					 
					vars.brush = d3.brushX()
					    .extent([[0, 0], [ vars.width, vars.height2 ]])
					    .on("brush end", function(){ return $.TOPIC_EVOLUTION.chart.base.interactions.brushed(x, x2, xAxis); });
					 
					vars.zoom = d3.zoom()
						.scaleExtent([1, Infinity])
						.translateExtent([[0, 0], [vars.width, vars.height]])
						.extent([[0, 0], [vars.width, vars.height]])
						.on("zoom",  function(){ return $.TOPIC_EVOLUTION.chart.base.interactions.zoomed(x, x2, xAxis);  });
	
					var line = d3.line()
					    .x(function(d) { return x(d.x); })
					    .y(function(d) { return y(d.y); });
					 
					var line2 = d3.line()
					    .x(function(d) {return x2(d.x); })
					    .y(function(d) {return y2(d.y); });
					 
					vars.line = line; 
					vars.line2= line2; 
					
					var svg = d3.select(svgContainer).append("svg")
					    .attr("width",  vars.width  + vars.margin.left + vars.margin.right)
					    .attr("height", vars.height + vars.margin.top  + vars.margin.bottom)
					    .on( "mouseover", function(){ return $.TOPIC_EVOLUTION.chart.base.interactions.mouseOverChart( x, this )} )
					    .on( "mousemove", function(){ return $.TOPIC_EVOLUTION.chart.base.interactions.mouseOverChart( x, this )} );
					 
					svg.append("defs").append("clipPath")
					    .attr("id", "clip")
					  .append("rect")
					    .attr("width", vars.width)
					    .attr("height", vars.height);
					 
					var focus = svg.append("g").attr("class", "focus")
					  .attr("transform", "translate(" + vars.margin.left + "," + vars.margin.top + ")");
					      
					var context = svg.append("g").attr("class", "context")
					  .attr("transform", "translate(" + vars.margin2.left + "," + vars.margin2.top + ")");
					  
					vars.color.domain( data.map( function( d ){ return d.key; }) );
					
					x.domain( d3.extent( data[0].values.map( function(d){ return d.x; }) ));
					y.domain([d3.min(data, function(c) { return d3.min(c.values, function(v) { return v.y; }); }),
					          d3.max(data, function(c) { return d3.max(c.values, function(v) { return v.y; }); }) ]);
					x2.domain(x.domain());
					y2.domain(y.domain());
					
					focus.append("g")
				    	.attr("class", "x axis")
				    	.attr("transform", "translate(0," + vars.height + ")")
				    	.call(xAxis);
				 
					focus.append("g")
				    	.attr("class", "y axis")
				    	.call(yAxis);
				
					var focuslineGroups = focus.selectAll("g.lines")
					   .data(data)
					   .enter().append("g").attr("class", "lines");
					      
					var focuslines = focuslineGroups.append("path")
					    .attr("class","line")
					    .attr("d", function(d) { return line(d.values); })
					    .style("stroke", function(d) { d.color = vars.color(d.key); return d.color;})
					    .attr("clip-path", "url(#clip)");
					 
					 
					focuslineGroups.append("g").selectAll("circle")
						.data( function( d){ return d.values } )
					    .enter().append("circle")
					    .attr("r", 3)
					    .attr("cx", function(d){return x(d.x)})
					    .attr("cy", function(d){return y(d.y)})
					    .attr("fill", "white")
					    .attr("stroke", function(d){ return d3.select(this.parentNode.parentNode).select("path.line").style("stroke"); });					   
					    
					var contextlineGroups = context.selectAll("g")
					    .data(data)
					    .enter().append("g");
					    
					var contextLines = contextlineGroups.append("path")
					    .attr("class", "line")
					    .attr("d", function(d) { return line2( d.values ); })
					    .style("stroke", function(d) {return vars.color(d.key);})
					    .attr("clip-path", "url(#clip)");
					 
					context.append("g")
						.attr("class", "x axis")
					    .attr("transform", "translate(0," + vars.height2 + ")")
					    .call(xAxis2);
					 
					context.append("g")
					    .attr("class", "x brush")
					    .call( vars.brush )
					    .call( vars.brush.move, x.range() )
					.selectAll("rect")
					    .attr("y", -6)
					    .attr("width", vars.width )
					    .attr("height", vars.height2 + 7)
					    
					svg.append("rect")
						.attr("class", "zoom")
						.attr("width", vars.width )
						.attr("height", vars.height )
						.attr("transform", "translate(" + vars.margin.left + "," + vars.margin.top + ")")
					    .call( vars.zoom );
				},		
				interactions : {
					mouseOverChart : function( x, $this ){
						var vars    = $.TOPIC_EVOLUTION.variables;
						var mouseX 	= d3.mouse( $this )[0];
						var invertX = x.invert( mouseX );
						var bisect	= d3.bisector( function( d ){ return d.x; }).right;
						var vertical= d3.select( "#widget-" + vars.widgetUniqueName + " .vertical-line");
						var focus	= d3.select( "#widget-" + $.TOPIC_EVOLUTION.variables.widgetUniqueName + " .focus");
						
						vertical.style("left", ( mouseX + 5 ) + "px");
						
						focus.selectAll(".line")
							.each( function( l ){
								var index 	= bisect( l.values, invertX );
								
								d3.select( this.parentNode ).selectAll("circle")
									.transition().duration(100)
									.attr("r", 3)
									.attr("fill", "white" );
							
								var parentBox = d3.select( this.parentNode );
								
								var indexCheck = function( index ){	
									parentBox.select("circle:nth-child(" + index + ")")
										.attr("class", function(c){
											var xSame = Math.abs( this.getBoundingClientRect().left - vertical.node().getBoundingClientRect().left ) < 10;
											var ySame = Math.abs( this.getBoundingClientRect().top  - ( d3.mouse( $this )[1]  + focus.node().getBoundingClientRect().top ) ) < 10;
											return xSame && ySame ? "hovered" : "";
										})
										.transition().duration(100)										
										.attr("r", function(c){ return  Math.abs( this.getBoundingClientRect().left - vertical.node().getBoundingClientRect().left) < 10 ? 5 : 3; })
										.attr("fill", function( c ){ return Math.abs( this.getBoundingClientRect().left - vertical.node().getBoundingClientRect().left) < 10  ? d3.select(this).attr("stroke") : "white"; });
									};
								
								indexCheck( index - 1); 
								indexCheck( index ); 
							});
						
						$.TOPIC_EVOLUTION.chart.tooltip.show( invertX );
					},
					zoomed : function( x, x2, xAxis ){
						if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
						
						var vars 	= $.TOPIC_EVOLUTION.variables;
						var focus 	= d3.select("#widget-" + vars.widgetUniqueName + " g.focus");
						var context = d3.select("#widget-" + vars.widgetUniqueName + " g.context")
						var t 		= d3.event.transform;
						  
						x.domain(t.rescaleX( x2 ).domain());
						  
						focus.selectAll("path.line").attr("d", function(d){ return vars.line( d.values ); });
						focus.selectAll("circle").attr("cx", function(d, i){return x(d.x)});
						focus.select(".x.axis").call( xAxis );

						context.select(".brush").call( vars.brush.move, x.range().map(t.invertX, t));
					},
					brushed : function ( x, x2, xAxis ) {
						if (d3.event.sourceEvent && d3.event.sourceEvent.type === "zoom") return; // ignore brush-by-zoom
						
						var vars  = $.TOPIC_EVOLUTION.variables;
						var focus = d3.select("#widget-" + vars.widgetUniqueName + " g.focus");
						var svg   = d3.select("#widget-" + vars.widgetUniqueName + " #tab-evolution svg");
						var s 	  = d3.event.selection || x2.range();
						
						x.domain(s.map( x2.invert, x2));
						focus.selectAll("path.line").attr("d", function(d){ return vars.line( d.values ); });
						focus.selectAll("circle").attr("cx", function(d){return x(d.x)});
						focus.select(".x.axis").call( xAxis );
						
						
						svg.select(".zoom")
							.call( vars.zoom.transform, d3.zoomIdentity.scale( vars.width / (s[1] - s[0])).translate(-s[0], 0));
					}
				}
			},
			legend : {
				content : function( data ){
					var vars = $.TOPIC_EVOLUTION.variables;
				
					var legend = d3.select("#legend").append("g")
						.attr("transform", " translate(" + vars.margin.left + "," + vars.margin.top + ")" )
						.selectAll("text")
						.data( data, function(d){return d.key} );

					//checkboxes
					legend.enter().append("circle")
						.attr("r", 5)
						.attr("cx", 0 )
						.attr("cy", function (d, i) { return 0 +i * 15; })  // spacing
						.attr("fill",function(d) { return vars.color(d.key); })
						.attr("stroke",function(d) { return vars.color(d.key); })
						.attr("stroke-width", "2px")
						.attr("class", function(d,i){return "legendcheckbox " + d.key})
						.on("click", function(d){
							d.inactive = !d.inactive;
						  
							d3.select(this).attr("fill", function(d){
								if( d.inactive )
									return "white"; 
								else return vars.color(d.key);  
							});
							
							d3.select("#widget-" + vars.widgetUniqueName + " #tab_evolution").selectAll(".line")
								.style("display", function(d){ return d.inactive ? "none" : "block"; });						 
						});
					// Add the Legend text
					legend.enter().append("text")
				    	.attr("x", 15)
				    	.attr("y", function(d,i){return 10 + i*15;})
				    	.attr("class", "legend")
				      	.style("fill", "#777" )
				      	.text(function(d){return d.key;});

					legend.exit().remove();
				},
				showAll : function(){
					d3.select("#widget-" + $.TOPIC_EVOLUTION.variables.widgetUniqueName + " #tab_evolution").selectAll(".line")
						.style("display", "block" );
					
					 d3.select("#legend").selectAll("circle")
					  	.attr("fill",function(d) { d.inactive = false; return $.TOPIC_EVOLUTION.variables.color( d.key ); });
				},
				hideAll : function(){
					d3.select("#widget-" + $.TOPIC_EVOLUTION.variables.widgetUniqueName + " #tab_evolution").selectAll(".line").transition().duration(100)
						.style("display", "none");
					
					d3.select("#legend").selectAll("circle").transition().duration(100)
						.attr("fill", function(d){ d.inactive = true; return "white"; });
				}
			},
			tooltip : {
				content : function( data,year ){
					var vertical = d3.select("#widget-" + $.TOPIC_EVOLUTION.variables.widgetUniqueName + " #tooltipContainer")
				        .insert("div", ":first-child")
				        .attr("class"	 , "vertical-line" )
				        .style("height"	 , $.TOPIC_EVOLUTION.variables.height + "px" )
				        .style("margin-top"	 , 10 + $.TOPIC_EVOLUTION.variables.margin.top + "px" );
				},
				show : function( year, mouseY ){	 
					var vars = $.TOPIC_EVOLUTION.variables;
			
					var $table = $("#widget-" + vars.widgetUniqueName + " #tooltipContainer .tooltip table");
					$table.empty().hide();
					
					$table.append($("<thead/>").append( $("<td/>").append("<strong>" + year.getFullYear() + "</strong>") ));
					
					var $body = $("<tbody/>");
					var $row = $("<tr/>");
						
					var circles = d3.select( "#widget-" + vars.widgetUniqueName + " .focus").selectAll("circle")
						.filter( function(){ return parseInt( d3.select(this).attr("r") ) > 3 });
					
					if ( circles.nodes().length == 0){
						$table.empty();
						return;
					}
						
					for ( var i = 0; i < circles.nodes().length; i++ ){
						var data = d3.select(circles.nodes()[i]).datum();
						
						$row = $("<tr/>").addClass( d3.select( circles.nodes()[i] ).attr("class") );
						$row.append( $("<td/>").append( $("<div/>").addClass("circle").css( "background-color", "#" + data.color ) ) );
						$row.append( $("<td/>").append( $("<span/>").text( data.key ) ) );
						
						var value = data.values.filter( function(v){ return v.x.getFullYear() == year.getFullYear(); } )[0].y;
						$row.append( $("<td/>").append( $("<strong/>").text( Number(value).toFixed(2) ) ) ); 
						
						d3.select( circles.nodes()[i] ).classed("hovered", false);
						
						if ( value > 0)
							$body.append( $row );
					}
					
					$table.append( $body );
					
				    $table.show();    
				}
			}
		}
			
}

function visualizeTermValue( data, svgContainer, widgetUniqueName ){	 
	var vars = $.TOPIC_EVOLUTION.variables ;
	vars.width 	 = vars.width  - vars.margin.left - vars.margin.right;
	vars.height2 = vars.height - vars.margin2.top - vars.margin2.bottom;
	vars.height  = vars.height - vars.margin.top  - vars.margin.bottom;
	vars.widgetUniqueName  = widgetUniqueName;
	   
	var processedData = $.TOPIC_EVOLUTION.processData ( data );
	var filteredData  = $.TOPIC_EVOLUTION.filterData ( processedData );
	$.TOPIC_EVOLUTION.chart.draw( filteredData, svgContainer );
	
}