$.bestPapers = {};
$.bestPapers.variables = {
		padding : 10,
		pubColor: "blue",
		authColor: "red",
		minRadius: 10,
		maxRadius: 50,
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
				citedBy : d.cited || Math.floor((Math.random() * 100) + 1), 
				year	: d.date,
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
	var citValue   = function(d){ if( d.citedBy != undefined ) return d.citedBy; };
	var radScale   = d3.scaleLinear()
		.domain([d3.min(data.nodes, citValue), d3.max(data.nodes, citValue)])
		.range([vars.minRadius, vars.maxRadius]);
	var totalRadius = 0;
	
	var $mainContainer = $("#widget-" + vars.wUniqueName + " .visualization-main");
	var svg 	   = d3.select("#widget-" + vars.wUniqueName + " .visualization-main" ).append("svg");
	var layer	   = svg.append("g").classed("best-papers-layer", true);	
	var simulation = d3.forceSimulation()
    	.force("link", d3.forceLink().id(function(d) { return d.index }))
    	.force("collide",d3.forceCollide( function(d){ if (d.group == 1) return radScale(d.citedBy) +8; else return 18; }).iterations(16) )
    	.force("charge", d3.forceManyBody())
    	.force("center", d3.forceCenter(vars.width / 2, vars.height / 2));
   
	var zoom = d3.zoom()
		.scaleExtent([0.7, 1.4])
		.on("zoom", zoomed);

	var nodesByGroup = function( group ){ return data.nodes.filter( function(d){ return d.group == group;} ); };
	
	var positionNodes = function(){
		 	var nodes = d3.selectAll(".node");
		 	var publDistanceConstant = (vars.width - totalRadius ) / nodesPubl.nodes().length;
		 	var authDistanceConstant = (vars.width - (nodesAuth.nodes().length * vars.authRadius * 2)) / nodesAuth.nodes().length;
		 		 	
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
		 	
		 	d3.select(".nodesPubl").attr("transform", "translate(" + publDistanceConstant/2 + ", 200)");
		 	d3.select(".nodesAuth").attr("transform", "translate(" + (authDistanceConstant < 0 ? vars.authRadius : 0) + ", 350)");
	};
	
	var positionLinks = function() {
		var publLayerTranslate = d3.transform( d3.select(".nodesPubl").attr("transform") ).translate;
		var authLayerTranslate = d3.transform( d3.select(".nodesAuth").attr("transform") ).translate;
		
		link.attr("d", function( d ){
			var xSource = d.source.group ==  1 ? d.source.x + publLayerTranslate[0] : d.source.x + authLayerTranslate[0];
			var ySource = d.source.group ==  1 ? d.source.y + publLayerTranslate[1] : d.source.y + authLayerTranslate[1];
			var xTarget = d.target.group ==  1 ? d.target.x + publLayerTranslate[0] : d.target.x + authLayerTranslate[0];
			var yTarget = d.target.group ==  1 ? d.target.y + publLayerTranslate[1] : d.target.y + authLayerTranslate[1];
			
		    return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
		});
    }  
	
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
  			.attr("class", function(d){ return "link" + d.source.name + "-" +d.target.name});

	var nodesLayer = layer.append("g").attr("class", "nodes-layer");
	
	//layer publications
	var nodesPubl = nodesLayer.append("g").attr("class", "nodes nodesPubl")
		.selectAll(".node")
		.data( nodesByGroup(1) )
    	.enter().append("g")
    		.attr("class", "node")
    		.on("mouseover", mouseover)
    		.on("mouseout", mouseout);
	
	nodesPubl.append("circle")
    		.attr("r", function(d){  
    			d.r = radScale(d.citedBy);
    			totalRadius += d.r * 2;
    			return d.r;
    		})
    		.attr("fill", function(d){  return vars.pubColor; }).attr("fill-opacity", 0.6)
    		.attr("stroke", function(d){  return vars.pubColor; }).attr("stroke-width", 1);
	var nodesPublText = nodesPubl.append("g").attr("class", "publ-name");
	
	var distanceConstant  = (vars.width - totalRadius ) / nodesPubl.nodes().length	
	nodesPubl.each( function(d){	
		var availableWidth = 2 * d.r + distanceConstant;
		wrapText( d3.select(this).select("g.publ-name"), d.name , availableWidth, "name", 12);} 
	);

	nodesPublText.attr("transform", function(d){ 
		var height = this.getBBox().height;
		return "translate(0," + -(d.r + height) + ")" } );
  
    //layer authors   	
	var nodesAuth = nodesLayer.append("g").attr("class", "nodes nodesAuth")
		.selectAll(".node")
		.data( nodesByGroup(2) )
    	.enter().append("g")
    		.attr("class", "node")
    		.on("mouseover", mouseover)
    		.on("mouseout", mouseout);
	
	nodesAuth.append("circle")
    		.attr("r", function(d){  
    			d.r = vars.authRadius;
    			return d.r;
    		})
    		.attr("fill", function(d){  return vars.authColor; }).attr("fill-opacity", 0.6)
    		.attr("stroke", function(d){  return vars.authColor; }).attr("stroke-width", 1);
	
	var distanceConstant = (vars.width - (nodesAuth.nodes().length * vars.authRadius * 2)) / nodesAuth.nodes().length; 	
	var nodesAuthText = nodesAuth.append("g").attr("class", "auth-name").attr("transform", function (d, i) {
		var y = distanceConstant <= 0 && i % 2 == 0 ?  -d.r * 2 : d.r * 2;  			  
		return "translate(0," + y + ")";
	});
	
	nodesAuth.each( function(d){ 
		var availableWidth = 2 * d.r + distanceConstant;
		wrapText( d3.select(this).select("g.auth-name"), abbrAuthorName( d.name ) , availableWidth, "name", 12);} 
	);
	
	d3.selectAll(".name").attr("text-anchor","middle");
		
	positionNodes();
	positionLinks();
	   
    simulation.nodes(data.nodes);

    simulation.force("link")
        .links(data.links);    
    
    var linkedById = {};
    link.each(function(d) { 
    	linkedById[d.source.id + "," + d.target.id] = 1;
    });
    
    function zoomed() {
    	layer.attr("transform", 'translate(' + d3.event.transform.x + ',' + d3.event.transform.y + ') scale(' + d3.event.transform.k + ')');
    }
    
    function mouseover(d) {	
    	d3.select(this).selectAll("text").transition().duration(750)
	  		.style("font-weight", "bold");
    	
    	d3.selectAll(".node").selectAll("circle").transition().duration(750)
    	  	.attr("fill-opacity", function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? 0.8 : 0.3 })
    		.attr("r", 			  function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? l.r + 4 : l.r; })
    		.attr("stroke-width", function(l){ return neighbors(d, l) || neighbors(l, d) || d === l ? 2 : 1; });
    	
    	link.transition().duration(750)
    		.attr("stroke", 		function(l) { return  ( d === l.source || d ===  l.target ) ? (d.group === 1 ? vars.pubColor : vars.authColor) : "black"; })
    		.attr('stroke-width', 	function(l) { return  ( d === l.source || d ===  l.target ) ? ( linkWidth == 1 ? 2 : vars.authRadius/4) : linkWidth; })
    		.attr("stroke-opacity", function(l) { return  ( d === l.source || d ===  l.target ) ? 0.6 : 0.1; });
    }

    function mouseout() {
    	d3.select(this).selectAll("text").transition().duration(750)
  			.style("font-weight", "normal");
	
    	d3.selectAll(".node").selectAll("circle").transition().duration(750)
	  		.attr("fill-opacity",  0.6)
	  		.attr("stroke-width", 1)
    		.attr("r", function( d ){ return d.r; });
    	
    	link.transition().duration(750)
    		.attr("stroke", "black" )
			.attr('stroke-width', linkWidth )
			.attr("stroke-opacity", 0.1 );
    }
    
    function neighbors(a, b){
    	return linkedById[a.id + "," + b.id];
    }
}

function abbrAuthorName( name ){
	var lastName  = name.substring(name.lastIndexOf(" "), name.length);
	var firstName = name.substring(0, name.lastIndexOf(" "));
	var initials  = (name.match(/\b(\w)/g)).join(". ");
	
	return lastName.trim() ;
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