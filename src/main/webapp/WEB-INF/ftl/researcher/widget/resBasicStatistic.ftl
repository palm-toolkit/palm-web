<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="authBasicSvg" class="authBasicSvg" style="width:100%;height:100%">
    <svg>
    </svg>
    </div>
    
    <div id="autOtherInfo" style="width:100%;overflow:hidden"></div>
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
			source : "<@spring.url '/researcher/basicInformation?id=114b11c1-3f38-4348-b6ad-34ae7cdfc903' />",
			query: "",
			queryString : "",
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){
			
				if( typeof data.author !== "undefined" ){

							var targetContainer = $( widgetElem ).find( ".coauthor-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							 $( widgetElem ).find( "#autOtherInfo" ).html( "" );
							
							<#-- bookmark button -->
				<#if currentUser??>
					if( !data.booked ){
	                	var butBook = $( "<a/>" )
	                					.attr({
	                						"class":"btn btn-block btn-social btn-twitter btn-sm width120px pull-right",
	                						"onclick":"$.PALM.bookmark.author( $( this ), '${currentUser.id}', '" + data.author.id + "' )",
	                						"data-goal":"add"})
	                					.append(
	                						$( "<i/>" )
	                							.attr({"class":"fa fa-bookmark"})
	                					)
	                					.append(
	                						"<strong>Bookmark</strong>"
	                					);
	                			
						targetContainer.append( butBook );
					} else {
						var butBook = $( "<a/>" )
	                					.attr({
	                						"class":"btn btn-block btn-social btn-twitter active btn-sm width120px pull-right",
	                						"onclick":"$.PALM.bookmark.author( $( this ), '${currentUser.id}', '" + data.author.id + "' )",
	                						"data-goal":"remove"})
	                					.append(
	                						$( "<i/>" )
	                							.attr({"class":"fa fa-check"})
	                					)
	                					.append(
	                						"<strong>Bookmarked</strong>"
	                					);
	                			
						targetContainer.append( butBook );
					}
				</#if>

							$( widgetElem ).find( "svg" ).html( "" );

							var researcherDiv = 
							$( '<div/>' )
								.addClass( 'author static' );
								
							var researcherNav =
							$( '<div/>' )
								.addClass( 'nav medium' );
								
							var researcherDetail =
							$( '<div/>' )
								.addClass( 'detail static' )
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
								
							<#-- email -->
							if( typeof data.author.email != 'undefined' && data.author.email != "" )
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation' )
									.css({ "clear" : "both"})
									.attr({ "title": data.author.name + " email" })
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-envelope icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.email )
									)
								);
								
							<#-- homepage -->
							if( typeof data.author.homepage != 'undefined' && data.author.homepage != "" )
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation urlstyle' )
									.css({ "clear" : "both"})
									.attr({ "title": data.author.name + " homepage" })
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-globe icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.homepage )
									).click( function( event ){ event.preventDefault();window.open( data.author.homepage, data.author.name + " homepage" ,'scrollbars=yes,width=650,height=500')})
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
										.addClass( 'photo medium' )
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
									.addClass( 'photo medium fa fa-user' )
								);
							}
							<#if loggedUser??>
							<#-- add edit button -->
							researcherNav
								.append(
									$( '<div/>' )
									.addClass( 'btn btn-default btn-xs pull-left' )
									.attr({ "data-url":"<@spring.url '/researcher/edit' />?id=" + data.author.id, "title":"Update " + data.author.name + " Profile"})
									.append(
										$( '<i/>' )
											.addClass( 'fa fa-edit' )
									).append( "Update" )
									.on( "click", function(e){
										e.preventDefault;
										$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
									})
								);
							</#if>
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
	        // if invalid date
	        if( dx == 0 )
	        	return "";
	        var dateformat = d3.time.format('%Y')(new Date(dx));
	        return dateformat;
	      });
	 
	  chart.y1Axis
	      .tickFormat(d3.format(',f'));
	
	  chart.y2Axis
	      .tickFormat(d3.format(',f'));
	
	  chart.bars.forceY([0]);
	
	  d3.select('#authBasicSvg svg')
	    .datum( data.d3data )
	    .transition().duration(500)
	    .call(chart)
	    ;
	    
	  chart.bars.dispatch.on("elementClick", function(e) {
	    var researcherPublicationWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_publication' ); 
						
		researcherPublicationWidget.options.queryString = "?id=" + data.author.id + "&year=" + e.data[2];
		<#-- add overlay -->
		researcherPublicationWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
		
		$.PALM.boxWidget.refresh( researcherPublicationWidget.element , researcherPublicationWidget.options );
	  });
	
	  nv.utils.windowResize(chart.update);
	
	  return chart;
	});
	
							<#-- end of publication visualization -->
				
				<#-- other information -->
				<#-- Academic Networks -->
						if( typeof data.sources!= "undefined"){
							var onAcademicNetwork = $( '<dd/>' );
							$.each( data.sources , function( index, sourceItem ){							
								onAcademicNetwork.append( 
									$( '<div/>' )
										.addClass( "nowarp urlstyle" )
										.attr( "title", sourceItem.source + " - " + sourceItem.url)
										.html( "<i class='fa fa-globe'></i> " + sourceItem.source + " - " + sourceItem.url)
										.click( function( event ){ event.preventDefault();window.open( sourceItem.url, sourceItem.source ,'scrollbars=yes,width=650,height=500')})
								);
							});
							
							$( "#autOtherInfo" ).html( "" )
								.append( $( '<dt/>' ).html( "On Academic Networks:" ).css("margin-top","15px") )
								.append( onAcademicNetwork);
							
						}
				
				<#-- syncronize number of publication -->
				var updatedPublicationNumber; 
				if( typeof data.author.publicationsNumber != 'undefined'){
					var citedBy = 0;
					if( typeof data.author.citedBy !== "undefined" )
						citedBy = data.author.citedBy;
					
					updatedPublicationNumber = "Publications: " + data.author.publicationsNumber + " || Cited by: " + citedBy;
				}
								
				var researcherListWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_list' ); 
				researcherListWidget.element.find( "#" + data.author.id ).find( ".paper" ).html( updatedPublicationNumber );
			}
													
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