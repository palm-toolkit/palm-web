$.activeResearchers = {};
$.activeResearchers ={
	variables : {	
		containerId 	 : undefined,		
		width : 1100,
		height: 600,
		h	  : 600,
		episodeWidth  : 200,
		episodeHeight : 9, 
		S 	  : 20,
		s 	  : 8,
		R 	  : 90,
		initialDegree : 30, 
		o 	  : 15, 
		t 	  : 10, 
		transitionDuration  : 1000, 
		easeType 			: "elastic", 
		highLightColor 		: "rgb(74, 74, 74)", // "#0073b7", //"#f39c12",
		clickedColor 		: "#73a0bb", // "rgb(13, 40, 185)",//"#f39c12",
		color : {
			episode : {
				name	: "#004f7e", //"#0073b7",
				value	: "#4a4a4a"
			},
			node 	: {
				circle 		  : "#e0e0e0",
				circle_stroke : "#6f6f6f",
				name		  : "#4a4a4a"
			},
			link	: {
				line_stroke	  : "rgb(222, 222, 222)"
			}
		},
		L	  : {},
		k 	  : {},
		line  : undefined,
		diagonal		   : undefined,
		publicationRequest : null,
		tooltipName		   : "tooltip-key-researcher"
	},
	data : function( ){
		var data = {}; 
		data.episodes = [];
		data.lefts = [];
		data.rights = [];
		$.PALM.visualizations.data.participants.forEach( function( participant, i ){
			participant.type  = "episode";
			participant.links = [];
			participant.publications.forEach( function( publication, j ){
				publication.topics.forEach( function( topic, q ){
					participant.links = participant.links.concat( d3.map(topic.termvalues).keys() );
				});
				
				participant.links.forEach( function( link, l ){
					var topicNode = {};
					topicNode.name = link;
					topicNode.type = "right";
					
					var positionTopicNode = data.rights.map( function( x ){ return x.name; }).indexOf( link );
					
					if ( positionTopicNode >= 0 ){
						topicNode.count = data.rights[ positionTopicNode ].count + 1;	
						data.rights[ positionTopicNode ].count = data.rights[ positionTopicNode ].count + 1;	
					}
					else{
						topicNode.count = 1;				
						data.rights.push( topicNode );
					}
				} );
				
			} );
			data.episodes.push( participant );
		} );
		var importTopics = data.rights.slice(0, 50);
		data.rights = importTopics.slice( 0, importTopics.length/2 ); 
		data.lefts  = importTopics.slice( importTopics.length/2, importTopics.length ).map( function( d ){ d.type="left"; return d; });
		
		var mappedJsonObject      = d3.map(data);		
		var mergedJsonObjectArray = d3.merge(mappedJsonObject.values());
		var combinedJsonObject 	  = {};		
			
		mergedJsonObjectArray.forEach( function( thisJsonObject ) {	
			thisJsonObject.key = $.PALM.utility.visualizations.getLowerCase(thisJsonObject.name);
			thisJsonObject.canonicalKey = thisJsonObject.key;
			combinedJsonObject[thisJsonObject.key] = thisJsonObject;								
		});
			
		linkObject = d3.map();				
		mappedJsonObject.get("episodes").forEach(function(episodeJsonObject) {
			// remove bad links
			episodeJsonObject.links = episodeJsonObject.links.filter(function(ab) {
				return typeof combinedJsonObject[$.PALM.utility.visualizations.getLowerCase(ab)] !== "undefined" && ab.indexOf("r-") !== 0;
			});
		});
		
		var episodeConceptLinkJsonArray = prepareData(mappedJsonObject, combinedJsonObject);
		
		return { mappedJsonObject : mappedJsonObject, combinedJsonObject : combinedJsonObject, episodeConceptLinkJsonArray : episodeConceptLinkJsonArray };
		
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
				jsonRecord.x = vars.episodeWidth / -2;
				jsonRecord.y = index * i - y;						
			});
			// initial degree determines the initial configuration, it's a global
			// variable
			var startDegree = 180 + vars.initialDegree, 
				endDegree   = 360 - vars.initialDegree, 
				rotateDegree= (endDegree - startDegree) / (mappedJsonObject.get("lefts").length - 1);
			
			mappedJsonObject.get("lefts").forEach(function(jsonRecord, index) {
				jsonRecord.x = endDegree - index * rotateDegree;
				jsonRecord.y = vars.h / 2 - vars.R;
				jsonRecord.xOffset = -vars.S;
				jsonRecord.depth   = 1;
			});
				
			startDegree = vars.initialDegree;
			endDegree   = 180 - vars.initialDegree;
			rotateDegree= (endDegree - startDegree) / (mappedJsonObject.get("rights").length - 1);
			
			mappedJsonObject.get("rights").forEach(function(jsonRecord, index) {
				jsonRecord.x = index * rotateDegree + startDegree;
				jsonRecord.y = vars.h / 2 - vars.R;
				jsonRecord.xOffset = vars.S;
				jsonRecord.depth = 1;
			});
				
			episodeConceptLinkJsonArray = [];	
			
			var linkJsonObject, Y, aa, X = vars.h / 2 - vars.R;
			
			mappedJsonObject.get("episodes").forEach( function(jsonEpisodeObject) {
				jsonEpisodeObject.links.forEach( function(linkString) {
					linkJsonObject = combinedJsonObject[$.PALM.utility.visualizations.getLowerCase(linkString)];
					
					if (!linkJsonObject || linkJsonObject.type === "reference") return;
										
					Y  = (linkJsonObject.x - 90) * Math.PI / 180;
					aa = jsonEpisodeObject.key + "-to-" + linkJsonObject.key;
					
					episodeConceptLinkJsonArray.push({
						source : jsonEpisodeObject,
						target : linkJsonObject,
						key : aa,
						canonicalKey : aa,
						x1 : jsonEpisodeObject.x + (linkJsonObject.type === "left" ? 0: vars.episodeWidth),
						y1 : jsonEpisodeObject.y + vars.episodeHeight / 2,
						x2 : Math.cos(Y) * X + linkJsonObject.xOffset,
						y2 : Math.sin(Y) * X
					});
				});
			});
			
			return episodeConceptLinkJsonArray;
		}
	},
	visualise : {
		chart : function( ){
			var vars = $.activeResearchers.variables;
		
			var mappedJsonObject	= $.PALM.visualizations.data.mappedJsonObject;
			var combinedJsonObject  = $.PALM.visualizations.data.combinedJsonObject;
			var episodeConceptLinkJsonArray = $.PALM.visualizations.data.episodeConceptLinkJsonArray;
			
			vars.diagonal = function( d){
				 return "M" + d.source.y + "," + d.source.x
			      		+ "C" + (d.source.y + d.target.y) / 2 + "," + d.source.x
			      		+ " " + (d.source.y + d.target.y) / 2 + "," + d.target.x
			      		+ " " + d.target.y + "," + d.target.x;
			};
				
			vars.line = d3.line()
				.x(function(X) { return X[0]; })
				.y(function(X) { return X[1]; })
				.curve( d3.curveBundle );
			
			var graphSVG = d3.select(vars.containerId +" .box-body .visualization-main" ).append("svg")
				.attr("width",  vars.width)
				.attr("height", vars.height)
				.attr("viewBox", ( -vars.width / 2 + 10) + " " + ( -vars.height / 2 - 20 ) + " " +  vars.width + " " +  vars.height )
				.attr("preserveAspectRatio", "xMinYMin")
				.append("g");
		
			var linkGraphSVG 	= graphSVG.append("g").attr("class", "links"); 
			var episodeGraphSVG = graphSVG.append("g").attr("class", "episodes");
			var nodeGraphSVG 	= graphSVG.append("g").attr("class", "nodes");	
			
		
			$.PALM.utility.visualizations.addGradient(graphSVG, "light-box-gradient", "light-gradient-stop-color-1", "light-gradient-stop-color-2");
			$.PALM.utility.visualizations.addGradient(graphSVG, "dark-box-gradient",  "dark-gradient-stop-color-1",  "dark-gradient-stop-color-2");
			$.PALM.utility.visualizations.addGradient(graphSVG, "clicked-box-gradient", "clicked-gradient-stop-color-1",  "clicked-gradient-stop-color-2");
		
			this.links(episodeConceptLinkJsonArray);
			this.elements.create(mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
		},
		links : function(episodeConceptLinkJsonArray){
			var vars = $.activeResearchers.variables;
			var linkGraphSVG = d3.select(vars.containerId + " svg g.links");
			
			if ( episodeConceptLinkJsonArray != null ){
				var group = linkGraphSVG.selectAll("g").data( episodeConceptLinkJsonArray ).enter().append("g").attr("class", "link");
				var paths = group	
					.append("path")
					.attr("d", function(Z) {
						var Y = Z.source ? { x : Z.source.x, y : Z.source.y } : { x : 0, y : 0};
						return vars.diagonal({
									source : Y,
									target : Y
						});
					});
				paths.attr("d", function(X) {
							return vars.line([[X.x1, X.y1], [X.x1, X.y1], [X.x1, X.y1]]);
					});
				paths.transition().duration(vars.transitionDuration).ease(d3.easeElastic)
						.attr("d", function(X) { return vars.line([[X.x1, X.y1], [X.target.xOffset * vars.s, 0],[X.x2, X.y2]]); });	
				
				group.append("text")
					.attr("class", "link-text")
					.attr("fill", vars.highLightColor)
					.attr("dx", function (d){ return d.target.x < 180 ?  "-0.35em" : "0.35em";})
					.attr("dy", "0.35em")
					.style("font-weight", "bold")
					.attr("text-anchor", function (d){ return d.target.x < 180 ? "start" : "end"; });	
			}			
		},
		elements :{  
			create : function(mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){		
				this.episodes(mappedJsonObject.get("episodes"), mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
				this.nodes(d3.merge([mappedJsonObject.get("lefts"), mappedJsonObject.get("rights")]), mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
			},
			episodes : function(episodesData, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
				var vars 			= $.activeResearchers.variables;
				var basedOn			= $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .basedOn .dropdown-menu li.selected").data("value");
				var transition 		= d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
				var episodeGraphSVG = d3.select(vars.containerId + " svg g.episodes"); 	
				
				var keys 			= episodesData.map( function( d ){ return d.key; });
				var episode 		= episodeGraphSVG.selectAll(".episode").data( episodesData ).enter().append("g")
					.attr("class", "episode")
					.on("mouseover", function(d){ $.activeResearchers.visualise.interactions.mouseoverEpisode(this, d, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray); })
					.on("mouseout",  function(d){ $.activeResearchers.visualise.interactions.mouseleaveEpisode(this, d); })
					.on("click", $.activeResearchers.visualise.interactions.episodeClicked);
				
				episode.transition(transition)
					.attr("transform", function(Z) { return "translate(" + [ Z.x, Z.y ] + ")"; });
				
				episode.append("rect")
					.attr("class", "rect-base light-color")
					.attr("rx", 2)
					.attr("ry", 2)
					.attr("width", vars.episodeWidth)
					.attr("height", vars.episodeHeight )
					.attr("fill", "transparent")
					.attr("stroke-width", "0.5px");
				
				var criterion = "publicationsNumber";
				if ( basedOn == "hindex" )
					criterion = "hindex";
				else
					if ( basedOn == "nrCitations" )
						criterion = "publicationsCitations";
				
				var range = d3.scaleLinear()
					.range([0, vars.episodeWidth]);
				
				range.domain([0, d3.max( episodesData, function( d ){ return d[criterion]; })]);
				
				episode.append("rect")
					.classed("rect-filling", true)
					.attr("rx", 2)
					.attr("ry", 2)		
					.attr("width", function( d, i ){ return range( d[criterion] ); })
					.attr("height", vars.episodeHeight )
					.attr("fill", "url(#light-box-gradient)");
				
				episode.append("text")
					.attr("class", "basedOn_value" )
					.attr("x", function( d, i ){ return range( d[criterion] )} ) 
					.attr("dx", ".15em")
					.attr("dy", ".75em")
					.attr("text-anchor", "start" )
					.attr("fill", vars.color.episode.value )
					.attr("fill-opacity", 0.6 )
					.text( function( d ){ return d[criterion];	} );

				episode.append("text")
					.attr("class", "researcher_name" )
					.attr("dx", ".35em")
					.attr("dy", "-.35em")
					.attr("fill", vars.color.episode.name )
					.text( function( d ) { return d.name; } );

				episode.exit()
					.transition(transition)
						.attr("transform", function(Z) { return "translate(" + [ vars.episodeWidth / -2, vars.episodeHeight / -2] + ")" ; });
				
				episode.exit().transition().duration(vars.transitionDuration).remove();
			},
			nodes : function(nodesData, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
				var vars 		 = $.activeResearchers.variables;
				var transition 	 = d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
				var nodeGraphSVG = d3.select(vars.containerId + " svg g.nodes"); 	
				
				var keys = nodesData.map( function( d ){ return d.key; });
				
				if ( keys.length == 0 ) 
					return;
				
				var nodes = nodeGraphSVG.selectAll(".node").data( nodesData );
				var node  = nodes.enter().append("g")
					.attr("class", "node")
					.attr("transform", function(n) {
						var Z = n.parent ? n.parent : { xOffset : 0, x : 0, y : 0 };
						return "translate(" + Z.xOffset + ",0)rotate(" + (Z.x - 90) + ")translate(" + Z.y + ")";
					})
					.on("mouseover", function(d){ 
						$.activeResearchers.visualise.interactions.mouseoverEpisode( this, d, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray);
					})
					.on("mouseout", function(d){ $.activeResearchers.visualise.interactions.mouseleaveEpisode( this, d ); })
					.on("click", $.activeResearchers.visualise.interactions.nodeClicked );
				
				var radiusRange = d3.scaleLinear()
					.domain([1, d3.max(nodesData, function(n){ return n.count; })])
					.range([1, 15]);
				
				var circle = node.append("circle").attr("r", 1)
					.attr( "fill", vars.color.node.circle )
					.attr("stroke", vars.color.node.circle_stroke)
					.attr("stroke-width", "1.5px");
				
				var labelStroke = node.append("text")
					.attr("class", "label-stroke")
					.attr("stroke", vars.color.node.circle_stroke)
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
			}		
		},//end episodes
		basedOn : function( basedOn ){
			var vars 	   		= $.activeResearchers.variables;
			var svg		   	   	= d3.select(vars.containerId + " svg" );	
			var linkGraphSVG 	= svg.select("g.links"); 
			var episodeGraphSVG = svg.select("g.episodes");
			var nodeGraphSVG 	= svg.select("g.nodes");	
			
			// remove existing data
			linkGraphSVG.html("");
			episodeGraphSVG.html("");
			nodeGraphSVG.html("");
			
			$(vars.containerId + " .visualization-main" ).html( "" );
			$(vars.containerId + " .visualization-details" ).addClass( "hidden" );
			
			var selected = $.PALM.selected;
			$.get( $.PALM.visualizations.url + "/venue/topResearchers?id=" + selected.event +"&orderBy=" + basedOn, function( response ){
				if( response.status != "ok" ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Key Researchers!", "The conference does not have any researchers assigned on PALM (insufficient data)" );
					return false;
				}
				vars.L = {};
				vars.k = {};
				vars.clickedNode = null;
				
				$.PALM.visualizations.data = response;		
				$.PALM.visualizations.data = $.activeResearchers.data( );
				
				$.activeResearchers.visualise.chart( );	
			} );
		},
		interactions : {
			mouseoverEpisode : function(elem, episode, mappedJsonObject, combinedJsonObject, episodeConceptLinkJsonArray){
				var linkObject = d3.map();							
				
				mappedJsonObject.get("episodes").forEach(function(episodeJsonObject) {							
					linkObject.set(episodeJsonObject.key, episodeJsonObject.links.map(function(link) {					
						var key = $.PALM.utility.visualizations.getLowerCase(link);
						
						if (typeof linkObject.get(key) === "undefined") 
							linkObject.set(key, []);
													
						linkObject.get(key).push(episodeJsonObject);
									
						return combinedJsonObject[key];
					}) );
				});
					
				mouseOnEpisode(elem, episode, linkObject, episodeConceptLinkJsonArray);
			},
			mouseleaveEpisode:  function(elem, episode){
				$.activeResearchers.variables.k = { node : null, map : {} };
				d3.select( elem.nearestViewportElement ).selectAll( "." + $.activeResearchers.variables.tooltipName ).remove();

				highLightElements();
			},
			closeList: function( ){
				var vars 		= $.activeResearchers.variables;
				var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
					
				thisWidget.element.find( ".visualization-details" ).addClass( "hidden" );
					
				if ( vars.clickedNode != null && vars.clickedNode.node != null )
					removeHighlightClickedNode( );
					
				function removeHighlightClickedNode( ){
					d3.selectAll("g.episode").classed("clicked", false);	
					vars.clickedNode = undefined;
						
					if ( vars.publicationRequest != null ){
						vars.publicationRequest.abort();
						vars.publicationRequest = null;
					}
					highLightElements();
				}
			},
			episodeClicked : function ( episode ){	
				var vars 		= $.activeResearchers.variables;
				var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
				var keywordText = thisWidget.element.find("#publist-search").val() || "";
				var queryString = "?id=" + episode.id + "&year=all&query=" + keywordText + "&queryKeywords=" + episode.links;
					
				activeResearchers_highlightClickedElement( this );
				getPublicationAuthor( this );
				
				function getPublicationAuthor( author ){
					var vars 		= $.activeResearchers.variables;
					var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
					var queryString = "?id=" + episode.id + "&year=all&queryKeywords=" + episode.links;
					thisWidget.options.queryString = queryString;
						
					thisWidget.element.find( ".visualization-details" ).removeClass( "hidden" );
						
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).show( 800 );
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );				
					// --------------------------------------
								
					var response = episode;
					var status 	 = ( episode.publications != null && episode.publications.length > 0 ) ? "ok" : "error"; 
					
					$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-header .author_name").html( "(" + response.publications.length + "): " 
								+ $.PALM.utility.visualizations.getNameAbbreviation( response.author.name ) );
								
					var mainContainer = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-content");
						
					$.publicationList.init( status, $.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.url, $.PALM.visualizations.user, vars.height - 30);
					
					response.element = response.author;
					response.status  = status;
						
					$.publicationList.visualize( mainContainer, response);
							
					//remove overlay and list unused elements 
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();
								
					$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .pull-left").css("display", "none");
					$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .timeline .time-label").css("display", "none");
					
					if ( !mainContainer.hasClass( "small" ) )
						mainContainer.addClass( "small" );
				}
			},
			nodeClicked : function ( node ){
				var vars = $.activeResearchers.variables;
					
				activeResearchers_highlightClickedElement( this );
				showPublicationTopic( node );
					
				function showPublicationTopic( node ){		
					var publOnTopic = getPublicationsOnInterestOrTopic( node.name );
					var status		= publOnTopic == null || publOnTopic.length == 0 ? "error" : "ok";		
					var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
					var queryString = "?year=all&queryKeywords=" + node.name;
						
					//show list container
					var mainContainer = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-content");
						
					thisWidget.element.find( ".visualization-details" ).removeClass( "hidden" );			
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).show( 800 );
						
					$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-header .author_name").html( "(" + publOnTopic.length + "): " + node.name );
						
					//init and visualise list
					$.publicationList.init( status, $.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.url, null, vars.height - 10);
						
					if ( status == "ok" ){
						var data = {
								element : node,
								publications : publOnTopic,
								totalPublication : publOnTopic.length,
								status : status
							}; 		
							
						$.publicationList.visualize( mainContainer, data);
							
						//hide unused elements  
						$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .pull-left").css("display", "none");
						$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .timeline .time-label").css("display", "none");
						
						if ( !mainContainer.hasClass( "small" ) )
							mainContainer.addClass( "small" );
					}
				}
					
				function getPublicationsOnInterestOrTopic( topic ){
					var publicationsOnInterest = [];					
					var author = d3.select( "#widget-" + $.PALM.visualizations.widgetUniqueName + " .episodes .episode");							
					var publications = author.datum().publications;
						
					for( var i = 0; i < publications.length; i++ ){
						var hasTopic = publications[i].topics.filter( function( publTopic ){ 
							var keys = Object.keys( publTopic.termvalues ).map(function(x) { return x.toLowerCase(); });
								return keys.indexOf( topic.toLowerCase() ) >= 0; 
						});
						if ( hasTopic.length != 0 )
							if ( publicationsOnInterest.indexOf( publicationsOnInterest[i] ) < 0)
								publicationsOnInterest = publicationsOnInterest.concat( publications[i] );
					}
					return publicationsOnInterest;
				}
			}
		}
	}//end visualize
};
function activeResearchers_highlightClickedElement( elem ){
	var vars = $.activeResearchers.variables;
	
	d3.selectAll("g.episode").classed("clicked", false);
	d3.selectAll("g.node").classed("clicked", false);
	
	d3.select(elem).classed("clicked", true);		
	vars.clickedNode = jQuery.extend(true, {}, vars.k);
}



function mouseOnEpisode(elem, episode, linkObject, episodeConceptLinkJsonArray){
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
		if ( linkObject.get(episode.canonicalKey) != undefined)
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
	
	if (  episode.type != undefined && episode.type === "episode"){
		/* add fictive data to episode till backend will provide the data */
		episode.author = { name : episode.name, id : episode.id};
		episode.affiliation = episode.aff != null ? episode.aff.institution : "";
		/*------------*/
		addTooltip( d3.select(elem), episode );
	}
}

function highLightElements() {
	var vars 			= $.activeResearchers.variables;
	var transition 		= d3.transition().duration(vars.transitionDuration).ease(d3.easeElastic);
	var nodeGraphSVG 	= d3.select(vars.containerId + " svg g.nodes");
	var episodeGraphSVG = d3.select(vars.containerId + " svg g.episodes");
	var linkGraphSVG 	= d3.select(vars.containerId + " svg g.links"); 	
	
	episodeGraphSVG.selectAll("rect.rect-base")
		.attr("class", function(d) { 
			if ( vars.clickedNode != undefined ){
				if ( vars.clickedNode.node.id == d.id)
					return "rect-base " + changeElementColor(d, "light-color", "clicked-color"); 
			}
			return "rect-base " + changeElementColor(d, "light-color", "dark-color"); });
	
	episodeGraphSVG.selectAll("rect.rect-filling")
		.attr("fill", function(d) { 
			if ( vars.clickedNode != undefined ){
				if ( vars.clickedNode.node.id == d.id)
					return changeElementColor(d, "url(#light-box-gradient)", "url(#clicked-box-gradient)"); 
			}
			return changeElementColor(d, "url(#light-box-gradient)", "url(#dark-box-gradient)"); });
	
	episodeGraphSVG.selectAll("text.researcher_name")
		.style("font-weight", function(d) { return changeElementColor(d, "normal", "bold"); });
	episodeGraphSVG.selectAll("text.basedOn_value")
		.attr("fill-opacity", function(d) { return changeElementColor(d, 0.6, 1); });
	
	d3.selection.prototype.moveToFront = function() {
		  return this.each(function(){
		    this.parentNode.appendChild(this);
		  });
	};
	
	linkGraphSVG.selectAll("path")
		.style("stroke", function(d) { 
			if ( vars.clickedNode != undefined ){
				var isClickedEpisodeHovered = vars.clickedNode.node.id != null && ( vars.clickedNode.node.id == d.source.id || vars.clickedNode.node.id == d.target.id );
				var isClickedNodeHovered    = vars.clickedNode.node.id == null && ( vars.clickedNode.node.name == d.source.name || vars.clickedNode.node.name == d.target.name );
				
				if ( isClickedEpisodeHovered || isClickedNodeHovered )
					return changeElementColor(d, vars.color.link.line_stroke, vars.clickedColor); 
			}
			return changeElementColor(d, vars.color.link.line_stroke, vars.highLightColor); 
		})
		.style("stroke-opacity", function(d) { return changeElementColor(d, 0.5, 0.3);})
		.sort(function(a, b) {
				if (!vars.k.node) return 0;				
				var aa = vars.k.map[a.canonicalKey] ? 1 : 0, 
					 Z = vars.k.map[b.canonicalKey] ? 1 : 0;
				return aa - Z;
		})
		.each( function( d ){
			if ( vars.clickedNode != undefined ){
				if ( vars.clickedNode.node.id == d.source.id || vars.clickedNode.node.id == d.target.id)
					return changeElementColor(d, null, d3.select(this).moveToFront() );
			}	
		}) ;
	linkGraphSVG.selectAll("text")
		.classed("hidden", function ( d ) { return changeElementColor(d, true, false); } )
		.text( function(d) {
			var isMouseOver = changeElementColor(d, false, true);
			
			if ( vars.clickedNode != undefined ){
				var isClickedEpisodeHovered = vars.clickedNode.node.id != null && ( vars.clickedNode.node.id == d.source.id || vars.clickedNode.node.id == d.target.id );
				var isClickedNodeHovered    = vars.clickedNode.node.id == null && ( vars.clickedNode.node.name == d.source.name || vars.clickedNode.node.name == d.target.name );
				
				if ( isClickedEpisodeHovered || isClickedNodeHovered )
					return null;
			}
			
			if ( isMouseOver ){
				if ( vars.k != null && vars.k.node != null )
					if  ( vars.k.node.type === "episode" )
						return getResearcherPublicationsOnTopic( d3.select( this.parentNode ).datum() ) + ".publ";
					else
						return getPublicationsOnTopic( d3.select( this.parentNode ).datum() ) + ".publ";
			}
		})
		.attr("transform", function ( d ){
			var transform = "";
			if (vars.k != undefined && vars.k.node != null && vars.k.node.type == "episode"){				
				var e = changeElementColor(d, null, d.target);
				var tr2 = [d.x2,d.y2];
				var offset = -2.25 * d.target.xOffset;
				
				if (vars.clickedNode != undefined && vars.clickedNode.node.id != null && vars.clickedNode.node.id == d.target.id){
					var e = null;
					var tr2 = [];
					var offset = 0;
				}
			}				
			else{
				var e = changeElementColor(d, null, d.source);
				var tr2 = [d.x1,d.y1];
				var offset = d.target.x < 180 ? 10 : -10;
				
				if (vars.clickedNode != undefined && vars.clickedNode.node.id == d.source.id){
					var e = changeElementColor(d, null, d.target);
					var tr2 = [d.x2,d.y2];
					var offset = -2.25 * d.target.xOffset;
				}
			}
			return transform = "translate("+ [offset, 0] +")rotate(" + (0) + ")translate(" + tr2 + ")";
		});	
	
	nodeGraphSVG.selectAll("circle")
		.attr("fill", function(d) {
			if (d === null) return vars.color.node.circle;
			else if ( vars.clickedNode != undefined ){
					if ( vars.clickedNode.map[d.key] )
						return changeElementColor(d, vars.color.node.circle, vars.clickedColor); 
				 }
			return changeElementColor(d, vars.color.node.circle, vars.highLightColor);
		})
		.attr("stroke", function(d) {
			if (d === null)  return changeElementColor(d, null, vars.highLightColor);
			else return changeElementColor(d, vars.color.node.circle_stroke, "#000");					
		})
		.attr("stroke-width", function(d) {
			if (d === vars.L.node) 
				return changeElementColor(d, null, 2.5);
			else return 1.5;
		});
	
	nodeGraphSVG.selectAll("text.label")
		.attr("fill", function(d) {
			return (d === vars.L.node || d.isGroup) ? vars.color.node.name : vars.clickedNode != undefined ? (vars.clickedNode.map[d.key] ? changeElementColor(d, vars.color.node.name, vars.clickedColor) : changeElementColor(d, vars.color.node.name, vars.highLightColor)) : changeElementColor(d, vars.color.node.name, vars.highLightColor);
		});

}

function getResearcherPublicationsOnTopic( link ){
	var vars = $.activeResearchers.variables;
	var nrPubl = 0;
	
	if ( vars.k != null && vars.k.node !== null ) {
		if ( vars.k.node.publications != null && vars.k.node.publications.length > 0){
			vars.k.node.publications.forEach( function( p ){ 
				if ( p.topics != null && p.topics.length > 0) {
					p.topics.forEach( function( t ){
						if ( t.termvalues[ link.source.name ] != null || t.termvalues[ link.target.name ] != null )
							nrPubl ++;
					})
				}
			});		
		}
	}
	return nrPubl;
} 

function getPublicationsOnTopic( link ){
	var vars = $.activeResearchers.variables;
	var nrPubl = 0;
	
	if ( link.source.type === "episode")
		var episode = link.source;
	else
		var episode = link.target;
	
	if ( episode.links != null && episode.links.length > 0 ){
		var topics = episode.links.filter( function( l ){ return l == vars.k.node.name });
		nrPubl += topics.length;
	}		

	return nrPubl;
} 

function addTooltip( elem, episode ){
	var tooltipParam =  {
		className 	: $.activeResearchers.variables.tooltipName,
		width 		: 200,
		height		: 80,
		borderRadius: 5,
		fontSize	: 12,
		bkgroundColor: "rgba(255, 255, 255, 0.9)"
	}
	var tooltip = new Tooltip( tooltipParam );
	
	tooltip.buildTooltip( elem, episode );
	tooltip.extraTranslate( elem, [0, -10] );
}

function changeElementColor(X, initial, changed) 
{
	if ($.activeResearchers.variables.k.node === null) {
		if ( $.activeResearchers.variables.clickedNode == null ) 
			return initial;	
		else
			return $.activeResearchers.variables.clickedNode.map[X.key] ? changed : initial;
	}
	if ( $.activeResearchers.variables.clickedNode == null ) 
		return $.activeResearchers.variables.k.map[X.key] ? changed : initial;
	else
		return $.activeResearchers.variables.k.map[X.key] ||  $.activeResearchers.variables.clickedNode.map[X.key] ? changed : initial;
}

function resize(){		
	var svg = d3.select(".visualization-main svg");
	var bbox = svg.node().getBBox();
	var vis = $( $.activeResearchers.variables.containerId + " .visualization-main" );
	var visSize = {
			width : vis.width(),
			height: vis.height(),
			x : -vis.width()/2,
			y : -vis.height()/2  
		};

	svg.attr("viewBox", (visSize.x)+" "+(visSize.y)+" "+(visSize.width)+" "+(visSize.height));
	svg.attr("width", (visSize.width));
	svg.attr("height",(visSize.height));
	
	var nodesGr = d3.select(".visualization-main svg .nodes");
	var bboxGr = nodesGr.node().getBBox();
	
	if (bboxGr.width > visSize.width)
		scale = visSize.width/bboxGr.width;
	else
		scale = 1;
	 d3.select(".visualization-main svg>g").attr("transform", "scale(" + scale + ")");		
}
