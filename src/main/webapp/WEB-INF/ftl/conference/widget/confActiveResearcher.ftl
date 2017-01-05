<style>
#widget-${wUniqueName} .box-body svg {
  font-family: Abel,"Helvetica Neue",Helvetica,Arial,sans-serif;
  font-size: 15px;
}
#widget-${wUniqueName} .box-body .episode > rect {
  stroke: #fff;
  stroke-width: 1.5px;
}

#widget-${wUniqueName} .box-body path {
  fill: none;
}

#widget-${wUniqueName} .box-body .episode, #widget-${wUniqueName} .box-body .node, #widget-${wUniqueName} .box-body .detail text, #widget-${wUniqueName} .box-body .all-episodes {
  cursor: pointer;
}

#widget-${wUniqueName} .box-body .all-episodes {
  fill: #aaa;
}

#widget-${wUniqueName} .box-body .detail a text:hover, #widget-${wUniqueName} .box-body text .all-episodes:hover {
  text-decoration: underline;
}
</style>
<div class="box-body">
	
</div>

<div class="box-footer">
	
</div>

<script>

$( function(){
	<#--activeResearcherOperator.initActiveResearcherInConfWindow("Educational Data Mining 2013","http://data.linkededucation.org/resource/lak/conference/edm2013");-->
	
	$.activeResearchers.init("#widget-${wUniqueName}", "Educational Data Mining 2013","http://data.linkededucation.org/resource/lak/conference/edm2013");
	$.activeResearchers.data("<@spring.url '/resources/json/activeScholar.json' />");
});

var activeResearcherOperator = 
{
	
	initActiveResearcherInConfWindow:function(conferenceName, conferenceURI)
	{
		this.createActiveResearcherVisual(conferenceURI);
	},
	
	createActiveResearcherVisual:function(conferenceURI)
	{
		var width = 1100, height = 700, h = height, U = 200, K = 22, S = 20, s = 8, R = 110, initialDegree = 30, o = 15, t = 10, w = 1000, F = "elastic", highLightColor = "#0da4d3";
		var mappedJsonObject, mergedJsonObjectArray, combinedJsonObject, linkObject, episodeConceptLinkJsonArray;
		var L = {}, k = {};
		var i, y;
		
		var r = d3.layout.tree().size([360, h / 2 - R]).separation(function(Y, X) {
					return (Y.parent == X.parent ? 1 : 2) / Y.depth;
				});
				
		var W = d3.svg.diagonal.radial().projection(function(X) {
					return [X.y, X.x / 180 * Math.PI];
				});
				
		var v = d3.svg.line().x(function(X) {
					return X[0];
				}).y(function(X) {
					return X[1];
				}).interpolate("bundle").tension(0.5);
				
		var graphSVG = d3.select("#widget-${wUniqueName} .box-body").append("svg").attr("width", width)
				.attr("height", height).append("g").attr("transform",
						"translate(" + width / 2 + "," + height / 2 + ")");
						
				
		var linkGraphSVG = graphSVG.append("g").attr("class", "links"), 
			episodeGraphSVG = graphSVG.append("g").attr(
				"class", "episodes"), nodeGraphSVG = graphSVG.append("g").attr("class", "nodes");
		
		//console.log("activeResearcherInConf?confURI="+encodeURI(conferenceURI));
		d3.json("<@spring.url '/resources/json/activeScholar.json' />",
				function(X, originJsonObject) {
					mappedJsonObject = d3.map(originJsonObject);		
					mergedJsonObjectArray = d3.merge(mappedJsonObject.values());
					combinedJsonObject = {};
					
					
					mergedJsonObjectArray.forEach(function(thisJsonObject) {	
								thisJsonObject.key = getLowerCase(thisJsonObject.name);
								thisJsonObject.canonicalKey = thisJsonObject.key;
								combinedJsonObject[thisJsonObject.key] = thisJsonObject;								
					});
					
					
					linkObject = d3.map();				
					mappedJsonObject.get("episodes").forEach(function(episodeJsonObject) {
						// remove bad links
						episodeJsonObject.links = episodeJsonObject.links.filter(function(ab) {
									return typeof combinedJsonObject[getLowerCase(ab)] !== "undefined"
											&& ab.indexOf("r-") !== 0;
								});
						
						linkObject.set(episodeJsonObject.key, episodeJsonObject.links.map(function(ab) {
											var key = getLowerCase(ab);
											if (typeof linkObject.get(key) === "undefined") {
												linkObject.set(key, []);
											}
											linkObject.get(key).push(episodeJsonObject);
											return combinedJsonObject[key];
										}));
					});
					
					prepareDataForVis();
					createVisualization();
					
				});
		
		
		function prepareDataForVis() 
		{
			if (L.node === null) 
			{
				return
			}
			L = {
				node : null,
				map : {}
			};
			i = Math.floor(height / mappedJsonObject.get("episodes").length);
			y = Math.floor(mappedJsonObject.get("episodes").length * i / 2);
			mappedJsonObject.get("episodes").forEach(function(jsonRecord, index) {
						jsonRecord.x = U / -2;
						jsonRecord.y = index * i - y;
						
					});
			// initial degree determines the initial configuration, it's a global variable
			
			var startDegree = 180 + initialDegree, endDegree = 360 - initialDegree, rotateDegree = (endDegree - startDegree) / (mappedJsonObject.get("themes").length - 1);
			mappedJsonObject.get("themes").forEach(function(jsonRecord, index) {
						jsonRecord.x = endDegree - index * rotateDegree;
						jsonRecord.y = h / 2 - R;
						jsonRecord.xOffset = -S;
						jsonRecord.depth = 1;
					});
			
			startDegree = initialDegree;
			endDegree = 180 - initialDegree;
			rotateDegree = (endDegree - startDegree) / (mappedJsonObject.get("perspectives").length - 1);
			mappedJsonObject.get("perspectives").forEach(function(jsonRecord, index) {
						jsonRecord.x = index * rotateDegree + startDegree;
						jsonRecord.y = h / 2 - R;
						jsonRecord.xOffset = S;
						jsonRecord.depth = 1;
					});
			
			episodeConceptLinkJsonArray = [];	
			var linkJsonObject, Y, aa, X = h / 2 - R;
			mappedJsonObject.get("episodes").forEach(function(jsonEpisodeObject) {
						jsonEpisodeObject.links.forEach(function(linkString) {
									
									linkJsonObject = combinedJsonObject[getLowerCase(linkString)];
									if (!linkJsonObject || linkJsonObject.type === "reference") {
										return
									}
									Y = (linkJsonObject.x - 90) * Math.PI / 180;
									aa = jsonEpisodeObject.key + "-to-" + linkJsonObject.key;
									episodeConceptLinkJsonArray.push({
												source : jsonEpisodeObject,
												target : linkJsonObject,
												key : aa,
												canonicalKey : aa,
												x1 : jsonEpisodeObject.x + (linkJsonObject.type === "theme" ? 0: U),
												y1 : jsonEpisodeObject.y + K / 2,
												x2 : Math.cos(Y) * X + linkJsonObject.xOffset,
												y2 : Math.sin(Y) * X
									});
							});
					});
			
		}
		
		
		
		function mouseOutEpisode() 
		{
			k = {
				node : null,
				map : {}
			};
			highLightElements();
		}
		
		function mouseOnEpisode(X) 
		{
			if (k.node === X) {
				return
			}
			k.node = X;
			k.map = {};
			k.map[X.key] = true;
			if (X.key !== X.canonicalKey) {
				k.map[X.parent.canonicalKey] = true;
				k.map[X.parent.canonicalKey + "-to-" + X.canonicalKey] = true;
				k.map[X.canonicalKey + "-to-" + X.parent.canonicalKey] = true;
			} else {
				linkObject.get(X.canonicalKey).forEach(function(Y) {
							k.map[Y.canonicalKey] = true;
							k.map[X.canonicalKey + "-" + Y.canonicalKey] = true;
						});
				episodeConceptLinkJsonArray.forEach(function(Y) {
							if (k.map[Y.source.canonicalKey]
									&& k.map[Y.target.canonicalKey]) {
								k.map[Y.canonicalKey] = true;
							}
						});
			}
			highLightElements();
		}
		
		function createVisualization() 
		{
			drawEpisodeConceptLinks();
			linkGraphSVG.selectAll("path").attr("d", function(X) {
						return v([[X.x1, X.y1], [X.x1, X.y1], [X.x1, X.y1]]);
					}).transition().duration(w).ease(F).attr("d", function(X) {
						return v([[X.x1, X.y1], [X.target.xOffset * s, 0],
								[X.x2, X.y2]]);
					});
			drawEpisode(mappedJsonObject.get("episodes"));
			drawNodes(d3.merge([mappedJsonObject.get("themes"), mappedJsonObject.get("perspectives")]));			
			mouseOutEpisode();
			
		}
		

		function drawNodes(X) 
		{
			var X = nodeGraphSVG.selectAll(".node").data(X, u);
			var Y = X.enter().append("g").attr("transform", function(aa) {
				var Z = aa.parent ? aa.parent : {
					xOffset : 0,
					x : 0,
					y : 0
				};
				return "translate(" + Z.xOffset + ",0)rotate(" + (Z.x - 90)
						+ ")translate(" + Z.y + ")";
			}).attr("class", "node").on("mouseover", mouseOnEpisode).on("mouseout", mouseOutEpisode);//.on("click", G);
			Y.append("circle").attr("r", 0);
			Y.append("text").attr("stroke", "#fff").attr("stroke-width", 4).attr(
					"class", "label-stroke");
			Y.append("text").attr("font-size", 0).attr("class", "label");
			X.transition().duration(w).ease(F).attr("transform", function(Z) {
				if (Z === L.node) {
					return null;
				}
				var aa = Z.isGroup ? Z.y + (7 + Z.count) : Z.y;
				return "translate(" + Z.xOffset + ",0)rotate(" + (Z.x - 90)
						+ ")translate(" + aa + ")";
			});
			X.selectAll("circle").transition().duration(w).ease(F).attr("r",
					function(Z) {
						if (Z == L.node) {
							return 100;
						} else {
							if (Z.isGroup) {
								return 7 + Z.count;
							} else {
								return 4.5;
							}
						}
					});
			X.selectAll("text").transition().duration(w).ease(F).attr("dy", ".3em")
					.attr("font-size", function(Z) {
								if (Z.depth === 0) {
									return 20;
								} else {
									return 15;
								}
							}).text(function(Z) {
								return Z.name;
							}).attr("text-anchor", function(Z) {
								if (Z === L.node || Z.isGroup) {
									return "middle";
								}
								return Z.x < 180 ? "start" : "end";
							}).attr("transform", function(Z) {
						if (Z === L.node) {
							return null;
						} else {
							if (Z.isGroup) {
								return Z.x > 180 ? "rotate(180)" : null;
							}
						}
						return Z.x < 180
								? "translate(" + t + ")"
								: "rotate(180)translate(-" + t + ")";
					});
			X.selectAll("text.label-stroke").attr("display", function(Z) {
						return Z.depth === 1 ? "block" : "none";
					});
			X.exit().remove();
		}
		
		function drawEpisodeConceptLinks() 
		{
			var X = linkGraphSVG.selectAll("path").data(episodeConceptLinkJsonArray, u);
			X.enter().append("path").attr("d", function(Z) {
						var Y = Z.source ? {
							x : Z.source.x,
							y : Z.source.y
						} : {
							x : 0,
							y : 0
						};
						return W({
									source : Y,
									target : Y
								});
					}).attr("class", "link");
			X.exit().remove();
		}
		
		
		function drawEpisode(Y) 
		{
			var Y = episodeGraphSVG.selectAll(".episode").data(Y, u);
			var X = Y.enter().append("g").attr("class", "episode").on("mouseover",
					mouseOnEpisode).on("mouseout", mouseOutEpisode);//.on("click", G);
			X.append("rect").attr("x", U / -2).attr("y", K / -2).attr("width", U)
					.attr("height", K).transition().duration(w).ease(F).attr("x",
							function(Z) {
								return Z.x;
							}).attr("y", function(Z) {
								return Z.y;
							});
			X.append("text").attr("x", function(Z) {
						return U / -2 + t;
					}).attr("y", function(Z) {
						return K / -2 + o;
					}).attr("fill", "#fff").text(function(Z) {
						return Z.name;
					}).transition().duration(w).ease(F).attr("x", function(Z) {
						return Z.x + t;
					}).attr("y", function(Z) {
						return Z.y + o;
					});
			Y.exit().selectAll("rect").transition().duration(w).ease(F).attr("x",
					function(Z) {
						return U / -2;
					}).attr("y", function(Z) {
						return K / -2;
					});
			Y.exit().selectAll("text").transition().duration(w).ease(F).attr("x",
					function(Z) {
						return U / -2 + t;
					}).attr("y", function(Z) {
						return K / -2 + o;
					});
			Y.exit().transition().duration(w).remove();
		}
		
		
		function highLightElements() 
		{
			episodeGraphSVG.selectAll("rect").attr("fill", function(X) {
						return changeElementColor(X, "#000", highLightColor, "#000");
					});
			linkGraphSVG.selectAll("path").attr("stroke", function(X) {
						return changeElementColor(X, "#aaa", highLightColor, "#aaa");
					}).attr("stroke-width", function(X) {
						return changeElementColor(X, "1.5px", "2.5px", "1px");
					}).attr("opacity", function(X) {
						return changeElementColor(X, 0.4, 0.75, 0.3);
					}).sort(function(Y, X) {
				if (!k.node) {
					return 0;
				}
				var aa = k.map[Y.canonicalKey] ? 1 : 0, Z = k.map[X.canonicalKey]
						? 1
						: 0;
				return aa - Z;
			});
			nodeGraphSVG.selectAll("circle").attr("fill", function(X) {
						if (X === L.node) {
							return "#000";
						} else {
							if (X.type === "theme") {
								return changeElementColor(X, "#666", highLightColor, "#000");
							} else {
								if (X.type === "perspective") {
									return changeElementColor(X, "#666", highLightColor, "#000");
									//return "#fff";
								}
							}
						}
						return changeElementColor(X, "#000", highLightColor, "#999");
					}).attr("stroke", function(X) {
						if (X === L.node) {
							return changeElementColor(X, null, highLightColor, null);
						} else {
							if (X.type === "theme") {
								return "#000";
							} else {
								if (X.type === "perspective") {
									return "#000";
									//return changeElementColor(X, "#000", highLightColor, "#000");
								}
							}
						}
						return null;
					}).attr("stroke-width", function(X) {
						if (X === L.node) {
							return changeElementColor(X, null, 2.5, null);
						} else {
							if (X.type === "theme" || X.type === "perspective") {
								return 1.5;
							}
						}
						return null;
					});
			nodeGraphSVG.selectAll("text.label").attr("fill", function(X) {
				return (X === L.node || X.isGroup) ? "#fff" : changeElementColor(X, "#000", highLightColor, "#999");
			});

		}
		
		function getLowerCase(X) {
			return X.toLowerCase().replace(/[ .,()]/g, "-");
		}
		
		function u(X) 
		{
			return X.key;
		}
		
		function changeElementColor(X, aa, Z, Y) 
		{
			if (k.node === null) {
				return aa;
			}
			return k.map[X.key] ? Z : aa;
		}
	}
};
</script>