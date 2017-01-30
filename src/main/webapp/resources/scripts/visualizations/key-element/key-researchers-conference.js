$.activeResearchers = {};
$.activeResearchers.variables ={
		widgetUniqueName : undefined,
		isUserLogged 	 : undefined,
		currentURL       : undefined,
		containerId 	 : undefined,		
		width : 1100,
		height: 600,
		h	  : 600,
		U	  : 200,
		K 	  : 22, 
		S 	  : 20,
		s 	  : 8,
		R 	  : 90,
		initialDegree : 40, 
		o 	  : 15, 
		t 	  : 10, 
		transitionDuration : 1000, 
		easeType : "elastic", 
		highLightColor : "#f39c12",
		L	  : {},
		k 	  : {},
		line  : undefined,
		diagonal : undefined
};
$.activeResearchers.init = function(widgetUniqueName, conferenceName, conferenceURI, currentURL, isUserLogged){
	var vars = $.activeResearchers.variables;
	vars.containerId 	  = "#widget-" + widgetUniqueName;	
	vars.width  		  = $(vars.containerId).width();
	vars.radius 		  = Math.min( $.SIMILAR.variables.width / 2 , $.SIMILAR.variables.height  );
	vars.widgetUniqueName = widgetUniqueName;
	vars.currentURL		  = currentURL;
	vars.isUserLogged	  = isUserLogged;
	
	var mappedJsonObject, mergedJsonObjectArray, combinedJsonObject, linkObject, episodeConceptLinkJsonArray;

	var r = d3.layout.tree()
		.size([360, vars.h / 2 - vars.R])
		.separation(function(Y, X) {
			return (Y.parent == X.parent ? 1 : 2) / Y.depth;
		});
			
	vars.diagonal = d3.svg.diagonal.radial()
		.projection(function(X) {
			return [X.y, X.x / 180 * Math.PI];
		});
			
	vars.line = d3.svg.line()
		.x(function(X) { return X[0]; })
		.y(function(X) { return X[1]; })
		.interpolate("bundle")
		.tension(0.5);
			
	var graphSVG = d3.select(vars.containerId +" .box-body").append("svg")
		.attr("width",  vars.width)
		.attr("height", vars.height)
		.append("g")
			.attr("transform", "translate(" + vars.width / 2 + "," + vars.height / 2 + ")");
							
	var linkGraphSVG 	= graphSVG.append("g").attr("class", "links"); 
	var episodeGraphSVG = graphSVG.append("g").attr("class", "episodes");
	var nodeGraphSVG 	= graphSVG.append("g").attr("class", "nodes");	
	
	createLightGradientColor(graphSVG);
	createDarkGradientColor(graphSVG);
};
$.activeResearchers.data = function( url ){
	d3.json(url, function(error, originJsonObject) {
		if (originJsonObject != undefined && originJsonObject.episodes != undefined)
			originJsonObject.episodes = originJsonObject.episodes.slice(0, 20);
		var mappedJsonObject      = d3.map(originJsonObject);		
		var mergedJsonObjectArray = d3.merge(mappedJsonObject.values());
		var combinedJsonObject 	  = {};
			
			
		mergedJsonObjectArray.forEach(function(thisJsonObject) {	
			thisJsonObject.key = getLowerCase(thisJsonObject.name);
			thisJsonObject.canonicalKey = thisJsonObject.key;
			combinedJsonObject[thisJsonObject.key] = thisJsonObject;								
		});
			
		linkObject = d3.map();				
		mappedJsonObject.get("episodes").forEach(function(episodeJsonObject) {
			// remove bad links
			episodeJsonObject.links = episodeJsonObject.links.filter(function(ab) {
				return typeof combinedJsonObject[getLowerCase(ab)] !== "undefined" && ab.indexOf("r-") !== 0;
			});
		});
		
		console.log("mappedJsonObject");
		console.log(mappedJsonObject);
		console.log("mergedJsonObjectArray");
		console.log(mergedJsonObjectArray);
		console.log("combinedJsonObject");
		console.log(combinedJsonObject);
		
		var episodeConceptLinkJsonArray = prepareData(mappedJsonObject, combinedJsonObject);
		$.activeResearchers.visualize(mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
			
	});
	
	function prepareData(mappedJsonObject, combinedJsonObject){
		var vars = $.activeResearchers.variables;
		if (vars.L.node === null) return;
			
		vars.L = {
			node : null,
			map  : {}
		};
		var i = Math.floor(vars.height / mappedJsonObject.get("episodes").length);
		var y = Math.floor(mappedJsonObject.get("episodes").length * i / 2);
		
		mappedJsonObject.get("episodes").forEach(function(jsonRecord, index) {
			jsonRecord.x = vars.U / -2;
			jsonRecord.y = index * i - y;						
		});
		// initial degree determines the initial configuration, it's a global variable
		var startDegree = 180 + vars.initialDegree, 
			endDegree   = 360 - vars.initialDegree, 
			rotateDegree= (endDegree - startDegree) / (mappedJsonObject.get("themes").length - 1);
		
		mappedJsonObject.get("themes").forEach(function(jsonRecord, index) {
			jsonRecord.x = endDegree - index * rotateDegree;
			jsonRecord.y = vars.h / 2 - vars.R;
			jsonRecord.xOffset = -vars.S;
			jsonRecord.depth   = 1;
		});
			
		startDegree = vars.initialDegree;
		endDegree   = 180 - vars.initialDegree;
		rotateDegree= (endDegree - startDegree) / (mappedJsonObject.get("perspectives").length - 1);
		
		mappedJsonObject.get("perspectives").forEach(function(jsonRecord, index) {
			jsonRecord.x = index * rotateDegree + startDegree;
			jsonRecord.y = vars.h / 2 - vars.R;
			jsonRecord.xOffset = vars.S;
			jsonRecord.depth = 1;
		});
			
		episodeConceptLinkJsonArray = [];	
		
		var linkJsonObject, Y, aa, X = vars.h / 2 - vars.R;
		
		mappedJsonObject.get("episodes").forEach( function(jsonEpisodeObject) {
			jsonEpisodeObject.links.forEach( function(linkString) {
				linkJsonObject = combinedJsonObject[getLowerCase(linkString)];
				
				if (!linkJsonObject || linkJsonObject.type === "reference") return;
									
				Y  = (linkJsonObject.x - 90) * Math.PI / 180;
				aa = jsonEpisodeObject.key + "-to-" + linkJsonObject.key;
				
				episodeConceptLinkJsonArray.push({
					source : jsonEpisodeObject,
					target : linkJsonObject,
					key : aa,
					canonicalKey : aa,
					x1 : jsonEpisodeObject.x + (linkJsonObject.type === "theme" ? 0: vars.U),
					y1 : jsonEpisodeObject.y + vars.K / 2,
					x2 : Math.cos(Y) * X + linkJsonObject.xOffset,
					y2 : Math.sin(Y) * X
				});
			});
		});
		
		return episodeConceptLinkJsonArray;
	}
};

$.activeResearchers.visualize = function( mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray ){
	this.visualize.links(episodeConceptLinkJsonArray);
	this.visualize.elements(mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
};

$.activeResearchers.visualize.links = function(episodeConceptLinkJsonArray){
	var vars = $.activeResearchers.variables;
	var linkGraphSVG = d3.select(vars.containerId + " svg g.links");
	var paths = linkGraphSVG.selectAll("path").data(episodeConceptLinkJsonArray, this.key);
	var enter = paths
		.enter().append("path")
		.attr("class", "link")
		.attr("d", function(Z) {
			var Y = Z.source ? 
						{ x : Z.source.x, y : Z.source.y } : { x : 0, y : 0};
			return vars.diagonal({
						source : Y,
						target : Y
			});
		});
	paths.attr("d", function(X) {
				return vars.line([[X.x1, X.y1], [X.x1, X.y1], [X.x1, X.y1]]);
		});
	paths.merge(enter)
		.transition().duration(vars.transitionDuration).ease(d3.easeElastic)
			.attr("d", function(X) { return vars.line([[X.x1, X.y1], [X.target.xOffset * vars.s, 0],[X.x2, X.y2]]); });	
}

$.activeResearchers.visualize.elements = function(mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
	this.elements.episodes(mappedJsonObject.get("episodes"), mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
	this.elements.nodes(d3.merge([mappedJsonObject.get("themes"), mappedJsonObject.get("perspectives")]), mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
};

$.activeResearchers.visualize.interactions = {
		mouseoverEpisode : function(episode, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
			var linkObject = d3.map();							
			mappedJsonObject.get("episodes").forEach(function(episodeJsonObject) {							
				linkObject.set(episodeJsonObject.key, episodeJsonObject.links.map(function(link) {
					var key = getLowerCase(link);
					if (typeof linkObject.get(key) === "undefined") {
						linkObject.set(key, []);
					}
					linkObject.get(key).push(episodeJsonObject);
							
					return combinedJsonObject[key];
				}) );
			});
			
			mouseOnEpisode(episode, linkObject, episodeConceptLinkJsonArray);
		},
		mouseleaveEpisode:  function(episode){
			vars.k = {
					node : null,
					map : {}
			};
			
			highLightElements();
		},
		click : function (episode){		
			var vars = $.activeResearchers.variables;
			var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
			var keywordText = thisWidget.element.find("#publist-search").val() || "";
			var queryString = "?id=" + episode.id + "&year=all&query=" + keywordText + "&queryKeywords=" + episode.links;
			
			thisWidget.options.queryString = queryString;
			thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
			
			//show the widget 
			thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).removeClass("hidden");
			
			//get publications from json
			var url = vars.currentURL + "/resources/json/publicationList.json"
			$.get( vars.currentURL + "/researcher/publicationList" + queryString , function( response ){ 
				// this has to be data that is returned by server 
				console.log(response);
				response.queryKeywords = episode.links;
				response.query = keywordText;
				for (var i = 0 ; i < response.publications.length; i++){
					if ( i % 2 == 0 && i % 3 == 0)
						response.publications[i].keyword = [ episode.links[0] ];
					else
						if ( i % 2 == 0 )
							response.publications[i].keyword = [ episode.links[1] ];
						else
							response.publications[i].keyword = [ episode.links[0], episode.links[1] ];
				}
				//--------------------------------------
				
				$("#publications-box-" + vars.widgetUniqueName + " .box-header .author_name").html( response.author.name );
				
				var mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
				$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged );
				$.publicationList.visualize( mainContainer, response);
				
				thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).find(".overlay").remove();
				
				
			});
		}
}

$.activeResearchers.visualize.elements.episodes = function(episodesData, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
	var vars 			= $.activeResearchers.variables;
	var transition 		= d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
	var episodeGraphSVG = d3.select(vars.containerId + " svg g.episodes"); 	
	
	var episodes 		= episodeGraphSVG.selectAll(".episode").data(episodesData, this.key);
	var episode 		= episodes.enter().append("g")
		.attr("class", "episode")
		.on("mouseover", function(d){
			$.activeResearchers.visualize.interactions.mouseoverEpisode(d, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
		})
		.on("mouseout", $.activeResearchers.visualize.interactions.mouseleaveEpisodes)
		.on("click", $.activeResearchers.visualize.interactions.click);
	
	episode.append("rect")
		.attr("x", vars.U / -2)
		.attr("y", vars.K / -2)
		.attr("rx", 2)
		.attr("ry", 2)
		.attr("width", vars.U)
		.attr("height", vars.K)
		.attr("fill", "url(#light-box-gradient)")
		.transition(transition)
			.attr("x", function(Z) { return Z.x; })
			.attr("y", function(Z) { return Z.y; });
	episode.append("text")
		.style("text-anchor", "middle")
		.attr("y", function(Z) { return vars.K / -2 + vars.o; })
		.text(function(Z) { return Z.name; })
		.transition(transition)
			.attr("y", function(Z) { return Z.y + vars.o; });
	
	episodes.exit().selectAll("rect")
		.transition(transition)
			.attr("x", function(Z) { return vars.U / -2; })
			.attr("y", function(Z) { return vars.K / -2; });
	episodes.exit().selectAll("text")
		.transition(transition)
			.attr("y", function(Z) { return vars.K / -2 + vars.o; });
	episodes.exit().transition().duration(vars.transitionDuration).remove();
};

$.activeResearchers.visualize.elements.nodes = function(nodesData, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
	var vars 		 = $.activeResearchers.variables;
	var transition 	 = d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
	var nodeGraphSVG = d3.select(vars.containerId + " svg g.nodes"); 	
	
	var nodes = nodeGraphSVG.selectAll(".node").data(nodesData, this.key);
	var node  = nodes.enter().append("g")
		.attr("class", "node")
		.attr("transform", function(n) {
			var Z = n.parent ? n.parent : { xOffset : 0, x : 0, y : 0 };
			return "translate(" + Z.xOffset + ",0)rotate(" + (Z.x - 90) + ")translate(" + Z.y + ")";
		})
		.on("mouseover", function(d){ 
			$.activeResearchers.visualize.interactions.mouseoverEpisode( d, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
		})
		.on("mouseout", $.activeResearchers.visualize.interactions.mouseleaveEpisodes);//.on("click", G);
	
	var radiusRange = d3.scaleLinear()
		.domain([1, d3.max(nodesData, function(n){ return n.count; })])
		.range([1, 15]);
	
	var circle = node.append("circle").attr("r", 1);
	var labelStroke = node.append("text")
		.attr("class", "label-stroke")
		.attr("stroke", "#fff")
		.attr("stroke-width", 4);	
	var label = node.append("text")
		.attr("class", "label")
		.attr("font-size", 0);
	
	node.transition(transition)
		.attr("transform", function(n) {
			if (n === vars.L.node) return null;
			var translate = (n.isGroup) ? n.y + (7 + n.count) : n.y;
		return "translate(" + n.xOffset + ",0)rotate(" + (n.x - 90) + ")translate(" + translate + ")";
	});
	circle
		.attr("r", function(n) {
			if (n == vars.L.node) return 100;
			else 
				if (n.isGroup) 
					return 4 + radiusRange( n.count );
				else 
					return 4.5;
		});
	label
		.attr("dy", ".3em")
		.attr("font-size", function(n) {
			if (n.depth === 0) 
				return 20;
			else 
				return 15;
		})
		.text(function(n) { return n.name; })
		.attr("text-anchor", function(n) {
			if (n === vars.L.node || n.isGroup) 
				return "middle";
						
			return n.x < 180 ? "start" : "end";
		})
		.attr("transform", function(n) {
			if (n === vars.L.node) return null;
			else 
				if (n.isGroup) 
					return n.x > 180 ? "rotate(180)" : null;					
			return n.x < 180 ? "translate(" + vars.t + ")" : "rotate(180)translate(-" + vars.t + ")";
		});
	labelStroke
		.attr("display", function(t) { return t.depth === 1 ? "block" : "none"; });
	
	nodes.exit().transition().duration(vars.transitionDuration).remove();
};

function getLowerCase(str) {
	return str.toLowerCase().replace(/[ .,()]/g, "-");
}

function mouseOnEpisode(episode, linkObject, episodeConceptLinkJsonArray){
	var vars = $.activeResearchers.variables;
	if (vars.k === episode) return

	vars.k.node = episode;
	vars.k.map = {};
	vars.k.map[episode.key] = true;
	if (episode.key !== episode.canonicalKey) {
		vars.k.map[episode.parent.canonicalKey] = true;
		vars.k.map[episode.parent.canonicalKey + "-to-" + episode.canonicalKey] = true;
		vars.k.map[episode.canonicalKey + "-to-" + episode.parent.canonicalKey] = true;
	} else {
		linkObject.get(episode.canonicalKey).forEach(function(e) {
			vars.k.map[e.canonicalKey] = true;
			vars.k.map[episode.canonicalKey + "-" + e.canonicalKey] = true;
		});
		
		episodeConceptLinkJsonArray.forEach(function(link) {
			if (vars.k.map[link.source.canonicalKey] && vars.k.map[link.target.canonicalKey])
				vars.k.map[link.canonicalKey] = true;					
		});
	}
	
	highLightElements();
}

function highLightElements() {
	var vars 			= $.activeResearchers.variables;
	var transition 		= d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
	var nodeGraphSVG 	= d3.select(vars.containerId + " svg g.nodes");
	var episodeGraphSVG = d3.select(vars.containerId + " svg g.episodes");
	var linkGraphSVG 	= d3.select(vars.containerId + " svg g.links"); 	
	
	episodeGraphSVG.selectAll("rect")
		.attr("fill", function(d) { return changeElementColor(d, "url(#light-box-gradient)", "url(#dark-box-gradient)", "url(#light-box-gradient)");});
	
	linkGraphSVG.selectAll("path")
		.attr("stroke", function(d) { return changeElementColor(d, "#aaa", vars.highLightColor, "#aaa"); })
		.attr("stroke-width", function(d) { return changeElementColor(d, "1.5px", "2.5px", "1px"); })
		.attr("opacity", function(d) { return changeElementColor(d, 0.4, 0.75, 0.3); })
		.sort(function(a, b) {
				if (!vars.k.node) return 0;				
				var aa = vars.k.map[a.canonicalKey] ? 1 : 0, 
					 Z = vars.k.map[b.canonicalKey] ? 1 : 0;
				return aa - Z;
		});
		
	nodeGraphSVG.selectAll("circle")
		.attr("fill", function(d) {
			if (d === null) return "#000";
			else return changeElementColor(d, "#666", vars.highLightColor, "#000"); //return changeElementColor(X, "#000", highLightColor, "#999");
		})
		.attr("stroke", function(d) {
			if (d === null)  return changeElementColor(d, null, vars.highLightColor, null);
			else return "#000";					
		})
		.attr("stroke-width", function(d) {
			if (d === vars.L.node) return changeElementColor(d, null, 2.5, null);
			else return 1.5;
		});
	
	nodeGraphSVG.selectAll("text.label")
		.attr("fill", function(d) {
			return (d === vars.L.node || d.isGroup) ? "#fff" : changeElementColor(d, "#000", vars.highLightColor, "#999");
		});

}

function changeElementColor(X, aa, Z, Y) 
{
	if ($.activeResearchers.variables.k.node === null) {
		return aa;
	}
	return $.activeResearchers.variables.k.map[X.key] ? Z : aa;
}
function createLightGradientColor(svg){
	var gradient = svg.append("defs")
	  .append("linearGradient")
	    .attr("id", "light-box-gradient")
	    .attr("x1", "0%")
	    .attr("y1", "0%")
	    .attr("x2", "0%")
	    .attr("y2", "100%");


	gradient.append("stop")
		.attr("class", "light-gradient-stop-color-1")
	    .attr("offset", "0%")
	    .attr("stop-opacity", 1);

	gradient.append("stop")
		.attr("class", "light-gradient-stop-color-2")
	    .attr("offset", "50%")
	    .attr("stop-opacity", 1);
	
	gradient.append("stop")
		.attr("class", "light-gradient-stop-color-2")
		.attr("offset", "50%")
		.attr("stop-opacity", 1);

	gradient.append("stop")
		.attr("class", "light-gradient-stop-color-1")
		.attr("offset", "100%")
		.attr("stop-opacity", 1);
}

function createDarkGradientColor(svg){
	var gradient = svg.append("defs")
	  .append("linearGradient")
	    .attr("id", "dark-box-gradient")
	    .attr("x1", "0%")
	    .attr("y1", "0%")
	    .attr("x2", "0%")
	    .attr("y2", "100%");


	gradient.append("stop")
		.attr("class", "dark-gradient-stop-color-1")
	    .attr("offset", "0%")
	    .attr("stop-opacity", 1);

	gradient.append("stop")
		.attr("class", "dark-gradient-stop-color-2")
	    .attr("offset", "50%")
	    .attr("stop-opacity", 1);
	
	gradient.append("stop")
		.attr("class", "dark-gradient-stop-color-2")
		.attr("offset", "50%")
		.attr("stop-opacity", 1);

	gradient.append("stop")
		.attr("class", "dark-gradient-stop-color-1")
		.attr("offset", "100%")
		.attr("stop-opacity", 1);
}
