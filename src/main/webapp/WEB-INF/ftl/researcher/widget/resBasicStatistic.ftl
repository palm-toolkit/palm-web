<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="pubBasicSvg" class="pubBasicSvg" style="width:100%;height:100%">
    <svg>
    </svg>
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
<#--
       $("#boxbody-${wUniqueName}").slimscroll({
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });
-->		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/basicInformation' />",
			query: "",
			queryString : "",
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".coauthor-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							$( widgetElem ).find( "svg" ).html( "" );

							var researcherDiv = 
							$( '<div/>' )
								.addClass( 'author' )
								.attr({ 'id' : data.author.id });
								
							var researcherNav =
							$( '<div/>' )
								.addClass( 'nav' );
								
							var researcherDetail =
							$( '<div/>' )
								.addClass( 'detail' )
								.append(
									$( '<div/>' )
										.addClass( 'name capitalize' )
										.html( data.author.name )
								);
								
							researcherDiv
								.append(
									researcherNav
								).append(
									researcherDetail
								);
								
							if( !data.author.isAdded ){
								researcherDetail.addClass( "text-gray" );
							}
							
							<#-- status -->
							if( typeof data.author.status != 'undefined')
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'status' )
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-briefcase icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.status )
									)
								);
							
							<#-- affiliation -->
							if( typeof data.author.aff != 'undefined')
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation' )
									.css({ "clear" : "both"})
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-institution icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.aff )
									)
								);
								
							if( typeof data.author.publicationsNumber != 'undefined'){
									var citedBy = 0;
									if( typeof data.author.citedBy !== "undefined" )
										citedBy = data.author.citedBy;
									researcherDetail.append(
										$( '<div/>' )
										.addClass( 'paper font-xs' )
										.css({ "clear" : "both"})
										.html( "<strong>Publications: " + data.author.publicationsNumber + " || Cited by: " + citedBy + "</strong>" )
									);
								}
								
							if( typeof data.author.photo != 'undefined'){
								researcherNav
									.append(
									$( '<div/>' )
										.addClass( 'photo' )
										.css({ 'font-size':'14px'})
										.append(
											$( '<img/>' )
												.attr({ 'src' : data.author.photo })
										)
									);
							} else {
								researcherNav
								.append(
									$( '<div/>' )
									.addClass( 'photo fa fa-user' )
								);
							}
							<#-- add clcik event -->
							researcherDetail
								.on( "click", function(){
									if( data.author.isAdded ){
										window.location = "<@spring.url '/researcher' />?id=" + data.author.id + "&name=" + data.author.name;
									} else {
										$.PALM.popUpIframe.create( "<@spring.url '/researcher/add' />?id=" + data.author.id + "&name=" + data.author.name , {popUpHeight:"416px"}, "Add " + data2.author.name + " to PALM");
									}
								} );
							
							targetContainer
								.append( 
									researcherDiv
								);

						<#-- publication visualization -->
nv.addGraph(function() {
  var chart = nv.models.linePlusBarChart()
        .margin({top: 30, right: 30, bottom: 50, left: 30})
        //We can set x data2 accessor to use index. Reason? So the bars all appear evenly spaced.
        .x(function(d,i) { return i })
        .y(function(d,i) {return d[1] })
        ;

    chart.xAxis
      .showMaxMin(false)
      .tickFormat(function(d) {
        var dx = data.d3data[0].values[d] && data.d3data[0].values[d][0] || 0;
        return d3.time.format('%Y')(new Date(dx))
      });
 
  chart.y1Axis
      .tickFormat(d3.format(',f'));

  chart.y2Axis
      .tickFormat(d3.format(',f'));

  chart.bars.forceY([0]);

  d3.select('#pubBasicSvg svg')
    .datum( data.d3data )
    .transition().duration(500)
    .call(chart)
    ;
    
  chart.bars.dispatch.on("elementClick", function(e) {
    console.log(e);
  });

  nv.utils.windowResize(chart.update);

  return chart;
}//,function( d ){
 //     d3.selectAll("rect").on('click',
//           function(){
//                 console.log( data.d3data[0].values[d] );
 //      });
//}
);

						<#-- end of publication visualization -->

								
						}
		};
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
	});
</script>