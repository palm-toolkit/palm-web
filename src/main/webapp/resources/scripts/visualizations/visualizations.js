function Visualizations(){};

Visualizations.prototype.common = {
		getImageBackground : function( widgetUniqueName, element ){
			if ( isImageURLValid( element ) ){ // if url valid add image pattern
				var authorImagePattern = this.createImagePattern( widgetUniqueName, element);
				return  "url(#pattern_" + element.id + ")";
			} 
			return null;
			
			function isImageURLValid( element ){
				if ( element.photo == undefined )
					return false;
				
				return true;
			}
		},
		addMissingPhotoIcon : function( box, position, details ){
			var className = details.className || "missing-photo-icon";
			if ( position == "first" )
				var text = box.insert( 'text',  ":first-child" )	
			else
				var text = box.append( 'text' );
			
			text.classed( className, true)
				.attr("dy", details.dy)
				.attr("fill", details.color)
				.attr("text-anchor", details.textAnchor)
				.style('font-size', details.size + 'px' )
				.style("font-family", "fontawesome")
				.text( details.text ); 
		},
		addShadow : function( element, id, height, deviation, color ){
			var defs = element.append("defs");
			var filter = defs.append("filter")
			    .attr("id", id )
			    .attr("height", height );
			filter.append("feGaussianBlur")
			    .attr("in", "SourceAlpha")
			    .attr("stdDeviation", deviation)
			    .attr("result", "blur");

			filter.append("feOffset")
			    .attr("in", "blur")
			    .attr("dx", deviation)
			    .attr("dy", deviation)
			    .attr("result", "offsetBlur");
			
			filter.append("feFlood")
			  .attr("in", "offsetBlur")
			  .attr("flood-color",  color)
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
		},
		createImagePattern : function( boxId, dataObject){
			var svg  = d3.select( boxId );
			var defs = ( svg.select("defs").node() == undefined ) ? svg.append("defs") : svg.select("defs");
			
			return defs.append("svg:pattern")
					.attr("id", "pattern_" + dataObject.id)
					.attr("class", "author_avatar")
					.attr("patternContentUnits", "objectBoundingBox" )
					.attr("width",  "100%" )
				   	.attr("height", "100%" )
				   .append("svg:image")
				   	.attr("xlink:href", dataObject.photo )
				   	.attr("preserveAspectRatio", "none")
				   	.attr("width",  1)
				   	.attr("height", 1)
				   	.attr("x", 0)
				   	.attr("y", 0);
		},
		createArc : function (innerRadius, outerRadius, startAngle, endAngle){
				return d3.arc()
			    	.innerRadius(innerRadius)
			    	.outerRadius(outerRadius)
			    	.startAngle( startAngle )
			    	.endAngle( endAngle );
		},
		wrapText : function ( container, text, width, className, fontSize){
			var lineHeight = fontSize;
			var y = 0;
			var words = text.split(" ").reverse();
			var textArray = [];
			var text = container.append("text").attr("class", className);
			var wordsLength = words.length;
			
			while( wordsLength >= 0 ){
				wordsLength = words.length == 0 ? -1 : words.length;
				word = words.length > 0 ? words.pop() : "";
				textArray.push(word);
				text.text( textArray.join(" ") );
				
				if ( text.node().getBBox().width > width ){
					y += lineHeight; 
					var w = textArray.pop();
					
					text.text( textArray.join(" ") );
					
					if ( textArray.length == 0 ){
						var ind = this.splitWord( container, w, width );
						var first = ind == w.length? w.substr(0, ind ) : w.substr(0, ind) + "-";
						textArray.push( first);
						
						w = w.substr( ind, w.length );
					}else if ( text.node().getBBox().width > width ){
						var ex = textArray.join(" ");
						textArray = [];
						var ind = this.splitWord( container, ex, width );
						var first = ind == ex.length? ex.substr(0, ind ) : ex.substr(0, ind) + "-";
						
						textArray.push( first);
						
						w = ex.substr( ind, ex.length ) + " " + w ;
					}
					
					text.text( textArray.join(" ") );
					
					textArray = [w];
					text = container.append("text").attr("class", className)
							.attr("dy", y )
							.text( textArray.join(" ") );
				}				
			}
		},
		splitWord : function ( container, word, width ){
			var letters = word.split("").reverse();
			var wordArray = [];
			var text  = container.append("text");
			
			while(letter = letters.pop()){
				wordArray.push( letter );
				text.text( wordArray.join("") );
				
				if ( text.node().getBBox().width > width ){
					text.remove();
					return wordArray.length - 1;
				}		
			}
			
			return wordArray.length;
		}
}