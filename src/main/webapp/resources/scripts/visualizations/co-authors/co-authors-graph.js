function createCoauthorsGraph(containerID, data, chartHeight, currentURL) {
	$.COAUTHOR.graph.options.width = $(containerID).width();
	$.COAUTHOR.graph.options.height = chartHeight;
	
	$.COAUTHOR.graph.options.containerID = containerID;
	$.COAUTHOR.graph.options.currentURL = currentURL;
	
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
	coauthorLinkColor: "#eee",
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
	
	//Filter values
	var boxClass	  =	 $.COAUTHOR.graph.options.containerID.substr( 0, $.COAUTHOR.graph.options.containerID.length - " .visualization-main".length - 1 ).split("-")[1];;
	var filterOrderBy = "coauthorTimes";
	var filterGroupBy = "affiliation";

	var $orderBySelected = $("#boxbody-" + boxClass + " .orderedBy .dropdown-menu li.selected");
	var $groupBySelected = $("#boxbody-" + boxClass + " .groupedBy .dropdown-menu li.selected");
	
	var initialFilters = function( $el, filter ){
		if ( $el.data("value") != filter ){
			$el.removeClass("selected disabled");
			var $otherElem = $el.prev() != null && $el.prev().length != 0 ? $el.prev() : $el.next();
			$otherElem.addClass("selected disabled");
			$otherElem.parents(".dropdown").children("button").html( $otherElem.text() + " <span class='caret'></span>" );
		}
	};
	initialFilters($orderBySelected, filterOrderBy);
	initialFilters($groupBySelected, filterGroupBy);
	
	$("#boxbody-" + boxClass + " .showInterests input").prop("checked", true);
	
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
		
		if ( d.commonPublications != undefined && d.commonPublications.length > 0){
			d.commonPublications.map( function(publ, pos){
				if (publicationsIds.indexOf( publ.id ) == -1){
					selectedAuthorPublications.push( publ );
					publicationsIds.push( publ.id );
				}
			});
		}
	});
	
	data.author.commonPublications = selectedAuthorPublications.sort( function( a, b ){
		return new Date( b.date ) - new Date( a.date);
	});

	
	graphCoauthors.links = linksArray;																		
	graphCoauthors.nodes = filterGroupBy == "affiliation" ? groupDataByAffiliation( sortData( data.coAuthors, filterOrderBy, "desc" ), data.author ) : sortData( data.coAuthors, filterOrderBy, "desc" );
		
	var dataGraph = new Object();
		dataGraph.coauthors = graphCoauthors;
	
	var interestNodes= interests;
	var sortedinterests = sortData( interestNodes, "value", "desc" );
	
	var maxinterestsNumber = 40;
	graphinterests.nodes = sortedinterests.length <= maxinterestsNumber ? sortedinterests : sortedinterests.slice( 0, maxinterestsNumber );
	graphinterests.links = [];
	
	var graphtopics = {};
	var topics = $.COAUTHOR.graph.graphData.mostUsedTopics(data.author.commonPublications);
	
	graphtopics.nodes = maxinterestsNumber < topics.length ? topics.slice(0, maxinterestsNumber) : topics;
	graphtopics.links = [];
	
	dataGraph.interests = graphinterests;
	dataGraph.topics 	= graphtopics;
	
	return dataGraph;
	
	function sortData( data, orderBy, order){
		return data.sort( function(nodeA, nodeB){
			return order == "desc" ? d3.descending(nodeA[orderBy], nodeB[orderBy]) : d3.ascending(nodeA[orderBy], nodeB[orderBy]);
		});
	}
	
	function groupDataByAffiliation( data, author ){
		var grouped = {"same" : [], "national" :[], "international":[], "unknown" :[] };
		
		var authorAffiliation = author.aff;
		author.institutionAffiliation = "same";
		
		data.forEach(function(coauthor, index){
			if ( coauthor.aff != null && authorAffiliation != null ){
				var isSameCountry = coauthor.aff.country == authorAffiliation.country && authorAffiliation.country != null;
				var isSameInstitution = coauthor.aff.institution == authorAffiliation.institution && authorAffiliation.institution != null;		
				
				coauthor.institutionAffiliation = isSameInstitution ? "same" : isSameCountry ? "national" : "international";
				grouped[ coauthor.institutionAffiliation ].push( coauthor );

			}else
				grouped[ "unknown" ].push( coauthor );	
		});
		
		return  [ author ].concat( grouped["same"], grouped["national"], grouped["international"], grouped["unknown"] );
	}
}
$.COAUTHOR.graph.graphData.mostUsedTopics = function( publications ){
	var topicsObject = [];
	var common = [];
	publications.forEach( function(p, i){
			for (key in p.topics){
				var termValues = p.topics[key].termvalues != null ? p.topics[key].termvalues : [];
				for ( term in termValues ){
					
					var exists = topicsObject.filter( function( t ){ 
						if (t.term == term.toLowerCase() )
							t.value +=1;
						return t.term == term.toLowerCase();
					});
					if ( exists.length == 0){ //not in list
						topicsObject.push ( { id: guid(), term : term.toLowerCase(), value :1 } );
					}
				}
			}
		});
	
	topicsObject = topicsObject.sort( function( a, b ){ return b.value - a.value; });
	
	return topicsObject;
	
	function guid() {
		  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
		    s4() + '-' + s4() + s4() + s4();
		}

	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
		    .toString(16)
		    .substring(1);
	}
}

$.COAUTHOR.graph.create = function(containerID, data) {
	var graphOptions  = this.options;	
	var graphData     = this.graphData(data);
	var coauthorsData = graphData.coauthors;
	
	var svg = d3.select(containerID).append("svg");
	var gGraph = svg.append("g").attr("class", "gGraph");
	
	svg.call(d3.zoom().scaleExtent([1/2, 8])
			.on("zoom", zoomed))
			.on("dblclick.zoom", null);
	
	svg.attr("viewBox", "0 0 " + graphOptions.width + " " + (graphOptions.height - graphOptions.margin.bottom - graphOptions.margin.top) )
		.attr("preserveAspectRatio", "xMinYMin meet");
	//---------------- coauthors
	var coauthorsLayer = gGraph.append("g")
		.attr("class", "gCoauthors");
	
	var simulationCoauthors = createSimulation(coauthorsData);
	
	var linksContainer = coauthorsLayer.append("g")
		.attr("class", "links");
	
	var nodesContainer = coauthorsLayer.append("g")
		.attr("class", "nodes");
	
	var distanceToCenter = coauthorsData.nodes.length < 20 ? ( 5 * coauthorsData.nodes.length + 50 * 1/(coauthorsData.nodes.length/10) ) : 4 * coauthorsData.nodes.length ;
	graphOptions.coauthor_distanceToCenter = distanceToCenter;
	
	this.nodes(coauthorsData, nodesContainer, "coauthor", distanceToCenter);
	this.links(coauthorsData, linksContainer);	
	
	//-------------- interests
//	var interestsData  = graphData.interests;	
//	
//	var interestsLayer = gGraph.append("g")
//		.attr("class", "gInterests");
//	
//	var simulationinterests = createSimulation(interestsData);
//	
//	var nodesContainer   = interestsLayer.append("g")
//		.attr("class", "nodes");
//	
//	var authorLayerSize = d3.select(containerID + " .gCoauthors").node().getBBox();
//	var distancePadding = 10;
//	distanceToCenter = authorLayerSize.width > authorLayerSize.height ? authorLayerSize.width / 2 + distancePadding: authorLayerSize.height / 2 + distancePadding;
//		
//	this.nodes(interestsData, nodesContainer, "interest", distanceToCenter);
	
	//-------------- topics
	var topicsData  = graphData.topics;	
	var topicsLayer = gGraph.append("g")
		.attr("class", "gTopics");
	var simulationTopics = createSimulation(topicsData);
	
	var nodesContainer   = topicsLayer.append("g")
		.attr("class", "nodes");

	var authorLayerSize = d3.select(containerID + " .gCoauthors").node().getBBox();
	var distancePadding = 20;
	distanceToCenter = authorLayerSize.width > authorLayerSize.height ? authorLayerSize.width/2  + distancePadding: authorLayerSize.height/2  + distancePadding;
	
	this.nodes(topicsData, nodesContainer, "topic", distanceToCenter);
	
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

$.COAUTHOR.graph.nodes = function (graphData, nodesContainer, mode, distance){
	var graphOptions = this.options;
	
	var coauthRadiusScale = d3.scaleLinear()
		.domain( [d3.min( graphData.nodes, function( d ){ return d.hindex; } ), d3.max( graphData.nodes, function( d ){ return d.hindex; } ) ] )
		.range( [4, 15] );

	var node = nodesContainer
		.selectAll(".node." + mode)
		.data(graphData.nodes)
		.enter().append("g")
			.attr("class", "node " + mode)
			.attr("id", function(d){ return d.id; });
	
	//user icon
	var icon = node.append("text")
		.attr("class", mode + "-icon " + mode)
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
		.style("font-size", function(d){ 
			var radius = d.hindex != null ? coauthRadiusScale( d.hindex ) : 5
			return (radius * 2) + "px"; })
		.text(function(d) { 
			if ( mode === "coauthor")
				return "\uf007"; 
			else
				return "\uf0c8"; 
		}); 

	var text = node.append("text")
		.attr("class", mode + "-name " + mode)
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
	
	if ( mode == "topic"){
		node.append("title").text( function( d ){ return "Appears in " + d.value +" publications"; });
	}
	node.append("circle")
		.attr("r", function(d){
			d.radius = d.hindex != null ? coauthRadiusScale( d.hindex ) : 5;
			return d.radius;
		})
		.attr("fill", "transparent");

	this.nodesPosition(node, distance, mode);	
	this.nodes.textPosition(text, mode);
	
	node.on("mouseenter", this.interactions.nodeMouseOver )
		.on("mouseleave", this.interactions.nodeMouseLeave )
		.on("click", this.interactions.nodeClicked );
}

$.COAUTHOR.graph.nodesPosition = function (node, radius, mode){
	var angleScale = d3.scalePoint()		
		.range([0, 2 * Math.PI])
		.domain( node.nodes().map( function( d, i ){ if ( i != 0 || mode !== "coauthor" ) return d3.select(d).datum().id; }) );

	if ( mode !== "coauthor")
		angleScale.range([0, 2 * Math.PI - 2 * Math.PI/node.nodes().length ]);
	
	var center = { x: this.options.width / 2, y: this.options.height/2};
	
	node.attr("transform", function(d, i) {
		if ( $.PALM.selected.researcher == d.id ){
			d.x = center.x;	
			d.y = center.y;	
		}else{
			d.angle =  angleScale( d.id ) ;
			d.x = center.x + radius * Math.cos( d.angle );	
			d.y = center.y + radius * Math.sin( d.angle );
		}
		d.fixed = true;
		return "translate(" + d.x + "," + d.y + ")";
	});
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
		if ( $.PALM.selected.researcher == d.id )
			return "middle";
		else 
			if (d.x < center.x)
				return "end";
			else return "start";
	})
	.attr("dx", function(d, i){
		if ( $.PALM.selected.researcher == d.id || isElemOnTopOrBottom(d.angle, angleSegm))
			return 0;
		else 
			if (d.x < center.x)
				return "-1.35em";
			else 
				return "1.35em";
	})
	.attr("dy", function(d, i){
		if ( $.PALM.selected.researcher == d.id )
			return "1em";
		if (isElemOnTopOrBottom(d.angle, angleSegm))
			if (d.y < center.y)
				return "-.95em";
			else 
				return "1.55em";
		return ".35em";
	})
	.attr("y", function(d, i){ if( $.PALM.selected.researcher == d.id ) return d.radius; });

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
	
	var positionTextLinks = function ( source, target){
		return  source > target ? target + (source - target)/2 : source + (target - source)/2;
	};
	
	text.attr("x", function(d){ return positionTextLinks(d.source.x, d.target.x); })
		.attr("y", function(d){ return positionTextLinks(d.source.y, d.target.y); });		
}


$.COAUTHOR.graph.showInterests = function( show ){
	var svg = d3.select($.COAUTHOR.graph.options.containerID + " svg" );
	
	svg.select(".gInterests").classed("hidden", show == 0 ? true : false);
	svg.select(".gTopics").classed("hidden", show == 0 ? true : false);
};

$.COAUTHOR.graph.orderBy = function( orderBy, groupBy ){
	var vars 	   = $.COAUTHOR.graph.options,
		svg		   = d3.select(vars.containerID + " svg" );
	
	//order nodes
	var nodes 		   = svg.selectAll(".node.coauthor").nodes();
	var selectedAuthor = nodes.shift();
	var orderedData	   = groupBy === "noGroup" ? sortData( nodes, orderBy, "desc" ) : groupDataAffiliation( sortData( nodes, orderBy, "desc" ) );
	
	nodesId = [];
	orderedData.map(function( d ){ nodesId.push( d3.select(d).datum().id ); });
	
	var angleScale = d3.scalePoint()		
		.range([0, 2 * Math.PI - 2 * Math.PI / orderedData.length ])
		.domain( nodesId );

	var center = { x: vars.width / 2, y: vars.height/2};
	var radius = vars.coauthor_distanceToCenter;
	
	var transition  = svg.transition().duration( 750 ),
		delay 		= function(d, i) { return i * 50; };
		delayLinks  = function(d, i) { return i * 30; };
	
	d3.selectAll( nodes ).transition(transition).attr("transform", function(d, i) {
		d.fixed = true;
		d.angle = angleScale( d.id );
		
		d.x = center.x + radius * Math.cos( d.angle );	
		d.y = center.y + radius * Math.sin( d.angle );
		
		return "translate(" + d.x + "," + d.y + ")";
	});
	nodes.unshift( selectedAuthor );
	$.COAUTHOR.graph.nodes.textPosition( d3.selectAll( nodes ).selectAll( "text.coauthor-name" ), "coauthor" );
		
	//order links
	var links = svg.selectAll(".link").nodes();
	d3.selectAll( links )
		.selectAll("line").transition(transition)
			.attr("x2", function(d) { return center.x + radius * Math.cos( angleScale( d.target.id ) ); })
			.attr("y2", function(d) { return center.y + radius * Math.sin( angleScale( d.target.id ) ); });
	d3.selectAll( links )
		.selectAll("text").transition(transition)
			.attr("x", function(d){ return positionTextLinks( d.source.x, d.target.x); })
			.attr("y", function(d){ return positionTextLinks( d.source.y, d.target.y); });

	function positionTextLinks( source, target){
		return  source > target ? target + (source - target)/2 : source + (target - source)/2;
	}
	
	function sortData( data, criterion, order){
		return data.sort( function(a, b){
			var nodeA = d3.select(a).datum(),
				nodeB = d3.select(b).datum();
			return order == "desc" ? d3.descending(nodeA[criterion], nodeB[criterion]) : d3.ascending(nodeA[criterion], nodeB[criterion]);
		});
	}
	
	function groupDataAffiliation( data ){
		var grouped = {"same" : [], "national" :[], "international":[], "unknown" :[] };
		data.map( function( a ){
			var nodeData = d3.select(a).datum();
			if ( nodeData.institutionAffiliation != null)
				grouped[ nodeData.institutionAffiliation ].push( a );
			else
				grouped[ "unknown" ].push( a );
		})
			
		return grouped["same"].concat( grouped["national"], grouped["international"], grouped["unknown"] );
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
					highlightCoauthorTopics(this, node);
					
					node.affiliation = node.aff != null ? node.aff.institution : null;
					
					//tooltip
					if ( node.angle != null )
						addTooltip( d3.select(this), node );
					
					//image
					if ( node.photo != null && node.photo.length != 0 ){						
							createImagePattern( node, node.radius  );	
							d3.select(this).select("circle")
								.attr("fill", "url(#pattern_" + node.id + ")");	
					}
				}else { //interest mouseover
					highlightNodeInterest(this, node);
					highlightInterestCoauthors(this, node);
					
					// topic mouseover
					highlightNodeTopic(this, node);
					highlightTopicCoauthors(this, node);
				} 
				
				function addTooltip( gnode, node ){
					var position = node.angle <= Math.PI/2 || 
								   node.angle >= Math.PI * 3/2 ? "right" : "left";
					var params = {
							className 	: "tooltip-coauthor",
							width 		: 200,
							height		: 80,
							fontSize	: 9,
							borderRadius: 5,
							imageRadius	: 30,
							position    : position,
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
					
					d3.select( $.COAUTHOR.graph.options.containerID + " .tooltip-content")
						.attr("transform", function(d){ 
							if ( params.position === "right") 
								return d3.select(this).attr("transform").split("rotate")[0] + "rotate(" + tooltipRotate +")";
							else
								return "rotate(" + tooltipRotate +")"; 
						});
				}
				
				function createImagePattern( dataObject, imageRadius ){
					var svg = d3.select( $.COAUTHOR.graph.options.containerID + " svg");
			    	if ( svg.select("defs").node() == undefined)
			    		var defs = svg.append("defs");
			    	else
			    		var defs = svg.select("defs");
			    	return defs.append("svg:pattern")
			    			.attr("id", "pattern_" + dataObject.id)
			    			.attr("class", "author_avatar")
			    			.attr("width", 1)
			    			.attr("height", 1)
			    			.attr('patternContentUnits', 'objectBoundingBox')
			    		   .append("svg:image")
			    		   	.attr("xlink:href", dataObject.photo )
			    		   	.attr("width", 1)
			    		   	.attr("height", 1)
			    		   	.attr("preserveAspectRatio", "xMinYMin slice");
			    }
				
	},
	nodeMouseLeave : function(d){
				var containerID = $.COAUTHOR.graph.options.containerID;
				d3.selectAll( containerID + " .node").classed("disabled", false).classed("hovered", false)
					.selectAll(".topic-icon").style("font-size", null);
				d3.selectAll( containerID + " .link").classed("disabled", false);
				d3.select( containerID + " svg" ).selectAll( ".tooltip-coauthor" ).remove();	
				
				d3.select(this).select("circle")
					.attr("fill", "transparent")
					.attr("r", d.radius);	
				
				d3.select(this).select(".coauthor-icon").style("display", "block");
	},
	nodeClicked : function( node ){
		d3.selectAll($.COAUTHOR.graph.options.containerID + " g.node")
			.classed("clicked", false)
			.selectAll("circle")
				.style("stroke", "transparent");
		d3.select(this).classed("clicked", true);	
		
		if ( Object.keys(node).indexOf("name") >= 0 ){ //click on coauthor		
			d3.select(this).select("circle").style("stroke", $.COAUTHOR.graph.options.coauthorIconColor[ node.institutionAffiliation ] || "grey");
			$.COAUTHOR.graph.publications( node );	
		}else{
			var publications = findPublicationsOnInterestOrTopic( node.term );
			$.COAUTHOR.graph.publications( {name : node.term, commonPublications : publications} );	
			
		}
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
		data.publications = node.commonPublications;//.sort( function( a, b){ return a.year - b.year; } );
		data.totalPublication = node.commonPublications.length;
	
	$mainContainer.html("");
	if ( !$mainContainer.hasClass("small") ) 
		$mainContainer.addClass("small");
	
	//create list
	$.publicationList.init( "ok",  widgetUniqueName, $.COAUTHOR.graph.options.currentURL, null, containerFullHeight - legendHeight - $.COAUTHOR.graph.options.margin.bottom - $.COAUTHOR.graph.options.margin.top);
	$.publicationList.visualize( $mainContainer, data);
	
	var title = "(" + data.publications.length + ") : " + node.name;
		
	$("#publications-box-" + widgetUniqueName + " .box-header .author_name").html( title );
	$("#publications-box-" + widgetUniqueName + " .box-header .box-title-container").removeClass("box-title-container");	
	$("#publications-box-" + widgetUniqueName + " .pull-left").css("display", "none");
	$("#publications-box-" + widgetUniqueName + " .timeline .time-label").css("display", "none");
}

function findPublicationsOnInterestOrTopic( topic ){
	var containerID = $.COAUTHOR.graph.options.containerID;
	var publicationsOnInterest = [];
	
	var author = d3.select( containerID + " .gCoauthors .node.coauthor");	
	
	var commonPublications = author.datum().commonPublications;
	
	for( var i = 0; i < commonPublications.length; i++ ){
		var hasTopic = commonPublications[i].topics.filter( function( publTopic ){ 
			var keys = Object.keys( publTopic.termvalues ).map(function(x) { return x.toLowerCase(); });
			return keys.indexOf( topic.toLowerCase() ) >= 0; 
		});
		if ( hasTopic.length != 0 )
			if ( publicationsOnInterest.indexOf( publicationsOnInterest[i] ) < 0)
				publicationsOnInterest = publicationsOnInterest.concat( commonPublications[i] );
	}

	return publicationsOnInterest;
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
		
		d3.select( nodeDOM ).select("circle").attr("r", 30);
}

function highlightCoauthorinterests(nodeDOM, nodeObject){
	var containerID = $.COAUTHOR.graph.options.containerID;
	if( nodeObject.commonInterests != undefined ){
		if ( nodeObject.commonInterests.length != 0 ){
			d3.selectAll( containerID + " .gInterests g.node").classed("disabled", function(n){
				var found =  $.grep(nodeObject.commonInterests, function(topic){ return topic.id == n.id; });
				if (found.length != 0){
					d3.select(this).select("text").style("font-size", "105%");
					return false;
				}
				return true;
			});
		}else
			d3.selectAll( containerID + " .gInterests .node").classed("disabled", true);
	}else
		d3.selectAll( containerID + " .gInterests .node").classed("disabled", false);
}

function highlightCoauthorTopics(nodeDOM, nodeObject){
	var containerID = $.COAUTHOR.graph.options.containerID;
	if( nodeObject.commonPublications != undefined ){
		if ( nodeObject.commonPublications.length != 0 ){
			var topicsPubl = $.COAUTHOR.graph.graphData.mostUsedTopics( nodeObject.commonPublications );
			
			d3.selectAll( containerID + " .gTopics g.node")
				.classed("disabled", function(n){
					if ( topicsPubl != null && topicsPubl.length > 0){
						var found =  $.grep(topicsPubl, function(topic){ return topic.term == n.term; });
						if (found.length != 0){
							d3.select(this).select("text").style("font-size", "105%");
							return false;
						}
					}			
					return true;
			});
		}else
			d3.selectAll( containerID + " .gTopics .node").classed("disabled", true);
	}else
		d3.selectAll( containerID + " .gTopics .node").classed("disabled", false);
}

function neighbouring(a, b){
	var linkedByIndex = {};
	d3.selectAll( $.COAUTHOR.graph.options.containerID + " .link").nodes().forEach( function(link){
		linkedByIndex[d3.select(link).datum().source.index + "," + d3.select(link).datum().target.index] = 1;
	});
	
	return linkedByIndex[a.index + "," + b.index];
}

function highlightNodeInterest(nodeDOM, nodeObject){
	d3.selectAll( $.COAUTHOR.graph.options.containerID + " .gInterests .node").classed("disabled", true);				
	d3.select(nodeDOM).classed("disabled", false);

}

function highlightNodeTopic(nodeDOM, nodeObject){
	d3.selectAll( $.COAUTHOR.graph.options.containerID + " .gTopics .node").classed("disabled", true);				
	d3.select(nodeDOM).classed("disabled", false);

}

function highlightInterestCoauthors(nodeDOM, nodeObject){
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

function highlightTopicCoauthors(nodeDOM, nodeObject){
	var topicCoauthors = [];
	var containerID = $.COAUTHOR.graph.options.containerID;
	d3.selectAll( containerID + " .gCoauthors .node").classed("disabled", function(author, i){
		if ( author.commonPublications != undefined && author.commonPublications.length > 0 ){
			var topicsPubl = $.COAUTHOR.graph.graphData.mostUsedTopics( author.commonPublications );
			
			if ( topicsPubl != null && topicsPubl.length > 0){
				var found = $.grep(topicsPubl, function(commonTopic){return commonTopic.term == nodeObject.term});
				if (found.length != 0){
					topicCoauthors.push( author );
					return false;	
				}	
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