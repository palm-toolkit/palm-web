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
	coauthorLinkColor: "#CCB5CB",
	topicIconColor : "#ead6fd",
	scaleTopicIconColor : d3.scaleLinear().range([0, 6])
};

$.COAUTHOR.graph.graphData = function (data){
	var graphCoauthors = new Object();
	var graphTopics = new Object();
	var linksArray = new Array();
		
	data.coAuthors.forEach(function(d, i) {
		var link = new Object();
			link.source = data.author.id;
			link.target = d.id;
			link.value 	= d.coautorTimes;
			linksArray.push(link);
	});
	graphCoauthors.links = linksArray;
	graphCoauthors.nodes = data.coAuthors;
	graphCoauthors.nodes.unshift(data.author);
	
	var dataGraph = new Object();
		dataGraph.coauthors = graphCoauthors;
	
	//graph.nodes = data.topics;	
	var topicNodes= [{ 
		"id"   : "23e905c-6237-4cd5-922c-7b9b04bd95f8",
		"name" : "grammatical relation",
		"value": 0.85
	},
	{ 
		"id"   : "3ee60023-ba39-4d8c-8b3e-a8940cf9014a",
		"name" : "natural language processing",
		"value": 1.0
	},
	{ 
		"id"   : "112b98a5-e4e9-4da1-9a0f-6c194c50f41f",
		"name" : "feature selection",
		"value": 0.5059523809523809
	},
	{ 
		"id"   : "81dd0115-75be-4f7a-906d-a6ff65a1d25c",
		"name" : "gibbs sampling",
		"value": 0.40062111801242234
	},
	{ 
		"id"   : "dbe81081-1462-4466-85f6-723592b2485d",
		"name" : "conditional random field",
		"value": 1.9257815049792703
	},
	{ 
		"id"   : "a49b489d-738a-44d1-a05e-587fd7318799",
		"name" : "information extraction",
		"value": 1.0
	},
	{ 
		"id"   : "73148710-341e-464c-acb9-7e8a0da8f8d6",
		"name" : "semantic role labeling",
		"value": 0.95886190017476784
	},
	{ 
		"id"   : "f0566908-4d65-436f-b733-973df833ccc9",
		"name" : "textual entailment",
		"value": 1.4407653242559631
	},
	{ 
		"id"   : "0bfbe602-475e-4915-aa5f-bf04c5621e5d",
		"name" : "information retrieval",
		"value": 0.4340728373891882
	},
	{ 
		"id"   : "ce110f79-995d-42c3-9b48-2ee46ec3ed2c",
		"name" : "machine translation",
		"value": 1.1879156070947388
	},
	{ 
		"id"   : "3cceff8f-667c-4282-874e-5c585a96f436",
		"name" : "parse tree",
		"value": 0.44349649765208005
	},
	{ 
		"id"   : "6751c59d-a77c-4e2b-b20a-59e95ff15da4",
		"name" : "recursive neural network",
		"value": 1.03599047591020964
	},
	{ 
		"id"   : "1093ecc9-8779-47d0-97b8-ffded4489733",
		"name" : "topic model",
		"value": 1.2944732677788363
	},
	{ 
		"id"   : "a5ab10b3-17fc-4a6e-821c-b23d78113502",
		"name" : "part-of-speech tagging",
		"value": 0.415344699777613
	},
	{ 
		"id"   : "ca4c0ac1-9634-40a8-8930-77e348454457",
		"name" : "deep learning",
		"value": 0.5841252096143097
	},
	{ 
		"id"   : "1a2c04c7-4085-481e-a3c6-b8c8e000e2b9",
		"name" : "neural machine translation",
		"value": 1.0
	},
	{ 
		"id"   : "2e73332d-732a-4c1a-97f3-f658065420d5",
		"name" : "long short-term memory",
		"value": 0.8833333333333333
	}    
	];
	var sortedTopics = topicNodes.sort(function(a, b){ //decreasing order
		if (a.value > b.value) return -1;
		else
			if (a.value < b.value) return 1;
			else
				return 0;
	});

	graphTopics.nodes = sortedTopics;
	graphTopics.links = [];
	
	dataGraph.topics = graphTopics;
	
	return dataGraph;
}
$.COAUTHOR.graph.nodes = function (graphData, nodesContainer, mode, distance){
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
	
	var icon = node.append("text")
		.attr("class", mode + "-icon")
		.attr("text-anchor", "middle")
		.attr("dominant-baseline", "central")
		.attr("fill", function(d, i){ 
			if ( mode === "coauthor")
				return graphOptions.coauthorIconColor[ i % 3];
			else{
				var minValue = d3.min(graphData.nodes, function(d){ return d.value});
				var maxValue = d3.max(graphData.nodes, function(d){ return d.value});
				graphOptions.scaleTopicIconColor.domain( [ minValue, maxValue ] );
				
				return d3.rgb(graphOptions.topicIconColor).darker( graphOptions.scaleTopicIconColor(d.value) );
			}
		})
		.style("font-family", "fontawesome")
		.style("font-size", function(d){ return (d.radius * 2) + "px"; })
		.text(function(d) { 
			if ( mode === "coauthor")
				return "\uf007"; 
			else
				return "\uf0c8"; 
		}); //user icon

	var text = node.append("text")
		.attr("class", mode + "-name")
		.text(function(d, i){ 
			if (i == 0 && mode === "coauthor"){
				var lastName  = d.name.substring(d.name.lastIndexOf(" "), d.name.length);
				var firstName = d.name.substring(0, d.name.lastIndexOf(" "));
				var initials  = (firstName.match(/\b(\w)/g)).join(". ");
				
				return initials + "." + lastName;
			}	
			else	
				return d.name;
		});
	
	this.nodesPosition(node, distance, mode);	
	this.nodes.textPosition(text);
}

$.COAUTHOR.graph.nodes.textPosition = function(text, mode){
	var center = {
			x : $.COAUTHOR.graph.options.width / 2,
			y : $.COAUTHOR.graph.options.height / 2
	};
	var nrNodes 	= mode === "coauthor" ? text.nodes().length - 1 : text.nodes().length;
	var angleSegm 	= (2 * Math.PI) / nrNodes;
	var distance	= 10;
	
	text.attr("text-anchor", function(d, i){ 
		if (d.x == center.x)
			return "middle";
		else 
			if (d.x < center.x)
				return "end";
			else return "start";
	})
	.attr("dx", function(d, i){
		if (d.x == center.x || isElemOnTopOrBottom(d.angle, angleSegm))
			return 0;
		else 
			if (d.x < center.x)
				return - 12;
			else 
				return 12;
	})
	.attr("dy", function(d, i){
		if (d.y == center.y)
			return ".35em";
		if (isElemOnTopOrBottom(d.angle, angleSegm))
			if (d.y < center.y)
				return "-.95em";
			else 
				return "1.55em";
		return ".35em";
	});

	function isElemOnTopOrBottom(angle, angleSegment){
		var angleBottom = Math.PI / 2;
		var angleTop    = 3 * Math.PI / 2;

		if (angleTop % angleSegment == 0){
			if (angle == angleBottom || angle == angleTop)
				return true;
		}else{
			if (angle > (angleBottom - angleSegment) && angle < (angleBottom + angleSegment))
				return true;
			if (angle > (angleTop - angleSegment) && angle < (angleTop + angleSegment))
				return true;
		}
		
		return false;
	}
}

$.COAUTHOR.graph.nodesPosition = function (node, radius, mode){
	var center = { x: this.options.width / 2, y: this.options.height/2};
	var nrNodes =  mode === "coauthor" ? node.nodes().length - 1 : node.nodes().length;
	
	node.attr("transform", function(d, i) {
		if (i == 0 && mode === "coauthor"){
			d.x = center.x;	
			d.y = center.y;	
		}else{
			var angle = 2 * Math.PI * i / nrNodes;
			d.angle = angle;
			d.x = center.x + radius * Math.cos(angle);	
			d.y = center.y + radius * Math.sin(angle);
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
		.enter().append("g");
	
	var line = link.append("line")
		.attr("class", "link-line")
		.attr("dy", ".35em")
		.attr("stroke", graphOptions.coauthorLinkColor)
		.attr("stroke-width", function(d) { return Math.sqrt(d.value); })
		.text(function(d) { return d.value; });;
	
	var text = link.append("text")
		.attr("class", "link-value")
		.attr("dx", "-.55em")
		.attr("dy", ".35em")
		.text(function(d) { return d.value; });
	
	line.attr("x1", function(d) { return d.source.x; })
 		.attr("y1", function(d) { return d.source.y; })
 		.attr("x2", function(d) { return d.target.x; })
 		.attr("y2", function(d) { return d.target.y; });
	
	text.attr("x", function(d){
		if (d.source.x > d.target.x)
			return d.target.x + (d.source.x - d.target.x)/2;
		else 
			return d.source.x + (d.target.x - d.source.x)/2;
		})
		.attr("y", function(d){
			if (d.source.y > d.target.y)
				return d.target.y + (d.source.y - d.target.y)/2;
			else 
				return d.source.y + (d.target.y - d.source.y)/2;
		});
}

$.COAUTHOR.graph.create = function(containerID, data) {
	var graphOptions  = this.options;	
	var coauthorsData = this.graphData(data).coauthors;
	
	var svg = d3.select(containerID).append("svg").attr("width", graphOptions.width).attr("height", graphOptions.height);
	var gGraph = svg.append("g").attr("class", "gGraph");
	svg.call(d3.zoom().scaleExtent([1/2, 8])
			.on("zoom", zoomed));
	//---------------- coauthors
	var coauthorsLayer = gGraph.append("g")
		.attr("class", "gCoauthors");
	
	var simulationCoauthors = createSimulation(coauthorsData);
	
	var linksContainer = coauthorsLayer.append("g")
		.attr("class", "links");
	
	var nodesContainer = coauthorsLayer.append("g")
		.attr("class", "nodes");
	
	var distanceToCenter = 5 * coauthorsData.nodes.length;
	this.nodes(coauthorsData, nodesContainer, "coauthor", distanceToCenter);
	this.links(coauthorsData, linksContainer);	
	
	//-------------- topics
	var topicsData  = this.graphData(data).topics;	
	
	var topicsLayer = gGraph.append("g")
		.attr("class", "gTopics");
	
	var simulationTopics = createSimulation(topicsData);
	
	var nodesContainer   = topicsLayer.append("g")
		.attr("class", "nodes");
	
	if (coauthorsData.nodes.length > topicsData.nodes.length)
		distanceToCenter += 5 * coauthorsData.nodes.length;
	else
		distanceToCenter += 5 * topicsData.nodes.length;
	
	this.nodes(topicsData, nodesContainer, "topic", distanceToCenter);
	
	//-------------- legend
	var legendContainer = gGraph.append("g")
		.attr("class", "gLegend");
	
	this.legend(legendContainer);
	
	function zoomed() {
		gGraph.attr("transform", d3.event.transform);
	}
	
	function createSimulation(data){
		var simulation = d3.forceSimulation()
			.force("link", d3.forceLink().id(function(d) { return d.id; }))
			.force("charge", d3.forceManyBody())
			.force("center", d3.forceCenter(graphOptions.width / 2, graphOptions.height / 2));

		simulation.nodes(data.nodes);
		simulation.force("link").links(data.links);
		
		return simulation;
	}
}
$.COAUTHOR.graph.legend = function (legendContainer){

}

}


$.COAUTHOR.block = {

}