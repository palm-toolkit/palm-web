<div class="box-body no-padding">
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
		<#if targetType??>
			eventObj.type = "${targetType!''}";
		</#if>
		<#if targetYear??>
			eventObj.year = "${targetYear!''}";
		</#if>
		<#if targetVolume??>
			eventObj.volume = "${targetVolume!''}";
		</#if>
		<#if publicationId??>
			eventObj.publicationId = "${publicationId!''}";
		</#if>
		
		
		<#-- add slim scroll -->
	      $(".content-list, .content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
	  
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
						$.PALM.popUpMessage.create( "loading venues...", { uniqueId:uniquePidVenueWidget, popUpHeight:40, directlyRemove:false});
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
										.addClass( "event" )
										.attr({ "data-id": itemEvent.id });
										
									<#-- event menu -->
									var eventNav = $( '<div/>' )
										.attr({'class':'nav'});
						
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
									
									<#-- edit option -->
									var eventEdit = $('<i/>')
												.attr({
													'class':'fa fa-edit', 
													'title':'edit event',
													'data-url':'<@spring.url '/event/edit' />' + '?id=' + itemEvent.id,
													'style':'display:none'
												});
												
									<#-- add click event to edit event -->
									eventEdit.click( function( event ){
										event.preventDefault();
										$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"430px"}, "Edit Event");
									});
									
									<#-- append edit  -->
									eventNav.append( eventEdit );
									
									eventItem.append( eventNav );
									
									eventItem.hover(function()
									{
									     eventEdit.show();
									}, function()
									{ 
									     eventEdit.hide();
									});

									<#-- event detail -->
									var eventDetail = $('<div/>').addClass( "detail" );
									<#-- title -->
									var eventName = $('<div/>').addClass( "title" ).html( itemEvent.name );


									<#-- append detail -->
									eventDetail.append( eventName );

									<#-- append to item -->
									eventItem.append( eventDetail );
									
									<#-- event list on event group -->
									eventItem.append( 
										$('<div/>')
										.attr({ "class":"event-year" })
										.css({"width":"100%","float":"left"})
									 );

									<#-- add clcik event -->
									eventDetail.on( "click", function(){
										<#-- remove active class -->
										$( this ).parent().siblings().removeClass( "active" );
										$( this ).parent().addClass( "active" );
										getVenueGroupDetails( $( this ).parent().data( 'id' ));
									});
									
									eventListContainer.append( eventItem );
									
									
									<#-- display first conference detail -->
									if( itemEvent.isAdded ){
										if( ( typeof eventObj.id == "undefined" || eventObj.id == "" ) && eventObj.id == itemEvent.id ){
											getVenueGroupDetails( eventObj.id );
											eventObj.id = "";
										}
										else{
											if( index == 0 )
												getVenueGroupDetails( itemEvent.id );
										}
									} else {
										var eventUrl = "<@spring.url '/venue/add' />?eventId=" + eventObj.eventId + "&type=" + eventObj.type + "&name=" + eventObj.name;
										if( typeof eventObj.volume !== "undefined" ){
											eventUrl += "&volume=" + eventObj.volume;
										}
										if( typeof eventObj.year !== "undefined" ){
											eventUrl += "&year=" + eventObj.year;
										}
										if( typeof eventObj.publicationId !== "undefined" ){
											eventUrl += "&publicationId=" + eventObj.publicationId;
										}
										$.PALM.popUpIframe.create( eventUrl, { "popUpHeight":"430px"} , "Add New Conference/Journal to PALM");
									}
									
								});
								var maxPage = Math.ceil(data.count/data.maxresult);
						
						
								// set dropdown page
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								// enable bootstrap tooltip
								$( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip();
								
								// set page number
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.count;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying conferences " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
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
									$.PALM.popUpIframe.create( eventUrl, {popUpHeight:"430px"}, "Add New Conference/Journal to PALM");
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
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 conferences-->
		//$.PALM.boxWidget.refresh( $( "#widget-${wId}" ) , options );
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
		
		<#-- when author list clciked --> 
		function getVenueGroupDetails( venueId ){
	
			<#-- show pop up progress log -->
			var uniquePid = $.PALM.utility.generateUniqueId();
			$.PALM.popUpMessage.create( "Fetch venue group details...", { uniqueId:uniquePid, popUpHeight:150, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid} );
			<#-- chack and fetch pzblication from academic network if necessary -->
			$.getJSON( "<@spring.url '/venue/fetchGroup?id=' />" + venueId + "&pid=" + uniquePid + "&force=false", function( data ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePid );
				
				var containerList = $( "[data-id='" + venueId + "']" ).find( ".event-year" );
				containerList.html( "" );
				$.each( data.events, function( index, itemEvent ){
					
					var eventItem = 
							$('<div/>')
							.addClass( "event-item" )
							.attr({ "data-id": itemEvent.id });
							
						<#-- event menu -->
						var eventNav = $( '<div/>' )
							.attr({'class':'nav'});
						
						<#-- edit option -->
						var eventEdit = $('<i/>')
									.attr({
										'class':'fa fa-edit', 
										'title':'edit event',
										'data-url':'<@spring.url '/event/edit' />' + '?id=' + itemEvent.id,
										'style':'display:none'
									});
									
						<#-- add click event to edit event -->
						eventEdit.click( function( event ){
							event.preventDefault();
							$.PALM.popUpIframe.create( $(this).data("url") , {}, "Edit Event");
						});
						
						<#-- append edit  -->
						eventNav.append( eventEdit );
						
						eventItem.append( eventNav );
						
						eventItem.hover(function()
						{
						     eventEdit.show();
						}, function()
						{ 
						     eventEdit.hide();
						});
	
						<#-- event detail -->
						var eventDetail = $('<div/>').addClass( "detail" );
						<#-- title -->
						var eventName = $('<div/>').addClass( "title" ).html( itemEvent.name );
						
						if( !itemEvent.isAdded )
							eventName.addClass( "grey-content" );
						else{
							if( ( typeof eventObj.eventId != "undefined" && eventObj.eventId != "" ) && eventObj.eventId == itemEvent.id ){
								getVenueDetails( eventObj.eventId );
								eventObj.eventId = "";
							}
						}
						<#-- append detail -->
						eventDetail.append( eventName );
	
						<#-- append to item -->
						eventItem.append( eventDetail );
	
						<#-- add clcik event -->
						eventDetail.on( "click", function(){
							<#-- remove active class -->
							$( this ).parent().siblings().removeClass( "active" );
							$( this ).parent().addClass( "active" );
							getVenueDetails( $( this ).parent().data( 'id' ));
						});
						
						containerList.append( eventItem );
						
						
						
					
				});
				
			
			}).fail(function() {
	   	 		$.PALM.popUpMessage.remove( uniquePid );
	  		});
		}
	
		<#-- when author list clciked --> 
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
						$.PALM.boxWidget.refresh( obj.element , obj.options );
					}
				});
			
			}).fail(function() {
	   	 		$.PALM.popUpMessage.remove( uniquePid );
	  		});
		}
	});
</script>