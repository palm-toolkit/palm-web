<div id="boxbody${wUniqueName}" class="box-body no-padding">
  	<div class="content-list">
    </div>
</div>

<script>
	$( function(){
		
		<#-- add slim scroll -->
	      $("#boxbody${wUniqueName}>.content-list").slimscroll({
				height: "500px",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
	
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/user/bookmark/publication' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){

							var publicationListContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous result -->
							publicationListContainer.html( "" );
							
							if( data.count > 0 ){
							
								<#-- build the publication table -->
								$.each( data.publications, function( index, itemPublication ){

									var publicationItem = 
										$('<div/>')
										.addClass( "publication" )
										.attr({ "data-id": itemPublication.id });
										
									<#-- publication menu -->
									var pubNav = $( '<div/>' )
										.attr({'class':'nav'});
						
									<#-- publication icon -->
									var pubIcon = $('<i/>');
									if( typeof itemPublication.type !== "undefined" ){
										if( itemPublication.type == "Conference" )
											pubIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemPublication.type == "Journal" )
											pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemPublication.type == "Book" )
											pubIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
									}else{
										pubIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown publication type" });
									}
									
									pubNav.append( pubIcon );
									
									publicationItem.append( pubNav );

									<#-- publication detail -->
									var pubDetail = $('<div/>').addClass( "detail" );
									<#-- title -->
									var pubTitle = $('<div/>').addClass( "title" ).html( itemPublication.title );

									<#--author-->
									var pubAuthor = $('<div/>').addClass( "author" );
									$.each( itemPublication.authors , function( index, itemAuthor ){
										if( index > 0)
											pubAuthor.append(", ");
										pubAuthor.append( itemAuthor.name );
									});

									<#-- append detail -->
									pubDetail.append( pubTitle );
									pubDetail.append( pubAuthor );
									
									
									if( typeof itemPublication.event !== 'undefined' ){
										var eventElem = $( '<div/>' )
														.addClass( 'event-detail font-xs' );
										
															
										var venueText = itemPublication.event.name;
										
										if( typeof itemPublication.volume != 'undefined' ){
											venueText += " (" + itemPublication.volume + ")";
										}
										if( typeof itemPublication.date != 'undefined' ){
											venueText += " " + itemPublication.date.substring(0, 4);
										}
										
										var eventPart = $( '<span/>' )
																.html( venueText );
										eventElem.append( eventPart );
										
										if( itemPublication.event.isAdded ){
											eventPart.removeClass( "text-gray" );
										}
										
										<#-- pages -->
										if( typeof itemPublication.pages !== 'undefined' ){
											eventElem.append( " pp. " + itemPublication.pages );
										}
					
										pubDetail.append( eventElem );			
									} else if( typeof itemPublication.venue !== 'undefined'){
										var eventElem = $( '<div/>' )
														.addClass( 'event-detail font-xs' );
																	
										var venueText = itemPublication.venue;
										
										if( typeof itemPublication.volume != 'undefined' ){
											venueText += " (" + itemPublication.volume + ")";
										}
										if( typeof itemPublication.date != 'undefined' ){
											venueText += " " + itemPublication.date.substring(0, 4);
										}
										
										var eventPart = $( '<span/>' )
																.addClass( "text-gray" )
																.html( venueText );
										eventElem.append( eventPart );
										
										<#-- pages -->
										if( typeof itemPublication.pages !== 'undefined' ){
											eventElem.append( " pp. " + itemPublication.pages );
										}
					
										pubDetail.append( eventElem );
									}
									
									<#-- append to item -->
									publicationItem.append( pubDetail );

									<#-- add click event -->
									pubDetail.on( "click", function(){
										window.location.href = "<@spring.url '/publication' />?id=" + itemPublication.id + "&title=" + itemPublication.title;
									});

									publicationListContainer.append( publicationItem );
								
								});
								
								<#-- $( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );-->
							}
							else{
								$.PALM.callout.generate( publicationListContainer, "warning", "Empty Bookmark !", "No Conference/Journal bookmarked" );
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
		
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
	});
</script>