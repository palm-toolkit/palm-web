<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
	</div>
</div>

<#--
<div class="box-footer">
</div>
-->
<script>
	$( function(){

		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} .box-content").slimscroll({
			height: "630px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/publicationList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				<#--remove everything -->
				$("#widget-${wUniqueName} .box-content").html( "" );
				
				<#--
				if( data.status != "ok"){
					alert( "error on publication list" );
					return false;
				}
				-->
				<#--
				if ( typeof data.publications === 'undefined') {
					alert( "error, no publication found" );
					return false;
				}
				-->
				var filterContainer = $( '<div/>' )
										.css({'width':'100%','margin':'0 10px 15px 0'})
										.addClass( "pull-left" )
										
				var filterSearch = $( '<div/>' )
									.addClass( "input-group" )
									.css({'width':'100%'})
									.append(
										$( '<input/>' )
										.attr({'type':'text', 'id':'publist-search', 'class':'form-control input-sm pull-right'})
									)
									.append(
										$( '<div/>' )
										.attr({'id':'publist-search-button-cont', 'class':'input-group-btn', 'title':'Will automatically search for all ' + data.author.name + '\'s publications'})
										.append(
											$( '<button/>' )
											.attr({'id':'publist-search-button', 'class':'btn btn-sm btn-default'})
											.append(
												$( '<i/>' )
												.attr({'class':'fa fa-search'})
											)
										)
										.on( "click", function(){
											var thisWidget = $.PALM.boxWidget.getByUniqueName( '${wUniqueName}' ); 
					
											<#-- find keyword if any -->
											var keywordText = filterSearch.find( "#publist-search" ).val();
											//if( typeof keywordText !== "undefined" && keywordText !== "")
											thisWidget.options.queryString = "?id=" + data.author.id + "&year=all&query=" + keywordText;
											<#-- add overlay -->
											thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
											$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
										} )
									)
				
				var filterYear = $( '<div/>' ).attr({'class':'btn-group','data-toggle':'buttons'});
				filterYear.append( $( "<label/>" )
									.attr({ "class":"btn btn-xs btn-default" })
									.append(
										$( "<input/>" )
										.attr({ "type":"radio", "id":"year-all", "name":"filteryear", "value":"all", "data-link": "?id=" + data.author.id + "&year=all"})
									).append( "all (" + data.totalPublication + ")" )
						 )
						 .append( $( "<label/>" )
									.attr({ "class":"btn btn-default btn-xs" })
									.append(
										$( "<input/>" )
										.attr({ "type":"radio", "id":"maxresult-10", "name":"filteryear", "value":"maxresult10", "data-link": "?id=" + data.author.id + "&maxresult=10"})
									).append( "recent (10)" )
						 )
				$.each( data.years, function( index, item ){
					filterYear.append( $( "<label/>" )
									.attr({ "class":"btn btn-default btn-xs" })
									.append(
										$( "<input/>" )
										.attr({ "type":"radio", "id":"year-" + item, "name":"filteryear", "value":item , "data-link": "?id=" + data.author.id + "&year=" + item})
									).append( item )
						 )
				});
				if( typeof data.query !== "undefined" ){
					filterYear.append( $( "<label/>" )
									.attr({ "class":"btn btn-default btn-xs active" })
									.append(
										$( "<input/>" )
										.attr({ "type":"radio", "id":"year-query", "name":"filteryear", "value":data.query , "data-link": "?id=" + data.author.id + "query=" + data.query, "checked": true})
									).append( data.query + "(" + data.count + ")" )
						 )
				}
				
				<#-- find active option -->
				var currentQueryArray = this.queryString.split( "&" );
				$.each( currentQueryArray , function( index, partQuery){
					if( partQuery.lastIndexOf( 'year', 0) === 0 && typeof data.query === "undefined" )
						filterYear.find( "#" + partQuery.replace( "=","-") ).prop("checked", true).parent().addClass( "active" );
					else if( partQuery.lastIndexOf( 'maxresult', 0) === 0 )
						filterYear.find( "#" + partQuery.replace( "=","-") ).prop("checked", true).parent().addClass( "active" );
					else if( partQuery.lastIndexOf( 'query', 0) === 0 )
						filterSearch.find( "#publist-search" ).val( partQuery.substring(6, partQuery.length) );
						
				});
				<#-- assign click functionality to year filter -->
				filterYear.on( "change", "input", function(e){
					var thisWidget = $.PALM.boxWidget.getByUniqueName( '${wUniqueName}' ); 
					
					thisWidget.options.queryString = $( this ).data( "link" );
					<#-- find keyword if any -->
					//var keywordText = filterSearch.find( "#publist-search" ).val();
					//if( typeof keywordText !== "undefined" && keywordText !== "")
					//	thisWidget.options.queryString += "&query=" + keywordText;
					<#-- add overlay -->
					thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					
					$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
				});
				<#-- append filter -->
				filterContainer.append( filterSearch );
				filterContainer.append( filterYear );
				$("#widget-${wUniqueName} .box-content").append( filterContainer );
				<#-- end of filter -->

				<#-- no publication found -->
				if ( typeof data.publications === 'undefined') {
					$("#widget-${wUniqueName} .box-content").append( "<strong>error, no publication found/match</strong>" );
					return false;
				}

				var timeLineContainer = 
					$( '<ul/>' )
						.addClass( "timeline" );

				var timeLineGroupYear = "";
				
				var noOfConferenceYearly;
				var noOfWorkshopYearly;
				var noOfJournalYearly;
				var noOfBookYearly;
				var noOfUnknownYearly;
				<#-- timeline group -->
				var liTimeGroup;
				
				<#-- add empty object, to add more loop -->
				data.publications.push( { "date":"endpublication"} );
					
				$.each( data.publications, function( index, item ){
					<#-- timeline group -->
					if( typeof item.date !== 'undefined' ){
						if( timeLineGroupYear !== item.date.substring(0, 4) ){
						
							if( typeof liTimeGroup !== "undefined" ){
							
								if( noOfConferenceYearly > 0 || noOfWorkshopYearly > 0){
									var noOfPublicationInfo = "";
									if( noOfConferenceYearly == 1 )
										noOfPublicationInfo += "1 Conference";
									else if( noOfConferenceYearly > 1 )
										noOfPublicationInfo += noOfConferenceYearly + " Conferences";
										
									if( noOfConferenceYearly > 0 && noOfWorkshopYearly > 0 )
										noOfPublicationInfo += " & ";
										
									if( noOfWorkshopYearly == 1 )
										noOfPublicationInfo += "1 Workshop";
									else if( noOfWorkshopYearly > 1 )
										noOfPublicationInfo += noOfWorkshopYearly + " Workshops";
										
									liTimeGroup.append( 
												$( '<span/>' )
												.addClass( "bg-blue" )
												.css({ "margin-left" : "10px" })
												.html( noOfPublicationInfo )
											);
								}
								if( noOfJournalYearly > 0 ){
									var noOfPublicationInfo = "";
									if( noOfJournalYearly == 1 )
										noOfPublicationInfo += "1 Journal";
									else if( noOfJournalYearly > 1 )
										noOfPublicationInfo += noOfJournalYearly + " Journals";
										
									liTimeGroup.append( 
												$( '<span/>' )
												.addClass( "bg-red" )
												.css({ "margin-left" : "10px" })
												.html( noOfPublicationInfo )
											);
								}
								if( noOfBookYearly > 0 ){
									var noOfPublicationInfo = "";
									if( noOfBookYearly == 1 )
										noOfPublicationInfo += "1 Book";
									else if( noOfBookYearly > 1 )
										noOfPublicationInfo += noOfBookYearly + " Books";
										
									liTimeGroup.append( 
												$( '<span/>' )
												.addClass( "bg-green" )
												.css({ "margin-left" : "10px" })
												.html( noOfPublicationInfo )
											);
								}
								
								var firstTimelineSpan = $( liTimeGroup) .find( "span:first" );
								firstTimelineSpan.html( (noOfConferenceYearly + noOfWorkshopYearly + noOfJournalYearly + noOfBookYearly + noOfUnknownYearly ) + " " + firstTimelineSpan.html() );
							}
							
							noOfConferenceYearly = 0;
							noOfWorkshopYearly = 0;
							noOfJournalYearly = 0;
							noOfBookYearly = 0;
							noOfUnknownYearly = 0;
							
							
							if( item.date != "endpublication" ){
								liTimeGroup = $( '<li/>' )
												.addClass( "time-label" )
												.append( 
													$( '<span/>' )
													.addClass( "bg-green" )
													.html( "Publications in " + item.date.substring(0, 4) )
												);
								timeLineContainer.append( liTimeGroup );
							}
						}
						timeLineGroupYear = item.date.substring(0, 4);
					} else {
						
						if( timeLineGroupYear != null ){
							var liTimeGroup2 = $( '<li/>' )
											.addClass( "time-label" )
											.append( 
												$( '<span/>' )
												.addClass( "bg-green" )
												.html( "Unknown publications date" )
											);
							timeLineContainer.append( liTimeGroup2 );

							 timeLineGroupYear = null;
						}
					}

					if( typeof item.title !== "undefined" ){
					
						var publicationItem = $( '<li/>' );
	
						<#-- timeline mark -->
						var timelineDot = $( '<i/>' );
						if( typeof item.type !== 'undefined'){
							if( item.type == "JOURNAL" ){
								timelineDot.addClass( "fa fa-files-o bg-red" );
								timelineDot.attr({ "title" : "Journal" });
								noOfJournalYearly++;
							}
							else if( item.type == "CONFERENCE" ){
								timelineDot.addClass( "fa fa-file-text-o bg-blue" );
								timelineDot.attr({ "title" : "Conference" });
								noOfConferenceYearly++;
							}
							else if( item.type == "WORKSHOP" ){
								timelineDot.addClass( "fa fa-file-text-o bg-blue-dark" );
								timelineDot.attr({ "title" : "Workshop" });
								noOfWorkshopYearly++;
							}
							else if( item.type == "BOOK" ){
								timelineDot.addClass( "fa fa-book bg-green" );
								timelineDot.attr({ "title" : "Book" });
								noOfBookYearly++;
							}
						}else{
							timelineDot.addClass( "fa fa-question bg-purple" );
							timelineDot.attr({ "title" : "Unknown" });
							noOfUnknownYearly++;
						}
	
						publicationItem.append( timelineDot );
	
						<#-- timeline container -->
						var timelineItem = $( '<div/>' ).addClass( "timeline-item" );
							
						<#-- timeline time -->
						var timelineTime = 
							$( '<span/>' ).addClass( "time" ).css({ "width":"128px","padding":"0 0 0 10px" });
								
						if( typeof item.date !== 'undefined' )
							timelineTime.append( "Published: " + $.PALM.utility.parseDateType1( item.date ));
						
						if( typeof item.date !== 'undefined' && typeof item.cited !== 'undefined' && item.cited > 0)
							timelineTime.append( "<br>");
							
						if( typeof item.cited !== 'undefined' && item.cited > 0){
							var citedByNumber = "Cited by: " + item.cited;
							if( typeof item.citedUrl !== "undefined" )
								citedByNumber = $( '<span/>' )
												.append( "Cited by: " )
												.append(
													$( '<span/>' )
													.addClass( "urlstyle" )
													.html( item.cited )
													.click( function( event ){ event.preventDefault();window.open( item.citedUrl, "link to citation list" ,'scrollbars=yes,width=650,height=500')})
												)
							timelineTime.append( citedByNumber );
						}
						
						timelineItem.append( timelineTime );
						
						<#-- clean non alpha numeric from title -->
						var cleanTitle = item.title.replace(/[^\w\s]/gi, '');
						
						<#-- timeline header -->
						var timelineHeader = $( '<h3/>' )
							.addClass( "timeline-header" )
							.append( "<strong><a href='<@spring.url '/publication' />?id=" + item.id + "&title=" + cleanTitle +"'>" + item.title + "</a></strong>" );
						timelineItem.append( timelineHeader );
	
						<#-- timeline body -->
						var timelineBody = $( '<div/>' ).addClass( "timeline-body" );
	
						if( typeof item.coauthor !== 'undefined' ){
							
							<#-- authors -->
							var timeLineAuthor = $( '<div/>' );
	
							$.each( item.coauthor, function( index, authorItem ){
								var eachAuthor = $( '<span/>' );
								
								<#-- photo -->
								<#--
								var eachAuthorImage = null;
								if( typeof authorItem.photo !== 'undefined' ){
									eachAuthorImage = $( '<img/>' )
										.addClass( "timeline-author-img" )
										.attr({ "width":"40px" , "src" : authorItem.photo , "alt" : authorItem.name });
								} else {
									eachAuthorImage = $( '<i/>' )
										.addClass( "fa fa-user bg-aqua" )
										.attr({ "title" : authorItem.name });
								}
								eachAuthor.append( eachAuthorImage );
								-->
								<#-- name -->
								
								var eachAuthorName;
								if( authorItem.isAdded ){
									eachAuthorName = $( '<a/>' ).html( authorItem.name )
										.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name})
								} else{
									<#if currentUser??>
										eachAuthorName = $( '<a/>' ).html( authorItem.name )
											.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name + "&add=yes"})
											.addClass( "text-gray" )
											.attr( "title" , "add " + authorItem.name + " to PALM" );
									<#else>
										eachAuthorName = $( '<span/>' ).html( authorItem.name )
											.addClass( "text-gray" )
											.attr( "title" , "Please log in to add " + authorItem.name + " to PALM" );
									</#if>
									
								}	

													
								if( index > 0 )
									eachAuthor.append( ", " );
								eachAuthor.append( eachAuthorName );
								
								timeLineAuthor.append( eachAuthor );
							});
	
							timelineBody.append( timeLineAuthor );
						}
						<#-- venue -->
						
						if( typeof item.event !== 'undefined' ){
							var eventElem = $( '<div/>' )
											.addClass( 'event-detail font-xs' );
							
												
							var venueText = item.event.name;
							var venueHref = "<@spring.url '/venue' />?eventId=" + item.event.id + "&type=" + item.type.toLowerCase();
							if( typeof item.event.abbr !== "undefined" ){
								venueText += " - " + item.event.abbr;
								venueHref += "&abbr=" + item.event.abbr;
							}
							venueHref += "&name=" + item.event.name.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + item.id ;
							
							<#-- the implementation logic is other way around, but this worked, then just leave it-->
							if( typeof item.event.isGroupAdded !== "undefined" && item.event.isGroupAdded )
								venueHref += "&add=yes";
							
							if( typeof item.volume != 'undefined' ){
								venueText += " (" + item.volume + ")";
								venueHref += "&volume=" + item.volume;
							}
							if( typeof item.date != 'undefined' ){
								venueText += " " + item.date.substring(0, 4);
								venueHref += "&year=" + item.date.substring(0, 4);
							}
							
							var eventPart;
							<#if currentUser??>
								if( item.event.isAdded ){
									eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.html( venueText );
								} else {
									eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.addClass( "text-gray" )
													.html( venueText );
								}
							<#else>
								if( item.event.isAdded ){
									eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.html( venueText );
								} else {
									eventPart = $( '<span/>' )
													.attr({ "title" : "Please log in to add " + venueText + " to PALM" })
													.addClass( "text-gray" )
													.html( venueText );
								}
							</#if>
						
							eventElem.append( eventPart );
							
							
							
							<#-- pages -->
							if( typeof item.pages !== 'undefined' ){
								eventElem.append( " pp. " + item.pages );
							}
		
							timelineBody.append( eventElem );			
						} else if( typeof item.venue !== 'undefined'){
							var eventElem = $( '<div/>' )
											.addClass( 'event-detail font-xs' );
														
							var venueText = item.venue;
							var venueHref = "<@spring.url '/venue' />?type=" + item.type.toLowerCase() + "&name=" + item.venue.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + item.id + "&add=yes";
							
							if( typeof item.volume != 'undefined' ){
								venueText += " (" + item.volume + ")";
								venueHref += "&volume=" + item.volume;
							}
							if( typeof item.date != 'undefined' ){
								venueText += " " + item.date.substring(0, 4);
								venueHref += "&year=" + item.date.substring(0, 4);
							}
							
							var eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.addClass( "text-gray" )
													.html( venueText );
							eventElem.append( eventPart );
							
							<#-- pages -->
							if( typeof item.pages !== 'undefined' ){
								eventElem.append( " pp. " + item.pages );
							}
		
							timelineBody.append( eventElem );
						}
						
					
						<#-- abstract -->
						<#--
						if( typeof item.abstract !== 'undefined' )
							timelineBody.append( '<strong>Abstract</strong><br/>' + item.abstract + '<br/>');
						-->
						<#-- keyword -->
						<#--
						if( typeof item.keyword !== 'undefined' )
							timelineBody.append( '<strong>Keyword</strong><br/>' + item.keyword.replace(/,/g, ', ') + '<br/>');
						-->
						timelineItem.append( timelineBody );
	
						publicationItem.append( timelineItem );
	
						timeLineContainer.append( publicationItem );
					}
				});

				<#-- append everything to  -->
				$("#widget-${wUniqueName} .box-content").append( timeLineContainer );
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