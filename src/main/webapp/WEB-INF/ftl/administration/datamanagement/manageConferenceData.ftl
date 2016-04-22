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
  	
	<div class="content-list height610px">
    </div>
    
    
</div>

<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="conferencePaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying conferences 0 - 0 of 0</span>
	</div>
</div>

<script>
	$( function(){
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
						},
			onRefreshDone: function(  widgetElem , data ){

							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							
							var eventListContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous result -->
							eventListContainer.html( "" );
							
							if( data.count > 0 ){
							
								<#-- build the conference list -->
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

									<#-- title -->
									var eventName = $('<div/>').addClass( "title" ).html( typeof itemEvent.abbr != "undefined" ? itemEvent.name + " (" + itemEvent.abbr + ")" : itemEvent.name );

									
									<#-- append detail -->
									eventDetail.append( eventName );

									<#-- eventDetailOption -->
									var eventDetailOption = $('<div/>').addClass( "option" );
									<#-- fill eventGroup detail option -->
									<#-- remove eventGroup button -->
									var eventGroupDeleteButton = $('<button/>')
										.addClass( "btn btn-danger btn-xs width130px pull-right" )
										.attr({ "data-id": itemEvent.id, "title":"remove " + itemEvent.title + " from PALM database" })
										.html( "delete " + itemEvent.type )
										.on( "click", function( e ){
											e.preventDefault();
											if ( confirm("Do you really want to remove this eventGroup?") ) {
											    $.post( "<@spring.url '/venue/delete' />", { id:itemEvent.id }, function( data ){
											    	if( data.status == "ok")
											    		location.reload();
											    } )
											}
										});
									
									eventDetailOption.append( eventGroupDeleteButton );
									
									eventDetail.append( eventDetailOption );
									
									<#-- event list on event group -->
									eventItem.append( 
										$('<div/>')
										.attr({ "class":"eventyear-list" })
									 );
									
									eventListContainer.append( eventItem );
									
									
								});
									
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
		
		
		<#--// first time on load, list 50 researchers-->
		conferenceSearch( $( "#conference_search_field" ).val().trim() , "first");
		
		function conferenceSearch( query , jumpTo ){
			//find the element option
			$.each( $.PALM.options.registeredWidget, function(index, obj){
				if( obj.type === "ADMINISTRATION" && obj.group === "data-conference" ){
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
						obj.options.source = "<@spring.url '/venue/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + "&source=internal";
					else
						obj.options.source = "<@spring.url '/venue/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + "&source=internal";
						
					$.PALM.boxWidget.refresh( obj.element , obj.options );
				}
			});
		}
	});
</script>