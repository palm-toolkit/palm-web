<div id="boxbody${wUniqueName}" class="box-body">
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
		var uniquePidInterestCloud = $.PALM.utility.generateUniqueId();

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/venue/interest' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Extracting event interest", { uniqueId:uniquePidInterestCloud, popUpHeight:40, directlyRemove:false , polling:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			
				<#-- check for interest evolution widget -->
				var interestEvolutionWidget = $.PALM.boxWidget.getByUniqueName( 'event_interest_evolution' ); 
				if( typeof interestEvolutionWidget !== "undefined" && !interestEvolutionWidget.executed){
					$.PALM.boxWidget.refresh( interestEvolutionWidget.element , interestEvolutionWidget.options );
				}
			

				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidInterestCloud );

var targetContainerContent = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".box-content" );

<#-- in case interest is not present -->
if( typeof data.interest == "undefined" ){
	$.PALM.callout.generate( targetContainerContent , "warning", "Unable to extract topics!", "Due to insufficient data" );
	return false;
}


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
	$( "<div/>" )
	.css({ "margin":"0 10px 0 0"})
	.append(
		$( "<span/>" ).html( "Algorithm : " )
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
	$( "<div/>" ) 
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
		<#-- reset -->
		dataPointer.dataYearStart = 0,
		dataPointer.dataYearEnd = countYear - 1;
		visualizeInterest( 0, "startyear");
	}
	<#-- assign bootstrap select  -->
	interestYearStartDropDown.selectpicker( 'refresh' );
	interestYearEndDropDown.selectpicker( 'refresh' );
}

function visualizeInterest( yearIndex , yearType ){
	if( yearType == "startyear"){
		if( dataPointer.dataYearEnd < yearIndex ){
			dataPointer.dataYearEnd = yearIndex;
			interestYearEndDropDown.val( dataPointer.dataYearEnd );
			interestYearEndDropDown.selectpicker( 'refresh' );
		}
		dataPointer.dataYearStart = yearIndex;
	}
	else{
		if( dataPointer.dataYearStart > yearIndex ){
			dataPointer.dataYearStart = yearIndex;
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
	var uniqueWordsHelperMap ={};
	var uniqueWords = [];
	var maximumSize = 0;
	var minimumSIze = 0; 

	for( var i = dataPointer.dataYearStart ; i <= dataPointer.dataYearEnd ; i++ ){
		$.each( data.interest[ dataPointer.dataProfileIndex ].interestlanguages[dataPointer.dataLanguageIndex].interestyears[i].termvalue, function( index, item ){
			if( uniqueWordsHelperMap[ item[1] ] != null){
				uniqueWords[ uniqueWordsHelperMap[ item[1] ] ].size = uniqueWords[ uniqueWordsHelperMap[ item[1] ] ].size + item[2];
			} else{
				var termValue={
					"text" : item[1],
					"size" : item[2]
				}
				uniqueWords.push( termValue );
				uniqueWordsHelperMap[ item[1] ] = uniqueWords.length - 1;
			}
		});
	}

	<#-- sort lagrgerst to smallest -->
	uniqueWords.sort( compareTermWord );

	<#-- cut to maximum 50 -->
	if( uniqueWords.length > 20 )
		 uniqueWords =  uniqueWords.slice(0,20);

	visualizeTextCloud( uniqueWords );

	<#-- activate bootstrap select -->
	//targetContainerFilter.find( ".box-filter-option" ).find('.selectpicker').selectpicker();
}

<#-- comparator for sorting weight of terms -->
function compareTermWord( a, b){
	if (a.size < b.size)
    	return 1;
  	if (a.size > b.size)
    	return -1;
  	return 0;
}

<#-- visualize text cloud -->				
function visualizeTextCloud( words ){
	var mainContainer = $("#widget-${wUniqueName}").find( ".box-content" );
	<#-- remove previous svg if exist -->
	mainContainer.find( ".svg-container").remove();
	<#-- the visualization -->
	var fill = d3.scale.category20();
	
	var width = mainContainer.width() * 0.9;
	var height = mainContainer.width() * 0.9;
	var maxFontSize = 18;

	d3.layout.cloud()
  .size([width, height])
  .words(words)
  .padding(5)
  .rotate(function() { return 0; })
  .font("Impact")
  .fontSize(function(d) {
		var fontsize = d.size * maxFontSize;
		if( fontsize < 12 )
			fontsize = 12;
		if( fontsize > 18 )
			fontsize = 20;
		return fontsize;
	})
  .on("end", draw)
  .start();

	function draw(words) {
    d3.select("#widget-${wUniqueName} .box-content" )
	  .append("div")
      .classed("svg-container", true) //container class to make it responsive
      .append("svg")
	  //responsive SVG needs these 2 attributes and no width and height attr
   	  .attr("preserveAspectRatio", "xMinYMin meet")
      .attr("viewBox", "0 0 " + width + " " + height)
      //class to make it responsive
      .classed("svg-content-responsive", true)
      //.attr("width", width)
      //.attr("height", height)
	  .attr( "id", "textCloud")
      .append("g")
      .attr("transform", "translate("+ width/2 +","+ height/2 +")")
      .selectAll("text")
      .data(words)
      .enter()
      .append("text")
      .style("font-size", function(d) { return d.size + "px"; })
      .style("font-family", "\"Trebuchet MS\", Helvetica, sans-serif")
      .style("fill", function(d, i) { return fill(i); })
      .style( "cursor", "pointer" )
      .attr("text-anchor", "middle")
      .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")"; 
      })
      .text(function(d) { return d.text; })
      .on("click", function (d, i){
         	var publicationTimeLineWidget = $.PALM.boxWidget.getByUniqueName( 'conference_publication' ); 
			if( typeof publicationTimeLineWidget !== "undefined" ){
				publicationTimeLineWidget.options.queryString = "?id=" + data.event.id + "&year=all&query=" + d.text;
				// add overlay 
				publicationTimeLineWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				$.PALM.boxWidget.refresh( publicationTimeLineWidget.element , publicationTimeLineWidget.options );
			} else
				alert( "Publication Timeline widget missing, please enable it from Event Widget Management" );
      });
	}
}
							
			}
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