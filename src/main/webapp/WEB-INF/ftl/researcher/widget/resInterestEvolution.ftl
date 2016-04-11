<div id="boxbody${wUniqueName}" class="box-body" style="height:380px;overflow:hidden">
	<div style="display:none" class="box-filter">
		<div class="box-filter-option" style="display:none"></div>
		<button class="btn btn-block btn-default box-filter-button btn-xs" onclick="$( this ).prev().slideToggle( 'slow' )">
			<i class="fa fa-filter pull-left"></i>
			<span>Something</span>
		</button>
	</div>
	<div class="box-content">
	</div>
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
<#--
		$("#boxbody${wUniqueName}").slimscroll({
			height: "300px",
	        size: "3px"
	    });
-->
		<#-- generate unique id for progress log -->
		var uniquePidInterestEvolution = $.PALM.utility.generateUniqueId();
		
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/interest' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Extracting/Loading interest evolution", { uniqueId:uniquePidInterestEvolution, popUpHeight:40, directlyRemove:false , polling:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			
			
				<#-- check for interest cloud widget -->
				var interestCloudWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_interest_cloud' ); 
				if( typeof interestCloudWidget !== "undefined" && !interestCloudWidget.executed){
					$.PALM.boxWidget.refresh( interestCloudWidget.element , interestCloudWidget.options );
				}
				
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidInterestEvolution );
				
var targetContainerContent = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".box-content" );
var targetContainerFilter = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".box-filter" );

<#-- clean target container -->
targetContainerContent.html( "" );
targetContainerFilter.show();
targetContainerFilter.find( ".box-filter-option" ).html( "" );
targetContainerFilter.find( ".box-filter-button" ).find( "span" ).html( "" );

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
	.addClass( "selectpicker btn-xs" )
	.css({ "max-width": "210px"})
	.on( "change", function(){ getLanguagesFromProfile( $( this ).val() ) } );

<#-- loop interst algorithm --> 								
$.each( data.interest, function(index, dataAlgorithmProfile){
	algorithmProfileDropDown.append( $( '<option/>' )
								.attr({ "value" : index })
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
targetContainerFilter.find( ".box-filter-option" ).append( algorithmProfileContainer );

<#-- assign bootstrap select  -->
algorithmProfileDropDown.selectpicker( 'refresh' );

<#-- create dropdown interest language -->
var interestLanguageDropDown = 
	$( '<select/>' )
	.css({ "max-width" : "70px" })
	.addClass( "selectpicker btn-xs" )
	.attr({ "id": "interest_language"})
	.on( "change", function(){ getYearFromLanguage( $( this ).val() ) } );

<#-- interest language container -->
var interestLanguageContainer = 
	$( "<div/>" )
	.css({ "margin":"0 20px 0 0"})
	.append(
		$( "<span/>" ).html( "Lang : " )
	).append(
		interestLanguageDropDown
	);

<#-- append to container -->
targetContainerFilter.find( ".box-filter-option" ).append( interestLanguageContainer );

<#-- create dropdown interest years -->
var interestYearStartDropDown = 
	$( '<select/>' )
	.css({ "max-width" : "60px" })
	.addClass( "selectpicker btn-xs" )
	.attr({ "id": "interest_year_start"})
	.on( "change", function(){ visualizeInterest(  $( this ).prop('selectedIndex') , "startyear") } );

var interestYearEndDropDown = 
	$( '<select/>' )
	.css({ "max-width" : "60px" })
	.addClass( "selectpicker btn-xs" )
	.attr({ "id": "interest_year_end"})
	.on( "change", function(){ visualizeInterest( $( this ).prop('selectedIndex') , "endyear") } );

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
targetContainerFilter.find( ".box-filter-option" ).append( interestYearContainer );

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
	<#-- assign bootstrap select  -->
	interestLanguageDropDown.selectpicker( 'refresh' );
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
			var optionYearStart = $( '<option/>' )
								.attr({ "value" : index  })
								.html( dataInterestYear.year );
			if( index == data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears.length - 1 )
				optionYearStart.attr('disabled','disabled');		
								
			interestYearStartDropDown.append( optionYearStart );	
			
			var optionYearEnd = $( '<option/>' )
								.attr({ "value" : index  })
								.html( dataInterestYear.year );
			
			if( index == 0 )
				optionYearEnd.attr('disabled','disabled');	
								
			interestYearEndDropDown.append( optionYearEnd );
		});
		<#-- change selected index of end year -->
		interestYearEndDropDown.children().eq( countYear - 1 ).attr( 'selected',true );
		<#-- -->
		dataPointer.dataYearStart = 0,
		dataPointer.dataYearEnd = countYear - 1;
		visualizeInterest( 0, "startyear");
	}
	<#-- assign bootstrap select  -->
	interestYearStartDropDown.selectpicker( 'refresh' );
	interestYearEndDropDown.selectpicker( 'refresh' );
}

<#-- Most of this code is copied from internet -->
<#-- forgot the source url though...  -->
function visualizeInterest( yearIndex , yearType ){

	var mainContainer = $("#widget-${wUniqueName}").find( ".box-content" );
	<#-- remove previous svg if exist -->
	mainContainer.find( ".svg-container").remove();
	
	if( yearType == "startyear"){
		if( dataPointer.dataYearEnd <= yearIndex ){
			dataPointer.dataYearEnd = yearIndex + 1;
			interestYearEndDropDown.val( dataPointer.dataYearEnd );
			interestYearEndDropDown.selectpicker( 'refresh' );
		}
		dataPointer.dataYearStart = yearIndex;
	}
	else{
		if( dataPointer.dataYearStart >= yearIndex ){
			dataPointer.dataYearStart = yearIndex - 1;
			interestYearStartDropDown.val( dataPointer.dataYearStart );
			interestYearStartDropDown.selectpicker( 'refresh' );
		}
		dataPointer.dataYearEnd = yearIndex;
	}
	<#-- set filter button label  -->
	targetContainerFilter
		.find( ".box-filter-button" )
		.find( "span" )
		.html( 
			(data.interest[ dataPointer.dataProfileIndex ].profile).replace( /\?/g,"∩") + ", " +
			data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].language + ", " +
			data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearStart].year + "-" +
			data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearEnd].year
		);
		
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


	streamChartData.sort( compareTermWord );

	<#-- fill missing data-->
	var streamChartDataComplete = [];
	var streamChartDataCompleteMapIndex= {};
	var startDate = parseInt( data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearStart].year);
	var endDate = parseInt(data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[dataPointer.dataYearEnd].year);
	var previousTerm = "";
	streamChartData.forEach(function(d) {
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
		<#-- set threshold -->
		var dataValue = d.value.toFixed(2);
		if( dataValue < 0.4 )
			dataValue = 0;
		streamChartDataComplete[ streamChartDataCompleteMapIndex[ d.key+d.date ] ].value = dataValue.toString();
		previousTerm = d.key;
	});

	visualizeStreamChart( streamChartDataComplete , data.author);
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

var tooltip = d3.select("#widget-${wUniqueName} .box-content")
    .append("div")
    .attr("class", "remove")
    .style("position", "relative")
    .style("z-index", "20")
    .style("visibility", "hidden")
    .style("top", "0px")
    .style("height", "0")
    .style("left", "30px")
    .style("font-weight", "bold");
	
margin = {top: 20, right: 20, bottom: 20, left: 10};
    width = $("#widget-${wUniqueName} .box-content").width() - margin.left - margin.right;
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
    .select("#widget-${wUniqueName} .box-content")
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