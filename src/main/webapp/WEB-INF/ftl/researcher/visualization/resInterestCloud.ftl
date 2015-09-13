<div id="boxbody${wId}" class="box-body">
	researcher interest cloud
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
}

function compareTermWord( a, b){
	if (a.size < b.size)
    	return 1;
  	if (a.size > b.size)
    	return -1;
  	return 0;
}
							
function visualizeTextCloud( words ){
	<#-- remove previous svg if exist -->
	$("#widget-${wId} .box-body").find( "#textCloud").remove();
	<#-- the visualization -->
	var fill = d3.scale.category20();
	
	var width = 600;
	var height = 150;
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
    d3.select("#widget-${wId} .box-body")
      .append("svg")
      .attr("width", width)
      .attr("height", height)
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
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>