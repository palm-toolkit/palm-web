$.activityStatus = {};
$.activityStatus.variables = {
};
$.activityStatus.getData = function( url, container, callback){
	console.log("getDAta");
	var vars 		= $.activityStatus.variables;
	var thisWidget  = $.PALM.boxWidget.getByUniqueName( container ); 
	if ( thisWidget != undefined)
		var queryString = thisWidget.options.queryString;
	
	if ( vars.year1 != undefined &&  vars.year2 != undefined &&  vars.year1.length != 0 &&  vars.year2.length != 0)
		queryString = thisWidget.options.queryString + "?yearMin=" + vars.year1 + "&yearMax=" + vars.year2;
	
	var urlData = thisWidget == undefined ? url + "/resources/json/circleMembers.json" : url + "/resources/json/circleMembers2.json";
	d3.json( urlData, function(error, data) {
		if ( error ) return;
		var visData = data.researchers.filter( function (d, i){
			if (d.citedBy != undefined && d.citedBy > 0 &&
				d.publicationsNumber != undefined && d.publicationsNumber > 0 	)
			return d;
		});
		
		callback( url, container, visData );
	});
}

$.activityStatus.init = function( url, container, data ){
	var margin = {top: 20, right: 20, bottom: 30, left: 40},
		width  =  $("#widget-" + container + " .visualization-main" ).width() - margin.left - margin.right,
		height = 500 - margin.top  - margin.bottom,
		color  = d3.scale.category10();
	
	setVariables( url, container, margin, width, height, color);
	
	$.activityStatus.visualise( data );
	$.activityStatus.publications();
}

$.activityStatus.visualise = function( data ){	
	var vars = 	$.activityStatus.variables;
	var lineMedian = d3.svg.line(),
		lineHoriz  = d3.svg.line(),
		lineVertic = d3.svg.line();

	// setup x 
	var xValue = function(d) { return d.publicationsNumber; }; // data -> value
	var xScale = d3.scaleLog().range([0, vars.width]).base(2);

	// setup y
	var yValue = function(d) { return d.citedBy ;}; // data -> value
	var yScale = d3.scaleLog().range([vars.height, 0]).base(2);;

	// setup fill color
	var cValue = function(d) { return d.isAdded;};

	var normalize = function ( value, min, max){
		return ( value - min ) / ( max - min );
	}

	d3.select( "#boxbody" + vars.widgetUniqueName + " .visualization-main").html("");
	
	// add the graph canvas to the body of the webpage
	var svg = d3.select( "#boxbody" + vars.widgetUniqueName + " .visualization-main").append("svg")
		.attr("width", vars.width + vars.margin.left + vars.margin.right)
    	.attr("height", vars.height + vars.margin.top + vars.margin.bottom)
      .append("g")
    	.attr("transform", "translate(" + vars.margin.left + "," + vars.margin.top + ")");

	// add the tooltip area to the webpage
	var tooltip = d3.select("body").append("div")
    	.attr("class", "tooltip")
    	.style("opacity", 0);

	// change string (from CSV) into number format
	data.forEach(function(d) {
		d.publicationsNumber = +d.publicationsNumber;
		d.citedBy = +d.citedBy;
	});

  // don't want dots overlapping axis, so add in buffer to data domain
  xScale.domain([d3.min(data, xValue)-1, d3.max(data, xValue)+1]).nice();
  yScale.domain([d3.min(data, yValue)-1, d3.max(data, yValue)+1]).nice();

  // x-axis
  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + vars.height + ")")
      .call(d3.axisBottom(xScale).tickSize(-vars.height).tickFormat(function (d) {
          return xScale.tickFormat(4,d3.format(",d"))(d)
      }))
    .append("text")
      .attr("class", "label")
      .attr("x", vars.width)
      .attr("y", -6)
      .attr("fill", "black")
      .style("text-anchor", "end")
      .text("Publications");

  // y-axis
  svg.append("g")
      .attr("class", "y axis")
      .call(d3.axisLeft(yScale).tickSize(-vars.width).tickFormat(function (d) {
          return yScale.tickFormat(4,d3.format(",d"))(d)
      }))
    .append("text")
      .attr("class", "label")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .attr("fill", "black")
      .style("text-anchor", "end")
      .text("Citations");

 // median line
  svg.append("g")
  	.attr("class", "median line");
  	
  // draw dots
  var dotsGroup = svg.append("g").attr("class", "dots");
  var dotGroup =  dotsGroup.selectAll(".dot").data(data)
  		.enter().append("g").attr("class", "dot")
  		.attr("transform", function (d) { return "translate(" + [ xScale(xValue(d)),  yScale(yValue(d))] + ")" })
  		.on("mouseover",  $.activityStatus.interactions.mouseoverNode )
  		.on("mouseout",   $.activityStatus.interactions.mouseleaveNode )
  		.on("click",      $.activityStatus.interactions.clickNode);
  dotGroup.append("circle")
      .attr("class", "dot")
      .attr("r", 7)
      .attr("stroke", function(d) { return vars.color(cValue(d));})
      .attr("stroke-width", "2px")
      .style("fill", "white")//function(d) { return color(cValue(d));}) 
      ;
  dotGroup.append("text").attr("class", "author-name-label")
  	.attr("dy", "-1em")
  	.style("text-anchor", "middle")
  	.text( function (d){ 
  		var lastName  = d.name.substring(d.name.lastIndexOf(" "), d.name.length);
		var firstName = d.name.substring(0, d.name.lastIndexOf(" "));
		var initials  = (firstName.match(/\b(\w)/g)).join(". ");
		
		return initials + "." + lastName;
  	});
  // draw legend
  var legend = svg.selectAll(".legend")
      .data(vars.color.domain())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

  // draw legend colored rectangles
  legend.append("rect")
      .attr("x", vars.width - 18)
      .attr("width", 18)
      .attr("height", 18)
      .style("fill", vars.color);

  // draw legend text
  legend.append("text")
      .attr("x", vars.width - 24)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .text(function(d) { return d.name;});
   
  arrangeLabels( svg );
}

$.activityStatus.publications = function (year1, year2){
	var vars 		= $.activityStatus.variables;
	var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
	var yearFilter  = false;
	
	if ( vars.year1 != undefined &&  vars.year2 != undefined &&  vars.year1.length != 0 &&  vars.year2.length != 0)
		yearFilter  = true;
	
	var queryString = !yearFilter ? thisWidget.options.queryString : thisWidget.options.queryString + "?yearMin=" + year1 + "&yearMax=" + year2;
		
	var url			=  vars.currentURL + "/resources/json/publicationsListCircle.json"
	d3.json( url, function(error, response) {
		$("#publications-box-" + vars.widgetUniqueName + " .box-header .author_name").html( "" );
		var $mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
		$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged, vars.height - 10);
		
		if( response.status == "ok"){
			response.element = response.circle;
			$.publicationList.visualize( $mainContainer, response );

			$.activityStatus.filter( response );
		}
	});
//	var url 		= vars.currentURL + "/circle/publicationList" + queryString;
//
//	$.get( url, function (response){
//		$("#publications-box-" + vars.widgetUniqueName + " .box-header .author_name").html( "" );
//		
//		var $mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
//		$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged, vars.height - 10);
//	
//	})
}

function setVariables( url, widgetUniqueName, margin, width, height, color){
	$.activityStatus.variables.currentURL 		= url,
	$.activityStatus.variables.widgetUniqueName = widgetUniqueName;
	$.activityStatus.variables.margin 			= margin ;
	$.activityStatus.variables.width 			= width;
	$.activityStatus.variables.height 			= height;
	$.activityStatus.variables.color 			= color;
}

$.activityStatus.filter = function( data ){
	//get time value for slider
	var dataTimeValue = function (d){ return d.published; };
	var min = parseInt( d3.min( data.years ) );
	var max = parseInt( d3.max( data.years ) );
	$.activityStatus.filter.time( data, min, max );
};

$.activityStatus.filter.time = function ( data, min, max ){
	var vars = $.activityStatus.variables;
	var line = d3.svg.line()
		 	.x(function(d,i) { return x(i); })
		 	.y(function(d) { return y(d); });
	
	var $sliderContainer = $("#widget-" + $.activityStatus.variables.widgetUniqueName + " #slider" );
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
		slide: function( event, ui ) {
			var delay = function() {
				var handleIndex = $(ui.handle).data('uiSliderHandleIndex');
				var label 		=  handleIndex == 0 ? '.min' : '.max';
				
				labelPosition.of = ui.handle;
				
				$(label)
					.html( ui.value )
					.position( labelPosition );
				
				vars.year1 = $sliderBody.slider('values', 0);
				vars.year2 = $sliderBody.slider('values', 1);

			}
			setTimeout(delay, 5);
		},
		stop: function( event, i){
			var updateVis = function(){
				var thisWidget     = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
				var $mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
				thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					
				$.activityStatus.getData(vars.currentURL, vars.widgetUniqueName, $.activityStatus.init);	
				thisWidget.element.find(".overlay").remove();
			};
			setTimeout( updateVis, 200);
		}
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

function arrangeLabels( svg ) {
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
	                if((Math.abs(a.left - b.left) * 2 < (a.width + b.width)) &&
	                   (Math.abs(a.top - b.top) * 2 < (a.height + b.height))) {
	                  // overlap, move labels
	                  var dx = (Math.max(0, a.right - b.left) +
	                           Math.min(0, a.left - b.right)) * 0.01,
	                      dy = (Math.max(0, a.bottom - b.top) +
	                           Math.min(0, a.top - b.bottom)) * 0.02,
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

$.activityStatus.readDataFromJSON = function ( url, container ){
	d3.json( url + "/resources/json/circleMembers.json", function(error, data) {
		if ( error ) return;
		
		var visData = data.researchers.filter( function (d, i){
			if (d.citedBy != undefined && d.citedBy > 0 &&
				d.publicationsNumber != undefined && d.publicationsNumber > 0 	)
			return d;
		});
		
		var margin = {top: 20, right: 20, bottom: 30, left: 40},
    		width  = 960 - margin.left - margin.right,
    		height = 500 - margin.top  - margin.bottom;
		var color = d3.scale.category10();
		setVariables( url, container, margin, width, height, color);
	
		$.activityStatus.visualise( visData );
		$.activityStatus.publications( );
	} );
}
$.activityStatus.interactions = {
		clickNode : function( node ){
			var vars 		= $.activityStatus.variables;
			var $this       = this;
			var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
			var keywordText = thisWidget.element.find("#publist-search").val() || "";
			var queryString = "?id=" + node.id + "&year=all&query=" + keywordText ;
			
			if ( vars.clickedNode != null){
				if ( vars.clickedNode.id === node.id)
					removeHighlightClickedNode( );
				else {
					highlightClickedNode( $this );
					getPublicationAuthor( node );
				}
			}
			else {
				highlightClickedNode( $this );
				getPublicationAuthor( node );
			}
			
		},
		mouseoverNode : function( node ){
			var vars  = $.activityStatus.variables;
			var $this = this;
			var dotsGraphSVG = d3.selectAll("#widget-" + vars.widgetUniqueName + " svg g.dot");
			
			dotsGraphSVG.attr("opacity", 0.4);
			
			vars.hoveredNode = node;			
			d3.select( $this ).classed("hovered", true)
				.attr("opacity", 1)
				.attr("transform", function ( d ){
					if ( !d3.select( this ).classed("clicked") )
						return d3.select( $this ).attr("transform") + " scale(1.3)";
					else
						return d3.select( $this ).attr("transform");
				});
			
		},
		mouseleaveNode : function( node ){
			var vars  = $.activityStatus.variables;
			var dotsGraphSVG = d3.selectAll("#widget-" + vars.widgetUniqueName + " svg g.dot");
			
			dotsGraphSVG.classed("hovered", false)
				.attr("opacity", 1)	
				.attr("transform", function( d ){
					var transform = d3.transform( d3.select( this ).attr("transform"));
					if (  d3.select( this ).classed("clicked") )
						return "translate(" + transform.translate + ") scale(" + transform.scale + ")";
					else
						return "translate(" + transform.translate + ")";
				});
			vars.hoveredNode = undefined;			
	
		}
}

function getPublicationAuthor( author ){
	var vars 		= $.activityStatus.variables;
	var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
	var keywordText = thisWidget.element.find("#publist-search").val() || "";
	var queryString = "?id=" + author.id + "&year=all&query=" + keywordText ;
	thisWidget.options.queryString = queryString;
	
	thisWidget.element.find(".visualization-main").removeClass("col-md-12").addClass("col-md-8");
	thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).find(".overlay").remove();
	thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
	thisWidget.element.find( ".visualization-details" ).removeClass("hidden");

	if ( vars.publicationRequest != null){
		vars.publicationRequest.abort();
	}
	vars.publicationRequest = $.get( vars.currentURL + "/researcher/publicationList" + queryString , function( response ){ 
		// this has to be data that is returned by server 
		response.queryKeywords = "";
		response.query = keywordText;
		
		//--------------------------------------
			
		$("#publications-box-" + vars.widgetUniqueName + " .box-header .author_name").html( response.author.name );
			
		var mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
		$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged, vars.height - 10);
		response.element = response.author;
		$.publicationList.visualize( mainContainer, response);
		
		thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).find(".overlay").remove();
			
		vars.publicationRequest = null;
	});
}


function highlightClickedNode( elem ){
	var vars = $.activityStatus.variables;
	d3.selectAll("g.dot").classed("clicked", false);
	d3.select(elem).classed("clicked", true);		
	vars.clickedNode = jQuery.extend(true, {}, vars.hoveredNode);
}

function removeHighlightClickedNode( ){
	var vars = $.activityStatus.variables;
	d3.selectAll("g.dot").classed("clicked", false);	
	vars.clickedNode = undefined;
	
	if ( vars.publicationRequest != null ){
		vars.publicationRequest.abort();
		vars.publicationRequest = null;
	}
}
