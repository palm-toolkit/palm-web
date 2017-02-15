function Tooltip( params ){
	var className 	= params.className;
	var width 		= params.width	  || 200;
	var height		= params.height	  || 70;
	var fontSize	= params.fontSize || 12;
	var borderRadius= params.borderRadius || 5;
	var imageRadius	= params.height/2 - 5 || 30;
	var position    = params.position || "top";
	var bkgroundColor = params.bkgroundColor || "rgba(255, 255, 255, 0.55)";
	var strokeColor = params.strokeColor || "#dadada";
	var withImage	= params.withImage == undefined ? true : params.withImage;
	
	this.getClassName 	 = function(){ return className; };
	this.getWidth 	 	 = function(){ return width; };
	this.getHeight 		 = function(){ return height; };
	this.getBorderRadius = function(){ return borderRadius; };
	this.getFontSize 	 = function(){ return fontSize; };
	this.getImageRadius  = function(){ return imageRadius; };
	this.getPosition	 = function(){ return position; };
	this.getBkgroundColor= function(){ return bkgroundColor; };
	this.getStrokeColor	 = function(){ return strokeColor; };
	this.getWithImage	 = function(){ return withImage; };
}

Tooltip.prototype.buildTooltip = function createTooltip( gNode, dataObject ){
		var borderRadius = this.getBorderRadius();
		var height		 = this.getHeight();
		var width		 = this.getWidth();
		var imageRadius  = this.getImageRadius();
		var fontSize	 = this.getFontSize();
		var bkColor		 = this.getBkgroundColor();
		var strokeColor  = this.getStrokeColor();
		var withImage    = this.getWithImage();
		
		var tooltipWidth  = width  - borderRadius;
		var tooltipHeight = height - borderRadius;
		var translate 	  = [0, ( height - borderRadius/2 ) / -2];
		
		
		var svg = d3.select( gNode.node().nearestViewportElement );
		if (svg != null){
			//add tooltip
			var gTooltip = svg.append("g").attr("class", "myTooltip " + this.getClassName());
			
			//position Tooltip
			switch( this.getPosition() ){
				case "top"    : translate = translateTop(); 
								rotate = 0;
								break;
				case "left"   : translate = translateRight(); 
								rotate 	  = translate[0] - tooltipWidth >= 0 ? 180 : 0;
								translate[1] += translate[0] - tooltipWidth >= 0 ? tooltipHeight: 0;
								break;
				case "right"  : translate = translateRight(); 
								rotate 	  = translate[0] + tooltipWidth <= svg.node().getBBox().width ? 0 : 180;
								translate[0] += translate[0] + tooltipWidth <= svg.node().getBBox().width ? 0 : -5;
								translate[1] += translate[0] + tooltipWidth <= svg.node().getBBox().width ? 0 : tooltipHeight;
								break;
				case "bottom" : translate = translateBottom ();
								rotate = 0; 
								break;
			}		
			gTooltip.attr("transform", "translate(" + translate + ") rotate(" + rotate + ")" );
		}
	
		//stroke
		tooltip_stroke( gTooltip );		
		//text
		var gContent = gTooltip.append("g").classed("tooltip-content", true);
		
		if ( rotate != 0 )
			gContent.attr("transform", "translate(" + [ tooltipWidth + tooltipHeight/2 + 5, tooltipHeight + 5] + ") rotate(" + rotate + ")" );
		tooltip_content( );
				
		return gTooltip;
		
		function tooltip_stroke( gTooltip ){
			tooltip_shadow( gTooltip );

			var stroke = gTooltip.append("path")
				.attr("d", "M 0 0 H " + tooltipWidth + 
					" A " + borderRadius + " " + borderRadius + " 0 0 1 " + width + " " + borderRadius/2 + " " +
					" V " + tooltipHeight + 
					" A " + borderRadius + " " + borderRadius + " 0 0 1 " + tooltipWidth + " " + (height - borderRadius/2) + " " +
					" H 0 A " + tooltipHeight/2 + " " + tooltipHeight/2 + " 1 0 0 0 0   ");
			stroke.classed("tooltip-stroke", true)
				.style("filter", "url(#drop-shadow)")
				.attr("fill", bkColor)
				.attr("stroke", strokeColor);
		}

		function tooltip_content( ){
			var distanceLeft = tooltipHeight/2 + 5;	
			//image
			if ( withImage ){
				var image = gContent.append("g").classed("image-icon", true)
					.attr("transform", "translate(" + [0, imageRadius + borderRadius ] + ")");
				var circle = image.append("circle").classed("image", true)
					.attr("r", imageRadius )
					.attr("stroke", strokeColor)
					.attr("fill", bkColor );
				
				if (dataObject.photo != null){
					var imagePattern = createImagePattern();
					circle.style("fill", "url(#pattern_" + dataObject.author.id + ")" );
				} else {
					image.append('text').classed("image missing-photo-icon", true)
						.attr("dy", ".35em")
						.style('font-size', 1.5 * imageRadius + 'px' )
						.style("font-family", "fontawesome")
						.style("text-anchor", "middle")
						.text("\uf007"); 
				}		
				var imageDetails = gContent.select(".image").node().getBBox();
			}
		
			//title
			var title = gContent.append("g").classed("title content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0 +")");
			wrapText(title, toTitleCase(dataObject.name), (width - distanceLeft), "title-name");	
			title.selectAll(".title-name");
			
			//status
			var status 	= gContent.append("g").classed("status content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			status.append("text").classed("icon-briefcase font-small", true)
				.style("font-family", "fontawesome")
				.text('\uf0b1');
			wrapText(status, dataObject.status || "Not Available", (width - distanceLeft), "status-name font-small");	
			status.selectAll(".status-name").attr("dx", "1.3em");
			
			//affiliation
			var affiliation = gContent.append("g").classed("affiliation content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			affiliation.append("text").classed("icon-institution font-small", true)
				.style("font-family", "fontawesome")
				.text('\uf19c');
			wrapText(affiliation, dataObject.affiliation || "Not available", (width - distanceLeft), "afiliation-name font-small");	
			affiliation.selectAll(".afiliation-name").attr("dx", "1.3em");
			
			//nr publications & citations
			var nrPublications = dataObject.publicationsNumber || "Not available";
			var nrCitations	   = dataObject.citedBy || "Not available";			
			var publicationsAndCitations = gContent.append("g").classed("pubs content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			wrapText(publicationsAndCitations, "Publications: " + nrPublications + ", Cited By: " + nrCitations, (width - distanceLeft), "paper font-small");
					
			//h-index
			var hindexString = dataObject.hindex || "Not available";
			var hindex = gContent.append("g").classed("hindex content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0 + ")");;
			wrapText(hindex, "H-index: " + hindexString, (width - distanceLeft), "hindex font-small");				
			
			positionContentElements( distanceLeft );
		}	
		
		function positionContentElements( distanceLeft ){
			var bbox = gContent.node().parentNode.getBBox();
			var x = distanceLeft;
			var y = (bbox.height - gContent.node().getBBox().height)/2;
			var prevH  = 0;
			gContent.selectAll("g.content-text")
				.attr("transform", function (d, i) {	
					var heightLine = d3.select(this).select("text").node().getBBox().height;
					var heightElem = this.getBBox().height;
					
					if (i == 0){
						y = heightLine;
						prevH = heightLine == heightElem ? 0 : heightElem;
					}else{
						
						var heightLine = d3.select(this).select("text").node().getBBox().height;
						var heightElem = this.getBBox().height;
						
						y += prevH == 0 ? heightLine : prevH;						
						
						prevH = heightLine == heightElem ? 0 : heightElem;
					}	
					return "translate(" + x + ", " + y +")"
				});
		}
		function createImagePattern(){
			return gTooltip.append("defs")
				.append("svg:pattern")
					.attr("id", "pattern_" + dataObject.author.id)
					.attr("class", "author_avatar")
					.attr("width", 1)
					.attr("height", 1)
				   .append("svg:image")
				   	.attr("xlink:href", dataObject.photo )
				   	.attr("width", imageRadius * 2)
				   	.attr("height", imageRadius * 2)
				   	.attr("x", 0)
				   	.attr("y", 0);
		}
		
		function toTitleCase(str) {
		    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
		}
		
		function translateTop(){
			var tooltipWidth  = width  - borderRadius;
			var tooltipHeight = height - borderRadius;
			var x = gNode.node().getBBox().width > width ? -(gNode.node().getBBox().width - width )/ 2 : (gNode.node().getBBox().width - width )/ 2;
			var y = - (height + 10);
			
			var nodeTranslate = d3.transform( gNode.attr("transform") ).translate;			
			if (nodeTranslate != undefined && nodeTranslate[0] != undefined){
				x += nodeTranslate[0];
				y += nodeTranslate[1];
			}
			if ( gNode.attr("x") != undefined ) x += gNode.attr("x");
			if ( gNode.attr("y") != undefined ) y += gNode.attr("y");
					
			var svgY = d3.select( gNode.node().nearestViewportElement ).node().getBBox().y;
			if ( y < svgY )
				return translateBottom();
			return [ x, y ];
		}
		
		function translateRight(){
			var $nodeParents   = $(gNode.node()).parents();
			var tooltipWidth  = width  - borderRadius;
			var tooltipHeight = height - borderRadius;
			var x = 10;
			var y = (height - borderRadius/2 ) / -2;
			
			var newXY = addElementTranslation(x, y, gNode);
	
			var i = 0;
			while ( i < $nodeParents.length && $nodeParents[i].tagName != "svg" ){
				newXY = addElementTranslation(newXY[0], newXY[1], d3.select($nodeParents[i]));
				i++;
			}
			x = newXY[0]; y= newXY[1];
			
			var svgWidth = d3.select( gNode.node().nearestViewportElement ).node().getBBox().width;
			
			return [ x, y ];
		}
		
		
		function addElementTranslation( x, y, elem ){
			var elemTranslate = d3.transform( elem.attr("transform") ).translate;
			if ( elemTranslate != undefined && elemTranslate[0] != undefined ){
				x += elemTranslate[0];
				y += elemTranslate[1];
			}
			if ( elem.attr("x") != undefined ) x += elem.attr("x");
			if ( elem.attr("y") != undefined ) y += elem.attr("y");
			
			return[x, y];
		}
		
		function translateBottom(){
			var tooltipWidth  = width  - borderRadius;
			var tooltipHeight = height - borderRadius;
			var x = gNode.node().getBBox().width > width ? -(gNode.node().getBBox().width - width )/ 2 : (gNode.node().getBBox().width - width )/ 2;
			var y = gNode.node().getBBox().height + 10;
			
			var nodeTranslate = d3.transform( gNode.attr("transform") ).translate;			
			if (nodeTranslate != undefined && nodeTranslate[0] != undefined){
				x += nodeTranslate[0];
				y += nodeTranslate[1];
			}
			if ( gNode.attr("x") != undefined ) x += gNode.attr("x");
			if ( gNode.attr("y") != undefined ) y += gNode.attr("y");
			
			return [x, y];
		}
		
		function wrapText( container, text, width, className){
			var lineHeight = fontSize;
			var y = 0;
			var words = text.split(" ").reverse();
			var textArray = [];
			var text = container.append("text").attr("class", className);
			
			while(word = words.pop()){
				textArray.push(word);
				text.text( textArray.join(" ") );
				
				if ( text.node().getBBox().width > width ){
					y += lineHeight; 
					var w = textArray.pop();
					text.text( textArray.join(" ") );
					
					textArray = [w];
					text = container.append("text").attr("class", className)
							.attr("dy", y )
							.text( textArray.join(" ") );
				}				
			}
		}
		
		function tooltip_shadow( gTooltip ){
			var defs = gTooltip.append("defs");
			var filter = defs.append("filter")
			    .attr("id", "drop-shadow")
			    .attr("height", "130%");
			filter.append("feGaussianBlur")
			    .attr("in", "SourceAlpha")
			    .attr("stdDeviation", 5)
			    .attr("result", "blur");

			filter.append("feOffset")
			    .attr("in", "blur")
			    .attr("dx", 5)
			    .attr("dy", 5)
			    .attr("result", "offsetBlur");
			
			filter.append("feFlood")
			  .attr("in", "offsetBlur")
			  .attr("flood-color", "#666")
			  .attr("flood-opacity", "1")
			  .attr("result", "offsetColor");
			
			 filter.append("feComposite")
	            .attr("in", "offsetColor")
	            .attr("in2", "offsetBlur")
	            .attr("operator", "in")
	            .attr("result", "offsetBlur");
			 
			var feMerge = filter.append("feMerge");

			feMerge.append("feMergeNode")
			    .attr("in", "offsetBlur")
			feMerge.append("feMergeNode")
			    .attr("in", "SourceGraphic");

			
		}
}