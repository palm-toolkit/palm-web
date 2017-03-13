$.publRank = {};
$.publRank.variables =  {
		margin : {top: 20, right: 20, bottom: 40, left: 40},
		padding: 10
};
$.publRank.data =  function( data ){
	var dataset = data.publications.map(function( d ){
		d.cited = d.cited == null || d.cited == 0 ?  Math.floor((Math.random() * 1000 ) + 1): d.cited;
	});
};
$.publRank.visualization = {
	data 	: function( data ){
				var dataset = [];  
				data.publications.map(function( d ){
					d.cited = d.cited == null || d.cited == 0 ?  Math.floor((Math.random() * 1000 ) + 1): d.cited;
					dataset.push(d);					
				});	
				return dataset;
	},
	setVars : function( url, user, widgetUniqueName, height ){
		var vars = $.publRank.variables;
		
		vars.url 			  = url;
		vars.user 			  = user;
		vars.widgetUniqueName = widgetUniqueName;
		vars.height 	      = height;
		vars.mainContainer    = $("#widget-" + widgetUniqueName + " .visualization-main");
		vars.thisWidget 	  = $.PALM.boxWidget.getByUniqueName( widgetUniqueName );	
		vars.width  	  	  = vars.mainContainer.width() - vars.margin.left - vars.margin.right;
	},
	draw : function(url, user, widgetUniqueName, data, height){
		if( data.status === "ok" && typeof data.publications !== 'undefined'){
	
			this.setVars(url, user, widgetUniqueName, height);
			
			var vars = $.publRank.variables;
			vars.thisWidget.element.find(".overlay").remove();			
			vars.mainContainer.html( "" );
		
			this.base( this.data( data ) );

		}else{
			$.PALM.callout.generate( $mainContainer , "warning", "Empty Publications !", "Sorry, you don't have any publication." );
			return false;
		}
	},
	base	 : function( dataset ){
		var vars 	= $.publRank.variables;
		var colors  = d3.scale.category10();

		var svg  	= d3.select("#widget-" + vars.widgetUniqueName + " .visualization-main" ).append("svg")
			.attr("width",  vars.width)
			.attr("height", vars.height);
		
		
		//Set up scales
		var nrPubl = dataset.length;
		var citation = function(d){ return d.cited; };
		var title = function(d){ return d.title; };
		var xScale = d3.scaleBand().rangeRound([0, vars.width]).padding(0.1)
			.domain(dataset.map( title ));

		var yScale = d3.scaleLinear()
			.domain([d3.min(dataset, citation), d3.max(dataset, citation)])
			.range([vars.height - vars.margin.bottom - vars.margin.top, 0]);

		var fillingScale = d3.scaleLinear()
			.domain([0,	1])
		.range([vars.height-vars.margin.bottom-vars.margin.top,0]);

		var color_hash = {
			    0 : ["Invite","#1f77b4"],
				1 : ["Accept","#2ca02c"],
				2 : ["Decline","#ff7f0e"]

		};
		var groups = svg.selectAll("g")
			.data(dataset)
			.enter()
			.append("g")
			.attr("class","rgroups")
			.attr("transform","translate("+ vars.margin.left + "," + - vars.margin.bottom +")")
			.style("fill", function(d, i) {
				return color_hash[0];
			});
		
		// Add a rect for each data value
		var rects = groups.selectAll("rect")
			.data(function(d) { return d.coauthor; })
			.enter()
			.append("rect")
			.attr("width", 2)
			.style("fill-opacity",1e-6);


		rects.transition()
		     .duration(function(d,i){
		    	 return 500 * i;
		     })
		     .ease(d3.easeElastic)
		    .attr("x", function( d, i ) {
				return xScale( d3.select(this.parentElement).datum().title );
			})
			.attr("y", function(d,i) {
				return vars.height - fillingScale(i/d3.select(this.parentElement).datum().coauthor.length);
			})
			.attr("height", function(d,i) {
				return -fillingScale(i/d3.select(this.parentElement).datum().coauthor.length) + (vars.height - vars.margin.top - vars.margin.bottom);
			})
			.attr("width", xScale.bandwidth())
			.style("fill-opacity",1)
			.style("fill", function( d, i ){ return colors(i); });

			svg.append("g")
				.attr("class","x axis")
				.attr("transform","translate(40," + (vars.height - vars.margin.bottom) + ")")
				.call(d3.axisBottom( xScale ));


			svg.append("g")
				.attr("class","y axis")
				.attr("transform","translate(" + vars.margin.left + "," + vars.margin.top + ")")
				.call( d3.axisLeft( yScale ) );
			
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


	},
	elements : function(){
		var stack = d3.layout.stack();

		d3.data("mperday.data",function(data){
			dataset = data;

			//Data, stacked
			stack(dataset);

			var color_hash = {
				    0 : ["Invite","#1f77b4"],
					1 : ["Accept","#2ca02c"],
					2 : ["Decline","#ff7f0e"]

			};


			//Set up scales
			var xScale = d3.time.scale()
				.domain([new Date(dataset[0][0].time),d3.time.day.offset(new Date(dataset[0][dataset[0].length-1].time),8)])
				.rangeRound([0, w-padding.left-padding.right]);

			var yScale = d3.scale.linear()
				.domain([0,				
					d3.max(dataset, function(d) {
						return d3.max(d, function(d) {
							return d.y0 + d.y;
						});
					})
				])
				.range([h-padding.bottom-padding.top,0]);

			var xAxis = d3.svg.axis()
						   .scale(xScale)
						   .orient("bottom")
						   .ticks(d3.time.days,1);

			var yAxis = d3.svg.axis()
						   .scale(yScale)
						   .orient("left")
						   .ticks(10);



			//Easy colors accessible via a 10-step ordinal scale
			var colors = d3.scale.category10();

			//Create SVG element
			var svg = d3.select("#mbars")
						.append("svg")
						.attr("width", w)
						.attr("height", h);

			// Add a group for each row of data
			var groups = svg.selectAll("g")
				.data(dataset)
				.enter()
				.append("g")
				.attr("class","rgroups")
				.attr("transform","translate("+ padding.left + "," + (h - padding.bottom) +")")
				.style("fill", function(d, i) {
					return color_hash[dataset.indexOf(d)][1];
				});

			// Add a rect for each data value
			var rects = groups.selectAll("rect")
				.data(function(d) { return d; })
				.enter()
				.append("rect")
				.attr("width", 2)
				.style("fill-opacity",1e-6);


			rects.transition()
			     .duration(function(d,i){
			    	 return 500 * i;
			     })
			     .ease("linear")
			    .attr("x", function(d) {
					return xScale(new Date(d.time));
				})
				.attr("y", function(d) {
					return -(- yScale(d.y0) - yScale(d.y) + (h - padding.top - padding.bottom)*2);
				})
				.attr("height", function(d) {
					return -yScale(d.y) + (h - padding.top - padding.bottom);
				})
				.attr("width", 15)
				.style("fill-opacity",1);

				svg.append("g")
					.attr("class","x axis")
					.attr("transform","translate(40," + (h - padding.bottom) + ")")
					.call(xAxis);


				svg.append("g")
					.attr("class","y axis")
					.attr("transform","translate(" + padding.left + "," + padding.top + ")")
					.call(yAxis);

				// adding legend

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


		});

	}
};
