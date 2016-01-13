<div id="boxbody${wId}" class="box-body">
	<div class="box-content">
	</div>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){

		<#-- add slimscroll to widget body -->
		$("#boxbody${wId} .box-content").slimscroll({
			height: "600px",
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
				if( data.status != "ok"){
					alert( "error on publication list" );
					return false;
				}
				if ( typeof data.publications === 'undefined') {
					alert( "error, no publication found" );
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
							$( '<span/>' ).addClass( "time" ).css({ "width":"114px","padding":"0 0 0 10px" });
								
						if( typeof item.date !== 'undefined' )
							timelineTime.append( "Published: " + $.PALM.utility.parseDateType1( item.date ));
						
						if( typeof item.date !== 'undefined' && typeof item.cited !== 'undefined' && item.cited > 0)
							timelineTime.append( "<br>");
							
						if( typeof item.cited !== 'undefined' && item.cited > 0)
							timelineTime.append( "Cited by: " + item.cited);
						
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
								var eachAuthorName = $( '<a/>' )
													.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name})
													.html( authorItem.name );
													
								<#-- check whether author is added -->
								if( !authorItem.isAdded ){
									eachAuthorName.addClass( "text-gray" );
									eachAuthorName.attr( "title" , "add " + authorItem.name + " to PALM" );
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
							var venueHref = "<@spring.url '/venue' />?eventId=" + item.event.id + "&type=" + item.type.toLowerCase() + "&name=" + item.event.name.toLowerCase().replace(/[^\w\s]/gi, '');
							
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
							
							if( item.event.isAdded ){
								eventPart.removeClass( "text-gray" );
							}
							
							<#-- pages -->
							if( typeof item.pages !== 'undefined' ){
								eventElem.append( " pp. " + item.pages );
							}
		
							timelineBody.append( eventElem );			
						} else if( typeof item.venue !== 'undefined'){
							var eventElem = $( '<div/>' )
											.addClass( 'event-detail font-xs' );
														
							var venueText = item.venue;
							var venueHref = "<@spring.url '/venue' />?type=" + item.type.toLowerCase() + "&name=" + item.venue.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + item.id ;
							
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
				$("#widget-${wId} .box-content").html( timeLineContainer );
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