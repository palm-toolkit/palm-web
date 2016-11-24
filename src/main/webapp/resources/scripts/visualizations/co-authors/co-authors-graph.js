function createCoauthorsGraph(containerID, data) {
	console.log(data);

	$.COAUTHOR.graph.options.width = $(containerID).width();
	$.COAUTHOR.graph.options.height = $(containerID).height();
	
	$.COAUTHOR.graph.create(containerID, data);
}

$.COAUTHOR = {};

$.COAUTHOR.graph = {};
$.COAUTHOR.graph.options = {
	width : 0,
	height : 0,
	color : d3.scaleOrdinal(d3.schemeCategory20),
	coauthorIconColor : ["#BB11A2", "#10E5BD" , "#DBFB65"],
	coauthorLinkColor: "#CCB5CB"
};
$.COAUTHOR.graph.graphData = function (data){
	var graph = new Object();
	var linksArray = new Array();
		
	data.coAuthors.forEach(function(d, i) {
		var link = new Object();
			link.source = data.author.id;
			link.target = d.id;
			link.value 	= d.coautorTimes;
			linksArray.push(link);
	});
	graph.links = linksArray;
	graph.nodes = data.coAuthors;
	graph.nodes.unshift(data.author);
	
	return graph;
}
$.COAUTHOR.graph.nodes = function (graphData, nodesContainer){
	var graphOptions = this.options;
	
	var node = nodesContainer
		.selectAll("circle")
		.data(graphData.nodes)
		.enter().append("g").attr("class", "node");
	node.append("circle")
		.attr("r", function(d){
			d.radius = 10;
			return d.radius;
		})
		.attr("fill", "transparent");
	
	var text = node.append("text")
		.attr("class", "coauthor-name")
		.text(function(d){ return d.name });
	
	var icon = node.append("text")
		.attr("class", "coauthor-icon")
		.attr("text-anchor", "middle")
		.attr("dominant-baseline", "central")
		.attr("fill", function(d, i){ 
			return graphOptions.coauthorIconColor[ i % 3];
		})
		.style("font-family", "fontawesome")
		.style("font-size", function(d){ return (d.radius * 2) + "px"; })
		.text(function(d) {
			 return "\uf007"; //user icon
		});
   
	this.nodesPosition(node, 120);	

	this.nodes.textPosition(text);
}
$.COAUTHOR.graph.nodes.textPosition = function(text){
	var center = {
			x : $.COAUTHOR.graph.options.width / 2,
			y : $.COAUTHOR.graph.options.height / 2
	};
	text.attr("dx", function(d, i){
			var distance = 10;
			if (i == 0){
				return - this.getComputedTextLength()
			}else{
				if (d.x > (center.x - 15) && d.x < (center.x + 15)) //top or bottom of the circle
					if (d.x < center.x)
						return - this.getComputedTextLength();
					else
						return 0;
		
				if (d.x < center.x)
					return - this.getComputedTextLength() - distance; //left of the circle
				else
					return distance;	//right of the circle
			}
		})
		.attr("dy", function(d, i){	
			if (i == 0){
				return ".35em";
			}else{
				if (d.x > (center.x - 15) && d.x < (center.x + 15))
					if (d.y < center.y)
						return "-.75em";
					else 
						return "1.35em";
				return ".35em";
			}
		});
}

$.COAUTHOR.graph.nodesPosition = function (node, radius){
	var center = { x: this.options.width / 2, y: this.options.height/2};
	var nrNodes = node.nodes().length - 1;
	
	node.attr("transform", function(d, i) {
		if (i != 0){
			var angle = 2 * Math.PI * i / nrNodes;
			d.x = center.x + radius * Math.cos(angle);	
			d.y = center.y + radius * Math.sin(angle);
		}else{
			d.x = center.x;	
			d.y = center.y;	
		}
		d.fixed = true;
		return "translate(" + d.x + "," + d.y + ")";
	});
}

$.COAUTHOR.graph.links = function (graphData, linksContainer){
	var graphOptions = this.options;
	var link = linksContainer.append("g")
		.attr("class", "links")
		.selectAll("line").data(graphData.links)
		.enter().append("line")
			.attr("dy", ".35em")
			.attr("stroke", graphOptions.coauthorLinkColor)
			.attr("stroke-width", function(d) { return Math.sqrt(d.value); })
			.text(function(d) { return d.value; });;
	
	link.attr("x1", function(d) { 
		console.log(d);
		return d.source.x; })
 		.attr("y1", function(d) { return d.source.y; })
 		.attr("x2", function(d) { return d.target.x; })
 		.attr("y2", function(d) { return d.target.y; });
}

$.COAUTHOR.graph.create = function(containerID, data) {
	var graphData = this.graphData(data);
	var graphOptions = this.options;
	
	var svg = d3.select(containerID).append("svg").attr("width", graphOptions.width).attr("height", graphOptions.height);
	var coauthorsLayer = svg.append("g")
		.attr("class", "coauthors-group")
		.call(d3.drag()
			.on("start", dragstarted)
			.on("drag", dragged)
			.on("end", dragended));
	
	var simulation = d3.forceSimulation()
		.force("link", d3.forceLink().id(function(d) { return d.id; }))
		.force("charge", d3.forceManyBody())
		.force("center", d3.forceCenter(graphOptions.width / 2, graphOptions.height / 2));

	simulation.nodes(graphData.nodes);
	simulation.force("link").links(graphData.links);
	
	var linksContainer = coauthorsLayer.append("g")
		.attr("class", "links");
	var nodesContainer = coauthorsLayer.append("g")
		.attr("class", "nodes")
	this.nodes(graphData, nodesContainer);
	this.links(graphData, linksContainer);	
	
//
//	function ticked() {
//		link.attr("x1", function(d) { return d.source.x; })
//		 	.attr("y1", function(d) { return d.source.y; })
//		 	.attr("x2", function(d) { return d.target.x; })
//		 	.attr("y2", function(d) { return d.target.y; });
//
//		
//	}
	
	function dragstarted(d) {
		if (!d3.event.active)
			simulation.alphaTarget(0.3).restart();
		d.fx = d.x;
		d.fy = d.y;
	}

	function dragged(d) {
		d.fx = d3.event.x;
		d.fy = d3.event.y;
	}

	function dragended(d) {
		if (!d3.event.active)
			simulation.alphaTarget(0);
		d.fx = null;
		d.fy = null;
	}
}

$.COAUTHOR.block = {

}