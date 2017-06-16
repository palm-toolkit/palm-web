$.publicationList = {};
$.publicationList.variables = {
		widgetUniqueName : undefined,
		currentURL 	  	 : undefined,
		isUserLogged 	 : undefined,
		data		 	 : undefined,
		yearFilterRequest: null,
		height			 : 0
};

$.publicationList.init = function( status, widgetUniqueName, currentURL, isUserLogged, height ){
	$.publicationList.variables.widgetUniqueName = widgetUniqueName;
	$.publicationList.variables.currentURL 	     = currentURL;
	$.publicationList.variables.isUserLogged 	 = isUserLogged;
	$.publicationList.variables.height			 = height;

	$("#widget-" + widgetUniqueName + " .visualization-details" ).height( height );
	
	var mainContainer = $("#publications-box-" + widgetUniqueName + " .box-content");
	
	mainContainer.css({"max-height":  + height + "px", "height":"100%"});
	
	mainContainer.html( "" );
};

$.publicationList.visualize = function( mainContainer, data){
	$.publicationList.variables.data = data;
	mainContainer.append( $.publicationList.visualize.filter( data ) );
	
	if( data.status != "ok"){
		
		if ( typeof data.publications === 'undefined') {
			if( typeof data.query === "undefined" || data.query == "" )
				$.PALM.callout.generate( mainContainer , "warning", "Empty Publications!", "Currently no publications found on PALM database" );
			else
				$.PALM.callout.generate( mainContainer , "warning", "Empty search result!", "No publications found with query \"" + data.query + "\"" );
			return false;
		}
		
		if ( typeof data.publications === 'undefined') {
			$.PALM.callout.generate( mainContainer , "warning", "Empty Publications !", "Researcher does not have any publication on PALM" );
			return false;
		}
		$.PALM.callout.generate( mainContainer , "warning", "Empty Publications !", "Researcher does not have any publication on PALM database" );
		return false;
	}
	
	mainContainer.append( $.publicationList.visualize.publications ( data ) );
};

$.publicationList.visualize.filter =  function( data ){
	var filterContainer = $( '<div/>' ).addClass( "pull-left" )
		.css({'width':'100%','margin':'0 10px 15px 0'});
	filterContainer.append( $.publicationList.visualize.filter.search( { element : data.element, query : data.query } ) );
	filterContainer.append( $.publicationList.visualize.filter.year( {element: data.element, totalPublication : data.totalPublication, years: data.years, query: data.query, count : data.count} ) );
	filterContainer.append( $.publicationList.visualize.filter.keyword( data ) );

	return filterContainer;
};

$.publicationList.visualize.filter.search = function( data ){
	var filterSearch = $( '<div/>' ).addClass( "input-group" )
		.css({'width':'100%'});
	
	var publistSearch = $( '<input/>' ).attr({'type':'text', 'id':'publist-search', 'class':'form-control input-sm pull-right'});
//				.keyup(function(e){
//					if(e.keyCode == 13){
//						var thisWidget = $.PALM.boxWidget.getByUniqueName( $.publicationList.variables.widgetUniqueName ); 
//						// find keyword if any 
//						var keywordText = filterSearch.find( "#publist-search" ).val();
//							
//						thisWidget.options.queryString = "?id=" + data.element.id + "&year=all&query=" + keywordText;			
//						thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
//						$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
//					}
//				});
	
	var buttonSearch = $( '<div/>' ).attr({'id':'publist-search-button-cont', 'class':'input-group-btn', 'title':'Will automatically search for all ' + data.element.name + '\'s publications'})
				.append( $( '<button/>' ).attr({'id':'publist-search-button', 'class':'btn btn-sm btn-default'})
				.append( $( '<i/>' ).attr({'class':'fa fa-search'}) ) );
//	buttonSearch.on( "click", function(){
//		var thisWidget = $.PALM.boxWidget.getByUniqueName( $.publicationList.variables.widgetUniqueName ); 
//		// find keyword if any
//		var keywordText = filterSearch.find( "#publist-search" ).val();
//
//		thisWidget.options.queryString = "?id=" + data.element.id + "&year=all&query=" + keywordText;
//		// add overlay 
//		thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
//		$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
//	} ); 
	
	if (data.query != undefined && data.query != "")
			publistSearch.val( data.query );
	
	filterSearch.append( publistSearch );
	filterSearch.append( buttonSearch );	

	return filterSearch;
}

$.publicationList.visualize.filter.year = function ( data ){
	var filterYear = $( '<div/>' ).attr({'class':'btn-group','data-toggle':'buttons'});
	
	filterYear.append( createYearContainer( "btn btn-default btn-xs", "year-all", "all", "?id=" + data.element.id + "&year=all", false, "all (" + data.totalPublication + ")") )
			  .append( createYearContainer( "btn btn-default btn-xs", "maxresult-10", "maxresult10", "?id=" + data.element.id + "&maxresult=10", false, "recent (10)") );
	
	if ( data.years != null){
		$.each( data.years, function( index, item ){
			filterYear.append( createYearContainer( "btn btn-default btn-xs", "year-" + item, item, "?id=" + data.element.id + "&year=" + item, false, item) );
		});
	}
	
	if( typeof data.query !== "undefined" && data.query.trim().length > 0){
		filterYear.append( createYearContainer( "btn btn-default btn-xs active", "year-query", data.query, "?id=" + data.element.id + "query=" + data.query, true, data.query + "(" + data.count + ")") );
	}
	
	var thisWidget = $.PALM.boxWidget.getByUniqueName( $.publicationList.variables.widgetUniqueName ); 		
	
	// find active option 
	var currentQueryArray = thisWidget.options.queryString.split( "&" );
	$.each( currentQueryArray , function( index, partQuery){
		if( partQuery.lastIndexOf( 'year', 0) === 0 && ( typeof data.query === "undefined" || data.query == ""))
			filterYear.find( "#" + partQuery.replace( "=","-") ).prop("checked", true).parent().addClass( "active" );
		else if( partQuery.lastIndexOf( 'maxresult', 0) === 0 )
			filterYear.find( "#" + partQuery.replace( "=","-") ).prop("checked", true).parent().addClass( "active" );			
	}); 
	
	// assign click functionality to year filter 
	filterYear.on( "change", "input", function(e){		
		var vars 		= $.publicationList.variables;
		var thisWidget  = $.PALM.boxWidget.getByUniqueName( vars.widgetUniqueName ); 
		var queryString = $( this ).data( "link" );
		
		var queryKeywordsStr = ""; 
		var currentQueryArray = thisWidget.options.queryString.split( "&" );
		$.each( currentQueryArray , function( index, partQuery){
			if( partQuery.lastIndexOf( 'queryKeywords', 0) === 0 ){
				queryString += "&" + partQuery;	
				queryKeywordsStr = partQuery.substring(14, partQuery.length)
			}
		}); 
		
		thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).find(".overlay").remove();
		thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
		
		if ( vars.yearFilterRequest != null)
			vars.yearFilterRequest.abort();
		
		thisWidget.options.queryString = queryString;
		
		vars.yearFilterRequest = $.get( vars.currentURL + "/researcher/publicationList" + queryString , function( response ){
			var mainContainer = $("#publications-box-" + vars.widgetUniqueName + " .box-content");
			//****
			var keywordText = thisWidget.element.find("#publist-search").val() || "";
			response.queryKeywords = queryKeywordsStr.split(",");
			response.query = keywordText;
			for (var i = 0 ; i < response.publications.length; i++){
				if ( i % 2 == 0 && i % 3 == 0)
					response.publications[i].keyword = [ queryKeywordsStr.split(",")[0] ];
				else
					if ( i % 2 == 0 )
						response.publications[i].keyword = [ queryKeywordsStr.split(",")[1] ];
					else
						response.publications[i].keyword = [ queryKeywordsStr.split(",")[0], queryKeywordsStr.split(",")[1] ];
			}
			//****
			$.publicationList.init( response.status, vars.widgetUniqueName, vars.currentURL, vars.isUserLogged, vars.height );
			$.publicationList.visualize( mainContainer, response);
			
			thisWidget.element.find( "#publications-box-" + vars.widgetUniqueName ).find(".overlay").remove();
			vars.yearFilterRequest = null;
		});
	});

	return filterYear;
	
	function createYearContainer( className, inputID, inputValue, data_link, checked, text){
		return $( "<label/>" ).attr({ "class": className })
			.append( $( "<input/>" ).attr({ "type":"radio", "id":inputID, "name":"filteryear", "value":inputValue , "data-link": data_link, "checked": checked}) )
			.append( text );
	}
}

$.publicationList.visualize.filter.keyword = function ( data ){
	var filterKeyword = $( '<div/>' ).attr({'class':'btn-group','data-toggle':'buttons'})
			.css({'display':'block'});
	
	if ( data.queryKeywords == undefined || data.queryKeywords.length == 0){
		return ;
	}
	
	$.each( data.queryKeywords, function( index, item ){
		filterKeyword.append( createKeywordContainer( "btn btn-default btn-xs active", "keyword-" + item, item, "?id=" + data.element.id + "&keyword=" + item, true, item) );
	});
	
	// assign click functionality to year filter 
	filterKeyword.on( "change", "input[type=checkbox]", function(e){
		var thisWidget = $.PALM.boxWidget.getByUniqueName( $.publicationList.variables.widgetUniqueName ); 		
			thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
		
		var checked_keywords = $(this).parents(".btn-group").find("input:checked");	
		
		var data = jQuery.extend(true, {}, $.publicationList.variables.data);
		
		if ( data != undefined ){
			var filteredPublications = data.publications;
			var i = 0;
			while ( i <= filteredPublications.length - 1){
				var pub = filteredPublications[i];
				var intersection = checked_keywords.filter( function( ind, input) { return pub.keyword != undefined && pub.keyword.indexOf( input.value ) != -1; })
				if ( intersection.length == 0 ){
					filteredPublications.splice(i, 1);
				}else
					i++;				
			};
				
			data.publications = filteredPublications;
			
			thisWidget.element.find("ul.timeline").remove();	
			thisWidget.element.find(".callout.callout-warning").remove();
			
			if ( typeof data.publications === 'undefined' || data.publications.length == 0) {
					$.PALM.callout.generate( thisWidget.element.find( "#publications-box-" + $.publicationList.variables.widgetUniqueName ) , "warning", "Empty Publications !", "No publication found." );
					thisWidget.element.find( ".overlay" ).remove();
					return false;
			}
				
			thisWidget.element.find(".box-content").append( $.publicationList.visualize.publications( data ) );		
			thisWidget.element.find( ".overlay" ).remove();
		}
	});
	
	return filterKeyword;
	
	function createKeywordContainer( className, inputID, inputValue, data_link, checked, text){
		return $( "<label/>" ).attr({ "class": className })
			.append( $( "<input/>" ).attr({ "type":"checkbox", "id":inputID, "name":"filterkeyword", "value":inputValue , "data-link": data_link, "checked": checked}) )
			.append( text );
	}
}
$.publicationList.visualize.publications = function ( data ){
	var dataCopy = jQuery.extend(true, {}, data);
	
	var timeLineContainer = $( '<ul/>' ).addClass( "timeline" );
	
	var timeLineGroupYear = "";
	var noOf = {			
			conferenceYearly : undefined,
			workshopYearly 	 : undefined,
			journalYearly 	 : undefined,
			bookYearly 		 : undefined,
			informalYearly 	 : undefined,
			unknownYearly 	 : undefined,	
	};
	

	var liTimeGroup;

	// add empty object, to add more loop 
	dataCopy.publications.push( { "date":"endpublication"} );

	$.each( dataCopy.publications, function( index, item ){
		// timeline group  
		var obj = timelineGroup_header( index, item, timeLineContainer, timeLineGroupYear, liTimeGroup, noOf);
		timeLineGroupYear = obj.timeLineGroupYear;
		liTimeGroup 	  = obj.liTimeGroup;
		
		if( typeof item.title !== "undefined" ){
			var publicationItem = $( '<li/>' );
			// timeline mark 
			publicationItem.append( createTimelineDot( item, noOf ) );

			//timeline container 
			var timelineItem = $( '<div/>' ).addClass( "timeline-item" );
			if (item.keyword != undefined && item.keyword.length > 0)
				timelineItem.data("keyword", item.keyword);
			
			timelineItem.append( createTimelineTime( item ) );
			timelineItem.append( createTimelineHeader( item ) );
			timelineItem.append( createTimelineBody( item ) );
			
			publicationItem.append( timelineItem );
			
			timeLineContainer.append( publicationItem );
		}
	});	
	return timeLineContainer;
}

function timelineGroup_header( index, item, timeLineContainer, timeLineGroupYear, liTimeGroup, noOf){
	var marginLeft = 10;
	
	if( typeof item.date !== 'undefined' ){ //timeline HEADERS
		if( timeLineGroupYear !== item.date.substring(0, 4) ){			
			if( typeof liTimeGroup !== "undefined" ){	
				if( noOf.conferenceYearly > 0 || noOf.workshopYearly > 0){
					var noOfPublicationInfo = publicationVenueType( noOf.conferenceYearly, "Conference")
				
					if( noOf.conferenceYearly > 0 && noOf.workshopYearly > 0 )
						noOfPublicationInfo += " & ";
				
					noOfPublicationInfo += publicationVenueType( noOf.workshopYearly, "Workshop");
				
					liTimeGroup.append(  createVenueTypeBox( "bg-blue", marginLeft, noOfPublicationInfo) );		
				}
				if( noOf.journalYearly > 0 ){						
					var noOfPublicationInfo = publicationVenueType( noOf.journalYearly, "Journal");
					liTimeGroup.append( createVenueTypeBox( "bg-red", marginLeft, noOfPublicationInfo) );			
				}
				if( noOf.bookYearly > 0 ){
					var noOfPublicationInfo = publicationVenueType( noOf.bookYearly, "Book");		
					liTimeGroup.append( createVenueTypeBox( "bg-green", marginLeft, noOfPublicationInfo) );
				}
				if( noOf.informalYearly > 0){
					var noOfPublicationInfo = publicationVenueType( noOf.informalYearly, "Informal/Other");
					liTimeGroup.append( createVenueTypeBox( "bg-gray", marginLeft, noOfPublicationInfo) );
				}
				
				var firstTimelineSpan = $( liTimeGroup) .find( "span:first" );
				firstTimelineSpan.html( (noOf.conferenceYearly + noOf.workshopYearly + noOf.journalYearly + noOf.informalYearly + noOf.bookYearly + noOf.unknownYearly ) + " " + firstTimelineSpan.html() );
			} 				
			noOf.conferenceYearly = 0;
			noOf.workshopYearly   = 0;
			noOf.journalYearly 	  = 0;
			noOf.bookYearly 	  = 0;
			noOf.informalYearly   = 0;
			noOf.unknownYearly 	  = 0;

			if( item.date != "endpublication" ){
				liTimeGroup = $( '<li/>' ).addClass( "time-label" )
								.append( $( '<span/>' ).addClass( "bg-green" ).html( "Publications in " + item.date.substring(0, 4) ) );
				timeLineContainer.append( liTimeGroup );
			}
		}
		timeLineGroupYear = item.date.substring(0, 4);
	} else {			
		if( timeLineGroupYear != null ){
			var liTimeGroup2 = $( '<li/>' ).addClass( "time-label" )
								.append( $( '<span/>' ).addClass( "bg-green" ).html( "Unknown publications date" ) );
			timeLineContainer.append( liTimeGroup2 );
			timeLineGroupYear = null;
		}
	}
	
	return {
			timeLineGroupYear : timeLineGroupYear,
			liTimeGroup       : liTimeGroup
		   };
	
	function createVenueTypeBox(className, marginLeft, html){
		return $( '<span/>' ).addClass( className )
					.css({ "margin-left" : marginLeft + "px" })
					.html( html )
	}
	
	function publicationVenueType( noOfDataYearly, venueType){
		var noOfPublicationInfo = "";
		if( noOfDataYearly == 1 )
			noOfPublicationInfo += "1 "  + venueType;
		else
			if( noOfDataYearly > 1 )
				noOfPublicationInfo += noOfDataYearly + " " + venueType + "s";
		return noOfPublicationInfo;
	}
}

function createTimelineDot( item, noOf ){
	var timelineDot = $( '<i/>' );
	if( typeof item.type !== 'undefined'){
		if( item.type == "JOURNAL" ){
			timelineDot.addClass( "fa fa-files-o bg-red" );
			timelineDot.attr({ "title" : "Journal" });
			noOf.journalYearly++;
		}
		else if( item.type == "CONFERENCE" ){
			timelineDot.addClass( "fa fa-file-text-o bg-blue" );
			timelineDot.attr({ "title" : "Conference" });
			noOf.conferenceYearly++;
		}
		else if( item.type == "WORKSHOP" ){
			timelineDot.addClass( "fa fa-file-text-o bg-blue-dark" );
			timelineDot.attr({ "title" : "Workshop" });
			noOf.workshopYearly++;
		}
		else if( item.type == "BOOK" ){
			timelineDot.addClass( "fa fa-book bg-green" );
			timelineDot.attr({ "title" : "Book" });
			noOf.bookYearly++;
		}
		else if( item.type == "INFORMAL" ){
			timelineDot.addClass( "fa fa-file-text-o bg-gray" );
			timelineDot.attr({ "title" : "Informal/other publication" });
			noOf.informalYearly++;
		}
	}else{
		timelineDot.addClass( "fa fa-question bg-purple" );
		timelineDot.attr({ "title" : "Unknown" });
		noOf.unknownYearly++;
	}
	
	return timelineDot;
}

function createTimelineTime( item ){
	var timelineTime = $( '<span/>' ).addClass( "time" ).css({ "width":"128px","padding":"0 0 0 10px" });
			
	if( typeof item.date !== 'undefined' )
		timelineTime.append( "Published: " + $.PALM.utility.parseDateType1( item.date ));
	
	if( typeof item.date !== 'undefined' && typeof item.cited !== 'undefined' && item.cited > 0)
		timelineTime.append( "<br>");
		
	if( typeof item.cited !== 'undefined' && item.cited > 0){
		var citedByNumber = "Cited by: " + item.cited;
		if( typeof item.citedUrl !== "undefined" ){
			citedByNumber = $( '<span/>' )
								.append( "Cited by: " )
								.append( $( '<span/>' ).addClass( "urlstyle" ).html( item.cited )
											.click( function( event ){ 
												event.preventDefault();
												window.open( item.citedUrl, "link to citation list" ,'scrollbars=yes,width=650,height=500'); }) );
		}
		timelineTime.append( citedByNumber );
	}
	return timelineTime;
}

function createTimelineHeader( item ){
	var cleanTitle = item.title.replace(/[^\w\s]/gi, "\\$&"); //clean non alpha numeric from title
	return $( '<h3/>' ).addClass( "timeline-header" )
			.append( "<strong><a href='" + $.publicationList.variables.currentURL + "/publication?id=" + item.id + "&title=" + cleanTitle + "'>" + item.title + "</a></strong>" );

}

function createTimelineBody( item ){
	var timelineBody = $( '<div/>' ).addClass( "timeline-body" );
	if( typeof item.coauthor !== 'undefined' ){
		timelineBody.append( createTimelineBody_authorsSection( item.coauthor ) );
		timelineBody.append( createTimelineBody_loadMoreSection( item ) );
		timelineBody.append( createTimelineBody_venueSection( item ) );	
	}	
	return timelineBody;
}

function createTimelineBody_authorsSection( coauthors ){
	var timeLineAuthor = $( '<div/>' ).addClass("authorSection");

	$.each( coauthors, function( index, authorItem ){
		var eachAuthor = $( '<span/>' );
		var eachAuthorName;
		
		if( authorItem.isAdded ){
			eachAuthorName = $( '<a/>' ).html( authorItem.name ).attr({ "href" : $.publicationList.variables.currentURL + "/researcher?id=" + authorItem.id + "&name=" + authorItem.name});
		}else{
			if ( $.publicationList.variables.isUserLogged )
				eachAuthorName = $( '<a/>' ).html( authorItem.name ).addClass( "text-gray" )
					.attr({ "href" : $.publicationList.variables.currentURL + "/researcher?id=" + authorItem.id + "&name=" + authorItem.name + "&add=yes"})
					.attr( "title" , "add " + authorItem.name + " to PALM" );
			else
				eachAuthorName = $( '<span/>' ).html( authorItem.name ).addClass( "text-gray" )					
					.attr( "title" , "Please log in to add " + authorItem.name + " to PALM" );	
		}	
		
		if( index > 0 )
			eachAuthor.append( ", " );
		
		eachAuthor.append( eachAuthorName );
		
		timeLineAuthor.append( eachAuthor );
	});

	return timeLineAuthor;
}

function createTimelineBody_loadMoreSection( item ){
	var loadMoreSection = $( '<div/>' ).addClass("loadMoreSection");
	if( item.contentExist ){
		// put container abstract and keywords
		var abstractSection = $( '<div/>' ).addClass("abstractSection");
		var keywordSection  = $( '<div/>' ).addClass("keywordSection");
		
		loadMoreSection.append( abstractSection );
		loadMoreSection.append( keywordSection );
		
		var loadMoreButton = $( '<div/>' ).addClass( 'btn btn-default btn-xxs font-xs pull-right' )
			.attr({ "data-load" : "false"})
			.html( "load more" )
			.click( function(){
				if( $( this ).attr( "data-load") == "false" ){ 
					var _this = this;
					$( this ).attr( "data-load", "true" ).html( "load less" );
					
					//load ajax keyword and abstract
					$.get( $.publicationList.variables.currentURL + "/publication/detail?id=" + item.id + "&section=abstract-keyword" , function( response ){
						if( typeof response.publication.abstract !== "undefined" )
							$(_this).parent().find( ".abstractSection").html( response.publication.abstract );
						if( typeof response.publication.keyword !== "undefined" )
							$(_this).parent().find( ".keywordSection").html( response.publication.keyword );
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
						
		loadMoreSection.append( loadMoreButton );
	}
	return loadMoreSection;
}

function createTimelineBody_venueSection( item ){
	var eventElem = $( '<div/>' ).addClass( 'event-detail font-xs' );
	if( typeof item.event !== 'undefined' ){					
		var venueText = item.event.name;
		var venueHref = $.publicationList.variables.currentURL+ "/venue?eventId=" + item.event.id + "&type=" + item.type.toLowerCase();
		
		if( typeof item.event.abbr !== "undefined" ){
			venueText += " - " + item.event.abbr;
			venueHref += "&abbr=" + item.event.abbr;
		}
		venueHref += "&name=" + item.event.name.replace(/[^\w\s]/gi, '') + "&publicationId=" + item.id ;
		
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
		if ( $.publicationList.variables.isUserLogged ){
			if( item.event.isAdded ){
				eventPart = $( '<a/>' )
								.attr({ "href" : venueHref })
								.html( venueText );
			} else {
				eventPart = $( '<a/>' ).addClass( "text-gray" )
								.attr({ "href" : venueHref })							
								.html( venueText );
			}
		}else {
			if( item.event.isAdded ){
				eventPart = $( '<a/>' )
								.attr({ "href" : venueHref })
								.html( venueText );
			} else {
				eventPart = $( '<span/>' ).addClass( "text-gray" )
								.attr({ "title" : "Please log in to add " + venueText + " to PALM" })
								.html( venueText );
			}
		}	
		eventElem.append( eventPart );
	} else {
		if( typeof item.venue !== 'undefined'){
			var venueText = item.venue;
			var venueHref = $.publicationList.variables.currentURL + "/venue?type=" + item.type.toLowerCase() + "&name=" + item.venue.replace(/[^\w\s]/gi, '') + "&publicationId=" + item.id + "&add=yes";

			if( typeof item.volume != 'undefined' ){
				venueText += " (" + item.volume + ")";
				venueHref += "&volume=" + item.volume;
			}
			
			if( typeof item.date != 'undefined' ){
				venueText += " " + item.date.substring(0, 4);
				venueHref += "&year=" + item.date.substring(0, 4);
			}

			venueHref += "&add=yes";

			var eventPart = $( '<a/>' ).addClass( "text-gray" )
					.attr({ "href" : venueHref })
					.html( venueText );
			
			eventElem.append( eventPart );
		}
	}
	//pages
	if( typeof item.pages !== 'undefined' ){
		eventElem.append( " pp. " + item.pages );
	}
	return eventElem;
}
