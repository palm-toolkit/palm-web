$.bestPapers = {};
$.bestPapers.variables = {
		padding : 10
};
$.bestPapers.init = function( url, wUniqueName, data, height){
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
		$.bestPapers.variables.width  	   = $mainContainer.children(".visualization-main").width() - margin.left - margin.right;
		$.bestPapers.variables.height 	   = height;
		$.bestPapers.variables.margin	   = margin;
	}
};
$.bestPapers.processData( data ){
	var nodes = []; var links = [];
	
	d3.map( data, function(d){
		var node = { id : d.id, name: d.name, group: 1};
		nodes.push( node );
	})
}

$.bestPapers.visualise = function( data ){
	var $mainContainer = $("#widget-" + wUniqueName + " .visualization-main");
	var vars 	   = $.bestPapers.variables;
	var svg 	   = d3.select( $mainContainer ).append("svg");
	var layer	   = svg.append("g").classed("best-papers-layer", true);	
	var simulation = d3.forceSimulation()
    	.force("link", d3.forceLink().id(function(d) { return d.index }))
    	.force("collide",d3.forceCollide( function(d){return d.r + 8 }).iterations(16) )
    	.force("charge", d3.forceManyBody())
    	.force("center", d3.forceCenter(chartWidth / 2, chartWidth / 2))
    	.force("y", d3.forceY(0))
    	.force("x", d3.forceX(0))
	
    svg.attr("width",  vars.width)
	   .attr("height", vars.height);
	
	layer.attr("transform", "translate(" + [vars.margin.left, vars.margin.top] + ")");
	
	var link = svg.append("g")
    	.attr("class", "links")
    	.selectAll("line")
    	.data(data.links)
    	.enter().append("line")
    		.attr("stroke", "black");

	var node = svg.append("g")
    	.attr("class", "nodes")
    	.selectAll("circle")
    	.data(data.nodes)
    	.enter().append("circle")
    		.attr("r", function(d){  return d.r })
    		.call(d3.drag()
    				.on("start", dragstarted)
    				.on("drag", dragged)
    				.on("end", dragended));
	
	var ticked = function() {
        link
            .attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });
        node
            .attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; });
    }  
    
    simulation
        .nodes(data.nodes)
        .on("tick", ticked);

    simulation.force("link")
        .links(data.links);    
    
    function dragstarted(d) {
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
    } 
}