function Visualizations(){};

Visualizations.prototype.common = {
		getImageBackground : function( widgetUniqueName, element, radius ){
			if ( isImageURLValid( element ) ){ // if url valid add image pattern
				var authorImagePattern = this.createImagePattern( widgetUniqueName, element, radius);
				return  "url(#pattern_" + element.id + ")";
			} 
			return null;
			
			function isImageURLValid( element ){
				if ( element.photo == undefined )
					return false;
				
				return true;
			}
		},
		addMissingPhotoIcon : function( box, radius ){
			box.append('text').classed("missing-photo-icon", true)
				.style('font-size', 1.5 * radius + 'px' )
				.text( "\uf007" ); 
		},
		addShadow : function( element, height, deviation, color ){
			var defs = element.append("defs");
			var filter = defs.append("filter")
			    .attr("id", "drop-shadow")
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
		createImagePattern : function( boxId, dataObject, radius ){
			var svg  = d3.select( boxId );
			var defs = ( svg.select("defs").node() == undefined ) ? svg.append("defs") : svg.select("defs");
			
			return defs.append("svg:pattern")
					.attr("id", "pattern_" + dataObject.id)
					.attr("class", "author_avatar")
					.attr("width", 1)
					.attr("height", 1)
				   .append("svg:image")
				   	.attr("xlink:href", dataObject.photo )
				   	.attr("width",  radius * 2)
				   	.attr("height", radius * 2)
				   	.attr("x", 0)
				   	.attr("y", 0);
		}
}