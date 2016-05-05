<div id="boxbody${wUniqueName}" class="box-body" style="height:320px;overflow:hidden">
	researcher interest evolution
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
//		$("#boxbody${wUniqueName}").slimscroll({
//			height: "300px",
//	        size: "3px"
//	    });

				<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/topicModel' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
			
			
				<#-- check for interest cloud widget -->
				var topicModelCloudWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_topicmodel_cloud' ); 
				if( typeof topicModelCloudWidget !== "undefined" && !topicModelCloudWidget.executed){
					$.PALM.boxWidget.refresh( topicModelCloudWidget.element , topicModelCloudWidget.options );
				}
				

var targetContainer = $( widgetElem ).find( "#boxbody${wUniqueName}" );

<#-- clean target container -->
targetContainer.html( "" );
<#-- the pointer of selected data -->
var dataPointer = {
	"dataProfileIndex" : 0,
	"dataLanguageIndex" : 0,
	"dataYearStart" : 0,
    "dataYearEnd" : 0
};
<#-- create dropdown algorithm profile -->
var algorithmProfileDropDown = 
	$( '<select/>' )
	.attr({ "id": "algorithm_profile"})
	.on( "change", function(){ getLanguagesFromProfile( $( this ).val() ) } );

<#-- loop interst algorithm --> 								
$.each( data.topicModel, function(index, dataAlgorithmProfile){
	algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : index , "title" : dataAlgorithmProfile.description })
								.html( (dataAlgorithmProfile.profile).replace( /\?/g,"∩") )
							);
});

<#-- interest algorithm profile container -->
var algorithmProfileContainer = 
	$( "<span/>" )
	.css({ "margin":"0 20px 0 0"})
	.append(
		$( "<span/>" ).html( "Algorithm profile : " )
	).append(
		algorithmProfileDropDown
	);

<#-- append to container -->
targetContainer.append( algorithmProfileContainer );

<#-- create dropdown interest language -->
var interestLanguageDropDown = 
	$( '<select/>' )
	.attr({ "id": "interest_language"})
	.on( "change", function(){ getYearFromLanguage( $( this ).val() ) } );

<#-- interest language container -->
var interestLanguageContainer = 
	$( "<span/>" )
	.css({ "margin":"0 20px 0 0"})
	.append(
		$( "<span/>" ).html( "Language : " )
	).append(
		interestLanguageDropDown
	);

<#-- append to container -->
targetContainer.append( interestLanguageContainer );

<#-- create dropdown interest years -->
var interestYearStartDropDown = 
	$( '<select/>' )
	.attr({ "id": "interest_year_start"})
	.on( "change", function(){ visualizeInterest( $( this ).val() , "startyear") } );

var interestYearEndDropDown = 
	$( '<select/>' )
	.attr({ "id": "interest_year_end"})
	.on( "change", function(){ visualizeInterest( $( this ).val() , "endyear") } );

<#-- interest language container -->
var interestYearContainer = 
	$( "<span/>" ) 
	.append(
		$( "<span/>" ).html( "Start : " )
	).append(
		interestYearStartDropDown
	)
	.append(
		$( "<span/>" ).html( "End : " )
	).append(
		interestYearEndDropDown
	);

<#-- append to container -->
targetContainer.append( interestYearContainer );

<#-- on the first load, call the following functions -->
getLanguagesFromProfile( 0 );

<#-- functions -->
function getLanguagesFromProfile( profileIndex ){
	<#-- set index profile and other to 0 -->
	dataPointer.dataProfileIndex = profileIndex;
	dataPointer.dataLanguageIndex = 0;
	
	<#-- clear previous option -->
	interestLanguageDropDown.html( "" );
	<#-- loop interst languages --> 
	if( typeof data.topicModel[ dataPointer.dataProfileIndex ] != "undefined" )	{						
		$.each( data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages , function(index, dataInterestLanguage){
			interestLanguageDropDown.append( $( '<option/>' )
								.attr({ "value" : index  })
								.html( dataInterestLanguage.language )
							);
		});

		<#-- call function to get the year  -->
		getYearFromLanguage( dataPointer.dataLanguageIndex );
	}
}

function getYearFromLanguage( languageIndex ){
	<#-- set data language index -->
	dataPointer.dataLanguageIndex = languageIndex;

	<#-- clear previous year option -->
	interestYearStartDropDown.html( "" );
	interestYearEndDropDown.html( "" );

	<#-- loop interst years -->
	var countYear = data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears.length;
	
	if( countYear > 0 ){

		$.each( data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears , function(index, dataInterestYear){
			interestYearStartDropDown.append( $( '<option/>' )
								.attr({ "value" : index  })
								.html( dataInterestYear.year )
							);
			interestYearEndDropDown.append( $( '<option/>' )
								.attr({ "value" : index  })
								.html( dataInterestYear.year )
							);
		});
		<#-- change selected index of end year -->
		interestYearEndDropDown.children().eq( countYear - 1 ).attr( 'selected',true );
		<#-- -->
		dataPointer.dataYearStart = 0,
		dataPointer.dataYearEnd = countYear - 1;
		visualizeInterest( 0, "startyear");
	}
}

<#-- Most of this code is copied from internet -->
<#-- forgot the source url though...  -->
function visualizeInterest( yearIndex , yearType ){

	var mainContainer = $("#widget-${wUniqueName}").find( ".box-body" );
	<#-- remove previous svg if exist -->
	mainContainer.find( ".svg-container").remove();
	
	if( yearType == "startyear"){
		if( parseInt( dataPointer.dataYearEnd ) < parseInt( yearIndex ) ){
			dataPointer.dataYearEnd = yearIndex;
			interestYearEndDropDown.children().eq( dataPointer.dataYearEnd ).attr( 'selected',true );
		}
		dataPointer.dataYearStart = yearIndex;
	}
	else{
		if( parseInt( dataPointer.dataYearStart ) > parseInt( yearIndex ) ){
			dataPointer.dataYearStart = yearIndex;
			interestYearStartDropDown.children().eq( dataPointer.dataYearStart ).attr( 'selected',true );
		}
		dataPointer.dataYearEnd = yearIndex;
	}
	<#-- construct the data for interest cloud -->
	var streamChartData = [];
	var maximumSize = 0;
	var minimumSize = 0; 

	for( var i = dataPointer.dataYearStart ; i <= dataPointer.dataYearEnd ; i++ ){
		$.each( data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[i].termvalue, function( index, item ){
				var termValueData={
					"key" : item[0],
					"date" : data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[i].year,
					"value" : item[1]
					
				}
				streamChartData.push( termValueData );
			
		});
	}


	streamChartData.sort( compareTermWord );

	<#-- fill missing data-->
	var streamChartDataComplete = [];
	var streamChartDataCompleteMapIndex= {};
	var startDate = parseInt( data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearStart].year);
	var endDate = parseInt(data.topicModel[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearEnd].year);
	var previousTerm = "";
	streamChartData.forEach(function(d) {
		if( d.key == "" )
			return;
	
		if( previousTerm != d.key ){
			for( var i = startDate ; i <= endDate ; i++ ){
				streamChartDataCompleteMapIndex[ d.key+i ] = streamChartDataComplete.length;
				var termValueData={
					"key" : d.key,
					"date" : i.toString(),
					"value" : "0.0"
				}
				streamChartDataComplete.push( termValueData );
			}
		}
		var dataValue = d.value.toString();
		streamChartDataComplete[ streamChartDataCompleteMapIndex[ d.key+d.date ] ].value = dataValue;
		previousTerm = d.key;
	});

	visualizeStreamChart( streamChartDataComplete );
}

function compareTermWord( a, b){
	if (a.key < b.key)
    	return -1;
  	if (a.key > b.key)
    	return 1;
  	return 0;
}
					
function visualizeStreamChart( data, author ){

var fill = d3.scale.category20();

// Define the div for the tooltip
//var div = d3.select("body").append("div")	
//    .attr("class", "d3-tooltip")				
//    .style("opacity", 0);

var tooltip = d3.select("#widget-${wUniqueName} .box-body")
    .append("div")
    .attr("class", "remove")
    .style("position", "absolute")
    .style("z-index", "20")
    .style("visibility", "hidden")
    .style("top", "80px")
    .style("left", "80px")
    .style("font-weight", "bold");
	
margin = {top: 20, right: 20, bottom: 20, left: 10};
    width = $("#widget-${wUniqueName} .box-body").width() - margin.left - margin.right;
    height = 250 - margin.top - margin.bottom;

    colorrange = ["#B30000", "#E34A33", "#FC8D59", "#FDBB84", "#FDD49E", "#FEF0D9"];

    parseDate = d3.time.format("%Y").parse;

    x = d3.time.scale().range([margin.left, width]);

    y = d3.scale.linear().range([height, 0]);

    z = d3.scale.ordinal().range(colorrange);

    xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom")
        .ticks(d3.time.years);

    yAxis = d3.svg.axis().scale(y);

    nest = d3.nest()
        .key(function(d) { return d.key; });

    data.forEach(function(d) {
        d.date = parseDate(d.date);
        d.value= +d.value;
        });

    stack = d3.layout.stack()
        .offset("silhouette")
        .values(function(d) { return d.values; })
        .x(function(d) { return d.date; })
        .y(function(d) { return d.value; });

    layers = stack(nest.entries(data));

    area = d3.svg.area()
        //.interpolate("cardinal")
        .interpolate("basis")
        .x(function(d) { return x(d.date); })
        .y0(function(d) { return y(d.y0); })
        .y1(function(d) { return y(d.y0 + d.y); });

    svg = d3
    .select("#widget-${wUniqueName} .box-body")
     .append("div")
      .classed("svg-container", true) //container class to make it responsive
      .append("svg")
	  //responsive SVG needs these 2 attributes and no width and height attr
//   	  .attr("preserveAspectRatio", "xMinYMin meet")
//      .attr("viewBox", "0 0 " + width + " " + height)
      //class to make it responsive
//      .classed("svg-content-responsive", true)
      //.attr("width", width)
      //.attr("height", height)
	  .attr( "id", "interestCloud")
    //.append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
        
    layers = stack(nest.entries(data));

        x.domain(d3.extent(data, function(d) { return d.date; }));
        y.domain([0, d3.max(data, function(d) { return d.y0 + d.y; })]);

    svg.selectAll(".layer")
          .data(layers)
          .enter().append("path")
          .attr("class", "layer")
          .attr("d", function(d) { return area(d.values); })
          //.style("fill", function(d, i) { return z(i); });
          .style("fill", function(d, i) { return fill(i); })
      	  .style( "cursor", "pointer" )
		 /* .on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", .9);		
            div	.html( "test"  + d.close);	
               // .style("left", (d3.event.pageX) + "px")		
               // .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });*/
        
        .on("mouseover", function(d, i) {
      svg.selectAll(".layer").transition()
      .duration(250)
      .attr("opacity", function(d, j) {
        return j != i ? 0.6 : 1;
    })})

    .on("mousemove", function(d, i) {
      mousex = d3.mouse(this);
      mousex = mousex[0];
      var invertedx = x.invert(mousex);
      invertedx = invertedx.getMonth() + invertedx.getDate();

      d3.select(this)
      .classed("hover", true)
      .attr("stroke", "#000")
      .attr("stroke-width", "0.5px"), 
      tooltip.html( "<p>" + d.key + "</p>" ).style("visibility", "visible");
      
    })
    .on("mouseout", function(d, i) {
     	svg.selectAll(".layer")
      		.transition()
      		.duration(250)
      		.attr("opacity", "1");
      	d3.select(this)
      		.classed("hover", false)
      	.attr("stroke-width", "0px"), tooltip.html( "<p>" + d.key + "</p>" ).style("visibility", "hidden");
  	})
	.on("click", function (d, i){
         	var publicationTimeLineWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_publication' ); 
			if( typeof publicationTimeLineWidget !== "undefined" ){
				publicationTimeLineWidget.options.queryString = "?id=" + author.id + "&year=all&query=" + d.key;
			<#-- add overlay -->
				publicationTimeLineWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				$.PALM.boxWidget.refresh( publicationTimeLineWidget.element , publicationTimeLineWidget.options );
			} 
			else
				alert( "Publication Timeline widget missing, please enable it from Researcher Widget Management" );
     });
      
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

<#--
    svg.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(" + width + ", 0)")
          .call(yAxis.orient("right"));

    svg.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(30, 0)")
          .call(yAxis.orient("left"));
-->

    svg.selectAll(".layer")
            .attr("opacity", 1)
            .on("mouseover", function(d, i) {
                svg.selectAll(".layer").transition()
                    .duration(250)
                    .attr("opacity", function(d, j) {
                        return j != i ? 0.6 : 1;
                        })
                });

	<#-- remove previous svg if exist -->
<#--
	$("#widget-${wUniqueName} .box-body").find( "#streamChart").remove();
		var format = d3.time.format("%Y");
		
		var margin = {top: 20, right: 25, bottom: 60, left: 25},
		    width = 600,
		    height = 400;
		
		var x = d3.time.scale()
		    .range([0, width]);
		
		var y = d3.scale.linear()
		    .range([height, 0]);
		
		var z = d3.scale.category20();//Constructs a new ordinal scale with a range of twenty categorical colors: #3182bd #6baed6 #9ecae1 #c6dbef #e6550d #fd8d3c #fdae6b #fdd0a2 #31a354 #74c476 #a1d99b #c7e9c0 #756bb1 #9e9ac8 #bcbddc #dadaeb #636363 #969696 #bdbdbd #d9d9d9.
		
		var xAxis = d3.svg.axis()
		    .scale(x)
		    .orient("bottom");
		
		var yAxis = d3.svg.axis()
		    .scale(y)
		    .orient("left")
		    .tickValues();
		    
		
		var stack = d3.layout.stack()
		    .offset("zero")
		    .values(function(d) { return d.values; })
		    .x(function(d) { return d.date; })
		    .y(function(d) { return d.value; });
		
		var nest = d3.nest()
		    .key(function(d) { return d.key; });
		
		var area = d3.svg.area()
		    .interpolate("cardinal")
		    .x(function(d) { return x(d.date); })
		    .y0(function(d) { return y(d.y0); })
		    .y1(function(d) { return y(d.y0 + d.y); });
		
		var svg = d3
			.select("#widget-${wUniqueName} .box-body")
			.append("svg")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.top + margin.bottom)
			.attr( "id", "streamChart")
		    .append("g")
		    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
		
		  data.forEach(function(d) {
		    d.date = format.parse(d.date);
		    d.value = +d.value;
		  });
		
		  var layers = stack(nest.entries(data));		  				 
		  //console.log(layers);
		  
		  x.domain(d3.extent(data, function(d) { return d.date; }));
		  y.domain([0, d3.max(data, function(d) { return d.y0 + d.y; })]);
		
		  var dataLayerEnter = svg.selectAll(".layer")
		      .data(layers)
		      .enter().append("path")
		      .attr("class", "layer")
		      .attr("d", function(d) { return area(d.values); })
		      .style("fill","black")
		  
			.on("mouseover", function(d, i) {
			      svg.selectAll(".layer").transition()
			      .duration(250)
			      .attr("opacity", function(d, j) {
			        return j != i ? 0.6 : 1;
			    })})

		    .on("mousemove", function(d, i) {
		      mousex = d3.mouse(this);
		      mousex = mousex[0];
		      var invertedx = x.invert(mousex);
		      invertedx = invertedx.getMonth() + invertedx.getDate();
		      var selected = (d.values);
		      for (var k = 0; k < selected.length; k++) {
		        datearray[k] = selected[k].date
		        datearray[k] = datearray[k].getMonth() + datearray[k].getDate();
		      }
		
		      mousedate = datearray.indexOf(invertedx);
		      pro = d.values[mousedate].value;
		
		      d3.select(this)
		      .classed("hover", true)
		      .attr("stroke", strokecolor)
		      .attr("stroke-width", "0.5px"), 
		      tooltip.html( "<p>" + d.key + "<br>" + pro + "</p>" ).style("visibility", "visible");
		      
		    })
		    .on("mouseout", function(d, i) {
		     svg.selectAll(".layer")
		      .transition()
		      .duration(250)
		      .attr("opacity", "1");
		      d3.select(this)
		      .classed("hover", false)
		      .attr("stroke-width", "0px"), tooltip.html( "<p>" + d.key + "<br>" + pro + "</p>" ).style("visibility", "hidden");
		  });  
				  
				  
				  
			dataLayerEnter.append("title").text(function(d) {return d.key+": "+"[2008:"+d.values[0].value+"]"+"[2009:"+d.values[1].value+"]"+"[2010:"+d.values[2].value+"]"+"[2011:"+d.values[3].value+"]"+"[2012:"+d.values[4].value+"]"+"[2013:"+d.values[5].value+"]"+" papers"});	  				 
					  		
		
		  			  				 
		  svg.selectAll(".layer")
		      .data(layers)
		      .transition()
		      .style("fill", function(d, i) { return z(i); })
		      .style("opacity", 0.80)
		      .duration(2000);
		      
		  svg.append("g")
		      .attr("class", "x axis")
		      .attr("transform", "translate(0," + height + ")")
		      .call(xAxis);
		
		  svg.append("g")
		      .attr("class", "y axis")
		      .call(yAxis)
		      .data(layers);
-->
	}
							
			} <#-- end on refresh done -->
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>