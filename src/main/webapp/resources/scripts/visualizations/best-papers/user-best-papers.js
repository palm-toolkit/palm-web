$.bestPapers = {};
$.bestPapers.variables = {
		padding : 10,
		pubColor: "#" +
				"51aee4",
		authColor: "#ff6666",
		minRadius: 10,
		maxRadius: 40,
		authRadius: 20
};
$.bestPapers.init = function( url, wUniqueName, userLoggedID, data, height){
	var $mainContainer = $("#widget-" + wUniqueName + " .visualization-main");
	// remove everything
	$mainContainer.html( "" );
	
	// check for error 
	if( data.status != "ok"){
		$.PALM.callout.generate( $mainContainer , "warning", "Empty Publications !", "Sorry, you don't have any publication, please try to add one" );
		return false;
	}
	if ( typeof data.publications === 'undefined') {
		$.PALM.callout.generate( $mainContainer , "warning", "Empty Publications !", "Sorry, you don't have any publication, please try to add one" );
		return false;
	}
	var margin = {top: 20, right: 20, bottom: 40, left: 40};
	setGlobalVariables( );
	
	return this.processData( data );
	
	function setGlobalVariables( ){
		$.bestPapers.variables.url 		   = url;
		$.bestPapers.variables.wUniqueName = wUniqueName;
		$.bestPapers.variables.userLogged  = userLoggedID;
		$.bestPapers.variables.width  	   = $mainContainer.width() - margin.left - margin.right;
		$.bestPapers.variables.height 	   = height;
		$.bestPapers.variables.margin	   = margin;
		$.bestPapers.variables.criterion   = $("#widget-" + wUniqueName + " .basedOn .dropdown-menu .selected").data("value");
	}
};
$.bestPapers.processData = function( data ){
	var vars  = $.bestPapers.variables;
	var nodes = []; var links = [];
	
	d3.map( data.publications, function(d){
		var node = { 
				id      : d.id, 
				name    : d.title, 
				type    : d.type,
				basedOn : d[vars.criterion] || 10, 
				cited	: d.cited,
				year	: d.date.substr(0, 4),
				group	: 1
		};

		d3.map(d.coauthor, function( a ){
			if ( a.id != vars.userLogged ){
				var author = {
						id 			: a.id,
						name		: a.name,
						affiliation	: a.aff || "",
						photo 		: a.photo || "" ,
						hindex		: a.hindex || -1,
						nrCollaboration: 1,
						group 		: 2
				};
				var target = author;
				var existAuthor = nodes.filter( function(n){ if ( a.id == n.id ) n.nrCollaboration += 1;  return a.id == n.id; });
				
				if ( existAuthor.length == 0 )	
					nodes.push( author );
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
	
	console.log("NODES: ");
	console.log( nodes );
	
	console.log("LINKS: ");
	console.log( links );
	
	return {nodes: nodes, links: links};
}

$.bestPapers.visualise = function( data ){
	var vars 	   = $.bestPapers.variables;
	var citValue   = function(d){ if( d.basedOn != undefined ) return d.basedOn; };
	var radScale   = d3.scaleLinear()
		.domain([d3.min(data.nodes, citValue), d3.max(data.nodes, citValue)])
		.range([vars.minRadius, vars.maxRadius]);
	var totalRadius = 0;
	var linkedById  = {};
	
	var $mainContainer = $("#widget-" + vars.wUniqueName + " .visualization-main");
	var svg 	   = d3.select("#widget-" + vars.wUniqueName + " .visualization-main" ).append("svg");
	var layer	   = svg.append("g").classed("best-papers-layer", true);	
	var simulation = d3.forceSimulation()
    	.force("link", d3.forceLink().id(function(d) { return d.index }))
    	.force("collide",d3.forceCollide( function(d){ if (d.group == 1) return radScale(d.basedOn) +8; else return 18; }).iterations(16) )
    	.force("charge", d3.forceManyBody())
    	.force("center", d3.forceCenter(vars.width / 2, vars.height / 2));
   
	var zoom = d3.zoom()
		.scaleExtent([0.7, 1.4])
		.on("zoom", zoomed);

	vars.data = data;
	
	var nodesByGroup = function( group ){ return data.nodes.filter( function(d){ return d.group == group;} ); };
	
	var positionNodes = function( positionLinks ) {
		 	var nodes = d3.selectAll(".node");
		 	var publDistanceConstant = (vars.width - totalRadius ) / nodesByGroup(1).length;
		 	var authDistanceConstant = (vars.width - (nodesByGroup(2).length * vars.authRadius * 2)) / nodesByGroup(2).length;
		 		 	
		 	var publDist = 0;
		 	var authDist = 0;
		 			 	
		 	nodes.attr("transform", function(d, i){ 
			    	x = d.group == 1 ? publDist : authDist;
			    	x += i == 0 ? d.r : d.group == 1 ? publDistanceConstant + d.r : ( authDistanceConstant <= 0 && i % 2 != 0 ? authDistanceConstant + d.r/2 : authDistanceConstant + d.r)  ;
			    	
			    	if ( d.group == 1 ){
			    		publDist = x + d.r;
			    		y = publDistanceConstant <= 0 && i % 2 != 0 ?  d.r * 2 : 0;  
			    	}
			    	else{
			    		authDist = x + d.r;
			    		y = authDistanceConstant <= 0 && i % 2 != 0 ?  d.r * 2 : 0;  
			    	}
			    				    	
			    	d.x = x;
			    	d.y = y;
					return "translate(" + d.x + "," + d.y + ")";
			});	
		 	
		 	var transition = d3.transition().duration( 550 ),
		        delay      = function(d, i) { return i * 50; };

		    transition.selectAll(".node")
		        .delay(delay)
		        .on("end", function(d, i){
		        	if ( i == nodes.nodes().length - 1 )
		        		positionLinks();
		        }) 
		        .attr("transform", function(d){
			 		var translate = d3.transform( d3.select(this).attr("transform") ).translate;
			 		d.xTranslate =  d.group === 1 ? d.x + publDistanceConstant/2 : d.x + (authDistanceConstant < 0 ? vars.authRadius : 0);
			 		d.yTranslate =  d.group === 1 ? d.y + 200 : d.y + 350;
			 		return "translate(" + [d.xTranslate, d.yTranslate] + ")";
		        });
	};
	
	var positionLinks = function() {
			var transition = d3.transition().duration( 550 ),
				delay      = function(d, i) { return i * 30; };
			
			link.transition(transition).delay( delay )
				.attr("opacity", 1)
				.attr("d", function( d ){
					var xSource = d.source.xTranslate ;
					var ySource = d.source.yTranslate ;
					var xTarget = d.target.xTranslate ;
					var yTarget = d.target.yTranslate ;
			
					return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
			});
    };
	
	svg
  		.attr("viewBox", "0 0 " +vars.width + " " + vars.height)
  		.attr("preserveAspectRatio", "xMinYMin meet")
  		.attr("width",  vars.width)
  		.attr("height", vars.height)
	    .call(zoom);

	var linkWidth = vars.authRadius/8 < 1 ? 1 : vars.authRadius/8 ;
	var link = layer.append("g")
  		.attr("class", "links")
  		.selectAll(".link")
  		.data(data.links)
  		.enter().append("path")
  			.attr("stroke", "black").attr("stroke-width", linkWidth ).attr("stroke-opacity", 0.1).attr("stroke-linecap", "round")
  			.attr("fill", "none")
  			.attr("class", function(d){ return "link" + d.source.name + "-" +d.target.name})
  			.attr("opacity", 0);

	var nodesLayer = layer.append("g").attr("class", "nodes-layer");
	
	var circleDetails = {
			radius		 : function( d ){ return d.group === 1 ? radScale(d.basedOn) : vars.authRadius; },
			fill		 : function( d ){ 
								if (d.group === 2 && d.photo != null && d.photo.length != 0 ){
									createImagePattern( d, d.r );	
									return "url(#pattern_" + d.id + ")" ;
								}
								return "white";// d.group === 1 ? vars.pubColor : vars.authColor; 
						   }, 
			fillOpacity	 : 1,
    		strokeColor  : function( d, color1, color2, step ){ return d.group === 1 ? d3.hsl( color1 ).darker( step ) : d3.hsl( color2 ).darker( step ); },
    		strokeWidth  : 2,
    		strokeOpacity: 1,
    		fontSize	 : 12
    };
	
	var addIcon = function( container, className, icon, color, size){
		container.append('text').classed(className, true)
			.attr("dy", ".35em")
			.attr("fill", color)
			.style('font-size', size + 'px' )
			.style("font-family", "fontawesome")
			.style("text-anchor", "middle")
			.text(icon); 
	};
	
	var createNodesLayer = function(nodesClassName, textClassName, data){
		var nodes = nodesLayer.append("g").attr("class", nodesClassName)
			.selectAll(".node")
			.data( data )
			.enter().append("g")
    			.attr("class", "node")
    			.on("mouseover", mouseover)
    			.on("mouseout", mouseout);
		// add circle
		nodes.append("circle")
			.attr("r", function(d){  d.r = circleDetails.radius(d);
				totalRadius += d.group === 1 ? d.r * 2 : 0;
				return d.r;
			})
			.attr("fill",   	   circleDetails.fill)
			.attr("fill-opacity",  circleDetails.fillOpacity)
			.attr("stroke", 	   function( d ){ return circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ); } )
			.attr("stroke-width",  circleDetails.strokeWidth)
			.attr("stroke-opacity",circleDetails.strokeOpacity);
		
		//add text and add icon
		var distanceConstant  = nodesClassName.indexOf("nodesPubl") >= 0 ? (vars.width - totalRadius ) / data.length : ( vars.width / data.length - vars.authRadius * 2 ) ; 	
		var nodesText         = nodes.append("g").attr("class", textClassName);
		
		nodes.each( function(d){	
			var availableWidth = d.group === 1 ? 2 * d.r + distanceConstant : 2 * d.r + distanceConstant - 5;
			var name = d.group === 1 ? d.name : abbrAuthorName( d. name );
			wrapText( d3.select(this).select("g." + textClassName), name , availableWidth, "name", 12);
			
			if (d.group === 1)
				addIcon(d3.select(this), "image publication", "\uf0f6", circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ), d.r * 1.3);
			else
				if (d.photo ==  null || d.photo.length == 0 )
					addIcon(d3.select(this), "image missing-photo-icon author_avatar", "\uf007", circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ), d.r * 1.3);					
		} );
		//position text
		nodesText.attr("transform", function(d, i){ 
			var height = this.getBBox().height;
			var y	   = d.group === 1 ? -(d.r + height) : distanceConstant <= 0 && i % 2 == 0 ?  -d.r * 2 : d.r * 2;  	
			return "translate(0," + y + ")" ;
		} );
		
		//add label
		nodes.each(function( d ){
			if (d.group === 1){
				var height 		  = this.getBBox().height,
				 	labelFontSize = circleDetails.fontSize + 2,
				 	padding		  = 5;
				
				d3.select(this).append("text")
					.attr("class", "publ-label")
					.attr("fill", circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ))
					.attr("y", d.r + labelFontSize + padding)
					.style("font-size", labelFontSize )
					.text(vars.criterion + ": " + d.basedOn);				
				d3.select(this).append("text")
					.attr("class", "publ-label")
					.attr("fill", circleDetails.strokeColor( d, vars.pubColor, vars.authColor, 2 ))
					.attr("y", -height + d.r - padding)
					.style("font-size", labelFontSize)
					.text( d.year);
			}			
		})
	};
	
	createNodesLayer("nodes nodesPubl", "publ-name", nodesByGroup(1));
	createNodesLayer("nodes nodesAuth", "auth-name", nodesByGroup(2));

	d3.selectAll(".node text").attr("text-anchor","middle").attr("opacity", circleDetails.fillOpacity );
	
	positionNodes( positionLinks );
	  
    simulation.nodes(data.nodes);
    simulation.force("link").links(data.links);    
    
    link.each(function(d) { linkedById[d.source.id + "," + d.target.id] = 1; });
    
    function zoomed() {
    	layer.attr("transform", 'translate(' + d3.event.transform.x + ',' + d3.event.transform.y + ') scale(' + d3.event.transform.k + ')');
    }
    
    function mouseover(d) {	
    	d3.select(this).selectAll("text").transition().duration(550)
	  		.style("font-weight", "bold");
    	
    	d3.selectAll(".node").selectAll("circle").transition().duration(550)
    	  	.attr("fill-opacity",  function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? circleDetails.fillOpacity     : circleDetails.fillOpacity/3 })
    	  	.attr("stroke-width",  function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? circleDetails.strokeWidth + 1 : circleDetails.strokeWidth; })
    	  	.attr("stroke-opacity",function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? circleDetails.strokeOpacity   : circleDetails.strokeOpacity / 10; })
    		.attr("r", 			   function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? l.r + 4 						 : l.r; });
    	d3.selectAll(".node").selectAll("text").transition().duration(550)	
    		.attr("opacity", function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? circleDetails.fillOpacity     : circleDetails.fillOpacity/3 });
    		
    	link.transition().duration(550)
    		.attr("stroke", 		function(l) { return  ( d === l.source || d ===  l.target ) ? (d.group === 1 ? vars.pubColor : vars.authColor) : "black"; })
    		.attr('stroke-width', 	function(l) { return  ( d === l.source || d ===  l.target ) ? ( linkWidth == 1 ? 2 : vars.authRadius/4) : linkWidth; })
    		.attr("stroke-opacity", function(l) { return  ( d === l.source || d ===  l.target ) ? 0.6 : 0.1; });
    }

    function mouseout() {
    	d3.select(this).selectAll("text").transition().duration(550)
  			.style("font-weight", "normal");
	
    	d3.selectAll(".node").selectAll("circle").transition().duration(550)
	  		.attr("fill-opacity",   circleDetails.fillOpacity )
	  		.attr("stroke-width",   circleDetails.strokeWidth )
	  		.attr("stroke-opacity", circleDetails.strokeOpacity )
    		.attr("r",              function( d ){ return d.r; });
    	
    	d3.selectAll(".node").selectAll("text").transition().duration(550)	
			.attr("opacity", circleDetails.fillOpacity );
		
    	link.transition().duration(550)
    		.attr("stroke", "black" )
			.attr('stroke-width', linkWidth )
			.attr("stroke-opacity", 0.1 );
    }
    
    function neighbors(a, b){
    	return linkedById[a.id + "," + b.id];
    }
    
    function createImagePattern( dataObject, imageRadius ){
    	if ( svg.select("defs").node() == undefined)
    		var defs = svg.append("defs");
    	else
    		var defs = svg.select("defs");
    	return defs.append("svg:pattern")
    			.attr("id", "pattern_" + dataObject.id)
    			.attr("class", "author_avatar")
    			.attr("width", 1)
    			.attr("height", 1)
    		   .append("svg:image")
    		   	.attr("xlink:href", dataObject.photo )
    		   	.attr("width", imageRadius * 2)
    		   	.attr("height", imageRadius * 2)
    		   	.attr("x", 0)
    		   	.attr("y", 0);
    }
}

$.bestPapers.filterBy = function( criterion ){
	var vars 	   = $.bestPapers.variables;					  
	var sortedData = sortData( vars.data.nodes.filter( function(n){ return n.group == 1} ), criterion );
	
	var x = d3.scaleBand()
		.rangeRound([0, vars.width])
		.padding(0.5);

	var x0 = x.domain( sortedData.map(function(d) { if ( d.group === 1 ) return d.id ; }).filter( function(n){ return n != undefined} ) );
			console.log(x.domain()); console.log(x.range());
	var svg			= d3.select("#widget-" + vars.wUniqueName + " .visualization-main svg" ), 
		transition  = svg.transition().duration( 750 ),
		delay 		= function(d, i) { return i * 50; };
		delayLinks  = function(d, i) { return i * 30; };

		transition.selectAll("path").attr("opacity", 0);
		
		transition.selectAll(".node").transition(transition)
			.delay(delay)
			 .on("end", function(d, i){
		        	if ( i == x.domain().length - 1 ){
		        		svg.selectAll("path").transition(transition).delay(delayLinks)
		        			.attr("opacity", 1)
		        			.attr("d", function( d ){
		        				var xSource = d.source.xTranslate ;
		        				var ySource = d.source.yTranslate ;
		        				var xTarget = d.target.xTranslate ;
		        				var yTarget = d.target.yTranslate ;
		    			
		        				return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
		        			});
		        	}
		     })
			.attr("transform", function(d) { 
				var translate = d3.transform( d3.select(this).attr("transform") ).translate;									
					
				d.xTranslate = d.group === 1 ? x0(d.id) : translate[0];
				d.yTranslate = translate[1];
				
				return "translate(" + [d.xTranslate, d.yTranslate]+ ")"; 
			});
}

function sortData( data, criterion){
	return data.sort( function(a, b){
		return d3.descending(a[criterion], b[criterion]);
	});
}
function abbrAuthorName( name ){
	var lastName  = name.substring(name.lastIndexOf(" "), name.length);
	var firstName = name.substring(0, name.lastIndexOf(" "));
	var initials  = (firstName.match(/\b(\w)/g)).join(".");
	
	return initials +"."+ lastName.trim() ;
}

function wrapText( container, text, width, className, fontSize){
	var lineHeight = fontSize;
	var y = 0;
	var words = text.split(" ").reverse();
	var textArray = [];
	var text = container.append("text").attr("class", className);
	
	while(word = words.pop()){
		textArray.push(word);
		text.text( textArray.join(" ") );
		
		if ( text.node().getBBox().width > width ){
			y += lineHeight; 
			var w = textArray.pop();
			
			if ( textArray.length == 0 ){
				var ind = splitWord( container, w, width );
				var first = ind == w.length? w.substr(0, ind ) : w.substr(0, ind) + "-";
				textArray.push( first);
				
				w = w.substr( ind, w.length );
			}
			
			text.text( textArray.join(" ") );
			
			textArray = [w];
			text = container.append("text").attr("class", className)
					.attr("dy", y )
					.text( textArray.join(" ") );
		}				
	}
}

function splitWord( container, word, width ){
	var letters = word.split("").reverse();
	var wordArray = [];
	var text  = container.append("text");
	
	while(letter = letters.pop()){
		wordArray.push( letter );
		text.text( wordArray.join("") );
		
		if ( text.node().getBBox().width > width ){
			text.remove();
			return wordArray.length - 1;
		}		
	}
	
	return wordArray.length;
}