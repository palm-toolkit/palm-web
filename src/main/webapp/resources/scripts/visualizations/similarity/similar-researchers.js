$.SIMILAR = {};
$.SIMILAR.variables = {
		width  : 0,
		height : 400,
		margin : {
			bottom  : 40,
			top 	: 10,
			right   : 10,
			left 	: 10
		},
		levels : 6,
		startAngle : -0.3 * Math.PI,
		endAngle   :  0.3 * Math.PI,
		color : d3.scaleOrdinal(d3.schemeCategory20),
		levelColor : "grey",
		labelColor: "#CCB5CB",
		segmentLineColor : "#ead6fd",
		format : d3.format(".0%"),
		radiusElement : 10,
		circle	: {
			bkgroundColor : "#EBEBEB"
		}
};

$.SIMILAR.create = function( widgetUniqueName, data ){
	$.SIMILAR.variables.widgetUniqueName = widgetUniqueName;
	$.SIMILAR.variables.containerId   	 = "#widget-" + widgetUniqueName;
	$.SIMILAR.variables.mainContainer 	 = $( $.SIMILAR.variables.containerId + " .visualization-main" );
	$.SIMILAR.variables.detailsContainer = $( $.SIMILAR.variables.containerId + " .visualization-details" );
	$.SIMILAR.variables.width  			 = $.SIMILAR.variables.mainContainer.width();
	$.SIMILAR.variables.radius 			 = Math.min( $.SIMILAR.variables.width / 2 , $.SIMILAR.variables.height  );	
	$.SIMILAR.variables.visualizations 	 = new Visualizations();
	
	var svg = d3.select( this.variables.containerId + " .visualization-main" ).append("svg")
		.attr("viewBox",  "0 0 " + this.variables.width + " " + this.variables.height )
		.attr("preserveAspectRatio", "xMinYMin meet" );
	var gSVG = svg.append("g")
		.attr("class", "radar-similar-researchers")
		.attr("transform", "translate(" + ( this.variables.width / 2 ) + "," + ( this.variables.height - this.variables.margin.bottom ) + ")")
		.on("click", clickedSvgGroup);

	this.base(gSVG, data);
	this.elements(gSVG, data);
}

$.SIMILAR.base= function (gSVG, data){
	var filter = gSVG.append('defs').append('filter').attr('id','glow'),
		feGaussianBlur = filter.append('feGaussianBlur').attr('stdDeviation','2.5').attr('result','coloredBlur'),
		feMerge = filter.append('feMerge'),
		feMergeNode_1 = feMerge.append('feMergeNode').attr('in','coloredBlur'),
		feMergeNode_2 = feMerge.append('feMergeNode').attr('in','SourceGraphic');
	
	var axisGrid= gSVG.append("g").attr("class", "axisWrapper");
	var gPath 	= axisGrid.append("g").attr("class", "axisPaths");
	var gLabels = axisGrid.append("g").attr("class", "axisLabels");	
	
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
	
	//author Avatar
	var gAuthorAvatar = gSVG.append("g").classed("authorAvatar", true);	
	var authorAvatarRadius = 20;	
	
	
	var user = gAuthorAvatar.append("circle")
		.classed("author-icon", true)
		.attr("r",authorAvatarRadius)
		.style("fill", function(){ 
			var bkground = $.SIMILAR.variables.visualizations.common.getImageBackground( "#widget-" + $.SIMILAR.variables.widgetUniqueName + " svg", data.author, authorAvatarRadius );
			
			if( bkground != null ) 
				return bkground;
			
			$.SIMILAR.variables.visualizations.common.addMissingPhotoIcon( d3.select( this.parentNode ), authorAvatarRadius );
			
			return $.SIMILAR.variables.circle.bkgroundColor;
		});

	var name = gAuthorAvatar.append("text")
		.classed("author-name", true)
		.attr("dx", 0)
		.attr("dy", "2.5em")
		.style("text-anchor", "middle")
		.style("font-weight", 600)
		.text( data.author.name );
	
	gAuthorAvatar.attr("transform", "translate(0, " + -authorAvatarRadius + ")");
}
$.SIMILAR.elements= function (gSVG, data){
	var similarAuthors = data.similarAuthors.filter(function(d, index){ 
		d.similarity *= 10; 
		return "similarity" in d && d.similarity >= 0.5;
	});
	
	var gSimilarAuthors = gSVG.append("g").attr("class", "similar-authors-elements");
	var defs = gSVG.select("defs");
	var radius = $.SIMILAR.variables.radiusElement;
	
	createElements(similarAuthors, gSimilarAuthors, defs, radius);
	positionElementsOnRadar(similarAuthors, radius);
};

function clickedSvgGroup(){
	var targetNode = d3.event.target.parentNode;
	d3.selectAll(".similar-authors-elements .similar-author").nodes().forEach(function(d, i){				
		if (d != targetNode) {
			d3.select(d).classed("clicked", false);  
		}			
		d3.select(d).on("mouseleave")(d);
	});
	
	if ( d3.selectAll(".similar-authors-elements .clicked").nodes().length == 0){
		d3.select(".similar-author-details").remove();
		jQuery(".similar_researchers .similar-topics-of-interest").remove();
	}
}

function createElements(similarAuthors, gSimilarAuthors, defs, radius){	
	var gSimilarAuthor = gSimilarAuthors.selectAll(".similar-author")
		.data(similarAuthors)
		.enter()
		.append("g").classed("similar-author",true)
			.on("mouseenter", mouseoverNode)
			.on("mouseleave", mouseleaveNode)
			.on("click", clickedNode);
	var coauthor = gSimilarAuthor.append("circle")
		.classed("coauthor-icon", true)
		.attr("r",radius)
		.style("fill", function(d, i){
			var imageBkground = $.SIMILAR.variables.visualizations.common.getImageBackground( "#widget-" + $.SIMILAR.variables.widgetUniqueName + " svg", similarAuthors[i], radius );
			
			if ( imageBkground != null ) // add image pattern
				return  "url(#pattern_" + similarAuthors[i].id + ")";
			
			$.SIMILAR.variables.visualizations.common.addMissingPhotoIcon( d3.select( this.parentNode ), radius );
			return $.SIMILAR.variables.circle.bkgroundColor;
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

function mouseoverNode(){
	 d3.selection.prototype.moveToFront = function() {  
	      return this.each(function(){
	        this.parentNode.appendChild(this);
	      });
	};
	d3.select(this).moveToFront();
	
	var scaleFactor = 2;
	d3.select(this)
		.transition()
		.duration(350)
		.attr("transform", "translate(" +  d3.transform(d3.select(this).attr("transform")).translate + ") scale(" + scaleFactor + ")")
		.select( "circle" ).attr( "transform", "scale(" + 1.5 + ")" ) ;
	
	//add Tooltip
	var tooltip = new Tooltip( {
		className 	: "tooltip-researcher-similarity",
		position	: "right",
		width 		: 100,
		height		: 35,
		borderRadius: 5,
		fontSize	: 12,
		withImage   : false,
		container	: d3.select( this )
	} );
	
	tooltip.buildTooltip( d3.select(this), d3.select(this).datum() );
}
function mouseleaveNode(node){
	if (node.name !== undefined)
		node = this;
	
	if ( !d3.select(node).classed("clicked")){
		d3.select(node)
			.transition()
			.duration(150)
			.attr("transform", "translate(" +  d3.transform(d3.select(node).attr("transform")).translate + ") scale(" + 1 + ")")
			.select("circle").attr("transform", " scale( 1 )");
	}
	d3.select(node).selectAll(".tooltip-researcher-similarity").remove();
}
function clickedNode(){
	d3.event.stopPropagation();

	var scaleFactor = 2;
	
	$.SIMILAR.variables.detailsContainer.empty().removeClass("hidden");

	//decrease all nodes size
	d3.select( $.SIMILAR.variables.mainContainer.selector ).selectAll(".similar-author.clicked")
		.classed("clicked", false)
		.attr("transform", function(d, i){ return "translate(" +  d3.transform(d3.select( this ).attr("transform")).translate + ") scale(" + 1 + ")"; })
		.select("circle").attr("transform", " scale( 1 )");
	
	//increase node size
	d3.select(this).classed("clicked", true)
		.attr("transform", function(d, i){ return "translate(" +  d3.transform(d3.select( this ).attr("transform")).translate + ") scale(" + scaleFactor + ")"; })
		.select("circle").attr("transform", " scale( 1.5 )");;

	//create author details box
	d3.select("g.similar-author-details").remove();
	
	var viewbox = [$.SIMILAR.variables.width , $.SIMILAR.variables.height ,$.SIMILAR.variables.width , $.SIMILAR.variables.height ];
	var gAuthorDetails =  d3.select( $.SIMILAR.variables.detailsContainer.selector ).append("svg")
		.attr( "width", $.SIMILAR.variables.width )	
		.append("g")
			.classed( "similar-author-details", true );				
		
	addBasicInfo(gAuthorDetails, d3.select(this) );	
	addListSimilarTopics(gAuthorDetails, d3.select(this));	
	
	d3.select( gAuthorDetails.node().parentNode ).attr( "height", ( gAuthorDetails.node().getBBox().height + gAuthorDetails.node().getBBox().y * 2.5) * scaleFactor );
}
function addBasicInfo(gAuthorDetails, node) {
	var gBasicInfo  = gAuthorDetails.append("g").classed("author-basic-info", true);
	var fontSize 	= 14;	
	var scaleFactor = 2.5;
	var border		= 3;

	var tooltip_content = d3.select( node.select( ".tooltip-content" ).node().cloneNode(true) ).attr("transform", null);
	gBasicInfo.node().appendChild( tooltip_content.node() );
	
	var basicInfoBoxMeasurements = gBasicInfo.node().getBBox();
	var photoRadius   			 = scaleFactor * $.SIMILAR.variables.radiusElement + 10;
	
	//---- details photo
	var photo = gBasicInfo.append("g").classed("photo similar-author", true);	
		photo.node().appendChild( node.select("circle").node().cloneNode(true) );
	if ( node.select(".similar-author > text").node() != null )
		photo.node().appendChild( node.select("text").node().cloneNode(true) );
	
	gBasicInfo.attr("transform", "translate(" + ( photoRadius + 2*border ) + " , " + basicInfoBoxMeasurements.height/2 + ") scale(" + scaleFactor + ")");			
	photo.attr("transform", "translate(0, " + basicInfoBoxMeasurements.height/2 + ")");	
}

function addListSimilarTopics(gAuthorDetails, node){
	var similarTopics = node.datum().similarTopics || [];
		similarTopics = similarTopics.sort(function(a, b){ return a.value < b.value; });
	
	var fontSize = 20;
	var scale = d3.scaleLinear()
		.domain([0, 1])
		.range([8, 20]);
	var accordionContainer = jQuery("<div/>").attr("id", "accordion-container").addClass("similar-topics-of-interest");
	var title = jQuery("<span/>").addClass("title").text("Similar Topics of Interest");	
	var noResultMessage = jQuery("<span/>").text("No similar topic of interst is available.");
	var accordionDiv = jQuery("<div/>").attr("id", "accordion"); 
	
	
	for (var i = 0; i < similarTopics.length; i++){
		var topicTitle 	  = jQuery("<h3/>").text(similarTopics[i].name);		
		accordionDiv.append(topicTitle);
		
		var papersOnTopicDiv = jQuery("<div/>");
		accordionDiv.append(papersOnTopicDiv);
	}
	var icons = {
		header: "ui-icon-circle-arrow-e",
		activeHeader: "ui-icon-circle-arrow-s"
	};
		
	accordionDiv.accordion({ 
		icons: icons,
		collapsible: true,	
		active: false,
		heightStyle: "auto"
	});
		
	accordionContainer.append(title);
	
	if ( similarTopics.length > 0) 
		accordionContainer.append(accordionDiv);
	else
		accordionContainer.append(noResultMessage);
	
	$.SIMILAR.variables.detailsContainer.append(accordionContainer);
	
	$.SIMILAR.variables.detailsContainer.children("#accordion").children("h3").each(function(i, d){
		jQuery(d).css({
			"font-size": scale(similarTopics[i].value) * fontSize / 20,
			"font-weight": 400,
			"padding" : "1px 1px 1px 30px"
		});	
	});
	$( $.SIMILAR.variables.detailsContainer.selector + " #accordion>div" )
	.each(function(i, d){
		var loading = jQuery("<div/>").addClass("loading-icon fa fa-refresh fa-spin");
		jQuery(d).css({ "height": jQuery(accordionContainer).height()/2 + "px"}).append(loading);	
	});
	
	var availableSpace = $( $.SIMILAR.variables.mainContainer.selector ).height() - accordionDiv.height();
	accordionDiv.slimscroll({
		height: $( $.SIMILAR.variables.mainContainer.selector ).height() - availableSpace,
		width: "100%",
		size: "6px",
		alwaysVisible: true,
		railVisible: true
	});
	
}
function addList(papersOnTopic){
	var contentList = jQuery("<div/>").addClass("content-list");

	for (var i = 0; i < papersOnTopic.length; i++){
		var publication = jQuery("<div/>").addClass("publication").attr("id", papersOnTopic[i].id);
		var navDiv = jQuery("<div/>").addClass("nav").append(
				jQuery("<i/>").addClass( setIconClass(papersOnTopic[i].type) ).attr("title", papersOnTopic[i].type)
		);
			
		var detailDiv = jQuery("<div/>").addClass("detail width-small");
		detailDiv.append(jQuery("<div/>").addClass("title").text(papersOnTopic[i].title));
		detailDiv.append(jQuery("<div/>").addClass("author").text(function(){
			var text = "";
			var coauthors = papersOnTopic[i].coauthor;
			for (var k = 0; k < coauthors.length; k++){
				if (k != 0)
					text += ", ";
				text += coauthors[k].name;
			}
			return text;
		}));
		detailDiv.append(jQuery("<div/>").addClass("event-detail font-xs")
				.append(jQuery("</span>").text(function(){
					return papersOnTopic[i].event.name + "(" + papersOnTopic[i].volume + ")" + papersOnTopic[i].date.substring(0, 4);
				}))
				.text(" pp. " + papersOnTopic[i].pages )
				);
		publication.append(navDiv);
		publication.append(detailDiv);
		contentList.append(publication);
	}
	return contentList;
}
function setIconClass(type){
	return "fa fa-file-text-o bg-blue";
}
function createArc(innerRadius, outerRadius){
	return d3.arc()
    	.innerRadius(innerRadius)
    	.outerRadius(outerRadius)
    	.startAngle( $.SIMILAR.variables.startAngle )
    	.endAngle( $.SIMILAR.variables.endAngle );
}

function createDOM(elem, className, text){
	return jQuery(elem).addClass(className).text(text);
}
function existsImage(image_url){

    var http = new XMLHttpRequest();

    http.open('HEAD', image_url, false);
    http.send();

    return http.status != 404;

}
function toTitleCase(str)
{
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}