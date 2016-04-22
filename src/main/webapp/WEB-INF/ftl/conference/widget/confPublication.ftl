<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
	</div>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
	
		$.PALM.callout.generate( $("#widget-${wUniqueName} .box-content") , "normal", "Click conference year/volume to show publication list", "" );

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
				var mainContainer = $("#widget-${wUniqueName} .box-content");
				mainContainer.html( "" ); 
				<#-- check for error  -->
				if( data.status != "ok"){
					<#--alert( "error on publication list" );-->
					$.PALM.callout.generate( mainContainer , "warning", "Empty Publications !", "An error occured when accesing server" );
					return false;
				}
				
				
				var filterContainer = $( '<div/>' )
										.css({'width':'100%','margin':'0 10px 15px 0'})
										.addClass( "pull-left" )
										
				var filterSearch = $( '<div/>' )
									.addClass( "input-group" )
									.css({'width':'100%'})
									.append(
										$( '<input/>' )
										.attr({'type':'text', 'id':'publist-search', 'class':'form-control input-sm pull-right'})
										.keyup(function(e){
										    if(e.keyCode == 13)
										    {
											    var thisWidget = $.PALM.boxWidget.getByUniqueName( '${wUniqueName}' ); 
						
												<#-- find keyword if any -->
												var keywordText = filterSearch.find( "#publist-search" ).val();
												//if( typeof keywordText !== "undefined" && keywordText !== "")
												thisWidget.options.queryString = "?id=" + data.event.id + "&query=" + keywordText;
												<#-- add overlay -->
												thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
												$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
										    }
										 })
									)
									.append(
										$( '<div/>' )
										.attr({'id':'publist-search-button-cont', 'class':'input-group-btn', 'title':'Will automatically search for all ' + data.event.name + '\'s publications'})
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
											thisWidget.options.queryString = "?id=" + data.event.id + "&query=" + keywordText;
											<#-- add overlay -->
											thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
											$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
										} )
									)
									
				var filterYear = $( '<div/>' ).attr({'class':'btn-group','data-toggle':'buttons'});
				if( typeof data.query !== "undefined" ){
					filterYear.append( $( "<label/>" )
									.attr({ "class":"btn btn-default btn-xs active" })
									.append(
										$( "<input/>" )
										.attr({ "type":"radio", "id":"year-query", "name":"filteryear", "value":data.query , "data-link": "?id=" + data.event.id + "query=" + data.query, "checked": true})
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
				
				
				<#-- append filter -->
				filterContainer.append( filterSearch );
				filterContainer.append( filterYear );
				mainContainer.append( filterContainer );
				
				filterSearch.find( "#publist-search" ).focus();
				
				if ( typeof data.publications === 'undefined') {
					<#--alert( "error, no publication found" );-->
					if( typeof data.query === "undefined" || data.query == "" )
						$.PALM.callout.generate( mainContainer , "warning", "Empty Publications!", "Currently no publications found on PALM database" );
					else
						$.PALM.callout.generate( mainContainer , "warning", "Empty search result!", "No publications found with query \"" + data.query + "\"" );
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
												.html( data.event.title + "  " + item.date.substring(0, 4) )
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
						else if( item.type == "INFORMAL" ){
							timelineDot.addClass( "fa fa-file-text-o bg-gray" );
							timelineDot.attr({ "title" : "Informal/other publication" });
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
					
					<#-- load more button -->
					if( item.contentExist ){
						<#-- put container abstract and keywords -->
						var abstractSection = $( '<div/>' ).addClass("abstractSection");
						timelineBody.append( abstractSection );
						
						var keywordSection = $( '<div/>' ).addClass("keywordSection");
						timelineBody.append( keywordSection );
						
						var loadMoreButton = $( '<div/>' )
										.addClass( 'btn btn-default btn-xxs font-xs pull-right' )
										.attr({ "data-load" : "false"})
										.html( "load more" )
										.click( function(){
											if( $( this ).attr( "data-load") == "false" ){
												var _this = this;
												 $( this )
												 	.attr( "data-load", "true" )
												 	.html( "load less" );
												 <#-- load ajax keyword and abstract -->
												$.get( "<@spring.url '/publication/detail' />?id=" + item.id + "&section=abstract-keyword" , function( data2 ){
													if( typeof data2.publication.abstract !== "undefined" )
														$(_this).parent().find( ".abstractSection").html( data2.publication.abstract );
													if( typeof data2.publication.keyword !== "undefined" )
														$(_this).parent().find( ".keywordSection").html( data2.publication.keyword );
												});
											} else{
												if( $( this ).text() == "load less" ){
													$( this ).parent().find( ".abstractSection").hide();
													$( this ).parent().find( ".keywordSection").hide();
													$( this ).html( "load more" );
												} else {
													$( this ).parent().find( ".abstractSection").show();
													$( this ).parent().find( ".keywordSection").show();
													$( this ).html( "load less" );
												}
											}
										});
										
						timelineBody.append( loadMoreButton );
					}
						
					<#-- venue -->
					
					if( typeof item.event !== 'undefined' ){
						var eventElem = $( '<div/>' )
										.addClass( 'event-detail font-xs' );
													
						var venueText = item.event.name;
						var venueHref = "<@spring.url '/venue' />?eventId=" + item.event.id + "&type=" + item.type.toLowerCase() + "&name=" + item.event.name.replace(/[^\w\s]/gi, '');
						
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
				mainContainer.append( timeLineContainer );
				
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