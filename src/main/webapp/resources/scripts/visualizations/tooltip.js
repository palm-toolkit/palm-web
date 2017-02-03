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
	
	this.getClassName 	 = function(){ return className; };
	this.getWidth 	 	 = function(){ return width; };
	this.getHeight 		 = function(){ return height; };
	this.getBorderRadius = function(){ return borderRadius; };
	this.getFontSize 	 = function(){ return fontSize; };
	this.getImageRadius  = function(){ return imageRadius; };
	this.getPosition	 = function(){ return position; };
	this.getBkgroundColor= function(){ return bkgroundColor; };
	this.getStrokeColor	 = function(){ return strokeColor; };
}

Tooltip.prototype.buildTooltip = function createTooltip( gNode, dataObject ){
		var borderRadius = this.getBorderRadius();
		var height		 = this.getHeight();
		var width		 = this.getWidth();
		var imageRadius  = this.getImageRadius();
		var fontSize	 = this.getFontSize();
		var bkColor		 = this.getBkgroundColor();
		var strokeColor  = this.getStrokeColor();
		
		var tooltipWidth  = width  - borderRadius;
		var tooltipHeight = height - borderRadius;
		var translate 	  = [0, ( height - borderRadius/2 ) / -2];
		
		
		var svg = d3.select( gNode.node().nearestViewportElement );
		if (svg != null){
			//add tooltip
			var gTooltip = svg.append("g").attr("class", "myTooltip " + this.getClassName());
			
			//position Tooltip
			switch( this.getPosition() ){
				case "top"    : translate = translateTop(); break;
				case "left"   : translate = translateLeft(); break;
				case "right"  : translate = translateRight(); break;
				case "bottom" : translate = translateBottom (); break;
			}		
			gTooltip.attr("transform", "translate(" + translate + ")");
		}
	
		//stroke
		tooltip_stroke( gTooltip );		
		//text
		var gContent = gTooltip.append("g").classed("tooltip-content", true);
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
			//image
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
			var distanceLeft = imageDetails.x + imageDetails.width + 5;
			
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
			var nrPublications = dataObject.nrPublications || "Not available";
			var nrCitations	   = dataObject.nrCitations || "Not available";			
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
			gContent.selectAll("g.content-text")
				.attr("transform", function (d, i) {				
					if (i > 0){
						var prevSibling = gContent.node().childNodes[ i ];
						if ( prevSibling != undefined){
		
							y += prevSibling.getBBox().height ;
						}
					}else{
							y += Math.abs(bbox.y) ;
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
		function translateLeft(){
			var tooltipWidth  = width  - borderRadius;
			var tooltipHeight = height - borderRadius;
			return [0, ( height - borderRadius/2 ) / -2];
		}
		function translateRight(){}
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