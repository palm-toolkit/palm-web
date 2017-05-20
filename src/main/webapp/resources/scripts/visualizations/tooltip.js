function Tooltip( params ){
	var className 	= params.className || "tooltip";
	var width 		= params.width	  || 200;
	var height		= params.height	  || 70;
	var fontSize	= params.fontSize || 12;
	var borderRadius= params.borderRadius || 5;
	var imageRadius	= 30;
	var position    = params.position || "top";
	var bkgroundColor = params.bkgroundColor || "rgba(255, 255, 255, 0.55)";
	var strokeColor = params.strokeColor || "#dadada";
	var withImage	= params.withImage == undefined ? true : params.withImage;
	var container	= params.container == undefined ? null : params.container;
	
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
	this.getContainer	 = function(){ return container; };
	
	this.setHeight	 	 = function( h ){ return height = h; };
	this.setPosition	 = function( p ){ return position = p; };
	this.setImageRadius	 = function( iR ){ return imageRadius = iR; };
	
}

Tooltip.prototype.extraTranslate = function ( gNode, extraTranslate ){
	var svg 	  = this.getContainer() == null ? d3.select( gNode.node().nearestViewportElement ) : this.getContainer();
	var gTooltip  = svg.select("g.myTooltip");
	var translate = d3.transform( gTooltip.attr("transform") ).translate;
	var rotate 	  = d3.transform( gTooltip.attr("transform") ).rotate;
	
	var translateX = translate[0] + extraTranslate[0];
	var translateY = translate[1] + extraTranslate[1];
	
	gTooltip.attr("transform", "translate(" + [translateX, translateY] + ") rotate(" + rotate + ")" );
};

Tooltip.prototype.buildTooltip = function createTooltip( gNode, dataObject ){
		var fontSize = this.getFontSize();
		var container = this.getContainer() == null ? d3.select( gNode.node().nearestViewportElement ) : this.getContainer();
		var svg = d3.select( gNode.node().nearestViewportElement );
		var gTooltip = null;
		var visualizations = new Visualizations();
		
		if (container != null){
			//add tooltip
			gTooltip = container.append("g").attr("class", "myTooltip " + this.getClassName());
	
			//add stroke	
			var pathTooltip = gTooltip.append("path").classed("tooltip-path", true);
		
			//add content 
			var gContent = gTooltip.append("g").classed("tooltip-content", true);
		
			//add content text
			tooltip_content( this );
			
			//set tooltip height based on content text
			var contentHeight = gContent.node().getBBox().height + 10;
			this.setHeight( contentHeight );
			this.setImageRadius( contentHeight / 2 - 5 );
		
			//add image
			if ( this.getWithImage() ) addImage( this );
		
			//position Tooltip
			var tooltipWidth  = this.getWidth()  - this.getBorderRadius();
			var tooltipHeight = this.getHeight() - this.getBorderRadius();
			var translate 	  = [0, ( this.getHeight() - this.getBorderRadius()/2 ) / -2];
		
			switch( this.getPosition() ){
				case "top"    : translate = translateTop( this ); 
								rotate = 0;
								break;
				case "left"   : translate = translateRight( this ); 
								rotate 	  = translate[0] - tooltipWidth >= 0 ? 180 : 0;
								translate[0] = rotate == 0 ? this.getImageRadius()/2 : -this.getImageRadius()/2;
								translate[1] = rotate == 0 ? -( contentHeight - 3 ) / 2 : ( contentHeight - 3)  / 2 ;
								break;
				case "right"  : translate = translateRight( this ); 
								rotate 	  = translate[0] + tooltipWidth <= svg.node().getBBox().width ? 0 : 180;
								translate[0] = rotate == 0 ? this.getImageRadius()/2 : -this.getImageRadius()/2;
								translate[1] = rotate == 0 ? -( contentHeight - 3 ) / 2 : ( contentHeight - 3)  / 2 ;
								break;
				case "bottom" : translate = translateBottom( this );
								rotate = 0; 
								break;
			}	
			//position the tooltip
			gTooltip.attr("transform", "translate(" + translate + ") rotate(" + rotate + ")" );
		
			if ( rotate != 0 )
				gContent.attr("transform", "translate(" + [ tooltipWidth + tooltipHeight/2 + 5, tooltipHeight + 5] + ") rotate(" + rotate + ")" );
		
			//create tooltip stroke
				tooltip_stroke( gTooltip, pathTooltip, this );		
		}
		
		return gTooltip;
		
		function tooltip_stroke( gTooltip, stroke, Tooltip ){
			var tooltipWidth  = Tooltip.getWidth()  - Tooltip.getBorderRadius();
			var tooltipHeight = Tooltip.getHeight() - Tooltip.getBorderRadius();
			
			visualizations.common.addShadow( gTooltip, "120%", 2, "#666" );
			
			stroke
				.attr("d", "M 0 0 H " + tooltipWidth + 
					" A " + Tooltip.getBorderRadius() + " " + Tooltip.getBorderRadius() + " 0 0 1 " + Tooltip.getWidth() + " " + Tooltip.getBorderRadius()/2 + " " +
					" V " + tooltipHeight + 
					" A " + Tooltip.getBorderRadius() + " " + Tooltip.getBorderRadius() + " 0 0 1 " + tooltipWidth + " " + ( Tooltip.getHeight() - Tooltip.getBorderRadius()/2) + " " +
					" H 0 A " + tooltipHeight/2 + " " + tooltipHeight/2 + " 1 0 0 0 0   ");
			
			stroke.classed("tooltip-stroke", true)
				.style("filter", "url(#drop-shadow)")
				.attr("fill",    Tooltip.getBkgroundColor() )
				.attr("stroke",  Tooltip.getStrokeColor() );
		}

		function tooltip_content( Tooltip ){
			var tooltipHeight = Tooltip.getHeight() - Tooltip.getBorderRadius();
			var distanceLeft  = tooltipHeight/2 + 5;	
					
			//title
			var title = gContent.append("g").classed("title content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0 +")");

			var authorName = shortcutName( toTitleCase(dataObject.name) );
			wrapText(title, authorName, ( Tooltip.getWidth() - distanceLeft), "title-name");	
			title.selectAll(".title-name");
			
			//status
			var status 	= gContent.append("g").classed("status content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			status.append("text").classed("icon-briefcase font-small", true)
				.style("font-family", "fontawesome")
				.text('\uf0b1');
			wrapText(status, dataObject.status || "none", ( Tooltip.getWidth() - distanceLeft), "status-name font-small");	
			status.selectAll(".status-name").attr("dx", "1.3em");
			
			//affiliation
			var affiliation = gContent.append("g").classed("affiliation content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			affiliation.append("text").classed("icon-institution font-small", true)
				.style("font-family", "fontawesome")
				.text('\uf19c');
			wrapText(affiliation, dataObject.affiliation || "none", ( Tooltip.getWidth() - distanceLeft), "afiliation-name font-small");	
			affiliation.selectAll(".afiliation-name").attr("dx", "1.3em");
			
			//nr publications & citations
			var nrPublications = dataObject.publicationsNumber || "0";
			var nrCitations	   = dataObject.citedBy || " 0 ";			
			var publicationsAndCitations = gContent.append("g").classed("pubs content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0+ ")");
			wrapText(publicationsAndCitations, "Publications: " + nrPublications + ", Cited By: " + nrCitations, ( Tooltip.getWidth() - distanceLeft), "paper font-small");
					
			//h-index
			var hindexString = dataObject.hindex || "none";
			var hindex = gContent.append("g").classed("hindex content-text", true)
				.attr("transform", "translate(" + distanceLeft + ", " + 0 + ")");;
			wrapText(hindex, "H-index: " + hindexString, ( Tooltip.getWidth() - distanceLeft), "hindex font-small");				
			
			positionContentElements( distanceLeft );
		}	
		
		function addImage( Tooltip ){
			//image
			var image = gContent.append("g").classed("image-icon", true)
					.attr("transform", "translate(" + [0, Tooltip.getImageRadius() + Tooltip.getBorderRadius() ] + ")");
			var circleBkGround = image.append("circle").classed("image", true)
					.attr("r",      Tooltip.getImageRadius() )
					.attr("stroke", Tooltip.getStrokeColor() )
					.attr("fill",   Tooltip.getBkgroundColor() );
			
			var imageBkground = visualizations.common.getImageBackground( "." + Tooltip.getClassName(), dataObject, Tooltip.getImageRadius() );
			if ( imageBkground != null ){
				var circle = image.append("circle").classed("image", true)
					.attr("r",      Tooltip.getImageRadius() )
					.attr("stroke", Tooltip.getStrokeColor() )
					.attr("fill",   Tooltip.getBkgroundColor() );
				circle.style("fill", "url(#pattern_" + dataObject.id + ")" );
			}else
				visualizations.common.addMissingPhotoIcon( image, Tooltip.getImageRadius() );
			
			
			
			
//			if (dataObject.photo != null){
//				visualization
//					var imagePattern = createImagePattern( Tooltip );
//					
//			} else {
//					image.append('text').classed("image missing-photo-icon", true)
//						.attr("dy", 			".35em")
//						.style('font-size', 	1.5 * Tooltip.getImageRadius() + 'px' )
//						.style("font-family", 	"fontawesome")
//						.style("text-anchor", 	"middle")
//						.text("\uf007"); 
//			}		
		}
		
		function positionContentElements( distanceLeft ){
			var bbox   = gContent.node().parentNode.getBBox();
			var x      = distanceLeft;
			var y 	   = (bbox.height - gContent.node().getBBox().height)/2;
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
		
		function createImagePattern( Tooltip ){
			return gTooltip.append("defs")
				.append("svg:pattern")
					.attr("id",    "pattern_" + dataObject.author.id)
					.attr("class", "author_avatar")
					.attr("width",  1)
					.attr("height", 1)
				   .append("svg:image")
				   	.attr("xlink:href", dataObject.photo )
				   	.attr("width",  Tooltip.getImageRadius() * 2)
				   	.attr("height", Tooltip.getImageRadius() * 2)
				   	.attr("x", 0)
				   	.attr("y", 0);
		}
		
		function toTitleCase(str) {
		    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
		}
		
		function shortcutName(str){
			var chunks = str.split(" ");
			var name = chunks[0];
			if ( chunks.length > 2){
				for (var i = 1; i < chunks.length - 1; i++){
					name += " " + chunks[i].charAt(0) + ".";
				}
			}
			return name + " " +chunks[ chunks.length - 1 ];
		}
		
		function translateTop( Tooltip ){
			var tooltipWidth  = Tooltip.getWidth()  - Tooltip.getBorderRadius();
			var tooltipHeight = Tooltip.getHeight() - Tooltip.getBorderRadius();
			var x 			  = gNode.node().getBBox().width > Tooltip.getWidth() ? -(gNode.node().getBBox().width - Tooltip.getWidth() )/ 2 : (gNode.node().getBBox().width - Tooltip.getWidth() )/ 2;
			var y 			  = - ( Tooltip.getHeight() + 10);	
			var nodeTranslate = d3.transform( gNode.attr("transform") ).translate;			
			var svgY 		  = d3.select( gNode.node().nearestViewportElement ).node().getBBox().y;
			
			if (nodeTranslate != undefined && nodeTranslate[0] != undefined){
				x += nodeTranslate[0];
				y += nodeTranslate[1];
			}
			if ( gNode.attr("x") != undefined ) x += gNode.attr("x");
			if ( gNode.attr("y") != undefined ) y += gNode.attr("y");
					
			if ( y < svgY ){
				Tooltip.setPosition( "bottom" ); 
				return translateBottom( Tooltip );
			}
			return [ x, y ];
		}
		
		function translateRight( Tooltip ){
			var $nodeParents  = $(gNode.node()).parents();
			var tooltipWidth  = Tooltip.getWidth()  - Tooltip.getBorderRadius();
			var tooltipHeight = Tooltip.getHeight() - Tooltip.getBorderRadius();
			var x 			  = 10;
			var y 			  = (Tooltip.getHeight() - Tooltip.getBorderRadius()/2 ) / -2;	
			var newXY 		  = addElementTranslation(x, y, gNode);	
			var i		 	  = 0;
			var svgWidth 	  = d3.select( gNode.node().nearestViewportElement ).node().getBBox().width;
			
			while ( i < $nodeParents.length && $nodeParents[i].tagName != "svg" ){
				newXY = addElementTranslation(newXY[0], newXY[1], d3.select($nodeParents[i]));
				i++;
			}
			return [ newXY[0], newXY[1] ];
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
		
		function translateBottom( Tooltip ){
			var tooltipWidth  = Tooltip.getWidth()  - Tooltip.getBorderRadius();
			var tooltipHeight = Tooltip.getHeight() - Tooltip.getBorderRadius();
			var x 			  = gNode.node().getBBox().width > Tooltip.getWidth() ? -(gNode.node().getBBox().width - Tooltip.getWidth() )/ 2 : (gNode.node().getBBox().width - Tooltip.getWidth() )/ 2;
			var y 			  = gNode.node().getBBox().height ;//+ 10;			
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
}