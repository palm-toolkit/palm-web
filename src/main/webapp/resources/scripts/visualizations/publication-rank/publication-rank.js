$.publRank = {};
$.publRank.variables =  {
		margin : {top: 40, right: 20, bottom: 20, left: 40},
		padding: 10
};

$.publRank.visualization = {
	data 	: function( data ){
				var vars 	= $.publRank.variables,		
					dataset = [],
					myPaper = vars.publication.basicinfo.publication; 
					myPaper.topics = vars.publication.topics.topics;
				data.publications.map(function( d ){
					d.cited = d.cited == null || d.cited == 0 ?  Math.floor((Math.random() * 500 ) + 0) : d.cited;
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
		vars.detailsContainer = $("#widget-" + widgetUniqueName + " .visualization-details");
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
			this.basicinfo();
//			this.list( dataset );
		}else{
			$.PALM.callout.generate( $mainContainer , "warning", "Empty Publications !", "Sorry, you don't have any publication." );
			return false;
		}
	},
	base	 : function( dataset ){
		var vars   = $.publRank.variables;
		var colors = [
		          "#bb857b", "#956347", "#6b2f24", "#4a1c13", "#401007", 
		          "#ec9acd", "#fb3fb3", "#c1348b", "#912B6A", "#7B3276", 
		          "#efea97", "#EEE314", "#E89013", "#F0920C", "#BF7A17", 
		          "#e6d1d9", "#e98195", "#cf0029", "#7b000b", "#49000e",
		          "#c4d3e0", "#5dd3e9", "#0194fe", "#012b7e", "#011149",
		          "#99d578", "#71cc49", "#043b05", "#043b05", "#031c06" ];
		
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
			.range([vars.height - vars.margin.bottom - vars.margin.top, 1]);

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
				.attr("class", function(d, i){ return i+1 == dataset.length ? "bar clicked" : "bar"; })
				.on("mouseenter", this.interactions.mouseoverBar)
				.on("mouseleave", this.interactions.mouseleaveBar)
				.on("click", this.interactions.clickedBar);
		
		var barWidth =  xScale.bandwidth() > 40 ? 40 : xScale.bandwidth();
		bars.append("rect")
			.attr("fill", "white")
			.attr("stroke", "black")
			.attr("stroke-opacity", "0.5")
			.attr("width", barWidth)
			.attr("height", function( d ){ d.height = yScale(d.cited); return d.height; });

		bars.append("text").attr("class", "bar-label")
			.style("font-size", "14px")
			.attr("fill", "black")
			.attr("opacity", "0.7")
			.attr("dy", "-.35em")
			.attr("dx", function () { return (barWidth - this.getComputedTextLength()) / 2; } ) 		
			.text(function( d ){ return d.cited; });
	
		bars.attr("transform",  function( d, i ) {
    		return "translate(" + [ 0, -yScale(d.cited) + vars.height - vars.margin.bottom] + ")";
    	});
		
		bars.transition().duration(function(d,i){ return 100 * i; }).ease(d3.easeCubic)
	    	.attr("transform", function( d, i ) {
	    		return "translate(" + [ xScale( i+1 ) + vars.margin.left, -yScale(d.cited) + vars.height - vars.margin.bottom] + ")";
	    	});

		var groups = bars.append("g")
			.attr("class","rgroups");
		
		// Add a rect for each topic value
		var rects = groups.selectAll("rect")
			.data( function(d) { 
				if ( d.topics.length != 0 ){
					d.topics.total = d3.sum(d.topics[0].termvalues, function(d){ return d.value;});
					return d.topics[0].termvalues.reverse().slice(0,5).reverse();
				}
				return []; 
			})
			.enter().append("rect")
				.attr("height", 0)
				.attr("width", barWidth)
				.style("fill-opacity", function(d, i){
					return d3.select(this.parentElement).datum().id == vars.publication.basicinfo.publication.id ? 1 : 0;						
				});
		
		var position = 0;		
		rects
			.attr("y", function(d,i) { 
				d.height = d3.select(this.parentElement).datum().height * d.value / d3.select(this.parentElement).datum().topics.total;
				position = i == 0 ? d.height : position + d.height;
				return d3.select(this.parentElement).datum().height - position;
			})
			.style("fill", function( d, i ){ 
				if ( colorScale.domain().indexOf(d.term) >= 0 )
					return colorScale( d.term );
				else 
					return d3.lab("#f1f1f1").darker(i);})
			.attr("height", function( d,i ){ return d.height; });
		
		var positionY1 = 0, positionY2 = 0;
		groups.selectAll("line")
			.data( function(d) { 
				if ( d.topics.length != 0 ){
					d.topics.total = d3.sum(d.topics[0].termvalues, function(d){ return d.value;});
					return d.topics[0].termvalues.slice(0,5).reverse();
				}
				return []; 
			})
			.enter().append("line")
				.attr("x1", 0)     
			    .attr("y1", function(d, i){ 
			    	var h  = d3.select(this.parentElement).datum().height * d.value / d3.select(this.parentElement).datum().topics.total;
			    	positionY1 = i == 0 ? h : positionY1 + h;
			    	return  d3.select(this.parentElement).datum().height - positionY1; })          
			    .attr("x2", barWidth)      
			    .attr("y2", function(d, i){ 
			    	var h = d3.select(this.parentElement).datum().height * d.value / d3.select(this.parentElement).datum().topics.total;
			    	positionY2 = i == 0 ? h : positionY2 + h;
		    		return  d3.select(this.parentElement).datum().height - positionY2; })          
				.attr("stroke", "black")
				.attr("stroke-opacity", function( d ){ return d3.select(this.parentElement).datum().id == vars.publication.basicinfo.publication.id ? 0.6 : 0; });

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
		  	.attr("y",vars.height + vars.margin.bottom)
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
			.attr("x2", vars.width + vars.margin.left - barWidth)
			.attr("y2",  vars.height - vars.margin.bottom - myPaperHeight )
			.attr("stroke","black")
			.style("stroke-dasharray", ("3, 3"));


	},
	elements : function(){},
	list : function( dataset ){
		var vars = $.publRank.variables;
		$("#widget-" + vars.widgetUniqueName + " .visualization-details .list-publications").empty();
		
		var svg =  d3.select("#widget-" + vars.widgetUniqueName + " .visualization-details .list-publications" ).append("svg")
			.attr("width",  vars.detailsContainer.width() - vars.margin.right);	
		
		var list = svg.append("g")
			.attr("class","list-publ")
			.attr("transform", "translate(" + [0, vars.margin.top ] + ")")
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
	  	
				posY	= i == 0 ? 10 : posY + (prev_nrKids * 16);
				g.append("text")
					.attr("y", posY)
					.attr("dx", ".7em")
					.style("text-anchor", "start")
					.text( i+1 + ".");

				var width = vars.detailsContainer.width() - vars.margin.right * 2;
				wrapText( g, d.title, width, "title-publ", 14)
	  	
				g.selectAll(".title-publ")
					.attr("dx", ".7em")
					.attr("x", 20)
					.attr("y",  posY)
			});
		
		svg.style("height", d3.select(".list-publ").node().getBBox().height + vars.margin.top );
	},
	bartopics : function( elem, d){
		var vars    = $.publRank.variables;
		var top     = -20;
		var topics  =  d.topics != null && d.topics.length > 0 ? d.topics[0].termvalues.slice(0,5) : [];
		var right   = false;
		var svg 	= d3.select("#widget-" + vars.widgetUniqueName + " svg");
		
		if (topics.length > 0 ){
			var list = svg.append("g").attr("class","list-topics");
			
			list.append("text").attr("class", "title")
				.style("text-anchor", "end")
				.text("Topics:");
			
			list.selectAll("g").data( topics )
				.enter()
				.append('g')
				.each(function(d,i){
					var g    = d3.select(this).attr("id", "list-item"),  	
					    posY = i*25 + 10;
					
					g.append("rect")
						.attr("y", posY)
						.attr("width", 10)
						.attr("height",10)
						.style("text-anchor", "end");
	
					g.append("text").attr("class", "text-term")
						.attr("y", posY + 10)	
						.style("font-weight", "normal")
						.text( function( dt ){ return dt.term; });
					
					g.append("text").attr("class", "text-value")
						.attr("y", posY + 10)
						.style("font-weight", "bold")
						.text( function( dt ){ return Math.round( dt.value * 100) / 100; });
				});
			
			list.selectAll("rect").attr("fill", function( dt, j ){ 
				if ( vars.colorScale.domain().indexOf( dt.term ) >= 0 )
					return vars.colorScale( dt.term );
				else 
					return d3.lab("#f1f1f1").darker((topics.length-1) - j); 
			});
			
			var barPosition = d3.transform( d3.select(elem).attr("transform") ).translate;
			var barSize		= d3.select(elem).node().getBBox();
			
			if ( barPosition[0] - list.node().getBBox().width < vars.margin.left )
				right = true;
			
			console.log( "Right: " + right);
			
			var y = vars.height - vars.margin.top - list.node().getBBox().height;
			
			if ( right ){
				var text1Prop = { "x" : 10,  "dx" : "0.35em", "anchor" : "start" }; 
				var text2Prop = { "x" : -10, "dx" : "0.35em", "anchor" : "end"  };
				var translate = [ barPosition[0] + list.node().getBBox().width / 2 , y];
			}else{
				var text1Prop = { "x" : 0,  "dx" : "-0.35em", "anchor" : "end" }; 
				var text2Prop = { "x" : 10, "dx" : "0.35em",  "anchor" : "start" };
				var translate = [ barPosition[0] - list.node().getBBox().width / 2  , y ];
			}
			
			list.selectAll(".text-term")
				.attr("x",  text1Prop.x)
				.attr("dx", text1Prop.dx)
				.style("text-anchor", text1Prop.anchor);
			
			list.selectAll(".text-value")
				.attr("x",  text2Prop.x)
				.attr("dx", text2Prop.dx)
				.style("text-anchor", text2Prop.anchor);
			
			var links = list.append("g")
		  		.attr("class", "links")
		  		.selectAll(".link")
		  		.data( topics )
		  		.enter().append("path")
	  				.attr("stroke", function(dt, i) { 
	  					if ( vars.colorScale.domain().indexOf( dt.term ) >= 0 )
						return vars.colorScale( dt.term );
					else 
						return d3.lab("#f1f1f1").darker((topics.length-1) - i); })
	  				.attr("stroke-width", 2 )
	  				.attr("opacity", 0.5)
	  				.attr("fill", "none")
	  				.attr("class", "link" )
//	  				.attr("transform", "translate(" + [translate[0], -y] + ")");
		
			list.attr("transform", "translate(" + translate + ")");
			
			links.attr("d", function( dl, i ){
				if (right){
					var rectBarPos = [parseInt (d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1) - i] ).attr("x") ) || 0, parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1)-  i] ).attr("y") )];
					
					xSource = barPosition[0] + rectBarPos[0] - translate[0];
					ySource = barPosition[1] + rectBarPos[1] + dl.height/2 - translate[1];
					
					var xTarget = 5;
					var yTarget = i*25 + 15;
					
				}else{
					var rectBarPos = [parseInt (d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1) - i] ).attr("x") ) || 0, parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1)-  i] ).attr("y") )];
					
					var xSource = 10;
					var ySource = i*25 + 15;
					
					var xTarget = barPosition[0] + rectBarPos[0] - translate[0];
					var yTarget = barPosition[1] + rectBarPos[1] + dl.height/2 - translate[1];
				}
				return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
			});
		}
		
//		if (topics.length > 0 ){
//			
//			var list = d3.select(elem).append("g")
//				.attr("class","list-topics");
//	
//			list.append("text")
//				.attr("class", "title")
//				.style("text-anchor", "end")
//				.text("Topics:");
//			
//			
//			list.selectAll("g").data( topics )
//				.enter()
//				.append('g')
//				.each(function(d,i){
//					var g    = d3.select(this).attr("id", "list-item"),  	
//					    posY = i*25 + 10;
//					
//					g.append("rect")
//						.attr("y", posY)
//						.attr("width", 10)
//						.attr("height",10)
//						.style("text-anchor", "end");
//	
//					g.append("text")
//						.attr("y", posY + 10)
//						.style("text-anchor", "end")
//						.style("font-weight", "normal")
//						.attr("dx", "-.35em")
//						.text( function( dt ){ return dt.term; });
//					
//					g.append("text")
//						.attr("y", posY + 10)
//						.style("text-anchor", "start")
//						.style("font-weight", "bold")
//						.attr("x", 10)
//						.attr("dx", ".35em")
//						.text( function( dt ){ return Math.round( dt.value * 100) / 100; });
//				});
//		
//			list.selectAll("rect").attr("fill", function( dt, j ){ 
//				if ( vars.colorScale.domain().indexOf( dt.term ) >= 0 )
//					return vars.colorScale( dt.term );
//				else 
//					return d3.lab("#f1f1f1").darker((topics.length-1) - j); });
//					
//			var links = list.append("g")
//		  		.attr("class", "links")
//		  		.selectAll(".link")
//		  		.data( topics )
//		  		.enter().append("path")
//	  				.attr("stroke", function(dt, i) { 
//	  					if ( vars.colorScale.domain().indexOf( dt.term ) >= 0 )
//						return vars.colorScale( dt.term );
//					else 
//						return d3.lab("#f1f1f1").darker((topics.length-1) - i); })
//	  				.attr("stroke-width", 2 )
//	  				.attr("opacity", 0.5)
//	  				.attr("fill", "none")
//	  				.attr("class", "link" )
//	  				.attr("transform", "translate(" + [vars.margin.left*2, -(-list.node().getBBox().height + d.height)] + ")");
//			
//			list.attr("transform", "translate(" + [-vars.margin.left*2, (-list.node().getBBox().height + d.height)] + ")");
//			links.attr("d", function( dl, i ){
//				var xSource = -vars.margin.left*2;
//				var ySource = i*25 + 10 + (-list.node().getBBox().height + d.height) + 5;
//				var xTarget = parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1) - i] ).attr("x") ) || 5;
//				var yTarget = parseInt ( d3.select( d3.select(elem).selectAll(".rgroups rect").nodes()[(topics.length-1)-  i] ).attr("y") ) + 5;
//				return "M" + xSource + "," + ySource + "C" + (xSource + xTarget)/2 + "," + ySource + " " + (xSource + xTarget)/2 + "," + yTarget + " " + xTarget + "," + yTarget;
//				});
//		}
	},
	basicinfo : function( publ ){
		var vars      = $.publRank.variables;
		var boxWidth  = vars.detailsContainer.width() - vars.margin.right,
			boxHeight = vars.height;
		
		$("#widget-" + vars.widgetUniqueName + " .visualization-details .basicinfo").empty();
		
		var svg =  d3.select( "#widget-" + vars.widgetUniqueName + " .visualization-details .basicinfo" ).append("svg")
			.attr("width",  boxWidth)	
			.attr("height", boxHeight );	
	
		var box = svg.append("g")
			.attr("class","box-basicinfo")
			.attr("transform", "translate(" + [0 , vars.margin.top ] + ")");

		box.append("text")
			.attr("class", "title")
			.attr("dy", "-.7em")
			.text("Paper Information:");
	
		//add basic info : title, authors, citations etc.	
		if ( publ  == null ){
			var publication = vars.publication.basicinfo.publication ;
			var topics      = vars.publication.topics.topics[0] == null ? [] : vars.publication.topics.topics[0].termvalues ;
			
		}else{
			var publication = publ;
			var topics      = publ.topics[0] == null ? [] : publ.topics[0].termvalues;
			
		}
		
		var data = [{ "label" : "Title", "text" : publication.title},
		            { "label" : "Author(s)", "text" : publication.authors.map( function( da ){ return da.name; }).join(", ")},
		            { "label" : publication.type, "text" : publication.event.name + " pp. " + publication.pages},
		            { "label" : "Published", "text" : publication.date},
		            { "label" : "Citations", "text" : publication.cited},
		            { "label" : "Topics", "text" : ""}];

		var positionY = 10;
		box.selectAll("g").data(data)
			.enter()
			.append('g').attr("class", function(d){ return "box-basicinfo-item " + d.label; })
			.each(function(d,i){
				var g 	 = d3.select(this);
				
				positionY  += i != 0 ? d3.select(this.previousSibling).node().getBBox().height + 5 : 0;
				
				g.attr("transform", "translate(" + [0, positionY] + ")")
				
				g.append("text")
					.style("font-weight" , "bold")
					.text( d.label );
				
				wrapText( g, d.text +"", boxWidth, "box-basicinfo-text", 14)
			  	g.selectAll(".box-basicinfo-text")
			  		.attr("y", 14)
			});
		
		//add topics
		var space   	 	= 0,
			maxWidthPerCol  = 0,
			topicsPerCol 	= 5,
			rectMaxSize  	= 50;
		
		var rectScale = d3.scaleLinear()
			.domain([0, 1])
			.range([5, rectMaxSize]);
		
		var topicsBox = box.select(".Topics").append("g")
			.attr("id", "list-publ-topics")
			.attr("transform", "translate(" + [vars.margin.left, 0] + ")");
		
		topicsBox.selectAll("g").data( topics )
		 	.enter()
		 	.append("g")
		 	.each( function(d, i){
		 		var g = d3.select(this)
		 			.attr("class", "list-item " + d.term),  	
		 		currentCol = Math.floor(i / topicsPerCol);
		 		pos        = (i - currentCol*topicsPerCol ) *25 +10;
			
		 		g.append("rect")
		 			.attr("x", space )
		 			.attr("y", pos)
		 			.attr("width", rectMaxSize)
		 			.attr("height",10)
		 			.attr("fill", "transparent")
		 			.attr("stroke", "black")
		 			.attr("stroke-opacity", 0.5)
		 			.style("text-anchor", "start");
		 		
		 		g.append("rect")
	 				.attr("x", space )
	 				.attr("y", pos)
	 				.attr("width", function( dt ){ return rectScale(dt.value); })
	 				.attr("height",10)
	 				.attr("fill", function( dt ){ return vars.colorScale( dt.term ); })
	 				.style("text-anchor", "start");

		 		g.append("text")
	 				.attr("x", function( dt ){ return  space ; })
	 				.attr("y", pos + 10)
	 				.style("text-anchor", "end")
	 				.attr("dx", "-.35em")
	 				.text( function( dt ){ return Math.round( dt.value * 100) / 100 ; });
		 		
		 		g.append("text")
		 			.attr("x", function( dt ){ return  space + rectMaxSize; })
		 			.attr("y", pos + 10)
		 			.style("text-anchor", "start")
		 			.attr("dx", ".35em")
		 			.text( function( dt ){ return dt.term; });
		 		
		 		maxWidthPerCol = maxWidthPerCol < this.getBBox().width ? this.getBBox().width : maxWidthPerCol;
		 		
		 		if ( i != 0 && (i + 1) % topicsPerCol == 0 ){
		 			space 		  += maxWidthPerCol + 5;
		 			maxWidthPerCol = 0;
		 		}
		 											  
		 		g.on("mouseenter", $.publRank.visualization.interactions.mouseoverTopic)
		 		 .on("mouseleave", $.publRank.visualization.interactions.mouseleaveTopic);
		 	} );	
		
		if (topics.length > 0){
			//scroll
			var scroll = box.select(".Topics").append("g").attr("class", "scroll")
				.attr("transform", "translate(" + [ vars.margin.left/2, topicsBox.node().getBBox().height + 14] +")");
			scroll.append("rect")
				.attr("width", boxWidth)
				.attr("height", 6)
				.attr("rx", 2)
				.attr("ry", 2)
				.attr("fill", "black")
				.attr("fill-opacity", 0.2);
		
			var scrollPercent = topicsBox.node().getBBox().width > boxWidth ? (boxWidth / topicsBox.node().getBBox().width)* 100 : 0;		
			scroll.append("rect")
				.attr("width", scrollPercent * boxWidth / 100 )
				.attr("height", 5.3)
				.attr("rx", 2).attr("ry", 2)
				.attr("fill", "black").attr("fill-opacity", 0.5)
			.call(d3.drag()
	 			.on("start", this.interactions.dragstartedTopicsList)
	 			.on("drag",  this.interactions.draggedTopicsList)
	 			.on("end",   this.interactions.dragendedTopicsList));
		}else{
			box.select(".Topics").append("text")
 				.attr("x", function( dt ){ return  space; })
 				.attr("y", 14)
 				.style("text-anchor", "start")
 				.attr("dx", ".35em")
 				.text( "No topic available" );
		}
	},
	interactions : {
		mouseoverBar : function(d){
			d3.selectAll(".bar").attr("opacity", 0.3);
			
			addTitle( this, d );
			
			d3.select(this).attr("opacity", 1);
			d3.select(this).select("rect").attr("stroke-width", "3px");
			d3.select(this).selectAll("text").style("font-weight", "bold");
			d3.select(this).selectAll("text").style("text-anchor", "middle");
			
			d3.select(this).selectAll(".rgroups rect ").style("fill-opacity", 1);
			$.publRank.visualization.bartopics( this, d);		
			
//			d3.select("#list-item-" + d.id).selectAll("text").style("font-weight", "bold");		
		},
		mouseleaveBar: function(d){
			d3.selectAll(".bar").attr("opacity", 1);
			
			d3.select(this).select("rect").attr("stroke-width", "1px");
			d3.select(this).select("text").style("font-weight", "normal");
			
			d3.select(this).selectAll(".rgroups rect ").style("fill-opacity", function( d ){ return d3.select(this.parentElement).datum().id == $.publRank.variables.publication.basicinfo.publication.id ? 1 : 0; });
						
			d3.select("#list-item-" + d.id).selectAll("text").style("font-weight", "normal");
			
			d3.select(".list-topics").remove();
			d3.select("#widget-"+ $.publRank.variables.widgetUniqueName + " svg").selectAll(".bar-title").remove();
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
		},
		mouseoverTopic : function(d){
			d3.selectAll(".bar").attr("opacity", 0.3);
			
			d3.select(this).attr("opacity", 1);
			d3.select(this).select("rect").attr("stroke-width", "3px");
			d3.select(this).selectAll("text").style("font-weight", "bold");
			
			d3.selectAll(".bar").nodes().map( function( db, i){
				var bar = d3.select(db);			
				var termFound = bar.datum().topics.length != 0 && bar.datum().topics[0].termvalues.map( function( dt ){ return dt.term; } ).indexOf( d.term ) >= 0;
				
				bar.attr("opacity", termFound ? 1 : 0.3);
				bar.select("rect").attr("stroke-width", termFound ? "3px" : "1px" );
				bar.select("text").style("font-weight", termFound ? "bold" : "normal" );
			});
		},
		mouseleaveTopic : function(d){
			d3.selectAll(".bar").attr("opacity", 1);
			d3.selectAll(".bar").select("rect").attr("stroke-width", "1px");
			d3.selectAll(".bar").select("text").style("font-weight", "normal");
			
			d3.select(this).select("rect").attr("stroke-width", "1px");
			d3.select(this).selectAll("text").style("font-weight", "normal");
			
			d3.select("#list-item-" + d.id).selectAll("text").style("font-weight", "normal");
			
			d3.select(".list-topics").remove();
		},
		clickedBar : function(d){
			d3.selectAll(".bar").classed("clicked", false);
			d3.select(this).classed("clicked", true);
			
			d.authors = d.authors == undefined ? d.coauthor : d.authors ;
			$.publRank.visualization.basicinfo( d );
		},
		dragstartedTopicsList : function(){
			d3.select(this).classed("dragged", true);
		},
		draggedTopicsList 	  : function(d){	
			var topics = d3.select("#widget-" + $.publRank.variables.widgetUniqueName + " #list-publ-topics");
			
			var widthBox	= $.publRank.variables.detailsContainer.width() - $.publRank.variables.margin.right;
			var widthScroll = this.getBBox().width;
			var widthTopics = topics.node().getBBox().width;
			
			var scrollX = widthBox > widthScroll ? widthBox - widthScroll : 0;
			d.x = d3.event.x <= scrollX && d3.event.x >= 0  ? d3.event.x : d3.event.x < 0  ? 0  : scrollX;
					 
			d3.select(this).attr("transform", "translate(" + [ d.x , 0] + ")");
			
			var topicsX = d.x > 0 ? -d.x * ( widthTopics - widthBox + $.publRank.variables.margin.left) / scrollX : $.publRank.variables.margin.left;
			topics.attr("transform", "translate("+[ topicsX , 0]+")");
			
		},
		dragendedTopicsList	  : function(){
			d3.select(this).classed("dragged", false);
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

function addTitle( elem, d ){
	var vars  	 = $.publRank.variables,
		x 	  	 = 0,
		y 		 = 0,
		widthBox = vars.width -vars.margin.right,
		barPos   = d3.transform( d3.select(elem).attr("transform") ).translate;
	
	var title = d3.select(elem.parentNode).append("g").attr("class", "bar-title");		
	var titleBackground = title.append("rect")
		.attr("rx", 5).attr("ry", 5)
		.attr("fill", "white");
		
	wrapText(title, d.title, 250, "bar-title-chunk", 14);
	
	x = barPos[0] - title.node().getBBox().width / 2;	
	if ( x < vars.margin.left )//too much left
		x = vars.margin.left;
	else
		if ( x + title.node().getBBox().width > widthBox) //too much right
			x = barPos[0] - title.node().getBBox().width  +d3.select(elem).node().getBBox().width;
	
	y = vars.height;
	
	d3.selectAll(".bar-title-chunk").style("font-weight", "bold");
	
	title.attr("transform", "translate(" + [x,y] + ")");  
	
	titleBackground.attr("height", title.node().getBBox().height + 20)
		.attr("width", title.node().getBBox().width + 10)
		.attr("transform", "translate(" + [-5, -18] + ")");  ;
	
}