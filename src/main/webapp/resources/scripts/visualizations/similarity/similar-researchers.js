$.SIMILAR = {};
$.SIMILAR.variables = {
		margin : {
			bottom  : 40,
			top 	: 10,
			right   : 10,
			left 	: 10
		},
		levels : 10,
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

$.SIMILAR.create = function( ){ 
	
	var svg = $.SIMILAR.variables.widget.select( ".visualization-main" ).append("svg")
		.attr("viewBox",  "0 0 " + this.variables.width + " " + this.variables.height )
		.attr("preserveAspectRatio", "xMinYMin meet" );
	var gSVG = svg.append("g")
		.attr("class", "radar-similar-researchers")
		.attr("transform", "translate(" + ( this.variables.width / 2 ) + "," + ( this.variables.height - this.variables.margin.bottom - this.variables.margin.top ) + ")")
		.on("click", $.SIMILAR.interactions.clickedSvgGroup);

	var similarAuthors = $.PALM.visualizations.data.similarAuthors.filter(function(d, index){ 
		d.similarity *= 100;
		return "similarity" in d && d.similarity >= 10;
	});
	var mapData = mapDataBySimilarity(similarAuthors);
	
	this.base(gSVG, $.PALM.visualizations.data.author, mapData);
	this.elements(gSVG, similarAuthors, mapData);
}

$.SIMILAR.base= function (gSVG, author, mapData){
	var filter = gSVG.append('defs').append('filter').attr('id','glow'),
		feGaussianBlur = filter.append('feGaussianBlur').attr('stdDeviation','2.5').attr('result','coloredBlur'),
		feMerge = filter.append('feMerge'),
		feMergeNode_1 = feMerge.append('feMergeNode').attr('in','coloredBlur'),
		feMergeNode_2 = feMerge.append('feMergeNode').attr('in','SourceGraphic');
	
	var axisGrid= gSVG.append("g").attr("class", "axisWrapper");
	var gPath 	= axisGrid.append("g").attr("class", "axisPaths");
	var gLabels = axisGrid.append("g").attr("class", "axisLabels");	
	
	var dataRange = d3.range(1,($.SIMILAR.variables.levels + 1)).reverse();
	
	var missingLevels = 0;
	
	dataRange.forEach( function(d, i){
		if (  mapData[(d * 10).toString()] == undefined && mapData[(d * 10 + 5).toString()] == undefined )
			missingLevels ++ ;
	})

	var missingLevelHeight = missingLevels != $.SIMILAR.variables.levels ? $.SIMILAR.variables.radius / $.SIMILAR.variables.levels / 2 : $.SIMILAR.variables.radius / ($.SIMILAR.variables.levels+1);
	var levelHeight		   = ($.SIMILAR.variables.radius - missingLevelHeight * (missingLevels - 1) )/ ( $.SIMILAR.variables.levels - (missingLevels - 1) );
	
	var innerRadius = $.SIMILAR.variables.radius ;
	var outerRadius = null;
	
	for (var i = 0; i < $.SIMILAR.variables.levels  ; i++){
		outerRadius = innerRadius;	
		innerRadius = mapData[(dataRange[$.SIMILAR.variables.levels -i] * 10).toString()] == undefined && mapData[(dataRange[$.SIMILAR.variables.levels -i] * 10 + 5).toString()] == undefined ? 
				innerRadius - missingLevelHeight : innerRadius - levelHeight;	
		
		var arc = $.PALM.utility.visualizations.createArc(innerRadius, outerRadius,  $.SIMILAR.variables.startAngle, $.SIMILAR.variables.endAngle );
		
		gPath.append("path")
			.attr("id", "level_" + i)
			.attr("class", "levelCircle")
			.attr("data-innerradius", innerRadius )
			.attr("data-outerradius", outerRadius )
			.attr("d", arc)
			.style("fill", "#CDCDCD")
			.style("fill-opacity", 0.5 +  0.05 * i)
			.style("stroke", "white")
			.style("filter" , "url(#glow)");
	}
	
	var innerRadius = $.SIMILAR.variables.radius;
	
	gLabels.selectAll(".axisLabel")
	   .data(d3.range(1,($.SIMILAR.variables.levels + 1 )).reverse())
	  .enter().append("text")
	   .attr("class", "axisLabel")
	   .attr("dy", "0.4em")
	   .style("font-size", "10px")
	   .style("font-weight", 600)
	   .attr("fill", "#737373")
	   .text(function(d,i) { 
		   innerRadius = mapData[(dataRange[$.SIMILAR.variables.levels - i ] * 10).toString()] == undefined && mapData[(dataRange[$.SIMILAR.variables.levels - i ] * 10 + 5).toString()] == undefined ? 
					innerRadius - missingLevelHeight : innerRadius - levelHeight;	
		   d3.select( this )
		   	.attr("x",  Math.sin($.SIMILAR.variables.endAngle) * innerRadius )
		   	.attr("y",  -Math.cos($.SIMILAR.variables.endAngle) * innerRadius );
		   return $.SIMILAR.variables.format(1 - ( d-1 )/10); 
		 });
	
	//author Avatar
	var gAuthorAvatar = gSVG.append("g").classed("authorAvatar", true);	
	var authorAvatarRadius = 20;	
		
	var user = gAuthorAvatar.append("circle")
		.classed("author-icon", true)
		.attr("r",authorAvatarRadius)
		.style("fill", function(){ 
			var bkground = $.PALM.utility.visualizations.getImageBackground( "#widget-" + $.PALM.visualizations.widgetUniqueName + " svg", author);
			
			if( bkground != null ) 
				return bkground;
			
			$.PALM.utility.visualizations.addMissingPhotoIcon( d3.select( this.parentNode ),  "last", {className: "missing-photo-icon author_avatar", size: 1.5 * authorAvatarRadius, color: "grey", dy : "0", textAnchor : "middle", text: "\uf007" }  );
			
			return $.SIMILAR.variables.circle.bkgroundColor;
		});

	var name = gAuthorAvatar.append("text")
		.classed("author-name", true)
		.attr("dx", 0)
		.attr("dy", "2.5em")
		.style("text-anchor", "middle")
		.style("font-weight", 600)
		.text( author.name );
	
	gAuthorAvatar.attr("transform", "translate(0, " + 0 + ")");
}

$.SIMILAR.elements = function (gSVG, similarAuthors, mapData){
	var gSimilarAuthors = gSVG.append("g").attr("class", "similar-authors-elements");
	var defs = gSVG.select("defs");
	var radius = $.SIMILAR.variables.radiusElement;
	
	createElements(similarAuthors, gSimilarAuthors, defs, radius);
	positionElementsOnRadar(similarAuthors, radius, mapData);

	$( "#widget-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();
	
	function createElements(similarAuthors, gSimilarAuthors, defs, radius){	
		var gSimilarAuthor = gSimilarAuthors.selectAll(".similar-author")
			.data(similarAuthors)
			.enter()
			.append("g").classed("similar-author",true)
				.on("mouseenter", $.SIMILAR.interactions.mouseoverNode)
				.on("mouseleave", $.SIMILAR.interactions.mouseleaveNode)
				.on("click", $.SIMILAR.interactions.clickedNode);
		
		var coauthor = gSimilarAuthor.append("circle")
			.classed("coauthor-icon", true)
			.attr("r",radius)
			.style("fill", function(d, i){
				var imageBkground = $.PALM.utility.visualizations.getImageBackground( "#widget-" + $.PALM.visualizations.widgetUniqueName + " svg", similarAuthors[i] );
				
				$.PALM.utility.visualizations.addMissingPhotoIcon( d3.select( this.parentNode ),  "first", {className: "missing-photo-icon author_avatar", size: 1.5 * radius, color: "grey", dy : ".35em", textAnchor : "middle", text: "\uf007" }  );
				
				if ( imageBkground != null ) // add image pattern
					return  "url(#pattern_" + similarAuthors[i].id + ")";
				
				$.PALM.utility.visualizations.addMissingPhotoIcon( d3.select( this.parentNode ),  "last", {className: "missing-photo-icon author_avatar", size: 1.5 * radius, color: "grey", dy : ".35em", textAnchor : "middle", text: "\uf007" }  );
				
				return $.SIMILAR.variables.circle.bkgroundColor;
			});
	}
	
	function positionElementsOnRadar( similarAuthors, bubbleRadius, mapData ){
		var similarityLevel = 100;
		var level = 1;
		var angle = Math.abs($.SIMILAR.variables.startAngle) + Math.abs($.SIMILAR.variables.endAngle);
		
		var positioned = {};
		
		if ( d3.selectAll("g.similar-author").nodes().length > 0 ){
			d3.selectAll("g.similar-author").each( function( d, i ){
								 
				var innerRadius = parseInt( d3.select( "#level_" + Math.floor( d.similarityLevel / 10 ) ).attr("data-innerradius") );
				var outerRadius = parseInt( d3.select( "#level_" + Math.floor( d.similarityLevel / 10 ) ).attr("data-outerradius") );
				var elementsToPosition = mapData[d.similarityLevel.toString()].length; 
				
				if ( ! ( d.similarityLevel in positioned ) ){
					positioned[ d.similarityLevel ] = [];
					positioned[ d.similarityLevel ].push(elementsToPosition);
				}
				
				var pathLength = angle * outerRadius;
				var fittingBubbles = pathLength / ( bubbleRadius * 2 );
				var fittingAngle   = fittingBubbles < elementsToPosition ?  angle / fittingBubbles : angle / elementsToPosition; 
				var startingAngle  = $.SIMILAR.variables.startAngle + fittingAngle/2;
				
				var lev = d.similarityLevel % 2 == 0 ? 0 : ( outerRadius - innerRadius ) / 2 ;
				var x =  Math.sin( ( elementsToPosition - positioned[ d.similarityLevel ] ) * fittingAngle + startingAngle) * ( outerRadius - lev );
				var y = -Math.cos( ( elementsToPosition - positioned[ d.similarityLevel ] ) * fittingAngle + startingAngle) * ( outerRadius - lev );
					
				d3.select( this ).attr("transform", "translate(" + x + "," + y + ")");
				
				positioned[ d.similarityLevel ] --;
			});
		}
	}
};

$.SIMILAR.interactions = {
		clickedSvgGroup : function(){
			var targetNode = d3.event.target.parentNode;
			d3.selectAll(".similar-authors-elements .similar-author").nodes().forEach(function(d, i){				
				if (d != targetNode) {
					d3.select(d).classed("clicked", false);  
				}			
				d3.select(d).on("mouseleave")(d);
			});
			
			if ( d3.selectAll(".similar-authors-elements .clicked").nodes().length == 0){
				d3.select(".similar-author-details").remove();
				jQuery( $.SIMILAR.variables.detailsContainer.selector + " .similar-topics-of-interest").remove();
				
				d3.select( $.SIMILAR.variables.detailsContainer.selector ).classed("hidden", true);
			}
		},
		mouseoverNode : function (){
			var fontSize = 12;
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
				padding		: 5, 
				fontSize	: fontSize/scaleFactor,
				withImage   : false,
				container	: d3.select( this )
			} );
			
			tooltip.buildTooltip( d3.select(this), d3.select(this).datum() );
		},
		mouseleaveNode : function (node){
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
			d3.select(node).selectAll(".author-similarityDegree").remove();
		},
		clickedNode : function (){
			//d3.event.stopPropagation();

			var scaleFactor = 2.5;
			//test
			
			$.SIMILAR.variables.detailsContainer.empty()
			.append("<button type='button' class='close' aria-hidden='true' onclick='$.SIMILAR.interactions.clickedCloseDetails()' >×</button>")
			.removeClass("hidden");

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
				
			$.SIMILAR.basicInfo(gAuthorDetails, d3.select(this) );	
			$.SIMILAR.topics.list(gAuthorDetails, d3.select(this));	
			
			d3.select( gAuthorDetails.node().parentNode ).attr( "height", ( gAuthorDetails.node().getBBox().height + $.SIMILAR.variables.margin.top ) * scaleFactor );
			$.SIMILAR.interactions.clickedTopic( this );
		},
		clickedTopic : function( elem ){	
			var _thisData = d3.select(elem).datum();
			
			$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
					
			if (_thisData.topicdetail != undefined && _thisData.topicdetail.length > 0){
				var topic = JSON.stringify(_thisData.topicdetail);
				

				$.SIMILAR.variables.getPaperOnTopic = $.get( $.PALM.visualizations.url + "/researcher/papersByTopicAndAuthor?id=" + _thisData.id + "&topic=" + topic,
					function( response ){
						console.log( "publications:");
						console.log(response);
						
						$.SIMILAR.variables.detailsContainer.find("#accordion" ).children("h3").map( 
							function(j, y){ 
								var tops = response.topic_paper[ '"' + $(y).text() + '"' ];								
								var accordionBox = $.SIMILAR.variables.detailsContainer.find("#accordion" ).children("div")[ j ];
									
								if ( tops.length > 0 ) 
									 $( accordionBox ).append( $ ($.SIMILAR.topics.publications( tops ))[0] );
								else $( accordionBox ).empty().append($("<p/>").text("No paper available"));
						});				
						
						$.SIMILAR.variables.detailsContainer.find("#accordion .content-list" ).slimscroll({
							height: "100%",
		        			size: "6px",
							allowPageScroll: true,
	   						touchScrollStep: 50,
	   						alwaysVisible: true,
	   						railVisible: true   						
		    			});			
				}).done(function() {
					$.SIMILAR.variables.detailsContainer.find( "#accordion-container .loading-icon" ).remove();
					$.SIMILAR.variables.getPaperOnTopic = null;
	  			});
			}							
		},
		clickedCloseDetails : function(){
			d3.select( $.SIMILAR.variables.detailsContainer.selector ).classed("hidden", true);
			
			if ( $.SIMILAR.variables.getPaperOnTopic != null )
				$.SIMILAR.variables.getPaperOnTopic.abort();
		}
}

$.SIMILAR.basicInfo = function (gAuthorDetails, node) {
	var gBasicInfo  = gAuthorDetails.append("g").classed("author-basic-info", true);
	var fontSize 	= 14;	
	var scaleFactor = 2.5;
	var border		= 3;

	var tooltip_content = d3.select( node.select( ".tooltip-content" ).node().cloneNode(true) ).attr("transform", null);
	tooltip_content.select(".similarity").remove();
	
	gBasicInfo.node().appendChild( tooltip_content.node() );
	
	var basicInfoBoxMeasurements = gBasicInfo.node().getBBox();
	var photoRadius   			 = scaleFactor * $.SIMILAR.variables.radiusElement + 10;
	
	//---- details photo
	var photo = gBasicInfo.append("g").classed("photo similar-author", true);	
	
	if ( node.select(".similar-author > text").node() != null )
		photo.node().appendChild( node.select("text").node().cloneNode(true) );
	
	photo.node().appendChild( node.select("circle").node().cloneNode(true) );
	
	if ( $( photo.select( "circle").node() ).css("fill").indexOf("url") < 0 )
		if ( node.select(".similar-author > text").node() != null )
			photo.node().appendChild( node.select("text").node().cloneNode(true) );
		

	createSimilarityDegreeArc(photo, "#0083ed",
			{ 
			  id		  : "similarityDegreeId",
			  className	  : "similarityDegree",
			  innerRadius : photoRadius / scaleFactor, 
			  outerRadius : photoRadius / scaleFactor + 2, 
			  startAngle  : 0, 
			  endAngle    : Math.PI * 2 * node.datum().similarity / 100} );
	
	addTextToArc(photo, "#0083ed", fontSize / scaleFactor  * 0.7, Number(node.datum().similarity).toFixed(1) + "%",
			{ 
		  	id		  : "similarityDegreeId",
		  	className : "similarityDegree"} );
	
	gBasicInfo.attr("transform", "translate(" + ( photoRadius + 2*border ) + " , " + ( $.SIMILAR.variables.margin.top ) + ") scale(" + scaleFactor + ")");			
	photo.attr("transform", "translate(0, " + (photoRadius / 2) + ")");	
	
	if ( gAuthorDetails.node().parentNode.getBBox().height < basicInfoBoxMeasurements.height )
		d3.select( gAuthorDetails.node().parentNode ).attr("height", basicInfoBoxMeasurements.height);
}

$.SIMILAR.topics = {
		list : function (gAuthorDetails, node){
			var similarTopics = node.datum().topicdetail || [];
				similarTopics = similarTopics.sort(function(a, b){ return a.value < b.value; });
				
			var fontSize = 14;
			var scale = d3.scaleLinear()
				.domain([0, 1])
				.range([8, 20]);
			var accordionContainer = jQuery("<div/>").attr("id", "accordion-container").addClass("similar-topics-of-interest");
			var title = jQuery("<span/>").addClass("title").text("Similar Topics of Interest");	
			var noResultMessage = jQuery("<span/>").text("No similar topic of interst is available.");
			var accordionDiv = jQuery("<div/>").attr("id", "accordion"); 
			
			
			for (var i = 0; i < similarTopics.length; i++){
				var unique = $.PALM.utility.visualizations.removeDuplicatesArray( similarTopics[i].name.split(";") );
				
				for ( j = 0; j < unique.length; j ++){
					var topicTitle 	  = jQuery("<h3/>").text( unique[j] );		
					accordionDiv.append(topicTitle);
				
					var papersOnTopicDiv = jQuery("<div/>");
					accordionDiv.append(papersOnTopicDiv);
				}
			}
			var icons = {
				header: "ui-icon-circle-arrow-e",
				activeHeader: "ui-icon-circle-arrow-s"
			};
				
			accordionDiv.accordion({ 
				icons: icons,
				collapsible: true,	
				active: false,
				heightStyle: "content"
			});
				
			accordionContainer.append(title);
			
			if ( similarTopics.length > 0) 
				accordionContainer.append(accordionDiv);
			else
				accordionContainer.append(noResultMessage);
			
			$.SIMILAR.variables.detailsContainer.append(accordionContainer);
			
			$( $.SIMILAR.variables.detailsContainer.selector + " #accordion>div" )
			.each(function(i, d){
				var loading = jQuery("<div/>").addClass("loading-icon fa fa-refresh fa-spin");
				jQuery(d).css({ "height": jQuery(accordionContainer).height()/2 + "px"}).append(loading);	
			});
			
			var basicDetailsHeight = d3.select( $.SIMILAR.variables.detailsContainer.selector + " .author-basic-info" ).node().getBoundingClientRect().height;
			
			accordionDiv.slimscroll({
				height: $.SIMILAR.variables.mainContainer.height() - basicDetailsHeight - title.height(),
				width: "100%",
				size: "6px",
				alwaysVisible: true,
				railVisible: true
			});	
		},
		publications : function (papersOnTopic){
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
}
function mapDataBySimilarity(similarAuthors){
	var mapData = {};
	for (var i = 0; i < similarAuthors.length; i++ ){
		var value 		 = similarAuthors[i].similarity ;
		var roundedValue = Math.round( value );
		//var key = value >= roundedValue ? (roundedValue ).toString() : ((roundedValue-1) + 5).toString();
		var lastDigit = value >= roundedValue ? (roundedValue ) % 10 : (roundedValue-1) % 10;
		var key = lastDigit == 0 ? Math.floor(value/10).toString() + lastDigit : lastDigit > 0 && lastDigit < 8 ? Math.floor(value/10).toString() + "5" : ( Math.floor(value/10) + 1 ).toString() + "0" ;
			
		similarAuthors[i].similarityLevel = key;
		
		if (key in mapData)
			mapData[key].push(similarAuthors[i]);
		else{
			mapData[key] = [];
			mapData[key].push(similarAuthors[i]);
		}
	}		
	return mapData;
}
function createSimilarityDegreeArc( container, color, arcData ){
	var similarityArc = $.PALM.utility.visualizations.createArc( arcData.innerRadius, arcData.outerRadius,  arcData.startAngle, arcData.endAngle );
	
	var arc = container.append("path")
		.attr("id", arcData.id )
		.attr("class", arcData.className)
		.attr("d", similarityArc ) 
		.style("fill", color)
		.style("fill-opacity", 0.9)
		.style("stroke", color);
}

function addTextToArc( container, color, fontSize, textContent, arcData ){
	var text = container.append("text")
		.attr("class", arcData.className )
		.attr("dy", "-.3em" )
		.style("font-size", fontSize );
		
	 text.append("textPath")
	    .attr("stroke", color )
	    .attr("stroke-width", 0.3)
	    .attr("startOffset","0%")
	    .style("text-anchor","start")
	    .attr("xlink:href","#" + arcData.id  )
	   .text( textContent );
}


function setIconClass(type){
	return "fa fa-file-text-o bg-blue";
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
