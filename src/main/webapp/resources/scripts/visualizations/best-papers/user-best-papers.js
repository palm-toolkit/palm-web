$.bestPapers = {
	variables : {
		padding : 10,
		pubColor: "#51aee4",
		authColor: "#ff6666",
		minRadius: 5,
		maxRadius: 25,
		authRadius: 10
	},
	processData : function( ){
		var vars  = $.bestPapers.variables;
		var nodes = []; var links = []; var authors = [];
		
		d3.map( $.PALM.visualizations.data.publications, function(d){
			var node = { 
					id      : d.id, 
					name    : d.title, 
					type    : d.type,
					basedOn : d[vars.criterion] || 10, 
					cited	: d.cited,
					year	: d.date.substr(0, 4),
					group	: 1,
					coauthors: []
			};

			d3.map(d.coauthor, function( a ){
				if ( a.id != $.PALM.visualizations.user ){
					var author = {
							id 			: a.id,
							name		: a.name,
							affiliation	: a.aff || "",
							photo 		: a.photo || "" ,
							hindex		: a.hindex ||  Math.floor((Math.random() * 10) + 1),
							nrCollaboration: 1,
							group 		: 2
					};
					node.coauthors.push(a.id);
					
					var target = author;
					var existAuthor = authors.filter( function(n){ if ( a.id == n.id ) n.nrCollaboration += 1;  return a.id == n.id; });
					
					if ( existAuthor.length == 0 )	
						authors.push( author );
					else
						target = existAuthor[0];
					
					var linkNew 	 = { source: node, target: target, value: 1 };
					var linkExistent = links.filter( function(l){ return linkNew.source.id == l.source.id && linkNew.target.id == l.target.id; });
					
					if ( linkExistent.length == 0 )
						links.push( linkNew );
				}
			});
			nodes.push( node );
		});
		nodes = nodes.concat( authors.sort( function (a, b ){ return b.hindex - a.hindex ;}) )
		return {nodes: nodes, links: links};
	},
	visualise : {
		chart : {
			draw : function( ){
				var vars 	   = $.bestPapers.variables;
				var citValue   = function(d){ if( d.basedOn != undefined ) return d.basedOn; };
				var hindexValue= function(d){ if( d.hindex != undefined ) return d.hindex; };
				var publTotalRadius = 0; var authTotalRadius = 0;
				var $mainContainer = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .visualization-main");
				var svg 	   = vars.widget.select( ".visualization-main" ).append("svg");
				var layer	   = svg.append("g").classed("best-papers-layer", true);	
				vars.linkedById= {};
				
				var data = $.PALM.visualizations.data;
				
				var radScale   = d3.scaleLinear()
					.domain([d3.min( data.nodes, citValue), d3.max( data.nodes, citValue)])
					.range([vars.minRadius, vars.maxRadius]);
				
				var authScale   = d3.scaleLinear()
					.domain([d3.min(data.nodes, hindexValue), d3.max(data.nodes, hindexValue)])
					.range([vars.minRadius, vars.maxRadius]);
		
				var simulation = d3.forceSimulation()
			    	.force("link",   d3.forceLink().id(function(d) { return d.id }))
			    	.force("collide",d3.forceCollide( function(d){ if (d.group == 1) return radScale(d.basedOn) +8; else return 18; }).iterations(16) )
			    	.force("charge", d3.forceManyBody())
			    	.force("center", d3.forceCenter(vars.width / 2, vars.height / 2));
			   
				simulation.nodes( data.nodes );
				simulation.force("link").links( data.links );    
		    
				var zoom = d3.zoom()
					.scaleExtent([0.7, 1.4])
					.on("zoom", $.bestPapers.interactions.zoomed);
		
			    svg
			  		.attr("viewBox", "0 0 " +vars.width + " " + vars.height)
			  		.attr("preserveAspectRatio", "xMinYMin meet")
			  		.attr("width",  vars.width)
			  		.attr("height", vars.height)
				    .call(zoom);
	
				var linkWidth = 1.5 ;
				var link = layer.append("g")
			  		.attr("class", "links")
			  		.selectAll(".link")
			  		.data( data.links )
			  	  .enter().append("path")
			  			.attr("stroke", "black").attr("stroke-width", linkWidth ).attr("stroke-opacity", 0.2).attr("stroke-linecap", "round")
			  			.attr("fill", "none")
			  			.attr("class", function(d){ return "link " + d.source.name + "-" +d.target.name})
			  			.attr("opacity", 0);
	
				var nodesLayer = layer.append("g").attr("class", "nodes-layer");
				
				vars.circleDetails = {
						radius		 : function( d ){ return d.group === 1 ? radScale(d.basedOn) : authScale(d.hindex); },
						fill		 : function( d ){ 
										if ( d.group ===  2 ){
											var bkground = $.PALM.utility.visualizations.getImageBackground( "#widget-" + $.PALM.visualizations.widgetUniqueName + " svg", d );
											
											if( bkground != null ) 
												return bkground;
										}	
										return "white";
									   }, 
						fillOpacity	 : 1,
			    		strokeColor  : function( d, color1, color2, step ){ return d.group === 1 ? d3.hsl( color1 ).darker( step ) : d3.hsl( color2 ).darker( step ); },
			    		strokeWidth  : function( d ){ return d.group === 1 ? 2 : 0; },
			    		strokeOpacity: 1,
			    		fontSize	 : 12
			    };

				var publRange = d3.scaleBand()
		 			.rangeRound([0, vars.width])
		 			.padding(0.5);
				var authRange = d3.scaleBand()
	 				.rangeRound([0, vars.width])
	 				.padding(1);

				var publDomain = publRange.domain( data.nodes.map(function(d) { if (d.group === 1 ) return d.id ; }).filter( function(n){ return n != undefined} ) );
				var authDomain = authRange.domain( data.nodes.map(function(d) { if (d.group === 2 ) return d.id ; }).filter( function(n){ return n != undefined} ) );

			
				var nodesByGroup = function( group ){ return data.nodes.filter( function(d){ return d.group == group;} ); };

				this.createNodesLayer(nodesLayer, "nodes nodesPubl", "publ-name", nodesByGroup(1));
				this.createNodesLayer(nodesLayer, "nodes nodesAuth", "auth-name", nodesByGroup(2));
	
				d3.selectAll(".node text").attr("text-anchor","middle").attr("opacity", vars.circleDetails.fillOpacity );
			
				$.bestPapers.visualise.chart.positionNodesAndLinks(svg, nodesLayer.selectAll(".node"), link );
							  
				simulation.stop();
				
				link.each(function(d) { 				
					vars.linkedById[d.source.id + "," + d.target.id] = 1;
				})
			}, //end draw
			createNodesLayer : function( nodesLayer, nodesClassName, textClassName, data ){
				var vars 	   		= $.bestPapers.variables;
				var	publTotalRadius = 0
				var authTotalRadius = 0;
				
				var addIcon = function( container, className, group, icon, color, size){
					if ( group === 1 )
						$.PALM.utility.visualizations.addMissingPhotoIcon( container, "last",  { className: className, size: size, color: color, dy : ".35em", textAnchor : "middle", text: icon } );
					else
						$.PALM.utility.visualizations.addMissingPhotoIcon( container, "first", { className: className, size: size, color: color, dy : ".35em", textAnchor : "middle", text: icon } );
				};
				
				var nodes = nodesLayer.append("g").attr("class", nodesClassName)
					.selectAll(".node")
					.data( data )
					.enter().append("g")
		    			.attr("class", "node");
				// add circle
				nodes.append("circle")
					.attr("r", function(d){  d.r = vars.circleDetails.radius(d);				
						return d.r;
					})
					.attr("fill",   	   vars.circleDetails.fill)
					.attr("fill-opacity",  vars.circleDetails.fillOpacity)
					.attr("stroke", 	   function( d ){ return vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ); } )
					.attr("stroke-width",  vars.circleDetails.strokeWidth)
					.attr("stroke-opacity",vars.circleDetails.strokeOpacity);
				
				//add text and add icon
				var distanceConstant  = nodesClassName.indexOf("nodesPubl") >= 0 ? 
						(vars.width - publTotalRadius ) / data.length : ( vars.width - authTotalRadius ) / $.PALM.visualizations.data.length ; 	
				var nodesText         = nodes.append("g").attr("class", textClassName);
				
			 	var publRange = d3.scaleBand()
			 		.rangeRound([0, vars.width])
			 		.padding(0.5);
			 	var publDomain = publRange.domain( data.map(function(d) { if (d.group === 1 ) return d.id ; }).filter(
			 			function(n){ return n != undefined} ) );
			 	
			 	var authRange = d3.scaleBand()
					.rangeRound([0, vars.width])
					.padding(1);
		 	 	var authDomain = authRange.domain( data.map(function(d) { if (d.group === 2 ) return d.id ; }).filter( 
		 	 			function(n){ return n != undefined} ) );
	
				nodes.each( function(d){
					var prevSibling =  d3.select(this.previousSibling);
					
					if ( d.group == 1 ){
						var distance = prevSibling.node() != undefined ? publDomain( d.id ) - publDomain( prevSibling.datum().id ) - prevSibling.datum().r - d.r - 5 : 0;
					}else
						var distance = prevSibling.node() != undefined ? 2*(  authDomain( d.id ) - authDomain( prevSibling.datum().id ) - prevSibling.datum().r - d.r) : 0;
					
					var availableWidth = d3.select( this ).node().getBoundingClientRect().width + distance;
					var name = d.group === 1 ? d.name : abbrAuthorName( d. name );
					
					$.PALM.utility.visualizations.wrapText( d3.select(this).select("g." + textClassName), name , availableWidth, "name", 12);
					
					if (d.group === 1)
						addIcon(d3.select(this), "image publication", d.group, "\uf0f6", vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ), d.r * 1.3);
					else
						addIcon(d3.select(this), "image missing-photo-icon author_avatar", d.group, "\uf007", vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ), d.r * 1.8);					
				} );
				
				//position text
				nodesText.attr("transform", function(d, i){ 
					var height = this.getBBox().height;
					var nrLines= d3.select( this ).selectAll(".name").nodes().length - 1;
					var y	   = d.group === 1 ? -(d.r + height) : i % 2 == 0 ?  ( -d.r - nrLines * vars.circleDetails.fontSize - 2) :( d.r  + vars.circleDetails.fontSize);  	
					return "translate(0," + y + ")" ;
				} );
				
				//add label
				nodes.each(function( d, i ){
					var height 		  = this.getBBox().height,
				 		labelFontSize = vars.circleDetails.fontSize,
				 		padding		  = 5;
				
					if (d.group === 1){
						d3.select(this).append("text")
							.attr("class", "publ-label")
							.attr("fill", vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ))
							.attr("y", d.r + labelFontSize + padding)
							.style("font-size", labelFontSize )
							.text(vars.criterion + ":" + d.basedOn);				
						d3.select(this).append("text")
							.attr("class", "publ-label")
							.attr("fill", vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ))
							.attr("y", -height + d.r - padding)
							.style("font-size", labelFontSize)
							.text( d.year);
					}else{
						var y = i % 2 == 0 ?  (d.r + labelFontSize + padding)  : -d.r  ;  	
						d3.select(this).append("text")
							.attr("class", "auth-label")
							.attr("fill", vars.circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ))
							.attr("y", y)
							.attr("dy", "-0.35em")
							.style("font-size", labelFontSize);			
					}			
				});
			},//end createNodesLayer
			positionNodesAndLinks : function( svg, nodes, link){
				var vars  = $.bestPapers.variables;
				//var nodes = svg.selectAll(".node");
				
				 var transition = d3.transition().duration( 50 ),
				 	 delay      = function(d, i) { return i * 50; };
				 	
				 var publRange = d3.scaleBand()
				 	.rangeRound([0, vars.width])
				 	.padding(0.5);
				 var authRange = d3.scaleBand()
			 		.rangeRound([0, vars.width])
			 		.padding(1);
	
				 var publDomain = publRange.domain( $.PALM.visualizations.data.nodes.map(function(d) { if (d.group === 1 ) return d.id ; }).filter( function(n){ return n != undefined} ) );
				 var authDomain = authRange.domain( $.PALM.visualizations.data.nodes.map(function(d) { if (d.group === 2 ) return d.id ; }).filter( function(n){ return n != undefined} ) );
	
				 vars.widget.style("pointer-events", "none");
				 
				 nodes.transition(transition).delay(delay)
				 	.on("end", function(d, i){
				        if ( i == nodes.nodes().length - 1 ){
				        	link.transition(transition).delay( delay )
							.on("end", function(l, i){
								if ( i == link.nodes().length - 1){
									svg.selectAll(".node")
										.on("mouseover", $.bestPapers.interactions.mouseover)
										.on("mouseout",  $.bestPapers.interactions.mouseout);
									
									vars.widget.style("pointer-events", "auto");
								}
							})
							.attr("opacity", 1)
							.attr("d", function( d ){
								d.source.xTranslate = d.source.group === 1 ? publDomain(d.source.id) : authDomain(d.source.id);
								d.target.xTranslate = d.target.group === 1 ? publDomain(d.target.id) : authDomain(d.target.id);
								d.source.yTranslate = d.source.group === 1 ? 200 : 350;
								d.target.yTranslate = d.target.group === 1 ? 200 : 350;
								
								var xSource = d.source.xTranslate ;
								var ySource = d.source.yTranslate ;
								var xTarget = d.target.xTranslate ;
								var yTarget = d.target.yTranslate ;
						
								return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " +
									(xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
							});
				        }
				    }) 
					.attr("transform", function(d) { 
						var translate = d3.transform( d3.select(this).attr("transform") ).translate;									
								
						d.xTranslate = d.group === 1 ? publDomain(d.id) : authDomain(d.id);
						d.yTranslate = d.group === 1 ? 200 : 350;
							
						return "translate(" + [d.xTranslate, d.yTranslate]+ ")"; 
					});
			}//end positionNodes
		} //end chart	
	}, //end visualise
	interactions : {
		zoomed : function () {
			$.bestPapers.variables.widget.select( "g.best-papers-layer" )
				.attr("transform", 'translate(' + d3.event.transform.x + ',' + d3.event.transform.y + ') scale(' + d3.event.transform.k + ')');
		},	//end zoomed    
		mouseover : function mouseover(d) {	
			var vars = $.bestPapers.variables;
			var linkWidth = 1.5 ;
			
		   	d3.select(this).selectAll("text").transition().duration(150)
				.style("font-weight", "bold");
		    d3.select(this).select("text.auth-label").text( "H-index:" + d.hindex);
		    	
		    vars.widget.selectAll(".visualization-main .node").transition().duration(150)
		   		.attr("transform",     function(l){ 
		    		var t = d3.transform( d3.select( this ).attr("transform") );
		    		if ( l.group === 1 )
		    			return "translate(" + t.translate + ") scale(1)";
		    		return neighbors(d, l) || neighbors(l, d) || d === l ? "translate(" + t.translate + ") scale(1.2)"	 : "translate(" + t.translate + ") scale(1)"; })
		    	.selectAll("circle")
		      		.attr("fill-opacity",  function(l){ 
		      			if ( neighbors(d, l) || neighbors(l, d) || d === l ) 
		      				return vars.circleDetails.fillOpacity;
		      				else return vars.circleDetails.fillOpacity/3 })
		      		.attr("stroke-width",  function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? vars.circleDetails.strokeWidth(l) + 1 : vars.circleDetails.strokeWidth(l); })
		      		.attr("stroke-opacity",function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? vars.circleDetails.strokeOpacity   : vars.circleDetails.strokeOpacity / 10; })
		      		.attr("r", 			   function(l){ 
		      			if ( l.group === 2 )
		      				return l.r;
		      			return neighbors(d, l) || neighbors(l, d) || d === l ? l.r + 4 : l.r; });
		    	
		    vars.widget.selectAll(".visualization-main .node").selectAll("text").transition().duration(150)	
		    	.attr("opacity", function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? vars.circleDetails.fillOpacity : vars.circleDetails.fillOpacity/3 });
		    		
		    vars.widget.selectAll(".visualization-main .link").transition().duration(150)
		    	.attr("stroke", 		function(l) { return  ( d.id === l.source.id || d.id ===  l.target.id ) ? (d.group === 1 ? vars.pubColor : vars.authColor) : "black"; })
		    	.attr('stroke-width', 	function(l) { return  ( d.id === l.source.id || d.id ===  l.target.id ) ? ( linkWidth == 1 ? 2 : vars.authRadius/4) : linkWidth; })
		    	.attr("stroke-opacity", function(l) { return  ( d.id === l.source.id || d.id ===  l.target.id ) ? 0.8 : 0.1; });
		    
		    function neighbors(a, b){
				return vars.linkedById[a.id + "," + b.id];
			}
		},//end mouseover
		mouseout : function () {
			var vars = $.bestPapers.variables;
			var linkWidth = 1.5 ;
			
		    d3.select(this).selectAll("text").transition().duration(150)
		  		.style("font-weight", "normal");
		    d3.select(this).select("text.auth-label").text("");
		    
		    vars.widget.selectAll(".visualization-main .node").transition().duration(150)
		    	.attr("transform", function(l){ return "translate(" + d3.transform( d3.select( this ).attr("transform") ).translate + ") scale(1)"} )
		    	.selectAll("circle")
			  		.attr("fill-opacity",   vars.circleDetails.fillOpacity )
			  		.attr("stroke-width",   vars.circleDetails.strokeWidth )
			  		.attr("stroke-opacity", vars.circleDetails.strokeOpacity )
		    		.attr("r",              function( d ){ return d.r; });
		    	
		    vars.widget.selectAll(".visualization-main .node").selectAll("text").transition().duration(150)	
				.attr("opacity", vars.circleDetails.fillOpacity );
				
		    vars.widget.selectAll(".visualization-main .link").transition().duration(150)
		    	.attr("stroke", "black" )
				.attr('stroke-width', linkWidth )
				.attr("stroke-opacity", 0.1 );
		} //end mouseout
	}, //end interactions
	orderBy : function( criterion ){
		var vars = $.bestPapers.variables,
			svg  = vars.widget.select( ".visualization-main svg" );
			
		var nodes = svg.selectAll(".node").nodes();
			sortedData = sortData( nodes.filter( function(n){ return d3.select(n).datum().group == 1} ), criterion );
			
		var x = d3.scaleBand()
			.rangeRound([0, vars.width])
			.padding(0.5);
	
		var x1 = x.domain( sortedData.map(function(d) { 
			var node = d3.select(d).datum();
			if (node.group === 1 ) return node.id ; 
		}).filter( function(n){ return n != undefined} ) );
	
		var transitionN  = d3.transition("order-node").duration( 150 ),
			transitionL  = d3.transition("order-link").duration( 150 ),
			delay 		= function(d, i) { return i * 50; };
			delayLinks  = function(d, i) { return i * 30; };
	
		svg.selectAll("path").attr("opacity", 0);
		vars.widget.style("pointer-events", "none");
		
		svg.selectAll(".node").transition(transitionN)
			.delay(delay)
			.on("end", function(d, i){
				if ( i == x.domain().length - 1 ){
					svg.selectAll("path").transition(transitionL).delay(delayLinks)
				       	.attr("opacity", 1)
				       	.attr("d", function( d ){
				       		d.source.xTranslate = d.source.group === 1 ? x1(d.source.id) : d.source.xTranslate;
							d.target.xTranslate = d.target.group === 1 ? x1(d.target.id) : d.target.xTranslate;
							d.source.yTranslate = d.source.group === 1 ? 200 : 350;
							d.target.yTranslate = d.target.group === 1 ? 200 : 350;
							
							
				       		var xSource = d.source.xTranslate ;
				       		var ySource = d.source.yTranslate ;
				       		var xTarget = d.target.xTranslate ;
				       		var yTarget = d.target.yTranslate ;
				    			
				       		return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
				       	});
					vars.widget.style("pointer-events", "auto");
				}
			})
			.attr("transform", function(d) { 
				var translate = d3.transform( d3.select(this).attr("transform") ).translate;									
							
				d.xTranslate = d.group === 1 ? x1(d.id) : translate[0];
				d.yTranslate = translate[1];
						
				return "translate(" + [d.xTranslate, d.yTranslate]+ ")"; 
			});
	},//end orderBy
	filterBy : {
		top : function( top ){
			var vars 	      = $.bestPapers.variables,
				publications  = 0,
				coauthors     = [],
				dataProcessed = {};
				
			dataProcessed.nodes = vars.dataBackUp.nodes.filter( function(d){
				publications += d.group == 1 ? 1 : 0;
				if ( d.group == 1 && publications <= top ) coauthors = coauthors.concat( d.coauthors );
				
				return ( d.group == 1 && publications <= top )
			} );
				
			var authorsNodes = vars.dataBackUp.nodes.filter( function(d){
				return d.group == 2 && $.inArray(d.id, coauthors) >= 0;
			} );
				
			dataProcessed.nodes = dataProcessed.nodes.concat( authorsNodes );
				
			dataProcessed.links = vars.dataBackUp.links.filter( function(l){
				return isIdInArray(l.source.id, dataProcessed.nodes) && isIdInArray(l.target.id, dataProcessed.nodes); } );
				
			var svg	= vars.widget.select( ".visualization-main svg" );
			svg.remove();
				
			var $orderBy = $(vars.widget.select( ".orderedBy .dropdown-menu" ).node() );
			$orderBy.children("li").removeClass("selected");
			$orderBy.children("li:first").addClass("selected");
			$orderBy.parents(".dropdown").children("button").html( $orderBy.children("li:first").text() + " <span class='caret'></span>" );
				
			var $mainContainer = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .visualization-main");
			$mainContainer.html( "" );
			
			$.PALM.visualizations.data = dataProcessed;
			$.bestPapers.visualise.chart.draw(  );
			
			function isIdInArray( id, array){
				var found = array.filter( function(e){ return e.id === id; });
				return found.length > 0;
			}
		},
		basedOn : function( based ){
				alert("based")
		}
	}//end filterBy
}//end object
function sortData( data, criterion){
	return data.sort( function(a, b){
		var nodeA = d3.select(a).datum(),
			nodeB = d3.select(b).datum();
		return d3.descending(nodeA[criterion], nodeB[criterion]);
	});
}
function abbrAuthorName( name ){
	var lastName  = name.substring(name.lastIndexOf(" "), name.length);
	var firstName = name.substring(0, name.lastIndexOf(" "));
	var initials  = (firstName.match(/\b(\w)/g)).join(".");
	
	return initials +"."+ lastName.trim() ;
}