function createCoauthorsGraph(containerID, data, chartHeight) {
	console.log(data);

	$.COAUTHOR.graph.options.width = $(containerID).width();
	$.COAUTHOR.graph.options.height = chartHeight;
	
	$.COAUTHOR.graph.options.containerID = containerID;
	
	$(containerID).html("");
	$.COAUTHOR.graph.create(containerID, data);
}

$.COAUTHOR = {};

$.COAUTHOR.graph = {};
$.COAUTHOR.graph.options = {
	width : 0,
	height : 0,
	margin : {
		left : 20, right : 20, top : 20, bottom : 20
	},
	color : d3.scaleOrdinal(d3.schemeCategory20),
	coauthorIconColor : {"same" : "#1f2f62", "national" : "#764d37" , "international" : "#13ae9c"},
	coauthorLinkColor: "#CCB5CB",
	topicIconColor : "rgb(198, 1, 73)",
	scaleTopicIconColor : d3.scale.linear().interpolate(d3.interpolateHcl).range(["rgb(255, 222, 26)", "rgb(0, 0, 0)"])
};

$.COAUTHOR.graph.graphData = function (data){
	var graphCoauthors = new Object();
	var graphinterests = {};
	var linksArray  = [];
	var interests 	    = [];
	var selectedAuthorPublications = [];
	var publicationsIds = [];
	data.coAuthors.forEach(function(d, i) {
		var link = new Object();
			link.source = data.author.id;
			link.target = d.id;
			link.value 	= d.coauthorTimes;
			linksArray.push(link);
		if ( d.commonInterests != undefined ){
			d.commonInterests.forEach(function(topic, index){
				var found = interests.filter(function(t){ return t.term === topic.term });
				if ( found.length == 0 )
					interests.push(topic);
				else
					found[0].value += topic.value;
			});
		}
		
		d.commonPublications.map( function(publ, pos){
			if (publicationsIds.indexOf( publ.id ) == -1){
				selectedAuthorPublications.push( publ );
				publicationsIds.push( publ.id );
			}
		});
	});
	
	data.author.commonPublications = selectedAuthorPublications;

	graphCoauthors.links = linksArray;
	graphCoauthors.nodes = sortCoauthorsByAffiliationAndImportance_decreasing(data, "hindex");
	
	var dataGraph = new Object();
		dataGraph.coauthors = graphCoauthors;
		
	var topicNodes= interests;
	var sortedinterests = topicNodes.sort(function(a, b){ //decreasing order
		if (a.value > b.value) return -1;
		else
			if (a.value < b.value) return 1;
			else
				return 0;
	});

	var maxinterestsNumber = 50;
	if (sortedinterests.length > maxinterestsNumber)
		sortedinterests = sortedinterests.slice( 0, maxinterestsNumber );
	
	graphinterests.nodes = sortedinterests;
	graphinterests.links = [];
	
	dataGraph.interests = graphinterests;
	
	return dataGraph;
	
	function sortCoauthorsByAffiliationAndImportance_decreasing( data, criterion ){
		var sameUniversity = []; var nationalUniversity = []; var internationalUniversity = []; var unaffiliated = [];
		var authorAffiliation = data.author.aff;
		data.author.institutionAffiliation = "same";
		
		data.coAuthors.forEach(function(coauthor, index){
			if ( coauthor.aff != null && authorAffiliation != null ){
				if ( coauthor.aff.country == authorAffiliation.country ){
					if ( coauthor.aff.institution == authorAffiliation.institution ){
						coauthor.institutionAffiliation = "same";
						sameUniversity.push( coauthor );
					}
					else {
						coauthor.institutionAffiliation = "national";
						nationalUniversity.push( coauthor );
					}
				}else{
					coauthor.institutionAffiliation = "international";
					internationalUniversity.push( coauthor );	
				}
			}else
				unaffiliated.push( coauthor );	
		});
		
		var sortBy_desc = function(a, b){ //decreasing order
			if (a[criterion] > b[criterion]) return -1;
			else
				if (a[criterion] < b[criterion]) return 1;
				else
					return 0;
		};
		
		sameUniversity 			= sameUniversity.sort(sortBy_desc);
		nationalUniversity 	    = nationalUniversity.sort(sortBy_desc);
		internationalUniversity = internationalUniversity.sort(sortBy_desc);
		
		var coauthorsNodes = [];
		
		coauthorsNodes.push(data.author);
		coauthorsNodes = coauthorsNodes.concat(sameUniversity);
		coauthorsNodes = coauthorsNodes.concat(nationalUniversity);
		coauthorsNodes = coauthorsNodes.concat(internationalUniversity);
		
		coauthorsNodes = coauthorsNodes.concat(unaffiliated);
		
		return coauthorsNodes;
	}
}
$.COAUTHOR.graph.nodes = function (graphData, nodesContainer, mode, distance){
	var graphOptions = this.options;
	
	var coauthRadiusScale = d3.scaleLinear()
		.domain( [d3.min( graphData.nodes, function( d ){ return d.hindex; } ), d3.max( graphData.nodes, function( d ){ return d.hindex; } ) ] )
		.range( [4, 20] )
	var node = nodesContainer
		.selectAll("circle")
		.data(graphData.nodes)
		.enter().append("g")
			.attr("class", "node")
			.attr("id", function(d){ return d.id; });
	node.append("circle")
		.attr("r", function(d){
			d.radius = d.hindex != null ? coauthRadiusScale( d.hindex ) : 5;
			return d.radius;
		})
		.attr("fill", "transparent");
	
	var icon = node.append("text")
		.attr("class", mode + "-icon")
		.attr("text-anchor", "middle")
		.attr("dominant-baseline", "central")
		.attr("fill", function(d, i){ 
			if ( mode === "coauthor"){
				var institutionAffiliation = graphOptions.coauthorIconColor[d.institutionAffiliation];
					return institutionAffiliation != null ? institutionAffiliation : "grey" ;
			}
			else{
				var minValue = d3.min(graphData.nodes, function(d){ return d.value});
				var maxValue = d3.max(graphData.nodes, function(d){ return d.value});
				graphOptions.scaleTopicIconColor.domain( [ minValue, maxValue ] );
				
				return graphOptions.scaleTopicIconColor(d.value);
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
			if ( mode === "coauthor" ){
				var lastName  = d.name.substring(d.name.lastIndexOf(" "), d.name.length);
				var firstName = d.name.substring(0, d.name.lastIndexOf(" "));
				var initials  = firstName == "" ? "" : (firstName.match(/\b(\w)/g)).join(". ");
				
				return initials == "" ? lastName : initials + "." + lastName;
			}	
			else	
				return d.term;
		});
	
	this.nodesPosition(node, distance, mode);	
	this.nodes.textPosition(text);
	
	node.on("mouseenter", this.interactions.nodeMouseOver )
		.on("mouseleave", this.interactions.nodeMouseLeave )
		.on("click", this.interactions.nodeClicked );
}

$.COAUTHOR.graph.nodes.textPosition = function(text, mode){
	var center = {
			x : $.COAUTHOR.graph.options.width / 2,
			y : $.COAUTHOR.graph.options.height / 2
	};
	var nrNodes 	= mode === "coauthor" ? text.nodes().length - 1 : text.nodes().length;
	var angleSegm 	= (2 * Math.PI) / nrNodes;
	var distance	= 10;
	
	$.COAUTHOR.graph.options.angleCoauthor = angleSegm;
	
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
	
	var link = linksContainer.selectAll("line")
		.data(graphData.links)
		.enter().append("g").attr("class", "link");
	
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
	var graphData     = this.graphData(data);
	var coauthorsData = graphData.coauthors;
	
	var svg = d3.select(containerID).append("svg").attr("width", graphOptions.width).attr("height", graphOptions.height - graphOptions.margin.bottom - graphOptions.margin.top);
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
	
	var distanceToCenter = coauthorsData.nodes.length < 10 ? 5 * coauthorsData.nodes.length + 50: 5 * coauthorsData.nodes.length ;
	this.nodes(coauthorsData, nodesContainer, "coauthor", distanceToCenter);
	this.links(coauthorsData, linksContainer);	
	
	//-------------- interests
	var interestsData  = graphData.interests;	
	
	var interestsLayer = gGraph.append("g")
		.attr("class", "ginterests");
	
	var simulationinterests = createSimulation(interestsData);
	
	var nodesContainer   = interestsLayer.append("g")
		.attr("class", "nodes");
	
	var authorLayerSize = d3.select(containerID + " .gCoauthors").node().getBBox();
	var distancePadding = 20;
	distanceToCenter = authorLayerSize.width > authorLayerSize.height ? authorLayerSize.width / 2 + distancePadding: authorLayerSize.height / 2 + distancePadding;
		
	this.nodes(interestsData, nodesContainer, "topic", distanceToCenter);
	
	//-------------- legend
	var containerDetailsID = containerID.substr(0, containerID.length - ".visualization-main".length) + "visualization-details";
	this.legend( containerDetailsID );
	
	this.publications( data.author );
	
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
$.COAUTHOR.graph.legend = function (containerID){
	var graphOptions = this.options;
	var legendContainer  = $("<div/>").addClass("divLegend");
	
	$(containerID).children(".divLegend").remove();
	
	legendContainer.append($("<span/>").addClass("title-legend").text("Legend"));
	legendContainer.append(function(){
			var ul = $("<ul/>").addClass("listElemLegend");
	
			var liCoauthorImportance  = createLegendElement("<div/>", "divCoauthorImportance", "Coauthor H-index", ["High", "", "", "", "Low"], {"icon":"fa fa-user", "repetition" : 5});
			var liTopicImportance     = createLegendElement("<div/>", "divTopicImportance", "Topic Importance", ["High", "", "", "", "Low"],{"icon":"fa fa-square", "repetition" : 5});
			var liNrCollaborations    = createLegendElement("<div/>", "divNrCollaborations", "Collaborations", [">50", "", "", "", "<10"], {"icon":"line-nrCollaborations", "repetition" : 5});
			var liCoauthorAffiliation = createLegendElement("<div/>", "divCoauthorAffiliation", "Coauthor Affiliation", ["Same University", "National University", "International University"], {"icon":"fa fa-user", "repetition" : 3});
			
			ul.append(liCoauthorImportance);
			ul.append(liTopicImportance);
			ul.append(liNrCollaborations);
			ul.append(liCoauthorAffiliation);
			
			return ul;
		});
	$(containerID).prepend(legendContainer);
	
	styleCoauthorImportanceLegend("#divCoauthorImportance"   + " .measurement-units");
	styleTopicImportanceLegend("#divTopicImportance"         + " .measurement-units");
	styleNrCollaborationsLegend("#divNrCollaborations"       + " .measurement-units");
	styleCoauthorAffiliationLegend("#divCoauthorAffiliation" + " .measurement-units");
	
	function createLegendElement(elementHTML, id, title, labels, measurementUnit){
		var liElem = $("<li/>");
		var elementLegend  = $(elementHTML).attr("id", id);
			elementLegend.append($("<span/>").addClass("title-label title small").text(title));
			elementLegend.append($("<div/>").addClass("measurement small")
				.append(function(){
					var divMeasurementLabels = $("<div/>").addClass("measurement-labels");
					if (labels != undefined)
						for (var i = 0; i < labels.length; i++)
							divMeasurementLabels.append( $("<span/>").text(labels[i]) );
					return divMeasurementLabels;
				})
				.append(function(){
					var divMeasurementUnits = $("<div/>").addClass("measurement-units");
					if (measurementUnit != undefined)
						for (var i = 0; i < measurementUnit.repetition; i++){
							divMeasurementUnits.append( $("<span/>").addClass(measurementUnit.icon));
						}
					return divMeasurementUnits;
				}));
		liElem.append(elementLegend);
		
		return liElem;
	}
	
	function styleCoauthorImportanceLegend(containerID){
		var initialFontSize = 30;
		var children = $(containerID).children();
		for (var i  = 0; i < children.length; i++){
			$(children[i]).css("fontSize", (initialFontSize - 5*i) + "px");
			$(children[i]).css("margin-top", 5*i + "px");
		}
	}
	function styleTopicImportanceLegend(containerID){
		var children = $(containerID).children();
		graphOptions.scaleTopicIconColor.domain([5, 0])
		for (var i  = 0; i < children.length; i++){
			$(children[i]).css("color", graphOptions.scaleTopicIconColor(i));
		}
	}
	function styleNrCollaborationsLegend(containerID){
		var initialBorderTopSize = 9;
		var children = $(containerID).children();
		for (var i  = 0; i < children.length; i++){
			$(children[i]).css("border-bottom-width", (initialBorderTopSize - 2*i) + "px");
		}
	}
	function styleCoauthorAffiliationLegend(containerID){
		var initialBorderTopSize = 17;
		var children = $(containerID).children();

		$(children[0]).css("color", graphOptions.coauthorIconColor["same"]);
		$(children[1]).css("color", graphOptions.coauthorIconColor["national"]);
		$(children[2]).css("color", graphOptions.coauthorIconColor["international"]);
		
	}
}

$.COAUTHOR.graph.interactions = {
	nodeMouseOver : function( node ){
				if ( Object.keys(node).indexOf("name") >= 0 ){ //co-author mouseover
					highlightNodeCoauthor(this, node);
					highlightCoauthorinterests(this, node);
					node.affiliation = node.aff != null ? node.aff.institution : null;
					if ( node.angle != null )
						addTooltip( d3.select(this), node );
				}else { // topic mouseover
					highlightNodeTopic(this, node);
					highlightTopicCoauthors(this, node);
				} 
				
				function addTooltip( gnode, node ){
					var params = {
							className 	: "tooltip-coauthor",
							width 		: 200,
							height		: 80,
							fontSize	: 9,
							borderRadius: 5,
							imageRadius	: 30,
							position    : node.angle < Math.PI/2 + $.COAUTHOR.graph.options.angleCoauthor || node.angle > Math.PI * 3/2 - $.COAUTHOR.graph.options.angleCoauthor ?  "right" : "left",
							bkgroundColor : "rgba(255, 255, 255, 0.83)",
							strokeColor : "#ececec",
							withImage	: false,	
							container	: gnode 
					};
					var tooltipS = new Tooltip( params );
					tooltipS.buildTooltip( gnode, node );	
					var tooltipTranslate = params.position == "right" ? [5, params.height/2] : [5, -params.height/2];
					var tooltipRotate	 = params.position == "right" ? 180 : 0;
					d3.select( $.COAUTHOR.graph.options.containerID + " .tooltip-coauthor")
						.attr("transform", "translate(" + tooltipTranslate + ")rotate(" + tooltipRotate +")");		
				}
	},
	nodeMouseLeave : function(){
				var containerID = $.COAUTHOR.graph.options.containerID;
				d3.selectAll( containerID + " .node").classed("disabled", false).classed("hovered", false);
				d3.selectAll( containerID + " .link").classed("disabled", false);
				d3.select( containerID + " svg" ).selectAll( ".tooltip-coauthor" ).remove();	
	},
	nodeClicked : function( node ){
		d3.selectAll($.COAUTHOR.graph.options.containerID + " g.node")
			.classed("clicked", false)
			.selectAll("circle")
				.style("stroke", "transparent");
		d3.select(this).classed("clicked", true);	
		d3.select(this).select("circle").style("stroke", $.COAUTHOR.graph.options.coauthorIconColor[ node.institutionAffiliation ] || "grey");
		$.COAUTHOR.graph.publications( node );			
	}
};

$.COAUTHOR.graph.publications = function( node ){
	//containers
	var mainContainerID 	= $.COAUTHOR.graph.options.containerID;
	var widgetUniqueName 	= mainContainerID.substr( 0, mainContainerID.length - " .visualization-main".length - 1 ).split("-")[1];
	var detailsContainerID 	= widgetUniqueName + ".visualization-details" ;
	var $mainContainer 	 	= $("#publications-box-" + widgetUniqueName + " .box-content");
	
	//heights
	var containerFullHeight = $.COAUTHOR.graph.options.height - $.COAUTHOR.graph.options.margin.bottom - $.COAUTHOR.graph.options.margin.top;
	var legendHeight 		= $( "#widget-" +  widgetUniqueName + " .divLegend").height();
	
	//data
	var data = {}; 
		data.element = node;
		data.publications = node.commonPublications.sort( function( a, b){ return a.year - b.year; } );
		data.totalPublication = node.commonPublications.length;
	
	$mainContainer.html("");
	if ( !$mainContainer.hasClass("small") ) 
		$mainContainer.addClass("small");
	
	//create list
	$.publicationList.init( "ok",  widgetUniqueName, null, null, containerFullHeight - legendHeight - $.COAUTHOR.graph.options.margin.bottom - $.COAUTHOR.graph.options.margin.top);
	$.publicationList.visualize( $mainContainer, data);
	
	//remove/add list elements
	$("#publications-box-" + widgetUniqueName + " .box-header .author_name").html( "with "  + node.name );
	$("#publications-box-" + widgetUniqueName + " .box-header .box-title-container").removeClass("box-title-container");	
	$("#publications-box-" + widgetUniqueName + " .pull-left").css("display", "none");
}

function highlightNodeCoauthor(nodeDOM, nodeObject){
		var containerID = $.COAUTHOR.graph.options.containerID;
		d3.selectAll( containerID + " .gCoauthors .node").classed("disabled", function(n){
			return ( neighbouring( nodeObject, n ) == true) ? false : true;
		});				
		d3.select(nodeDOM).classed("disabled", false).classed("hovered", nodeObject.angle == null ? false : true );
	
		d3.selectAll( containerID + " .gCoauthors .link").classed("disabled", function(link) {
			return (link.source === nodeObject || link.target === nodeObject) ? false : true;
		});
}

function highlightCoauthorinterests(nodeDOM, nodeObject){
	var containerID = $.COAUTHOR.graph.options.containerID;
	if( nodeObject.commonInterests != undefined ){
		if ( nodeObject.commonInterests.length != 0 ){
			d3.selectAll( containerID + " .ginterests g.node").classed("disabled", function(n){
				var found =  $.grep(nodeObject.commonInterests, function(topic){ return topic.id == n.id; });
				if (found.length != 0)
					return false;
				return true;
			});
		}else
			d3.selectAll( containerID + " .ginterests .node").classed("disabled", true);
	}else
		d3.selectAll( containerID + " .ginterests .node").classed("disabled", false);
}

function neighbouring(a, b){
	var linkedByIndex = {};
	d3.selectAll( $.COAUTHOR.graph.options.containerID + " .link").nodes().forEach( function(link){
		linkedByIndex[d3.select(link).datum().source.index + "," + d3.select(link).datum().target.index] = 1;
	});
	
	return linkedByIndex[a.index + "," + b.index];
}

function highlightNodeTopic(nodeDOM, nodeObject){
	d3.selectAll( $.COAUTHOR.graph.options.containerID + " .ginterests .node").classed("disabled", true);				
	d3.select(nodeDOM).classed("disabled", false);

}

function highlightTopicCoauthors(nodeDOM, nodeObject){
	var topicCoauthors = [];
	var containerID = $.COAUTHOR.graph.options.containerID;
	d3.selectAll( containerID + " .gCoauthors .node").classed("disabled", function(author, i){
		if (author.commonInterests != undefined){
			var found = $.grep(author.commonInterests, function(commonTopic){return commonTopic.id == nodeObject.id});
			if (found.length != 0){
				topicCoauthors.push( author );
				return false;	
			}			
			return true;
		}			
	});				
	d3.select(nodeDOM).classed("disabled", false);
	
	d3.selectAll( containerID + " .gCoauthors .link").classed("disabled", function(link) {		
		var found = $.grep(topicCoauthors, function(author){return link.source === author || link.target === author});
		return found.length > 0 ? false : true;
	});
}

$.COAUTHOR.block = {

}