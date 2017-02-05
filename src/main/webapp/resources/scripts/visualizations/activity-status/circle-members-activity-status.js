$.activityStatus = {};
$.activityStatus.variables = {

};
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
		setVariables(url, container, margin, width, height, color);
	
		$.activityStatus.visualise( visData );
		$.activityStatus.publications( );
	} );
}
$.activityStatus.publications = function (){
	var vars = 	$.activityStatus.variables;
	
	var url 		= vars.currentURL + "/circle/publicationList" + queryString;
	var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
	
	var queryString = "?id=" + "";
	$.get( url, function (response){
		$("#publications-box-" + vars.widgetUniqueName + " .box-header .author_name").html( "" );
		
		var mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
		$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged, vars.height - 10);
	
	})
}

function setVariables(url, widgetUniqueName, margin, width, height, color){
	$.activityStatus.variables.currentURL 		= url,
	$.activityStatus.variables.widgetUniqueName = widgetUniqueName;
	$.activityStatus.variables.margin 			= margin ;
	$.activityStatus.variables.width 			= width;
	$.activityStatus.variables.height 			= height;
	$.activityStatus.variables.color 			= color;
}	
$.activityStatus.visualise = function( data ){	
	var vars = 	$.activityStatus.variables;
	var lineMedian = d3.svg.line(),
		lineHoriz  = d3.svg.line(),
		lineVertic = d3.svg.line();

	// setup x 
	var xValue = function(d) { return d.publicationsNumber; }; // data -> value
	var xScale = d3.scaleLog().range([0, vars.width]);

	// setup y
	var yValue = function(d) { return d.citedBy ;}; // data -> value
	var yScale = d3.scaleLog().range([vars.height, 0]);

	// setup fill color
	var cValue = function(d) { return d.isAdded;};

	var normalize = function ( value, min, max){
		return ( value - min ) / ( max - min );
	}

	// add the graph canvas to the body of the webpage
	var svg = d3.select( "#boxbody" + vars.container + " .visualization-main").append("svg")
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
  		.attr("transform", function (d) {
  			return "translate(" + [ xScale(xValue(d)),  yScale(yValue(d))] + ")"});
  dotGroup.append("circle")
      .attr("class", "dot")
      .attr("r", 10)
      .attr("stroke", function(d) { return vars.color(cValue(d));})
      .attr("stroke-width", "2px")
      .style("fill", "white")//function(d) { return color(cValue(d));}) 
      .on("mouseover", function(d) {
          tooltip.transition()
               .duration(200)
               .style("opacity", .9);
          tooltip.html(d["Cereal Name"] + "<br/> (" + xValue(d) 
	        + ", " + yValue(d) + ")")
               .style("left", (d3.event.pageX + 5) + "px")
               .style("top", (d3.event.pageY - 28) + "px");
      })
      .on("mouseout", function(d) {
          tooltip.transition()
               .duration(500)
               .style("opacity", 0);
      });
  dotGroup.append("text")
  	.attr("dy", "-1em")
  	.style("text-anchor", "middle")
  	.text( function (d){ return d.name; });
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
      .text(function(d) { return d.name;})

}