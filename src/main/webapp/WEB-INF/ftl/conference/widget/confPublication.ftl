<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
	</div>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){

		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} .box-content").slimscroll({
			height: "600px",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/venue/publicationList' />",
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
						.addClass( "timeline notatimeline" );

				var timeLineGroupYear = "";

				$.each( data.publications, function( index, item ){
					<#-- timeline group -->
					if( typeof item.date !== 'undefined' ){
						if( timeLineGroupYear !== item.date.substring(0, 4)){
							var liTimeGroup = $( '<li/>' )
											.addClass( "time-label" )
											.append( 
												$( '<span/>' )
												.addClass( "bg-green" )
												.html( data.title + "  " + item.date.substring(0, 4) )
											);
							timeLineContainer.append( liTimeGroup );
						}
						timeLineGroupYear = item.date.substring(0, 4);
					} else {
						if( timeLineGroupYear != null ){
							var liTimeGroup = $( '<li/>' )
											.addClass( "time-label" )
											.append( 
												$( '<span/>' )
												.addClass( "bg-green" )
												.html( "Unknown publications date" )
											);
							timeLineContainer.append( liTimeGroup );

							 timeLineGroupYear = null;
						}
					}

					
					var publicationItem = $( '<li/>' ).attr({ "id":"p" + item.id });

					<#-- timeline mark -->
					var timelineDot = $( '<i/>' );
					if( typeof item.type !== 'undefined'){
						if( item.type == "JOURNAL" ){
							timelineDot.addClass( "fa fa-files-o bg-red" );
							timelineDot.attr({ "title" : "Journal" });
						}
						else if( item.type == "CONFERENCE" ){
							timelineDot.addClass( "fa fa-file-text-o bg-blue" );
							timelineDot.attr({ "title" : "Conference" });
						}
						else if( item.type == "BOOK" ){
							timelineDot.addClass( "fa fa-book bg-green" );
							timelineDot.attr({ "title" : "Book" });
						}
						else if( item.type == "WORKSHOP" ){
							timelineDot.addClass( "fa fa-file-text-o bg-blue-dark" );
							timelineDot.attr({ "title" : "Workshop" });
						}
						else if( item.type == "EDITORSHIP" ){
							timelineDot.addClass( "fa fa-book bg-teal" );
							timelineDot.attr({ "title" : "Editorship" });
						}
					}else{
						timelineDot.addClass( "fa fa-question bg-purple" );
							timelineDot.attr({ "title" : "Unknown" });
					}

					publicationItem.append( timelineDot );

					<#-- timeline container -->
					var timelineItem = $( '<div/>' ).addClass( "timeline-item" );
					
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
												.html( venueText );
						eventElem.append( eventPart );
						
						<#-- pages -->
						if( typeof item.pages !== 'undefined' ){
							eventElem.append( " : " + item.pages );
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
												.html( venueText );
						eventElem.append( eventPart );
						
						<#-- pages -->
						if( typeof item.pages !== 'undefined' ){
							eventElem.append( " : " + item.pages );
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
				});

				<#-- append everything to  -->
				$("#widget-${wUniqueName} .box-content").html( timeLineContainer );
				
				<#-- changed scroll position -->
				if( typeof data.publicationId !== "undefined" ){
					var publicationTarget = $("#boxbody${wUniqueName} .box-content").find( "#p" + data.publicationId );
					if( publicationTarget.length > 0 ){
						var scrollTo_val = publicationTarget[0].offsetTop + 'px';
						//console.log( "scroll : " + scrollTo_val );
						$("#boxbody${wUniqueName} .box-content").slimscroll({
							scrollTo : scrollTo_val
						});
						// add highlight effect
						$( publicationTarget ).effect("highlight", {}, 3000);
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