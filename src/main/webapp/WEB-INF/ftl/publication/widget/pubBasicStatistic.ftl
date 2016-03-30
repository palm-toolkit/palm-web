<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	<form role="form" action="<@spring.url '/publication' />" method="post">
	</form>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		<#--
		$("#boxbody${wUniqueName} form").slimscroll({
			height: "250px",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });
		-->
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/publication/basicInformation' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				targetContainer.html( "" );
				
				<#if currentUser??>
					if( !data.booked ){
	                	var butBook = $( "<a/>" )
	                					.attr({
	                						"class":"btn btn-block btn-social btn-twitter btn-sm width110px pull-right",
	                						"onclick":"$.PALM.bookmark.publication( $( this ), '${currentUser.id}', '" + data.publication.id + "' )",
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
	                						"class":"btn btn-block btn-social btn-twitter active btn-sm width110px pull-right",
	                						"onclick":"$.PALM.bookmark.publication( $( this ), '${currentUser.id}', '" + data.publication.id + "' )",
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
				
				if( typeof data.publication !== "undefined" ){
						targetContainer.append(
											$( '<dt/>' ).html( "Title:" )
										)
										.append(
											$( '<dd/>' ).html( data.publication.title )
										);
				
				
					if( typeof data.publication.authors !== 'undefined' ){
							
						<#-- authors -->
						var authorsHeader = $( '<dt/>' ).html( "Authors:" )
						var authorsBody = $( '<dd/>' );

						$.each( data.publication.authors , function( index, authorItem ){
							var eachAuthor = $( '<span/>' );
							
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
							
							authorsBody.append( eachAuthor );
						});

						targetContainer.append( authorsHeader ).append( authorsBody );
					}
						
						
					if( typeof data.publication.date !== "undefined" ){
						targetContainer.append(
											$( '<dt/>' ).html( "Published:" )
										)
										.append(
											$( '<dd/>' ).html( $.PALM.utility.parseDateType1( data.publication.date ) )
										);
					}
					
					if( typeof data.publication.type !== "undefined" || 
						typeof data.publication.event !== 'undefined' ||
						typeof data.publication.venue !== 'undefined' ){
					
						var venueLabel = "Venue";
						if( typeof data.publication.type !== "undefined" )
							venueLabel = data.publication.type;
							
						var venueLabelObj = $( '<dt/>' ).addClass( "capitalize" ).html( data.publication.type + ":" )
						var venueBodyObj = $( '<dd/>' );
						targetContainer.append( venueLabelObj ).append( venueBodyObj );
						
						
						<#-- venue -->
						if( typeof data.publication.event !== 'undefined' ){
							var eventElem = $( '<div/>' )
											.addClass( 'event-detail' );
							
												
							var venueText = data.publication.event.name;
							var venueHref = "<@spring.url '/venue' />?eventId=" + data.publication.event.id + "&type=" + data.publication.type.toLowerCase() + "&name=" + data.publication.event.name.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + data.publication.id;
							
							if( typeof data.publication.event.isGroupAdded === "undefined" || !data.publication.event.isGroupAdded )
								venueHref += "&add=yes";
								
							if( typeof data.publication.volume != 'undefined' ){
								venueText += " (" + data.publication.volume + ")";
								venueHref += "&volume=" + data.publication.volume;
							}
							if( typeof data.publication.date != 'undefined' ){
								venueText += " " + data.publication.date.substring(0, 4);
								venueHref += "&year=" + data.publication.date.substring(0, 4);
							}
							
							var eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.addClass( "text-gray" )
													.html( venueText );
							eventElem.append( eventPart );
							
							if( data.publication.event.isAdded ){
								eventPart.removeClass( "text-gray" );
							}
							
							<#-- pages -->
							if( typeof data.publication.pages !== 'undefined' ){
								eventElem.append( " pp. " + data.publication.pages );
							}
		
							venueBodyObj.append( eventElem );			
						} else if( typeof data.publication.venue !== 'undefined'){
							var eventElem = $( '<div/>' )
											.addClass( 'event-detail' );
														
							var venueText = data.publication.venue;
							var venueHref = "<@spring.url '/venue' />?type=" + data.publication.type.toLowerCase() + "&name=" + data.publication.venue.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + data.publication.id ;
							
							if( typeof data.publication.volume != 'undefined' ){
								venueText += " (" + data.publication.volume + ")";
								venueHref += "&volume=" + data.publication.volume;
							}
							if( typeof data.publication.date != 'undefined' ){
								venueText += " " + data.publication.date.substring(0, 4);
								venueHref += "&year=" + data.publication.date.substring(0, 4);
							}
							
							venueHref += "&add=yes";
							
							var eventPart = $( '<a/>' )
													.attr({ "href" : venueHref })
													.addClass( "text-gray" )
													.html( venueText );
							eventElem.append( eventPart );
							
							<#-- pages -->
							if( typeof data.publication.pages !== 'undefined' ){
								eventElem.append( " pp. " + data.publication.pages );
							}
		
							venueBodyObj.append( eventElem );
						}
						
					}

					if( typeof data.publication.publisher != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Publisher:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.publisher )
						);
					} 
					if( typeof data.publication.cited != "undefined"){
						var citedByNumber = data.publication.cited;
						if( typeof data.publication.citedUrl !== "undefined" )
							citedByNumber = $( '<span/>' )
												.addClass( "urlstyle" )
												.html( data.publication.cited )
												.click( function( event ){ event.preventDefault();window.open( data.publication.citedUrl, "link to citation list" ,'scrollbars=yes,width=650,height=500')});
						targetContainer.append(
							$( '<dt/>' ).html( "Cited by:" )
						)
						.append(
							$( '<dd/>' ).html( citedByNumber )
						);
					}
					if( typeof data.publication.language != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Language:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.language )
						);
					}
					<#-- Academic Networks -->
					if( typeof data.publication.sources!= "undefined"){
						var onAcademicNetwork = $( '<dd/>' );
						$.each( data.publication.sources , function( index, sourceItem ){							
							onAcademicNetwork.append( 
								$( '<div/>' )
									.addClass( "nowarp urlstyle" )
									.attr( "title", sourceItem.source + " - " + sourceItem.url)
									.html( "<i class='fa fa-globe'></i> " + sourceItem.source + " - " + sourceItem.url)
									.click( function( event ){ event.preventDefault();window.open( sourceItem.url, sourceItem.source ,'scrollbars=yes,width=650,height=500')})
							);
						});
						
						targetContainer
							.append( $( '<dt/>' ).html( "On Academic Networks:" ).css("margin-top","15px") )
							.append( onAcademicNetwork);
						
					}
					
					<#-- Files -->
					if( typeof data.publication.files!= "undefined"){
						var onDigitalLibraries = $( '<dd/>' );
						$.each( data.publication.files , function( index, fileItem ){
							var iconType = "<i class='fa fa-globe'></i> ";
							if( fileItem.type == "PDF" )
								 iconType = "<i class='fa fa-file-pdf-o'></i> ";
							var label = "";
							if( typeof fileItem.type  != "undefined" )
								label = fileItem.type;
							else
								label = fileItem.type + " file";
														
							onDigitalLibraries.append( 
								$( '<div/>' )
									.addClass( "nowarp urlstyle" )
									.attr( "title", label)
									.html( iconType + fileItem.url)
									.click( function( event ){ event.preventDefault();window.open( fileItem.url, label ,'scrollbars=yes,width=650,height=500')})
							);
						});
						
						targetContainer
							.append( $( '<dt/>' ).html( "Other Sources:" ).css("margin-top","15px") )
							.append( onDigitalLibraries );
						
					}
				}
				else
					targetContainer.html( $( '<dl/>' ).append( $( '<dt/>' ).html( "No information available" ) ) );
					
				var butBibtex = $( "<a/>" )
        					.attr({
        						"class":"btn btn-block btn-default btn-sm pull-right",
        						"style":"width:80px"
        						})
        					.append(
        						"<strong>BibTeX</strong>"
        					)
							.click( function( event ){
								event.preventDefault();
								$.PALM.popUpIframe.create( "<@spring.url '/publication/bibtexview' />?id=" + data.publication.id , {}, "BibTeX & Cite" );
							});

				targetContainer.append( butBibtex );
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