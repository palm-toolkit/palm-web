$.activityStatus = {
	variables : {
		userColor : "#0073b7"
	},
	visualise : function(){	
		var vars = 	$.activityStatus.variables;
		// setup x 
		var xValue = function(d) { return d.publicationsNumber; }; // data -> value
		var xScale = d3.scaleLinear().range([0, vars.width]);//.base(2);
	
		// setup y
		var yValue = function(d) { return d.citedBy ;}; // data -> value
		var yScale = d3.scaleLog().range([vars.height - vars.margin.top, 0]).base(2);;
	
		// setup fill color
		var cValue = function(d) { return d.isAdded;};
	
		var normalize = function ( value, min, max){
			return ( value - min ) / ( max - min );
		}
		
		//empty container
		vars.widget.select( ".visualization-main" ).html("");

		var translateTop = vars.margin.top * 2;
		
		// add the graph canvas to the body of the webpage
		var svg = vars.widget.select( ".visualization-main" ).append("svg")
			.attr("width", vars.width + vars.margin.left + vars.margin.right)
	    	.attr("height", vars.height + translateTop + vars.margin.bottom)
	      .append("g")
	    	.attr("transform", "translate(" + vars.margin.left + "," + translateTop + ")")
	    	.attr("class", "activity-status-chart");
	
		var user = null;
		// change string (from CSV) into number format
		$.PALM.visualizations.data.forEach(function(d) {
			d.publicationsNumber = +d.publicationsNumber;
			d.citedBy = +d.citedBy;
			
			if ( d.id == $.PALM.visualizations.user )
				user = d;
		});
		
		$.PALM.visualizations.user = user != null ? user : $.PALM.visualizations.user;
		
		var miny = d3.min($.PALM.visualizations.data, yValue) == 0 ? 1 : d3.min($.PALM.visualizations.data, yValue);
		var maxy = d3.max($.PALM.visualizations.data, yValue) == 0 ? 1 : d3.max($.PALM.visualizations.data, yValue);
		
		// don't want dots overlapping axis, so add in buffer to data domain
		xScale.domain([d3.min($.PALM.visualizations.data, xValue)-1, d3.max($.PALM.visualizations.data, xValue)+5]).nice();
		yScale.domain([ miny, maxy]);
	
		// x-axis
		svg.append("g")
	      	.attr("class", "x axis")
	      	.attr("transform", "translate(0," + vars.height + ")")
	      	.call( d3.axisBottom(xScale).tickSize(-vars.height) )
	      .append("text")
	      	.attr("class", "label")
	      	.attr("x", vars.width/2 )
	      	.attr("y", 25)
	      	.attr("fill", "black")
	      	.style("text-anchor", "end")
	      	.text("Publications");
	
		// y-axis
		svg.append("g")
			.attr("class", "y axis")
		    .call( d3.axisLeft(yScale).tickSize(-vars.width) )
		  .append("text")
		    .attr("class", "label")
		    .attr("transform", "rotate(-90)")
		    .attr("y", -30)
		    .attr("x", -vars.height/2 )
		    .attr("fill", "black")
		    .style("text-anchor", "start")
		    .text("Citations");
	
		//draw lines 
		var addLineAndLabel = function(group, x1, y1, x2, y2, id, color, label){
			var line = group.append("path").attr("class", "line")
				.attr("id", id)
				.style("stroke", color) 
				.style("stroke-dasharray", 3) 
				.attr("d", "M" + x1 + " " + y1 + "L" + x2 + " " + y2);
		  
			group.append("text").attr("class", "line-label")
		  	  .append("textPath")
		  		.attr("xlink:href", "#" + id)
		  		.attr("text-anchor", "start")
		  		.attr("startOffset", "93%")	
		  		.style("fill", color)
		  		.text( label );
		  
		  	return line;
		};
	  
		var lines = svg.append("g").attr("class", "lines");
	  
		addLineAndLabel(lines, 0, vars.height, vars.width, vars.height, "line-hAxis", "black" , "").style("stroke-dasharray", 0) ;
		addLineAndLabel(lines, 0, 0, 0, vars.height, "line-vAxis", "black" , "").style("stroke-dasharray", 0) ; 
		//addLineAndLabel(lines, 0, vars.height, vars.width, 0, "line-median", "grey" , "Median").style("stroke-dasharray", 0) ;
	   
		if ( !$.isEmptyObject( user ) ){
			addLineAndLabel(lines, xScale( xValue(user) ), 0, xScale( xValue(user) ), vars.height, "line-vertical", vars.userColor, "" );
			addLineAndLabel(lines, 0, yScale( yValue(user) ), vars.width, yScale( yValue(user) ), "line-horizontal", vars.userColor, "" );
		}
	  
		// draw dots
		var dotsGroup = svg.append("g").attr("class", "dots");
		var dotGroup =  dotsGroup.selectAll(".dot").data( $.PALM.visualizations.data )
		  .enter().append("g").attr("class", "dot")
		  	.on("mouseenter", function( d ){ $.activityStatus.interactions.mouseoverNode( this, d ); })
		  	.on("mouseleave",  $.activityStatus.interactions.mouseleaveNode )
		  	.on("click",      $.activityStatus.interactions.clickNode);
		dotGroup
	  		.transition()
	  		.duration(500)
	  		.delay(function(d, i) {return i / $.PALM.visualizations.data.length * 200; })
	  		.on("end", function(d, i){
	  			if ( i == $.PALM.visualizations.data.length - 1)
	  			  arrangeLabels( svg, dotGroup );
	  		})
	  		.attr("transform", function (d) { return "translate(" + [ xScale(xValue(d)),  yScale(yValue(d))] + ")" });
	  		
		var circle = dotGroup.append("circle")
	      	.attr("class", "dot")
	      	.attr("r", 7)
	      	.attr("stroke", function(d) { return vars.color(cValue(d));})
	      	.attr("stroke-width", "2px")
	      	.attr("fill", "white");
	
		dotGroup.append("text").attr("class", "author-name-label")
	  		.attr("dy", "-0.75em" )
	  		.text( function (d){ 
	  			var lastName  = d.name.substring(d.name.lastIndexOf(" "), d.name.length);
	  			var firstName = d.name.substring(0, d.name.lastIndexOf(" "));
	  			var initials  = (firstName.match(/\b(\w)/g)).join(". ");
			
	  			return initials + "." + lastName;
	  		})
	  		.style("text-anchor", function( d ){ 
		  		if ( xScale(xValue(d)) - this.getComputedTextLength()/2 < 0 )
		  			return "start";
		  		if ( xScale(xValue(d)) + this.getComputedTextLength()/2 > vars.width )
		  			return "end";
		  		return "middle"; });
	},
	publications : { 
		circle : function ( query ){
			var vars 		= $.activityStatus.variables;
			var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
			var yearFilter  = false;
			
			if ( vars.year1 != undefined &&  vars.year2 != undefined &&  vars.year1.length != 0 &&  vars.year2.length != 0)
				yearFilter  = true;
			
			queryString = !yearFilter ? "?id=" + $.PALM.selected.circle + "&maxresult=1000" : "?id=" + $.PALM.selected.circle + "&maxresult=1000" + "&yearMin=" + vars.year1 + "&yearMax=" + vars.year2;
			queryString += query != null ? "&query=" + query : "";
			
			var url 		= $.PALM.visualizations.url + "/circle/publicationList" + queryString;
			
			$.get( url, function (response){
				var $mainContainer = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-content");
				var $publicationsBox = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName); 
				
				$mainContainer.html("");
				if ( !$mainContainer.hasClass("small") ) 
					$mainContainer.addClass("small");
				
				$publicationsBox.find(".box-header .author_name").html( "" );
				
				$.publicationList.init( response.status, $.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.url, $.PALM.visualizations.user, vars.height - 10 );
				
				response.element = response.circle;
				
				$.publicationList.visualize( $mainContainer, response );
		
				$.activityStatus.filter.create( response );		
					
				var title = response.publications != null ? "(" + response.publications.length + ")" :  "(0)";
				thisWidget.element.find(".title-visualization-details").html( response.circle.name );
					
				thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();
		
				$publicationsBox.find( ".box-header .author_name" ).html( title );
				$publicationsBox.find( ".box-header .box-title-container").removeClass("box-title-container");	
				$publicationsBox.find( ".pull-left .btn-group").css("display", "none");
				$publicationsBox.find( ".timeline .time-label").css("display", "none");
					
				thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).find(".overlay").remove();
				
				thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).find( "#publist-search" ).keyup(function(e){
					if(e.keyCode == 13){
						thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
						var keywordText = thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).find( "#publist-search" ).val();
						$.activityStatus.publications.circle( keywordText );
					}
				});
				thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).find(" #publist-search-button").on( "click", function(){
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					var keywordText = thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName).find( "#publist-search" ).val();
					$.activityStatus.publications.circle( keywordText );
				} ); 
					
			})
		},
		member : function ( author, gNode ){
			var vars 		= $.activityStatus.variables;
			var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
			var keywordText = thisWidget.element.find("#publist-search").val() || "";
			var yearFilter  = false;
			
			if ( vars.year1 != undefined &&  vars.year2 != undefined &&  vars.year1.length != 0 &&  vars.year2.length != 0)
				yearFilter  = true;
			
			var queryString = !yearFilter ? "?id=" + $.PALM.selected.circle + "&author_id=" + author.id + "&year=all&query=" + keywordText + "&maxresult=1000" : "?id=" + $.PALM.selected.circle + "&author_id=" + author.id +  "&maxresult=1000" + "&yearMin=" + vars.year1 + "&yearMax=" + vars.year2;
			thisWidget.options.queryString = queryString;
			
			thisWidget.element.find(".visualization-main").removeClass("col-md-12 col-sm-12").addClass("col-md-8 col-sm-8");
			thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();
			thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
			thisWidget.element.find( ".visualization-details" ).removeClass("hidden");

			if ( vars.publicationRequest != null){
				vars.publicationRequest.abort();
			}
			
			vars.publicationRequest = $.get( $.PALM.visualizations.url + "/circle/memberPublicationList" + queryString , function( response ){ 
				// this has to be data that is returned by server 
				response.queryKeywords = "";
				
				//--------------------------------------	
				var mainContainer = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-content");
				$.publicationList.init( response.status, $.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.url, $.PALM.visualizations.user, vars.height - 200- 10);
				response.element = author;
				$.publicationList.visualize( mainContainer, response);
				
				var title = response.publications != null ? "(" + response.publications.length + ")" : "(0)";
				
				thisWidget.element.find(".title-visualization-details").html( author.name );
				
				thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).find(".overlay").remove();

				$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-header .author_name").html( title );
				$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-header .box-title-container").removeClass("box-title-container");	
				$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .pull-left").css("display", "none");
				$("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .timeline .time-label").css("display", "none");
			
				vars.publicationRequest = null;
				
				if ( response.citationRate != null && response.citationRate.length != 0 ){
					$("<div/>").addClass("citation-average-trend").insertBefore( " #widget-publications-" + $.PALM.visualizations.widgetUniqueName );
					$.activityStatus.addLineChart( d3.select( "#widget-" + $.PALM.visualizations.widgetUniqueName + " .citation-average-trend" ), response.citationRate);
				}
			});
		}
	},
	refresh : function( container, widgetUniqueName, user, data ){
		var vars = $.activityStatus.variables;
		var thisWidget = $.PALM.boxWidget.getByUniqueName( widgetUniqueName );
		
		var circles = d3.selectAll( thisWidget.element.find( "g.dot" ) );
		var axisX 	= d3.select( thisWidget.element.find( ".visualization-main .x.axis" ).selector );
		var axisY 	= d3.select( thisWidget.element.find( ".visualization-main .y.axis" ).selector );
		
		// setup x 
		var xValue = function(d) { return d.publicationsNumber; }; // data -> value
		var xScale = d3.scaleLinear().range([0, vars.width]);
	
		// setup y
		var yValue = function(d) { return d.citedBy ;}; // data -> value
		var yScale = d3.scaleLog().range([vars.height - vars.margin.top, 0]).base(2);;
	
		var miny = d3.min(data, yValue) == 0 ? 1 : d3.min(data, yValue);
		var maxy = d3.max(data, yValue) == 0 ? 1 : d3.max(data, yValue);
		
		xScale.domain([ d3.min(data, xValue), d3.max(data, xValue) ]).nice();
		yScale.domain([ miny, maxy ]).nice();
	
		circles.style("visibility", "hidden");
		
		var transition = d3.transition().duration(500).delay( i / data.length * 200 );
		
		for ( var i = 0; i < data.length; i++){
			var found = circles.filter( function( c ){ return c.id == data[i].id; });
			var x = xScale(xValue( data[i] )); var y = yScale(yValue( data[i] ));
			
			if ( found.nodes().length > 0){
				var circle = d3.select( found.nodes()[0] );	
			
				circle.datum().publicationsNumber = data[i].publicationsNumber;
				circle.datum().citedBy = data[i].citedBy;
				
				circle
					.style("visibility", "visible")
					.transition( transition )
					.duration(500)
					.delay( i / data.length * 150 )
					.on("end", i == ( data.length - 1 ) ? arrangeLabels( d3.select( "g.activity-status-chart"  ), circles ) : null )
					.attr("transform", "translate(" +  x + "," + y + ")" );	
			}
		}	
		axisX
			.transition()
			.duration(500)
			.call(d3.axisBottom(xScale).tickSize(-vars.height) );
		axisY
			.transition()
			.duration(500)
			.call(d3.axisLeft(yScale).tickSize(-vars.width) );
		  
		if ( !$.isEmptyObject( user ) ){
			vars.widget.select( "svg" ).select("#line-vertical").transition().duration(500)
				.attr("d", "M" + xScale( xValue(user) ) + " " + 0 + "L" + xScale( xValue(user) ) + " " + vars.height);
			vars.widget.select( "svg" ).select("#line-horizontal").transition().duration(500)
				.attr("d", "M" + 0 + " " + yScale( yValue(user) ) + "L" + vars.width + " " + yScale( yValue(user) ));
		}
	},
	getData : function( container, user, callback){
		var vars 		  = $.activityStatus.variables;
		var thisWidget    = $.PALM.boxWidget.getByUniqueName( container ); 
		var mainContainer = $("#widget-" + container + " .visualization-main");
		
		if ( thisWidget != undefined){
			var queryString = thisWidget.options.queryString;
		
			if ( vars.year1 != undefined &&  vars.year2 != undefined &&  vars.year1.length != 0 &&  vars.year2.length != 0)
				queryString = "?id=" + $.PALM.selected.circle + "&yearMin=" + vars.year1 + "&yearMax=" + vars.year2 + "&maxresult=1000";
		}
		var urlData = $.PALM.visualizations.url + "/circle/researcherList" + queryString;
		$.get( urlData, function( response ){
			if( typeof response === 'undefined' || response.status != "ok" || typeof response.researchers === 'undefined'){
				$.PALM.callout.generate( mainContainer , "warning", "Empty Members !", "The circle does not have any memeber on PALM database" );
				return false;
			}
					
			var visData = response.researchers.filter( function (d, i){
				if (d.citedBy != undefined && d.citedBy > 0 &&
					d.publicationsNumber != undefined && d.publicationsNumber > 0 	)
				return d;
			});
				
			callback( $.PALM.visualizations.url, container, user, visData );					
		});
		
		$.PALM.boxWidget.getByUniqueName( container ).element.find(".overlay").remove();	
	},
	addLineChart : function ( container, data ){
			var vars = $.activityStatus.variables;
			var height = 150, 
				width  = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .visualization-details").width() - vars.margin.left -10; 
			
			var showData = function (obj, d) {
				var coord = [ d3.select(obj).node().getBBox().x + vars.margin.left, d3.select(obj).node().getBBox().y ];
				var infobox = d3.select("#widget-" + $.PALM.visualizations.widgetUniqueName + " .infobox");
				var $infobox = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .infobox");
				 // now we just position the infobox roughly where our mouse is
				$infobox.empty();
				
				$infobox.append("<span> Average: " + Number( d.citationCount / d.paperCount).toFixed(2) + "</span>"); 
				$infobox.append("<span style='float: right;'>" + d.year + "</span>"); 
				$infobox.append("<div class='label'>#Publications per Year:<span class='label'>" + d.paperCount + "</span></div>");
				$infobox.append("<div class='label'>#Citations per Year:<span class='label'>" + d.citationCount + "</span></div>");
				
				$infobox.removeClass("hidden");
				
				var x0 = vars.margin.left; 
				var y0 = -vars.margin.top - 10;
				
				var x = x0 + coord[0] - $infobox.width()/2;
				var y = y0 - ( height - coord[1]) - $infobox.height() ;
				
				if ( x + $infobox.width() > width )
					x -= $infobox.width() /2;
				if ( y <  -height - vars.margin.top)
					y += $infobox.height() + 30;
				infobox.style("left", x + "px");
				infobox.style("top", y + "px");
				
			}
			
			var hideData = function(){
				$("#widget-" + $.PALM.visualizations.widgetUniqueName + " .infobox").addClass("hidden");
			}
			 
			var gSVG = container
			 	.insert("svg", ":first-child")
			 		.attr("width", width )
			 		.attr("height", height  )
			 		.style("width",  $("#widget-" + $.PALM.visualizations.widgetUniqueName + " .visualization-details").width() )
			 		.style("height", 150 + vars.margin.top * 2 + 10)
			 	.append("g").attr("class", "citationRate");	  
			  
			 gSVG.append("text")
			 	.attr("class", "label")
			  	.attr("dx", "-.75em")
			  	.attr("dy", "-0.65em")
			  	.style('font-size', 14 + 'px' )
			  	.text( "Citations' Average Trend" );
			 gSVG.append("text")
			 	.attr("dx", "-.75em")
			  	.attr("dy", "-0.65em")
				.style('font-size', 14 + 'px' )
				.style("font-family", "fontawesome")
				.style("text-anchor", "end")
				.text( "\uf05a" )
				.on("mouseover", $.activityStatus.interactions.mouseOverInfo )
				.on("mouseleave", $.activityStatus.interactions.mouseLeaveInfo );

			 gSVG.attr("transform", function (d) { return "translate(" + [vars.margin.left - 5, vars.margin.top] + ")" } );	  

			data = data.sort(function(a, b) {
				 var year1 = parseInt( a.year );
				 var year2 = parseInt( b.year );
				 return year1 - year2;
			});
				 
			// get max and min dates - this assumes data is sorted
			 var minDate = new Date( data[0].year + "" ),
				 maxDate = new Date( data[data.length - 1].year + "");
				 
			var x = d3.scaleTime().range([0, width]).domain( [minDate, maxDate] ).nice();
			var y = d3.scaleLinear().range([height, 0]).domain([0, d3.max(data, function(d) { return d.citationCount / d.paperCount ; } )]).nice();
			
			var xTicks = data.length > 5 ? 5 : data.length < 2 ?  4 : data.length;
			var yTicks = data.length > 5 ? 5 : data.length;
			// x-axis
			gSVG.append("g")
			      .attr("class", "x axis")
			      .attr("transform", "translate(0," + height + ")")
			       .call(d3.axisBottom(x).ticks(xTicks).tickFormat(d3.timeFormat("%Y")).tickSize(-height) )
			    .append("text")
			      .attr("class", "label")
			      .attr("x", width / 2)
			      .attr("y", 25)
			      .attr("dx", "-.3em")
			      .attr("fill", "black")
			      .style("text-anchor", "start" )
			      .style("font-size", "12px" )
			      .text("Year");

			  // y-axis
			gSVG.append("g")
			      .attr("class", "y axis")
			      .call(d3.axisLeft(y).ticks(yTicks).tickSize(-width) )
			    .append("text")
			      .attr("class", "label")
			      .attr("transform", "rotate(-90)")
			      .attr("y", -25)
			      .attr("dx", "-1.7em")
			      .attr("fill", "black")
			      .style("font-size", "12px" )
			      .style("text-anchor", "end" )
			      .text("Citations' Average");

			  
				// create a line function that can convert data[] into x and y points
			var line = d3.svg.line()
				 .x(function(d, i) { return x( new Date( d.year + "" ) ); })
				 .y(function(d) { return y( d.citationCount/ d.paperCount ); });
				
			//dots
			gSVG
				 .selectAll("circle")
				 .data(data)
				 .enter().append("circle")
				 .attr("fill", "steelblue")
				 .attr("r", 3)
				 .attr("stroke", "transparent")
				 .attr("stroke-width", 6)
				 .on("mouseover", function(d) { showData(this, d);})
				 .on("mouseout", function(){ hideData();})
				 .attr("cx", function(d) { return x(new Date( d.year + "" ) ); })
				 .attr("cy", function(d) { return y( d.citationCount/ d.paperCount ); });
				 
			var path = gSVG.append("svg:path")
				.attr("d", line(data)) 
				.attr("fill", "none")
				.attr("stroke", "steelblue")
				.attr("stroke-width", "2px");
			
			var totalLength = path.node().getTotalLength();
			path.attr("stroke-dasharray", totalLength + " " + totalLength)
		     	.attr("stroke-dashoffset", totalLength)
		     .transition()
		       	.duration(1500)
		       	.attr("stroke-dashoffset", 0);

			$(gSVG.node().closest("div")).prepend("<div class='infobox details hidden'/>");
	},
	filter : {
		create: function( data ){
			//get time value for slider
			var dataTimeValue = function (d){ return d.published; };
			var min = parseInt( d3.min( data.years ) );
			var max = parseInt( d3.max( data.years ) );
			$.activityStatus.filter.time( data, min, max );
		},
		time : function ( data, min, max ){
			var vars = $.activityStatus.variables;
			var line = d3.svg.line()
				 	.x(function(d,i) { return x(i); })
				 	.y(function(d) { return y(d); });
			
			var $sliderContainer = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " #slider" );
			var $sliderBody 	 = $sliderContainer.children(".body");
			var labelPosition 	 = {
					my: "center top",
					at: "center bottom",
					offset: "0, 10"
			};
			
			if ( vars.initialMinYear == undefined && vars.initialMaxYear == undefined ){
				vars.initialMinYear = min;
				vars.initialMaxYear = max;
			}

			if ( vars.year1 == undefined && vars.year2 == undefined ){
				vars.year1 = min;
				vars.year2 = max;
			}

			$sliderBody.slider({
				range: true,
				height: "0.5em",
				min: vars.initialMinYear,
				max: vars.initialMaxYear,
				values: [vars.year1, vars.year2] ,
				stop: function( event, i){
					var updateVis = function(){
						var thisWidget     = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
						var $mainContainer = $("#publications-box-" + $.PALM.visualizations.widgetUniqueName + " .box-content");
						thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
						thisWidget.element.find( ".visualization-details >.citation-average-trend" ).remove();
						
						if ( vars.clickedNode != null ){
							$.activityStatus.publications.member( vars.clickedNode, {} );
							return;
						} 

						$.activityStatus.getData( $.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.user, $.activityStatus.refresh);	
						$.activityStatus.publications.circle();
						thisWidget.element.find(".overlay").remove();
					};
					setTimeout( updateVis, 200);
				}
			});
			
			$sliderBody.on( "slide", function( event, ui ) {
				var slider = this;
				var delay = function() {
					var handleIndex = $(ui.handle).data('uiSliderHandleIndex');
					var label 		=  handleIndex == 0 ? '.min' : '.max';
					
					labelPosition.of = ui.handle;
					
					vars.tooClose = ui.values[1] - ui.values[0] < 4 ? true : false;			
					
					$(label)
						.html( ui.value )
						.position( labelPosition );
					
					
					if ( vars.tooClose ) {
						if ( $(".top").length == 0 )
							$(label).addClass("top");
					}
					else
						$(label).removeClass("top");
						
					vars.year1 = $sliderBody.slider('values', 0);
					vars.year2 = $sliderBody.slider('values', 1);
				
			    }
				setTimeout(delay, 0);
			});
			
			labelPosition.of = $( $sliderBody.children("span").eq(0) );
			$sliderContainer.children(".min")
				.html( $sliderBody.slider('values', 0) )
				.position( labelPosition );

			labelPosition.of = $( $sliderBody.children("span").eq(1) );
			$sliderContainer.children(".max")
				.html( $sliderBody.slider('values', 1) )
				.position( labelPosition );
		}	
	},
	interactions : {
		clickNode : function( node ){
			var vars 		= $.activityStatus.variables;
			var $this       = this;
			var thisWidget  = $.PALM.boxWidget.getByUniqueName( $.PALM.visualizations.widgetUniqueName ); 
			var keywordText = thisWidget.element.find("#publist-search").val() || "";
				
			var $sliderContainer = $("#widget-" + $.PALM.visualizations.widgetUniqueName + " #slider" );
			var $sliderBody 	 = $sliderContainer.children(".body");
				
			thisWidget.element.find( ".visualization-details >.citation-average-trend" ).remove();
				
			if ( vars.clickedNode != null){
				if ( vars.clickedNode.id === node.id){
					$.activityStatus.interactions.removeHighlightClickedNode( );
					thisWidget.element.find( "#publications-box-" + $.PALM.visualizations.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					$.activityStatus.getData($.PALM.visualizations.widgetUniqueName, $.PALM.visualizations.user, $.activityStatus.refresh );
					$.activityStatus.publications.circle();
					
					return;
				}
				else {
					$.activityStatus.interactions.highlightClickedNode( $this );
					$.activityStatus.publications.member( node, $this );
				}
			}
			else {
				$.activityStatus.interactions.highlightClickedNode( $this );
				$.activityStatus.publications.member( node, $this );
			}
		},
		mouseoverNode : function( elem, node ){
			d3.selection.prototype.moveToFront = function() {  
				return this.each(function(){
					this.parentNode.appendChild(this);
				});
			};
			var vars  = $.activityStatus.variables;
			var $this = elem;
			var dotsGraphSVG = d3.selectAll("#widget-" + $.PALM.visualizations.widgetUniqueName + " svg g.dot");
				
			//bring to front
			d3.select( $this ).moveToFront();
			
			//highlight/hide
			dotsGraphSVG.attr("opacity", 0.4);	
			vars.hoveredNode = node;			
			d3.select( $this ).classed("hovered", true)
				.attr("opacity", 1)
				.attr("transform", function ( d ){
					return d3.select( $this ).attr("transform") + " scale(4)";
				});
				
			//add icon 			
			$.PALM.utility.visualizations.addMissingPhotoIcon( d3.select( elem ), "first", {className: "missing-photo-icon author_avatar", size: 7, color: vars.userColor, dy : ".35em", textAnchor : "middle", text: "\uf007" } );
			
			var image = $.PALM.utility.visualizations.getImageBackground( "#widget-" + $.PALM.visualizations.widgetUniqueName + " svg", node );
			
			d3.select(elem).select("circle").attr("fill", image != null ? image : "white" );

			if ( image == null )
				$.PALM.utility.visualizations.addMissingPhotoIcon( d3.select( elem ), "last", {className: "missing-photo-icon author_avatar", size: 7, color: vars.userColor, dy : ".35em", textAnchor : "middle", text: "\uf007" } );
			
			//add tooltip
			var tooltip = new Tooltip({
					className 	  : vars.tooltipClassName || "",
					width 		  : 210,
					height		  : 80,
					bkgroundColor : "rgba(255, 255, 255, 0.8)",
					strokeColor   : "steelblue",
					position  	  : "right", 
					withImage	  : false
			});
				
			tooltip.buildTooltip( d3.select($this), node );
		},
		mouseleaveNode : function( node ){
			var vars  = $.activityStatus.variables;
			var dotsGraphSVG = vars.widget.select( "svg" ).selectAll( "g.dot" );
				
			dotsGraphSVG.classed("hovered", false)
				.attr("opacity", 1)	
				.attr("transform", function( d ){
					var transform = d3.transform( d3.select( this ).attr("transform"));
						return "translate(" + transform.translate + ")";
				});
			
			vars.hoveredNode = undefined;
			//remove icon
			vars.widget.select( "svg" ).selectAll( ".author_avatar").remove();
			//remove tooltip
			vars.widget.select( "svg" ).selectAll( "." + vars.tooltipClassName ).remove();
		},
		mouseOverInfo : function( node ){
			var $this = this;
			var width = d3.select( $this.parentNode ).node().getBBox().width / 2 + 40;
			var infoText = d3.select($this.parentNode).append("g").attr("class", "infoText");
			var rect = infoText.append("rect");
			var text = "Citations Average per Year = sum of the papers' citations published in a year devided by the number of publications in that year."
			var padding = 10;
			
			$.PALM.utility.visualizations.wrapText(infoText, text, width, "info-text", 12 );
							
			$.PALM.utility.visualizations.addShadow( infoText, "drop-shadow", "120%", 3, "#666", 1 );
				
			rect.attr("width", infoText.node().getBBox().width + padding)
				.attr("height", infoText.node().getBBox().height + padding)
				.attr("x", -padding/3 + "px")
				.attr("y", "-1em")
				.attr("fill", "white")
				.attr("opacity", 0.8)
				.style("filter", "url(#drop-shadow)");
				
			infoText.attr("transform", "translate(" +[ $this.getBBox().width/2 - padding*3 , padding/2 ]+ ")")
		},
		mouseLeaveInfo : function( node ){
			var $this = this;
			d3.select($this.parentNode).select(".infoText").remove();
		},
		highlightClickedNode : function ( elem ){
			var vars = $.activityStatus.variables;
			d3.selectAll("g.dot").classed("clicked", false);
			d3.select(elem).classed("clicked", true);		
			vars.clickedNode = jQuery.extend(true, {}, vars.hoveredNode);
		},
		removeHighlightClickedNode : function ( ){
			var vars = $.activityStatus.variables;
			d3.selectAll("g.dot").classed("clicked", false);	
			vars.clickedNode = undefined;
			
			if ( vars.publicationRequest != null ){
				vars.publicationRequest.abort();
				vars.publicationRequest = null;
			}
		}
	}
}

function arrangeLabels( svg, circles ) {	
	circles.selectAll(".author-name-label")
		.style("text-anchor", function( d ){ 
			var translateX = d3.transform( d3.select(this.parentNode).attr("transform") ).translate[0];
			
	  		if ( translateX - this.getComputedTextLength()/2 < 0 )
	  			return "start";
	  		if ( translateX + this.getComputedTextLength()/2 > $.activityStatus.variables.width )
	  			return "end";
	  		return "middle"; 
	  	})
	  	.attr("transform", null);
	
	
	  var move = 1;
	  while(move > 0) {
	    move = 0;
	    svg.selectAll(".author-name-label")
	       .each(function() {
	         var that = this,
	             a = this.getBoundingClientRect();
	         svg.selectAll(".author-name-label")
	            .each(function() {
	              if(this != that) {
	                var b = this.getBoundingClientRect();
	                             
	                if((Math.abs(a.left - b.left)  < Math.max(a.width, b.width)) &&
	 	                   (Math.abs(a.top - b.top) < Math.min(a.height, b.height))) {
	                  // overlap, move labels
	                  var dx = (Math.max(0, a.right - b.left) +
	                           Math.min(0, a.left - b.right)) * 0.02,
	                      dy = (Math.max(0, a.bottom - b.top) +
	                           Math.min(0, a.top - b.bottom)) * 0.03,
	                      tt = d3.transform(d3.select(this).attr("transform")),
	                      to = d3.transform(d3.select(that).attr("transform"));
	                  move += Math.abs(dx) + Math.abs(dy);
	                
	                  to.translate = [ to.translate[0] + dx, to.translate[1] + dy ];
	                  tt.translate = [ tt.translate[0] - dx, tt.translate[1] - dy ];
	                  d3.select(this).attr("transform", "translate(" + tt.translate + ")");
	                  d3.select(that).attr("transform", "translate(" + to.translate + ")");
	                  a = this.getBoundingClientRect();
	                }
	              }
	            });
	       });
	  }
}





