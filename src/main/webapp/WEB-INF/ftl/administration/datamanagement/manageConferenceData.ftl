<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="conference_search_field" name="conference_search_field" 
	      class="form-control input-sm pull-right" value="<#if targetName??>${targetName!''}</#if>" placeholder="Search conference/journal on database">
	      <div id="conference_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
  	</div>
  	
	<div class="content-list">
    </div>
    
    
</div>

<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="conferencePaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">20</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying conferences 1 - 50 of 462</span>
	</div>
</div>

<script>
	$( function(){
	    <#-- add conference object -->
		var eventObj = {};
		<#if targetId??>
			eventObj.id = "${targetId!''}";
		</#if>
		<#if targetEventId??>
			eventObj.eventId = "${targetEventId!''}";
		</#if>
		<#if targetName??>
			eventObj.name = "${targetName!''}";
		</#if>
		<#if targetNotation??>
			eventObj.notation = "${targetNotation!''}";
		</#if>
		<#if targetType??>
			eventObj.type = "${targetType!''}";
		</#if>
		<#if targetYear??>
			eventObj.year = "${targetYear!''}";
		</#if>
		<#if targetVolume??>
			eventObj.volume = "${targetVolume!''}";
		</#if>
		<#if targetAdd??>
			eventObj.add = "${targetAdd!''}";
		</#if>
		<#if publicationId??>
			eventObj.publicationId = "${publicationId!''}";
		</#if>
		
		
		<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		  <#--
		   $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			railVisible: true,
    			alwaysVisible: true
		  });
	  		-->
	    <#-- event for searching conference -->
	    $( "#conference_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 /* || e.keyCode == 32 */ )
			    conferenceSearch( $( this ).val() , "first");
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#conference_search_field" ).val().length == 0 )
			    	conferenceSearch( $( this ).val() , "first");
		});
		
		<#-- icon search presed -->
		$( "#conference_search_button" ).click( function(){
			conferenceSearch( $( "#conference_search_field" ).val() , "first");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				conferenceSearch( $( "#conference_search_field" ).val() , "next");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				conferenceSearch( $( "#conference_search_field" ).val() , "prev");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				conferenceSearch( $( "#conference_search_field" ).val() , "first");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				conferenceSearch( $( "#conference_search_field" ).val() , "end");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			conferenceSearch( $( "#conference_search_field" ).val() , $( this ).val() );
		});

		<#-- generate unique id for progress log -->
		var uniquePidVenueWidget = $.PALM.utility.generateUniqueId();
		
		var options ={
			source : "<@spring.url '/venue/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						<#-- show pop up progress log -->
						$.PALM.popUpMessage.create( "loading Conferences...", { uniqueId:uniquePidVenueWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidVenueWidget );

							var eventListContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous result -->
							eventListContainer.html( "" );
							// remove any remaing tooltip
							$( "body .tooltip" ).remove();
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
							
								// build the conference table
								$.each( data.eventGroups, function( index, itemEvent ){
									var eventItem = 
										$('<div/>')
										.addClass( "eventgroup-item" )
										.attr({ "data-id": itemEvent.id });
										
									<#-- hide unevaluated event -->
									if( !itemEvent.isAdded ){
										eventItem.css("display","none");
										data.count--;
									}
										
									<#-- event group -->
									var eventGroup = $( '<div/>' )
										.attr({'class':'eventgroup'})
										.attr({ "data-id": itemEvent.id });
										
									<#-- put event group into event item -->
									eventItem.append( eventGroup );
										
									<#-- event menu -->
									var eventNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append to event group -->
									eventGroup.append( eventNav );
									
									<#-- event detail -->
									var eventDetail = $('<div/>')
										.addClass( "detail" );
									
									<#-- append to event group -->
									eventGroup.append( eventDetail );
						
									<#-- event icon -->
									var eventIcon = $('<i/>');
									if( typeof itemEvent.type !== "undefined" ){
										if( itemEvent.type == "conference" )
											eventIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemEvent.type == "journal" )
											eventIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemEvent.type == "book" )
											eventIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
									}else{
										eventIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown event type" });
									}
									
									eventNav.append( eventIcon );

								<#if loggedUser??>
									<#-- edit option -->
									var eventEdit = $('<i/>')
												.attr({
													'class':'fa fa-edit', 
													'title':'edit event',
													'data-url':'<@spring.url '/venue/eventGroup/edit' />' + '?id=' + itemEvent.id
												});
												
									<#-- add click event to edit event -->
									eventEdit.click( function( e ){
										e.preventDefault();
										$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"430px"}, "Edit " + itemEvent.name);
									});
									
									<#-- append edit  -->
									eventNav.append( eventEdit );
								</#if>

									<#-- title -->
									var eventName = $('<div/>').addClass( "title" ).html( typeof itemEvent.abbr != "undefined" ? itemEvent.name + " (" + itemEvent.abbr + ")" : itemEvent.name );

									
									<#-- append detail -->
									eventDetail.append( eventName );

									
									
									<#-- event list on event group -->
									eventItem.append( 
										$('<div/>')
										.attr({ "class":"eventyear-list" })
									 );

									<#-- add click event -->
									eventDetail.on( "click", function( e){
										<#-- remove active class -->
										if( $.PALM.selected.record(  "eventGroup", $( this ).parent().data( 'id' ) , $( this ).parent() )){
											//$( this ).parent().siblings().removeClass( "active" );
											//$( this ).parent().addClass( "active" );
											getVenueGroupDetails( $( this ).parent().data( 'id' ) , eventGroup);
										}
									});
									
									eventListContainer.append( eventItem );
									
									
									<#-- display first conference detail -->
									if( itemEvent.isAdded ){
										if( typeof eventObj.id != "undefined" && eventObj.id != "" && eventObj.id == itemEvent.id ){
											getVenueGroupDetails( eventObj.id , eventGroup );
											eventObj.id = "";
										}
										else{
											//if( index == 0 )
											//	getVenueGroupDetails( itemEvent.id , eventGroup );
										}
									} else {
										if( data.count == 0 ){
											var eventUrl = "<@spring.url '/venue/add' />";
											var eventUrlQuery = "";
											if( typeof eventObj.eventId !== "undefined" ){
												eventUrlQuery += "&eventId=" + eventObj.eventId;
											}
											if( typeof eventObj.type !== "undefined" ){
												eventUrlQuery += "&type=" + eventObj.type;
											}
											if( typeof eventObj.name !== "undefined" ){
												eventUrlQuery += "&name=" + eventObj.name;
											}
											if( typeof eventObj.notation !== "undefined" ){
												eventUrlQuery += " " + eventObj.notation;
											}
											if( typeof eventObj.volume !== "undefined" ){
												eventUrlQuery += "&volume=" + eventObj.volume;
											}
											if( typeof eventObj.year !== "undefined" ){
												eventUrlQuery += "&year=" + eventObj.year;
											}
											if( typeof eventObj.publicationId !== "undefined" ){
												eventUrlQuery += "&publicationId=" + eventObj.publicationId;
											}
											
											if( eventUrlQuery != "" ){
												eventUrl += "?" + eventUrlQuery.substring( 1, eventUrlQuery.length );
											}
											$.PALM.popUpIframe.create( eventUrl, { "popUpHeight":"460px"} , "Add New Conference/Journal to PALM");
										}
									}
									
								});
								if( typeof eventObj.add !== "undefined" && eventObj.add == "yes" )
									data.totalCount = data.count;
									
								var maxPage = Math.ceil(data.totalCount/data.maxresult);
						
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								<#-- enable bootstrap tooltip -->
								$( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip();
								
								<#-- set page number -->
								$pageDropdown.val( data.startPage + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.startPage + 1) * data.maxresult;
								if( data.startPage == maxPage - 1 ) 
								endRecord = data.totalCount;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying conferences " + ((data.startPage * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );
							}
							else{
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
								
								<#-- pop up iframe when eventObj.id and eventObj.type exist -->
								var eventUrl = "<@spring.url '/venue/add?' />";
								if( typeof eventObj.eventId !== "undefined" ){
									eventUrl += "eventId=" + eventObj.eventId + "&";
								}
								if( typeof eventObj.name !== "undefined" ){
									eventUrl += "name=" + eventObj.name + "&";
								}
								if( typeof eventObj.type !== "undefined" ){
									eventUrl += "type=" + eventObj.type + "&";
								}
								if( typeof eventObj.volume !== "undefined" ){
									eventUrl += "volume=" + eventObj.volume + "&";
								}
								if( typeof eventObj.year !== "undefined" ){
									eventUrl += "year=" + eventObj.year + "&";
								}
								if( typeof eventObj.publicationId !== "undefined" ){
									eventUrl += "publicationId=" + eventObj.publicationId;
								}
								if( typeof eventObj.name !== "undefined" && eventObj.name != "" ){
									$.PALM.popUpIframe.create( eventUrl, {popUpHeight:"460px"}, "Add New Conference/Journal to PALM");
									eventObj.name = "";
								}
							}
						}
		};
		
		// register the widget
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 conferences-->
		<#--$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );-->
		<#-- There is a small bug here, but I forgot what -->
		if( typeof eventObj.add !== "undefined" && eventObj.add == "yes" )
			conferenceSearch( $( "#conference_search_field" ).val().trim() , "first");
		else
			conferenceSearch( $( "#conference_search_field" ).val().trim() , "first");
	
		function conferenceSearch( query , jumpTo ){
			//find the element option
			$.each( $.PALM.options.registeredWidget, function(index, obj){
				if( obj.type === "CONFERENCE" && obj.group === "sidebar" ){
					var maxPage = parseInt($( obj.element ).find( "span.total-page" ).html()) - 1;
					if( jumpTo === "next")
						obj.options.page = obj.options.page + 1;
					else if( jumpTo === "prev")
						obj.options.page = obj.options.page - 1;
					else if( jumpTo === "first")
						obj.options.page = 0;
					else if( jumpTo === "end")
						obj.options.page = maxPage;
					else
						obj.options.page = parseInt( jumpTo ) - 1;
						
					$( obj.element ).find( ".paginate_button" ).each(function(){
						$( this ).removeClass( "disabled" );
					});
									
					if( obj.options.page === 0 ){
						$( obj.element ).find( "li.toFirst" ).addClass( "disabled" );
						$( obj.element ).find( "li.toPrev" ).addClass( "disabled" );
					} else if( obj.options.page > maxPage - 1){
						$( obj.element ).find( "li.toNext" ).addClass( "disabled" );
						$( obj.element ).find( "li.toEnd" ).addClass( "disabled" );
					}
						
					if( jumpTo === "first") // if new searching performed
						obj.options.source = "<@spring.url '/venue/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + "&source=internal" + ( typeof eventObj.type !== 'undefined' ? "&type=" + eventObj.type : "");
					else
						obj.options.source = "<@spring.url '/venue/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + "&source=internal" + ( typeof eventObj.type !== 'undefined' ? "&type=" + eventObj.type : "");
						
					$.PALM.boxWidget.refresh( obj.element , obj.options );
				}
			});
		}
		
		<#-- when venue group clicked --> 
		function getVenueGroupDetails( venueId, eventGroup ){
	
			<#-- show pop up progress log -->
			var uniquePid = $.PALM.utility.generateUniqueId();
			$.PALM.popUpMessage.create( "Fetch venue group details...", { uniqueId:uniquePid, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid} );
			<#-- chack and fetch publication from academic network if necessary -->
			$.getJSON( "<@spring.url '/venue/fetchGroup?id=' />" + venueId + "&pid=" + uniquePid + "&force=false", function( data ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePid );
				
				var containerList = $( "[data-id='" + venueId + "']" ).find( ".eventyear-list" );
										
				containerList.html( "" );
				
				<#-- store year information -->
				var eventCurrentYear;
				
				var eventYearItem;
				var eventYear;
				
				var eventVolumeList;
				var eventArray = [];
				
				<#-- add empty object into event, to add loop -->
				data.events.push( {} );
				
				$.each( data.events, function( index, itemEvent ){
				
					var eventYearTemp;
				
					if( eventCurrentYear != itemEvent.year ){
					
					
						<#-- put previous content for volume here -->
						if( typeof eventCurrentYear !== "undefined" ){
							<#-- check array of event volume -->
							if( eventArray.length === 0 ){
								return;<#-- empty array just continue -->
							} 
							<#-- event group without volume -->
							else if ( eventArray.length === 1 ){
								<#-- add more properties such as number of paper -->
								<#-- add clcik event -->
								eventYearItem.attr({ "data-id": eventArray[0].id });
												
								eventYearItem.find( ".detail:first" ).on( "click", function(){
									<#-- remove active class -->
									triggerGetVenueDetails( $( this ).parent().parent().data( 'id' ), "onclick", [ eventGroup, eventYearTemp ]);
								});

								<#-- check if this is target item -->
								triggerGetVenueDetails( eventArray[0].id, "automatic", [ eventGroup, eventYear ]);
							}
							<#-- event group with volume -->
							else 
							{

								<#-- put into event year item -->
									
								<#-- event Volume List -->
								eventVolumeList =
									$('<div/>')
									.addClass( "eventvolume-list" );
								
								<#-- append Event Volume list -->
								eventYearItem.append( eventVolumeList );
								
								<#-- Put inside for each statement -->
								$.each( eventArray, function( index2, eventVolume){
								
									<#-- event volume item -->
									var eventVolumeItem = 
											$('<div/>')
											.addClass( "eventvolume" )
											.attr({ "data-id": eventVolume.id });
									
									<#-- not in database flag -->	
									if( !eventVolume.isAdded ){
										eventVolumeItem.addClass( "text-gray" );
									}
									
									<#-- append event volume item to event volume list -->
									eventVolumeList.append( eventVolumeItem );
									
									<#-- event volume navigation -->
									var eventVolumeNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append event volume navigation to event volume item-->
									eventVolumeItem.append( eventVolumeNav );
									
									<#-- event detail -->
									var eventVolumeDetail = $('<div/>').addClass( "detail" );
				
									<#-- append to item -->
									eventVolumeItem.append( eventVolumeDetail );
									
									
									<#-- event group volumes -->
									if( typeof eventVolume.volume !== "undefined" )
									{
										var eventVolumeElement = $('<div/>')
														.addClass( "info" )
														.attr({
																'title':eventVolume.name
														})
														.append(
															$('<i/>')
															.attr({
																'class':'fa fa-check icon font-xs',
																'style':'margin: 0 -10px;'
															})
														)
														.append(
															$('<span/>')
															.attr({
																'class':'volume'
															})
															.html( "Volume " + eventVolume.volume )
														);
										eventVolumeDetail.append( eventVolumeElement );
									}
									else 
									{
										var eventVolumeElement = $('<div/>')
														.addClass( "info" )
														.attr({
																'title':eventVolume.name
														})
														.append(
															$('<i/>')
															.attr({
																'class':'fa fa-check icon font-xs',
																'style':'margin: 0 -10px;'
															})
														)
														.append(
															$('<span/>')
															.attr({
																'class':'volume'
															})
															.html( $.PALM.utility.cutStringWithoutCutWord( eventVolume.name, 50 ) + "..." )
														);
										eventVolumeDetail.append( eventVolumeElement );
									}
			
									<#-- add click event -->
									eventVolumeDetail.on( "click", function(){
										triggerGetVenueDetails( $( this ).parent().data( 'id' ), "onclick", [ eventGroup, eventYearTemp, eventVolumeItem ]);
									});
									
									<#-- check if this is target item -->
									triggerGetVenueDetails( eventVolume.id, "automatic", [ eventGroup, eventYearTemp, eventVolumeItem ] );
									
								});<#-- end of foreach statement -->
								
								<#-- append event volume list to eventyear -->
								eventYearItem.append( eventVolumeList );
							}
							
							<#-- reset event array -->
							eventArray = [];
						}
					
						if( typeof itemEvent.year !== "undefined"){
							<#-- store previous itemYear -->
							eventYearTemp = eventYear;
					
							eventYearItem =
								$('<div/>')
								.addClass( "eventyear-item" );
								
							<#-- append Event Year Item -->
							containerList.append( eventYearItem );
							
							<#-- event year -->
							eventYear =
								$('<div/>')
								.addClass( "eventyear" );
								
							if( !itemEvent.isAdded ){
								eventYear.addClass( "text-gray" );
							}
								
							<#-- append Event Year to Event Year Item -->
							eventYearItem.append( eventYear );
							
							<#-- event navigation -->
							var eventYearNav = $( '<div/>' )
								.attr({'class':'nav'});
								
							<#-- append Event Year Navigation to Event Year -->
							eventYear.append( eventYearNav );
							
							<#-- event detail -->
							var eventYearDetail = $('<div/>').addClass( "detail" );
							
							<#-- add click event -->
							eventYearDetail.on( "click", function(){
								$( this ).parent().addClass( "active" );
							});
							
							<#-- append Event Detail to Event Year -->
							eventYear.append( eventYearDetail );
							
							
							<#-- event year detail content -->
								<#-- event title -->
								var eventYearTitleText = "";
								if( typeof data.eventGroup.abbr !== "undefined" ){
									eventYearTitleText = data.eventGroup.abbr;
								} else{
									eventYearTitleText = data.eventGroup.name;
								}
															
								<#-- event year title -->
								var eventYearTitle = $('<div/>').addClass( "title" ).html( eventYearTitleText + " - " + itemEvent.year);
								
								<#-- append Event Title to Event Year Detail-->
								eventYearDetail.append( eventYearTitle );
							
								<#-- event number -->
								if( typeof itemEvent.number !== "undefined" )
								{
									var eventNumber = itemEvent.number;
									eventNumber == "1" ? eventNumber += "st" : eventNumber == "2" ? eventNumber += "nd" : eventNumber += "th";
									
									eventNumber += " " + eventYearTitleText;
									
									var eventNumberElement = $('<div/>')
													.addClass( "info" )
													.append(
														$('<i/>')
														.attr({
															'class':'fa fa-hashtag icon font-xs',
														})
													)
													.append(
														$('<span/>')
														.attr({
															'class':'number',
														})
														.html( eventNumber )
													);
									eventYearDetail.append( eventNumberElement );
								}
								<#-- event date -->
								if( typeof itemEvent.date !== "undefined" )
								{
									var eventDateElement = $('<div/>')
													.addClass( "info" )
													.append(
														$('<i/>')
														.attr({
															'class':'fa fa-calendar icon font-xs',
														})
													)
													.append(
														$('<span/>')
														.attr({
															'class':'date',
														})
														.html( itemEvent.date + ", " + itemEvent.year )
													);
									eventYearDetail.append( eventDateElement );
								}
	
								<#-- event location -->
								if( typeof itemEvent.location !== "undefined" )
								{
									var eventLocationElement = $('<div/>')
													.addClass( "info" )
													.append(
														$('<i/>')
														.attr({
															'class':'fa fa-map-marker icon font-xs',
														})
													)
													.append(
														$('<span/>')
														.attr({
															'class':'date',
														})
														.html( itemEvent.location )
													);
									eventYearDetail.append( eventLocationElement );
								}
	
							<#-- end of event detail content -->
							}<#-- end of typeof eventItem.year !== "undefined" -->
						<#-- store year changes -->
						eventCurrentYear = itemEvent.year;
						
					}<#-- end of currentYear != tempYear --> 
					
					<#-- put item into array -->
					eventArray.push( itemEvent );

					
				});<#-- end of foreach staement -->
				
				<#-- changed scroll position -->
				var scrollTo_val = containerList.parent()[0].offsetTop + 'px';
				//console.log( "scroll : " + scrollTo_val );
				$(".content-list").slimscroll({
					scrollTo : scrollTo_val
				});
				
				<#-- trigger conference group basic statistic -->
				$.each( $.PALM.options.registeredWidget, function(index, obj){
					if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
						if( obj.selector === "#widget-conference_basic_information" ){
							obj.options.queryString = "?id=" + venueId + "&type=eventGroup"
							$.PALM.boxWidget.refresh( obj.element , obj.options );
						} else {
						<#-- clear other widget -->
							obj.element.find( ".box-content" ).html( "" );
						}
					}
				});
			}).fail(function() {
	   	 		$.PALM.popUpMessage.remove( uniquePid );
	  		});
		}
		
		<#-- check if venue detail is a target -->
		function triggerGetVenueDetails( eventId, triggerType, activeObjects ){
			if( triggerType == "automatic" ){
				if( typeof eventObj.eventId != "undefined" ){
					if( eventObj.eventId == eventId ){
						if( $.PALM.selected.record(  "event", eventId, activeObjects ))
							getVenueDetails( eventId );
					}
				}
			} else {
				if( $.PALM.selected.record( "event", eventId, activeObjects ))
					getVenueDetails( eventId );
			}
		}
	
		<#-- when venue list clciked --> 
		function getVenueDetails( venueId ){
			<#-- put loading overlay -->
	    	$.each( $.PALM.options.registeredWidget, function(index, obj){
					if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
						obj.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					}
				});
	
			<#-- show pop up progress log -->
			var uniquePid = $.PALM.utility.generateUniqueId();
			$.PALM.popUpMessage.create( "Fetch venue details...", { uniqueId:uniquePid, popUpHeight:150, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid} );
			<#-- chack and fetch pzblication from academic network if necessary -->
			$.getJSON( "<@spring.url '/venue/fetch?id=' />" + venueId + "&pid=" + uniquePid + "&force=false", function( data ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePid );
				<#-- refresh registered widget -->
				$.each( $.PALM.options.registeredWidget, function(index, obj){
					if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
						obj.options.queryString = "?id=" + venueId;
						<#-- add additional query string for conference publication -->
						if( typeof eventObj.publicationId !== "undefined" ){
							if( obj.selector === "#widget-conference_publication" )
								obj.options.queryString += "&publicationId=" + eventObj.publicationId;
						}
						$.PALM.boxWidget.refresh( obj.element , obj.options );
					}
				});
			
			}).fail(function() {
	   	 		$.PALM.popUpMessage.remove( uniquePid );
	  		});
		}
	});
</script>