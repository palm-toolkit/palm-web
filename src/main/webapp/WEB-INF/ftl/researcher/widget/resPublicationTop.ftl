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
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/publicationTopList' />",
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

				<#-- no publication found -->
				if ( typeof data.publications === 'undefined') {
					$("#widget-${wUniqueName} .box-content").append( "<strong>error, no publication found/match</strong>" );
					return false;
				}

				var timeLineContainer = 
					$( '<ul/>' )
						.addClass( "timeline notatimeline" );

				var timeLineGroupYear = "";
				
				<#-- timeline group -->
				var liTimeGroup;
					
				$.each( data.publications, function( index, item ){

					if( typeof item.title !== "undefined" ){
					
						var publicationItem = $( '<li/>' );
	
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
							else if( item.type == "WORKSHOP" ){
								timelineDot.addClass( "fa fa-file-text-o bg-blue-dark" );
								timelineDot.attr({ "title" : "Workshop" });
							}
							else if( item.type == "BOOK" ){
								timelineDot.addClass( "fa fa-book bg-green" );
								timelineDot.attr({ "title" : "Book" });
							}
						}else{
							timelineDot.addClass( "fa fa-question bg-purple" );
							timelineDot.attr({ "title" : "Unknown" });
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
							
							if( typeof item.event.isGroupAdded === "undefined" || !item.event.isGroupAdded )
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
							
							venueHref += "&add=yes";
							
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