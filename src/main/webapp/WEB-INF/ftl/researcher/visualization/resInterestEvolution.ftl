<div id="boxbody${wId}" class="box-body">
	researcher interest evolution
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId}").slimscroll({
			height: "250px",
	        size: "3px"
	    });

				<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/interest' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){

var targetContainer = $( widgetElem ).find( "#boxbody${wId}" );

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
$.each( data.interest, function(index, dataAlgorithmProfile){
	algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : index , "title" : dataAlgorithmProfile.description })
								.html( dataAlgorithmProfile.profile )
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
	if( typeof data.interest[ dataPointer.dataProfileIndex ] != "undefined" )	{						
		$.each( data.interest[ dataPointer.dataProfileIndex ].interestlanguages , function(index, dataInterestLanguage){
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
	var countYear = data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears.length;
	
	if( countYear > 0 ){

		$.each( data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears , function(index, dataInterestYear){
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

function visualizeInterest( yearIndex , yearType ){
	if( yearType == "startyear"){
		if( dataPointer.dataYearEnd < yearIndex ){
			dataPointer.dataYearEnd = yearIndex;
			interestYearEndDropDown.children().eq( dataPointer.dataYearEnd ).attr( 'selected',true );
		}
		dataPointer.dataYearStart = yearIndex;
	}
	else{
		if( dataPointer.dataYearStart > yearIndex ){
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
		$.each( data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[i].termvalue, function( index, item ){
				var termValueData={
					"key" : item[1],
					"date" : data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[i].year,
					"value" : item[2]
					
				}
				streamChartData.push( termValueData );
			
		});
	}

var somedata = [{"key":"active time","date":"05/13/2013","value":"3860.0"},{"key":"active time","date":"05/14/2013","value":"5167.0"},{"key":"active time","date":"05/15/2013","value":"5663.0"},{"key":"active time","date":"05/16/2013","value":"542.0"},{"key":"active time","date":"05/16/2013","value":"6758.0"},{"key":"active time","date":"05/17/2013","value":"6379.0"},{"key":"active time","date":"05/18/2013","value":"10710.0"},{"key":"active time","date":"05/19/2013","value":"10025.0"},{"key":"active time","date":"05/20/2013","value":"4326.0"},{"key":"active time","date":"05/21/2013","value":"3711.0"},{"key":"active time","date":"05/22/2013","value":"10.0"},{"key":"active time","date":"05/22/2013","value":"3371.0"},{"key":"distance","date":"05/13/2013","value":"5766.0"},{"key":"distance","date":"05/14/2013","value":"7472.0"},{"key":"distance","date":"05/15/2013","value":"8264.0"},{"key":"distance","date":"05/16/2013","value":"797.0"},{"key":"distance","date":"05/16/2013","value":"14842.0"},{"key":"distance","date":"05/17/2013","value":"9369.0"},{"key":"distance","date":"05/18/2013","value":"19950.0"},{"key":"distance","date":"05/19/2013","value":"18100.0"},{"key":"distance","date":"05/20/2013","value":"6547.0"},{"key":"distance","date":"05/21/2013","value":"5583.0"},{"key":"distance","date":"05/22/2013","value":"18.0"},{"key":"distance","date":"05/22/2013","value":"4989.0"},{"key":"steps","date":"05/13/2013","value":"7210.0"},{"key":"steps","date":"05/14/2013","value":"9481.0"},{"key":"steps","date":"05/15/2013","value":"10431.0"},{"key":"steps","date":"05/16/2013","value":"1006.0"},{"key":"steps","date":"05/16/2013","value":"14975.0"},{"key":"steps","date":"05/17/2013","value":"11821.0"},{"key":"steps","date":"05/18/2013","value":"22069.0"},{"key":"steps","date":"05/19/2013","value":"20228.0"},{"key":"steps","date":"05/20/2013","value":"8107.0"},{"key":"steps","date":"05/21/2013","value":"6944.0"},{"key":"steps","date":"05/22/2013","value":"21.0"},{"key":"steps","date":"05/22/2013","value":"6268.0"}];

streamChartData.sort( compareTermWord );

var streamChartDataComplete = [];
var startDate = parseInt( data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearStart]);
var endDate = parseInt(data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearEnd]);
var previousTerm = "";
streamChartData.forEach(function(d) {
	if( previousTerm != d.key )
	for( var i = startDate ; i <= endDate ; i++ ){
		if( d.key)
	}
});


console.log( streamChartData );

<#-- fixes missing data -->

visualizeStreamChart( somedata );
}

function compareTermWord( a, b){
	if (a.key < b.key)
    	return -1;
  	if (a.key > b.key)
    	return 1;
  	return 0;
}
					
function visualizeStreamChart( data ){
	
margin = {top: 20, right: 20, bottom: 20, left: 30};
    width = 550 - margin.left - margin.right;
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

    svg = d3.select("#widget-${wId} .box-body").append("svg")
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
          .style("fill", function(d, i) { return z(i); });

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(" + width + ", 0)")
          .call(yAxis.orient("right"));

    svg.append("g")
          .attr("class", "y axis")
          .call(yAxis.orient("left"));


    svg.selectAll(".layer")
            .attr("opacity", 1)
            .on("mouseover", function(d, i) {
                svg.selectAll(".layer").transition()
                    .duration(250)
                    .attr("opacity", function(d, j) {
                        return j != i ? 0.6 : 1;
                        })
                });

	/*
	<#-- remove previous svg if exist -->
	$("#widget-${wId} .box-body").find( "#streamChart").remove();
	<#-- the visualization -->
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
		
		var svg = d3.select("#widget-${wId} .box-body").append("svg")
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
		      .on("mouseover", function(d) {
		   				d3.select(this)
		   				.style("opacity", 1.0)
		  		})
			.on("mouseout", function() {
				  d3.select(this)
				  .style("opacity", 0.8)
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
*/
	}
							
			} <#-- end on refresh done -->
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>