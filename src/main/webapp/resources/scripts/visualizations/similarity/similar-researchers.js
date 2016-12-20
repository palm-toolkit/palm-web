function createSimilarResearchers(containerID, data){
	$.SIMILAR.variables.width = $(containerID).width();
	$.SIMILAR.variables.height = $(containerID).height();
	$.SIMILAR.variables.radius = Math.min( $.SIMILAR.variables.width / 2 , $.SIMILAR.variables.height  );
	
	$.SIMILAR.create(containerID, data);
}
$.SIMILAR = {};

$.SIMILAR.variables = {
	width  : 0,
	height : 0,
	levels : 6,
	startAngle : -0.3 * Math.PI,
	endAngle   :  0.3 * Math.PI,
	color : d3.scaleOrdinal(d3.schemeCategory20),
	levelColor : "grey",
	labelColor: "#CCB5CB",
	segmentLineColor : "#ead6fd",
	format : d3.format(".0%")
};

$.SIMILAR.create = function(id, data){
	var svg = d3.select(id).append("svg")
		.attr("width",  $.SIMILAR.variables.width  )
		.attr("height", $.SIMILAR.variables.height );
	var gSVG = svg.append("g")
		.attr("class", "radar-similar-researchers")
		.attr("transform", "translate(" + ( $.SIMILAR.variables.width / 2 ) + "," + ( $.SIMILAR.variables.height ) + ")");

	this.base(gSVG, data);
	this.elements(gSVG, data);
}

$.SIMILAR.base= function (gSVG, data){
	var filter = gSVG.append('defs').append('filter').attr('id','glow'),
		feGaussianBlur = filter.append('feGaussianBlur').attr('stdDeviation','2.5').attr('result','coloredBlur'),
		feMerge = filter.append('feMerge'),
		feMergeNode_1 = feMerge.append('feMergeNode').attr('in','coloredBlur'),
		feMergeNode_2 = feMerge.append('feMergeNode').attr('in','SourceGraphic');
	
	var axisGrid 	  = gSVG.append("g").attr("class", "axisWrapper");
	var gAuthorAvatar = gSVG.append("g").classed("authorAvatar", true);
	
	var gPath 	= axisGrid.append("g").attr("class", "axisPaths");
	var gLabels = axisGrid.append("g").classed("axisLabels", true);	
	
	var dataRange = d3.range(1,($.SIMILAR.variables.levels + 1)).reverse();
	
	for (var i = 1; i < $.SIMILAR.variables.levels + 1; i++){
		var outerRadius = $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * dataRange[i];
		var innerRadius = $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * (dataRange[i - 1] );
		var arc = d3.arc()
			.innerRadius(innerRadius)
			.outerRadius(outerRadius)
			.startAngle( $.SIMILAR.variables.startAngle )
			.endAngle( $.SIMILAR.variables.endAngle );
		
		gPath.append("path")
			.attr("id", "level_" + i)
			.attr("class", "levelCircle")
			.attr("d", arc)
			.style("fill", "#CDCDCD")
			.style("stroke", "white")
			.style("filter" , "url(#glow)");
	}
	
	gLabels.selectAll(".axisLabel")
	   .data(d3.range(1,($.SIMILAR.variables.levels + 1 )).reverse())
	  .enter().append("text")
	   .attr("class", "axisLabel")
	   .attr("x", function(d){
		   return Math.sin($.SIMILAR.variables.endAngle) * $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * d;
	   })
	   .attr("y", function(d){
		   return -Math.cos($.SIMILAR.variables.endAngle) * $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * d;})
	   .attr("dy", "0.4em")
	   .style("font-size", "10px")
	   .style("font-weight", 600)
	   .attr("fill", "#737373")
	   .text(function(d,i) { return $.SIMILAR.variables.format(1 - ( d-1 )/10); });
	

	var authorAvatarRadius = 20;
	var authorAvatar = createImagePattern(gSVG.select("defs"), data.author, authorAvatarRadius);
	
	var user = gAuthorAvatar.append("circle")
		.classed("author-icon", true)
		.attr("r",authorAvatarRadius)
		.style("fill", "url(#pattern_" + data.author.id + ")");

	var name = gAuthorAvatar.append("text")
		.classed("author-name", true)
		.attr("dx", 0)
		.attr("dy", "2.5em")
		.style("text-anchor", "middle")
		.style("font-weight", 600)
		.text( data.author.name );
	
	gAuthorAvatar.attr("transform", "translate(0, " + -authorAvatarRadius + ")");
	
//	//Append the labels at each axis
//	axis.append("text")
//		.attr("class", "legend")
//		.style("font-size", "11px")
//		.attr("text-anchor", "middle")
//		.attr("dy", "0.35em")
//		.attr("x", function(d, i){ return rScale(maxValue * cfg.labelFactor) * Math.cos(angleSlice*i - Math.PI/2); })
//		.attr("y", function(d, i){ return rScale(maxValue * cfg.labelFactor) * Math.sin(angleSlice*i - Math.PI/2); })
//		.text(function(d){return d})
//		.call(wrap, cfg.wrapWidth);

	
}
$.SIMILAR.elements= function (gSVG, data){
	var similarAuthors = data.coAuthors.filter(function(d, index){ 
		return "similarity" in d && d.similarity >= 0.5;
	});
	
	var gSimilarAuthors = gSVG.append("g").attr("class", "similar-authors-elements");
	var defs = gSVG.select("defs");
	var radius = 10;
	
	createElements(similarAuthors, gSimilarAuthors, defs, radius);
	positionElementsOnRadar(similarAuthors, radius);
};
function createElements(similarAuthors, gSimilarAuthors, defs, radius){	
	var gSimilarAuthor = gSimilarAuthors.selectAll(".similar-author")
		.data(similarAuthors)
		.enter()
		.append("g").classed("similar-author",true)
			.on("mouseover", mouseOverNode)
			.on("mouseleave", mouseLeaveNode);
	var coauthor = gSimilarAuthor.append("circle")
		.classed("coauthor-icon", true)
		.attr("r",radius)
		.style("fill", function(d, i){
			if ( similarAuthors[i].photo != undefined ){ // add image pattern
				var coauthorImagePattern = createImagePattern(defs, similarAuthors[i], radius);
				return  "url(#pattern_" + similarAuthors[i].id + ")";
			}else {					
				return "transparent";
			}
		});
	gSimilarAuthor.append('text')
		.style('font-size', 1.5 * radius + 'px' )
		.text(function(d, i) { 
			if ( similarAuthors[i].photo === undefined ) 
				return  "\uf007";
			else 
				return ""; 
		}); 
	
}

function positionElementsOnRadar(similarAuthors, bubbleRadius){
	var mapData = mapDataBySimilarity(similarAuthors);
	
	var similarityLevel = 100;
	var level = 1;
	var angle = Math.abs($.SIMILAR.variables.startAngle) + Math.abs($.SIMILAR.variables.endAngle);
	
	while (similarityLevel >= 50){
		if ( mapData[similarityLevel.toString()] !== undefined ){
			var elementsToPosition = mapData[similarityLevel.toString()].length; 
			var pathLength = angle * ( level * $.SIMILAR.variables.radius / $.SIMILAR.variables.levels);
			var fittingBubbles = pathLength / ( bubbleRadius * 2 );
			var fittingAngle   =  fittingBubbles < elementsToPosition ?  angle / fittingBubbles : angle / elementsToPosition; 
			var startingAngle  = $.SIMILAR.variables.startAngle + fittingAngle/2;
			for (var i = 0; i < elementsToPosition; i++){
				var x =  Math.sin(i * fittingAngle + startingAngle) * $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * level;
				var y = -Math.cos(i * fittingAngle + startingAngle) * $.SIMILAR.variables.radius / $.SIMILAR.variables.levels * level;
				
				var node = d3.selectAll("g.similar-author").nodes().filter(function(d, index){ 
					return d3.select(d).datum().id === mapData[similarityLevel.toString()][i].id;
					});
				d3.select(node[0]).attr("transform", "translate(" + x + "," + y + ")");
			}
		}
		similarityLevel -= 5;
		level += 0.5; 
	}
	
}

function mapDataBySimilarity(similarAuthors){
	var mapData = {};
	for (var i = 0; i < similarAuthors.length; i++ ){
		var value 		 = similarAuthors[i].similarity * 10;
		var roundedValue = Math.round( value );
		var key = value >= roundedValue ? (roundedValue * 10).toString() : ((roundedValue-1) * 10 + 5).toString();
			
		if (key in mapData)
			mapData[key].push(similarAuthors[i]);
		else{
			mapData[key] = [];
			mapData[key].push(similarAuthors[i]);
		}
	}		
	return mapData;
}

function mouseOverNode(){
//	console.log(d3.event.transform);
	var scaleFactor = 2;
	d3.select(this)
		.transition()
		.duration(350)
		.attr("transform", "translate(" +  d3.transform(d3.select(this).attr("transform")).translate + ") scale(" + scaleFactor + ")");
}
function mouseLeaveNode(){
	d3.select(this)
		.transition()
		.duration(150)
		.attr("transform", "translate(" +  d3.transform(d3.select(this).attr("transform")).translate + ") scale(" + 1 + ")");
}

function createArc(innerRadius, outerRadius){
	return d3.arc()
    	.innerRadius(innerRadius)
    	.outerRadius(outerRadius)
    	.startAngle( $.SIMILAR.variables.startAngle )
    	.endAngle( $.SIMILAR.variables.endAngle );
}

function createImagePattern(container, author, radius){
	return container.append("svg:pattern")
		.attr("id", "pattern_" + author.id)
    	.attr("class", "author_avatar")
    	.attr("width", radius * 2)
    	.attr("height", radius * 2)
       .append("svg:image")
        .attr("xlink:href", author.photo )
        .attr("width", radius * 2)
        .attr("height", radius * 2)
        .attr("x", 0)
        .attr("y", 0);
}

function existsImage(image_url){

    var http = new XMLHttpRequest();

    http.open('HEAD', image_url, false);
    http.send();

    return http.status != 404;

}