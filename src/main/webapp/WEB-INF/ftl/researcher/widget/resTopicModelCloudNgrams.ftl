<div id="boxbody${wUniqueName}" class="box-body">
	<div style="display:none" class="box-filter">
		
	</div>
	<div class="box-content">
	</div>
</div>

<script>
	$( function(){
		<#-- generate unique id for progress log -->
		var uniquePidInterestCloud = $.PALM.utility.generateUniqueId();

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/topicCompositionNCloud' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Extracting author topic composition", { uniqueId:uniquePidInterestCloud, popUpHeight:40, directlyRemove:false , polling:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			
				<#-- check for interest evolution widget -->
				var topicModelEvolutionWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_topicmodel_evolution' ); 
				if( typeof topicModelEvolutionWidget !== "undefined" && !topicModelEvolutionWidget.executed){
					$.PALM.boxWidget.refresh( topicModelEvolutionWidget.element , topicModelEvolutionWidget.options );
				}

				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidInterestCloud );

var targetContainerContent = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".box-content" );
var targetContainerFilter = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find( ".box-filter" );

<#-- clean target container -->
targetContainerContent.html( "" );
targetContainerFilter.show();
targetContainerFilter.find( ".box-filter-option" ).html( "" );
targetContainerFilter.find( ".box-filter-button" ).find( "span" ).html( "" );


<#-- functions -->
<#-- construct the data for interest cloud -->
	var uniqueWordsHelperMap ={};
	var uniqueWords = [];
	var maximumSize = 0;
	var minimumSIze = 0; 


<#--	$.each( data.termvalue, function( index, item ){
		
		var termValue={
			"text" : item[0],
			"size" : parseFloatitem[1]
		}
		console.log(termValue);
		uniqueWords.push( termValue );
	});
	
	console.log(uniqueWords);
-->

for ( var i = 0; i < data.termvalue.length; i++){

	for (var k in data.termvalue[i]){
		var termValue = {
			"text" : k,
			"size" : data.termvalue[i][k]
		}
		uniqueWords.push({"text" : k, "size" : parseFloat(data.termvalue[i][k])});
		//uniqueWords.push(termValue);
	}
}
console.log(uniqueWords);

<#--
for (var i = 0; i < termvalue.length; i++){
	uniquewords.push(termvalue[0]
}-->

	<#-- sort lagrgerst to smallest -->
	uniqueWords.sort( compareTermWord );

	<#-- cut to maximum 50 
	if( uniqueWords.length > 20 )
		 uniqueWords =  uniqueWords.slice(0,20);
	-->

	visualizeTextCloud( uniqueWords );

	<#-- activate bootstrap select -->
	//targetContainerFilter.find( ".box-filter-option" ).find('.selectpicker').selectpicker();


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
		if( fontsize < 1000 )
			fontsize = 10;
		else if( fontsize < 3000 && fontsize >= 1000 )
			fontsize = 16;
		else if( fontsize < 5000 && fontsize >= 3000 )
			fontsize = 18;
		else if( fontsize < 6000 && fontsize >= 5000 )
			fontsize = 20;	
		else 
			fontsize = 22;
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
         	var publicationTimeLineWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_publication' ); 
			
			if( typeof publicationTimeLineWidget !== "undefined" ){
				publicationTimeLineWidget.options.queryString = "?id=" + data.author.id + "&year=all&query=" + d.text;
				<#-- add overlay -->
				publicationTimeLineWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				$.PALM.boxWidget.refresh( publicationTimeLineWidget.element , publicationTimeLineWidget.options );
			} else
				alert( "Publication Timeline widget missing, please enable it from Researcher Widget Management" );
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