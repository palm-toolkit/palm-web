$.publRank = {};
$.publRank.variables =  {
		margin : {top: 40, right: 20, bottom: 40, left: 40},
		padding: 10
};
$.publRank.data =  function( data ){
	var dataset = data.publications.map(function( d ){
		d.cited = d.cited == null || d.cited == 0 ?  Math.floor((Math.random() * 1000 ) + 1): d.cited;
	});
};
$.publRank.visualization = {
	data 	: function( data ){
				var vars 	= $.publRank.variables,		
					dataset = [],
					myPaper = vars.publication.basicinfo.publication; 
					myPaper.topics = vars.publication.topics.topics;
				data.publications.map(function( d ){
					d.cited = d.cited == null || d.cited == 0 ? Math.floor((Math.random() * 1000 ) + 0) : d.cited;
					if ( d.id !== myPaper.id)
						dataset.push(d);	
				});	
				return dataset.sort( function(a, b){ return b.cited - a.cited}).concat( myPaper );
	},
	setVars : function( url, user, widgetUniqueName, height, publication ){
		var vars = $.publRank.variables;
		
		vars.url 			  = url;
		vars.user 			  = user;
		vars.widgetUniqueName = widgetUniqueName;
		vars.height 	      = height;
		vars.publication	  = publication;
		vars.mainContainer    = $("#widget-" + widgetUniqueName + " .visualization-main");
		vars.detailsContainer    = $("#widget-" + widgetUniqueName + " .visualization-details");
		vars.thisWidget 	  = $.PALM.boxWidget.getByUniqueName( widgetUniqueName );	
		vars.width  	  	  = vars.mainContainer.width() - vars.margin.left - vars.margin.right;
		vars.width			  = vars.width > 800 ? 800 : vars.width; 
	},
	draw : function(url, user, widgetUniqueName, data, publication, height){
		if( data.status === "ok" && typeof data.publications !== 'undefined'){
	
			this.setVars(url, user, widgetUniqueName, height, publication);
			
			var vars = $.publRank.variables;
			vars.thisWidget.element.find(".overlay").remove();			
			vars.mainContainer.html( "" );
		
			var dataset = this.data( data ) 
			this.base( dataset );
			this.list( dataset );

		}else{
			$.PALM.callout.generate( $mainContainer , "warning", "Empty Publications !", "Sorry, you don't have any publication." );
			return false;
		}
	},
	base	 : function( dataset ){
		var vars   = $.publRank.variables;
		var colors = [
		          "#ffce44", "#3c4158", "#686a70", "#72675c", "#d6d0c9", 
		          "#c6684c", "#cc9b1c", "#10816a", "#7f93ac", "#8bdeb9", 
		          "#f28571", "#c25277", "#135589", "#e9c77b", "#c4d4e0", 
		          "#FF7E5F", "#765285", "#351C4D", "#709FB0", "#726A95",
		          "#351F39", "#613A43", "#849974", "#36384C", "#726968",
		          "#6CBF84", "#EFAA52", "#AB3E16", "#b32868", "#D1A827" ];
		
		var svg   = d3.select("#widget-" + vars.widgetUniqueName + " .visualization-main" ).append("svg")
			.attr("width",  vars.width)
			.attr("height", vars.height);	
		
		//Set up scales
		var citation = function(d){ return d.cited; };
		var index    = function(d, i){ return i+1; };
		
		var xScale = d3.scaleBand()
			.rangeRound([0, vars.width]).padding(0.1)
			.domain(dataset.map( index ));

		var yScale = d3.scaleLinear()
			.domain([d3.max(dataset, citation), d3.min(dataset, citation)])
			.range([vars.height - vars.margin.bottom - vars.margin.top, 100]);

		var yAxisScale = d3.scaleLinear()
			.domain([d3.min(dataset, citation), d3.max(dataset, citation)])
			.range([vars.height - vars.margin.bottom - vars.margin.top, 0]);

		var terms = vars.publication.topics.topics[0].termvalues.map(function( d){ return d.term; });
		var colorScale = d3.scaleOrdinal()
			.domain( terms )
			.range( colors );

		vars.colorScale = colorScale;
		
		var bars = svg.selectAll("g")
			.data(dataset)
			.enter().append("g")
				.attr("class", "bar")
				.on("mouseenter", this.interactions.mouseoverBar)
				.on("mouseleave", this.interactions.mouseleaveBar);
		
		bars.append("rect")
			.attr("fill", "white")
			.attr("stroke", "black")
			.attr("stroke-opacity", "0.5")
			.attr("width", xScale.bandwidth())
			.attr("height", function( d ){ d.height = yScale(d.cited); return d.height; });

		bars.append("text").attr("class", "bar-label")
			.style("font-size", "14px")
			.attr("fill", "black")
			.attr("opacity", "0.7")
			.text(function( d ){ return d.cited; })
			.attr("dy", "-.35em")
			.attr("dx", function () { return (xScale.bandwidth() - this.getComputedTextLength()) / 2; } ) ;
		
		bars.transition().duration(function(d,i){ return 100 * i; }).ease(d3.easeCubic)
	    	.attr("transform", function( d, i ) {
	    		return "translate(" + [ xScale( i+1 ) + vars.margin.left, -yScale(d.cited) + vars.height - vars.margin.bottom] + ")";
	    	});

		var groups = bars.append("g")
			.attr("class","rgroups");
		
		// Add a rect for each data value
		var rects = groups.selectAll("rect")
			.data( function(d) { 
				if ( d.topics.length != 0 ){
					d.topics.total = d3.sum(d.topics[0].termvalues, function(d){ return d.value;});
					return d.topics[0].termvalues.reverse().slice(0,10);
				}
				return []; 
			})
			.enter().append("rect")
				.attr("height", 0)
				.attr("width", xScale.bandwidth())
				.style("fill-opacity",1e-6);
		
		var position = 0;
		
		rects.transition().duration(function(d,i){ return 100 * i; }).ease(d3.easeCubic)
			.attr("height", function(d,i) {
				var height = d3.select(this.parentElement).datum().height * d.value / d3.select(this.parentElement).datum().topics.total;
				return height;
			})
			.attr("y", function(d,i) { 
				var currPosition = position;
				var val =  d3.select(this.parentElement).datum().height * d.value / d3.select(this.parentElement).datum().topics.total;
				
				position = i == 0 ? val : position + val;
				return i == 0 ? 0 : currPosition;})
			.style("fill-opacity",1)
			.style("fill", function( d, i ){ return colorScale( d.term ) != undefined ? colorScale( d.term ) : "white"; });

		// x y axis
		svg.append("g")
			.attr("class","x axis")
			.attr("transform","translate(" + vars.margin.left + "," + (vars.height - vars.margin.bottom) + ")")
			.call(d3.axisBottom( xScale ));

		svg.append("g")
			.attr("class","y axis")
			.attr("transform","translate(" + vars.margin.left + "," + vars.margin.top + ")")
			.call( d3.axisLeft( yAxisScale ) );
		
		//labels
		svg.append("text")
			.attr("transform","rotate(-90)")
			.attr("y", 0 - 3.5)
			.attr("x", 0-(vars.height/2))
			.attr("dy","1em")
			.text("Number of Citations");

		svg.append("text")
			.attr("class","xtext")
		  	.attr("x",vars.width/2 - vars.margin.left)
		  	.attr("y",vars.height - 5)
		  	.attr("text-anchor","middle")
		  	.text("Publications");

		svg.append("text")
			.attr("class","title")
        	.attr("x", (vars.width / 2))             
        	.attr("y", 20)
        	.attr("text-anchor", "middle")  
        	.style("font-size", "16px") 
        	.style("text-decoration", "underline")  
        	.text("Top Publications in " + dataset[0].type + " " + dataset[0].event.name);

		//citation axis
		var myPaperHeight = dataset[ dataset.length-1 ].height;
		svg.append("line")
			.attr("class","citation axis")
			.attr("x1", vars.margin.left )
			.attr("y1", vars.height - vars.margin.bottom - myPaperHeight )
			.attr("x2", vars.width + vars.margin.left - xScale.bandwidth())
			.attr("y2",  vars.height - vars.margin.bottom - myPaperHeight )
			.attr("stroke","black")
			.style("stroke-dasharray", ("3, 3"));


	},
	elements : function(){
				var legend = svg.append("g")
								.attr("class","legend")
								.attr("x", w - padding.right - 65)
								.attr("y", 25)
								.attr("height", 100)
								.attr("width",100);

				legend.selectAll("g").data(dataset)
					  .enter()
					  .append('g')
					  .each(function(d,i){
					  	var g = d3.select(this);
					  	g.append("rect")
					  		.attr("x", w - padding.right - 65)
					  		.attr("y", i*25 + 10)
					  		.attr("width", 10)
					  		.attr("height",10)
					  		.style("fill",color_hash[String(i)][1]);

					  	g.append("text")
					  	 .attr("x", w - padding.right - 50)
					  	 .attr("y", i*25 + 20)
					  	 .attr("height",30)
					  	 .attr("width",100)
					  	 .style("fill",color_hash[String(i)][1])
					  	 .text(color_hash[String(i)][0]);
					  });

				svg.append("text")
				.attr("transform","rotate(-90)")
				.attr("y", 0 - 5)
				.attr("x", 0-(h/2))
				.attr("dy","1em")
				.text("Number of Messages");

			svg.append("text")
			   .attr("class","xtext")
			   .attr("x",w/2 - padding.left)
			   .attr("y",h - 5)
			   .attr("text-anchor","middle")
			   .text("Days");

			svg.append("text")
	        .attr("class","title")
	        .attr("x", (w / 2))             
	        .attr("y", 20)
	        .attr("text-anchor", "middle")  
	        .style("font-size", "16px") 
	        .style("text-decoration", "underline")  
	        .text("Number of messages per day.");

			//On click, update with new data			
			d3.selectAll(".m")
				.on("click", function() {
					var date = this.getAttribute("value");

					var str;
					if(date == "2014-02-19"){
						str = "19.data";
					}else if(date == "2014-02-20"){
						str = "20.data";
					}else if(date == "2014-02-21"){
						str = "21.data";
					}else if(date == "2014-02-22"){
						str = "22.data";
					}else{
						str = "23.data";
					}

					d3.data(str,function(data){

						dataset = data;
						stack(dataset);

						console.log(dataset);

						xScale.domain([new Date(0, 0, 0,dataset[0][0].time,0, 0, 0),new Date(0, 0, 0,dataset[0][dataset[0].length-1].time,0, 0, 0)])
						.rangeRound([0, w-padding.left-padding.right]);

						yScale.domain([0,				
										d3.max(dataset, function(d) {
											return d3.max(d, function(d) {
												return d.y0 + d.y;
											});
										})
									])
									.range([h-padding.bottom-padding.top,0]);

						xAxis.scale(xScale)
						     .ticks(d3.time.hour,2)
						     .tickFormat(d3.time.format("%H"));

						yAxis.scale(yScale)
						     .orient("left")
						     .ticks(10);

						 groups = svg.selectAll(".rgroups")
		                    .data(dataset);

		                    groups.enter().append("g")
		                    .attr("class","rgroups")
		                    .attr("transform","translate("+ padding.left + "," + (h - padding.bottom) +")")
		                    .style("fill",function(d,i){
		                        return color(i);
		                    });


		                    rect = groups.selectAll("rect")
		                    .data(function(d){return d;});

		                    rect.enter()
		                      .append("rect")
		                      .attr("x",w)
		                      .attr("width",1)
		                      .style("fill-opacity",1e-6);

		                rect.transition()
		                    .duration(1000)
		                    .ease("linear")
		                    .attr("x",function(d){
		                        return xScale(new Date(0, 0, 0,d.time,0, 0, 0));
		                    })
		                    .attr("y",function(d){
		                        return -(- yScale(d.y0) - yScale(d.y) + (h - padding.top - padding.bottom)*2);
		                    })
		                    .attr("height",function(d){
		                        return -yScale(d.y) + (h - padding.top - padding.bottom);
		                    })
		                    .attr("width",15)
		                    .style("fill-opacity",1);

		                rect.exit()
					       .transition()
					       .duration(1000)
					       .ease("circle")
					       .attr("x",w)
					       .remove();

		                groups.exit()
					       .transition()
					       .duration(1000)
					       .ease("circle")
					       .attr("x",w)
					       .remove();


						svg.select(".x.axis")
						   .transition()
						   .duration(1000)
						   .ease("circle")
						   .call(xAxis);

						svg.select(".y.axis")
						   .transition()
						   .duration(1000)
						   .ease("circle")
						   .call(yAxis);

						svg.select(".xtext")
						   .text("Hours");

						svg.select(".title")
				        .text("Number of messages per hour on " + date + ".");
					});			
				});
	},
	list : function( dataset ){
		var vars = $.publRank.variables;
		var svg =  d3.select("#widget-" + vars.widgetUniqueName + " .visualization-details .list-publications" ).append("svg")
			.attr("width",  vars.detailsContainer.width() - vars.margin.left - vars.margin.right)
			.attr("height", vars.height);	
		var list = svg.append("g")
			.attr("class","list-publ")
			.attr("transform", "translate(" + [vars.margin.left, vars.margin.top * 1.5] + ")")
			.attr("height", 100)
			.attr("width",100);
	
		list.append("text")
			.attr("class", "title")
			.attr("dy", "-.7em")
			.text("Publications:");
		
		var posY = 0;
		list.selectAll("g").data(dataset)
			.enter()
			.append('g')
			.on("mouseover", this.interactions.mouseoverList)
			.on("mouseleave", this.interactions.mouseleaveList)
			.each(function(d,i){
				var g = d3.select(this).attr("id", "list-item-" +d.id);
				var prev = d3.select(this.previousElementSibling),
				prev_nrKids = i != 0 ? prev.selectAll(".title-publ").nodes().length : 1;
	  	
				posY	= i == 0 ? 20 : posY + (prev_nrKids * 16);
				g.append("text")
					.attr("y", posY)
					.attr("width", 10)
					.attr("height",10)
					.style("text-anchor", "end")
					.text( i+1 + ".");

				var width = vars.detailsContainer.width() - vars.margin.left - 10;
				wrapText( g, d.title, width, "title-publ", 14)
	  	
				g.selectAll(".title-publ")
					.attr("x", 5)
					.attr("y",  posY)
			});
	},
	topics : function( elem, d){
		var vars    = $.publRank.variables;
		
		var list = d3.select(elem).append("g")
			.attr("class","list-topics")
			.attr("transform", "translate(" + [-vars.margin.left*2, -120] + ")");

		list.append("text")
			.attr("class", "title")
			.style("text-anchor", "end")
			.text("Topics:");
		
		var topics =  vars.publication.topics.topics[0].termvalues.reverse().slice(0,10);

		list.selectAll("g").data( topics )
			.enter()
			.append('g')
			.each(function(d,i){
				var g = d3.select(this).attr("id", "list-item");
				var prev = d3.select(this.previousElementSibling),
				prev_nrKids = i != 0 ? prev.selectAll(".name-topic").nodes().length : 1;
	  	
				var posY = i*25 + 10;
				g.append("rect")
					.attr("y", posY)
					.attr("width", 10)
					.attr("height",10)
					.attr("fill", function( dt ){ return vars.colorScale( dt.term ); })
					.style("text-anchor", "end");

				g.append("text")
					.attr("y", posY + 10)
					.style("text-anchor", "end")
					.style("font-weight", "bold")
					.attr("dx", "-.35em")
					.text( function( dt ){ return dt.term; });
				
				g.append("text")
					.attr("y", posY + 10)
					.style("text-anchor", "start")
					.style("font-weight", "bold")
					.attr("x", 10)
					.attr("dx", ".35em")
					.text( function( dt ){ return dt.value; });
			});
	
		var links = list.append("g")
	  		.attr("class", "links")
	  		.selectAll(".link")
	  		.data( topics )
	  		.enter().append("path")
  				.attr("stroke", function(dt) { return vars.colorScale( dt.term ); })
  				.attr("stroke-width", 2 )
  				.attr("opacity", 0.5)
  				.attr("fill", "none")
  				.attr("class", "link" )
  				.attr("transform", "translate(" + [vars.margin.left*2, 120] + ")")
  				.attr("d", function( dl, i ){
					var xSource = -vars.margin.left*2;
					var ySource = i*25 + 10 - (120) + 5;
					var xTarget = parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[i] ).attr("x") ) || 5;
					var yTarget = parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[i] ).attr("y") ) + 5;
					return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
  				});
		},
	interactions : {
		mouseoverBar : function(d){
			d3.selectAll(".bar").attr("opacity", 0.3);
			
			d3.select(this).attr("opacity", 1);
			d3.select(this).select("rect").attr("stroke-width", "3px");
			d3.select(this).select("text").style("font-weight", "bold");

			if ( d.id == $.publRank.variables.publication.basicinfo.publication.id ){
				$.publRank.visualization.topics( this, d);
			}
			
			d3.select("#list-item-" + d.id).selectAll("text").style("font-weight", "bold");
		},
		mouseleaveBar: function(d){
			d3.selectAll(".bar").attr("opacity", 1);
			
			d3.select(this).select("rect").attr("stroke-width", "1px");
			d3.select(this).select("text").style("font-weight", "normal");
			
			d3.select("#list-item-" + d.id).selectAll("text").style("font-weight", "normal");
			
			d3.select(".list-topics").remove();
		},
		mouseoverList: function(d){
			d3.select(this).selectAll("text").style("font-weight", "bold");
			
			d3.selectAll(".bar").each(function( e ){
				var g = d3.select(this);
				if ( d.id == e.id ){
					g.selectAll("text").style("font-weight", "bold");
					g.select("rect").attr("stroke-width", "3px");
				}else
					g.attr("opacity", 0.3);
			})
		},
		mouseleaveList: function(d){
			d3.select(this).selectAll("text").style("font-weight", "normal");
			
			d3.selectAll(".bar").each(function( e ){
				var g = d3.select(this);
				g.selectAll("text").style("font-weight", "normal");
				g.select("rect").attr("stroke-width", "1px");	
				
				g.attr("opacity", 1);
			})
		}
	}
};

function wrapText( container, text, width, className, fontSize){
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
			
			if ( textArray.length == 0 ){
				var ind = splitWord( container, w, width );
				var first = ind == w.length? w.substr(0, ind ) : w.substr(0, ind) + "-";
				textArray.push( first);
				
				w = w.substr( ind, w.length );
			}
			
			text.text( textArray.join(" ") );
			
			textArray = [w];
			text = container.append("text").attr("class", className)
					.attr("dy", y )
					.text( textArray.join(" ") );
		}				
	}
}
