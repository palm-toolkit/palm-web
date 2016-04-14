<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-padding">
	<#-- filters -->
<#--
	<div class="box-filter">
		<div class="box-filter-option" style="display:none">

		<div id="author_block">
	    	<div class="input-group" id="author_search_block" style="width:100%">
	      		<input type="text" id="author_search_field" name="author_search_field" class="form-control input-sm pull-right" 
	      		placeholder="Search author on database"/>
	      		<div id="publication_search_button" class="input-group-btn">
	        		<button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      		</div>
	    	</div>

			<div class="palm_pub_atr" id="selected_author" data_author_id="all">
				<div class="palm_pub_atr_photo" style="font-size: 14px;">
					<img src="https://scholar.google.com/citations?view_op=view_photo&amp;user=gyLI8FYAAAAJ&amp;citpid=1" class="palm_pub_atr_img">
				</div>
				<div class="palm_atr_name">mohamed amine chatti</div>
				<div class="palm_atr_aff">rwth aachen university</div>
			</div>
        </div>

		</div>
		<button class="btn btn-block btn-default box-filter-button" onclick="$( this ).prev().slideToggle( 'slow' )">
			<i class="fa fa-filter pull-left"></i>
			<span>Something</span>
		</button>
	</div>
-->
	<#--  search block -->
	<div class="box-tools">
		<div class="input-group" style="width: 100%;">
	      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" 
	      placeholder="Search publication on database" value="<#if targetTitle??>${targetTitle!''}</#if>"/>
	      <div id="publication_search_button" class="input-group-btn">
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
			<ul id="publicationPaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying publications 0 - 0 of 0</span>
	</div>
</div>

<script>
	$( function(){
		<#-- set target author id -->
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>
	
		<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "5px",
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
	    <#-- event for searching researcher -->
		var tempInput = $( "#publication_search_field" ).val();
	    $( "#publication_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    publicationSearch( $( this ).val() , "first");
			  tempInput = $( this ).val().trim();
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#publication_search_field" ).val().length < 2 && tempInput != $( this ).val().trim()){
			    	publicationSearch( "" , "first");
			    	history.pushState( null, "Publication page", "<@spring.url '/publication' />");
			   		tempInput = "";
			    } else
			    	tempInput = $( this ).val().trim();
		});

		<#-- icon search presed -->
		$( "#publication_search_button" ).click( function( e ){
			e.preventDefault();
			publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "next");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "prev");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "end");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			publicationSearch( $( "#publication_search_field" ).val() , $( this ).val() );
		});

		<#-- button search loading -->
		$( "#publication_search_button" ).find( "i" ).removeClass( "fa-search" ).addClass( "fa-refresh fa-spin" );
		
		<#-- generate unique id for progress log -->
		var uniquePidPublicationWidget = $.PALM.utility.generateUniqueId();
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/publication/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading publications...", { uniqueId:uniquePidPublicationWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
							var publicationListContainer = $( widgetElem ).find( ".content-list" );
							
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidPublicationWidget );
							
							<#-- check for error  -->
							<#--
							if( typeof data.publications === "undefined"){
								$.PALM.callout.generate( publicationListContainer , "warning", "Empty Publications!", "An error occured - please try again later" );
								return false;
							}
							-->

							<#-- remove previous result -->
							publicationListContainer.html( "" );
							<#-- button search loading -->
							$( "#publication_search_button" ).find( "i" ).removeClass( "fa-refresh fa-spin" ).addClass( "fa-search" );

							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							<#-- callout -->
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( publicationListContainer , "normal", "Currently no publications found on PALM database" );
								else
									$.PALM.callout.generate( publicationListContainer , "warning", "Empty search results!", "No publications found with query \"" + data.query + "\"" );
								return false;
							}
							
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
										else if( itemPublication.type == "Workshop" )
											pubIcon.addClass( "fa fa-file-text-o bg-blue-dark" ).attr({ "title":"Workshop" });
										else if( itemPublication.type == "Journal" )
											pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemPublication.type == "Book" )
											pubIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
										else if( itemPublication.type == "Informal" )
											pubIcon.addClass( "fa fa-file-text-o bg-gray" ).attr({ "title":"Other/Informal" });
									}else{
										pubIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown publication type" });
									}
									
									pubNav.append( pubIcon );
									
								<#if loggedUser??>
									<#-- edit option -->
									var pubEdit = $('<i/>')
												.attr({
													'class':'fa fa-edit', 
													'title':'edit publication',
													'data-url':'<@spring.url '/publication/edit' />' + '?id=' + itemPublication.id
												});
												
									<#-- add click event to edit publication -->
									pubEdit.click( function( event ){
										event.preventDefault();
										$.PALM.popUpIframe.create( $(this).data("url") , {}, "Edit Publication");
									});
									
									<#-- append edit  -->
									pubNav.append( pubEdit );
								</#if>

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
										//var venueHref = "<@spring.url '/venue' />?eventId=" + itemPublication.event.id + "&type=" + itemPublication.type.toLowerCase() + "&name=" + itemPublication.event.name.toLowerCase().replace(/[^\w\s]/gi, '');
										
										if( typeof itemPublication.volume != 'undefined' ){
											venueText += " (" + itemPublication.volume + ")";
											//venueHref += "&volume=" + itemPublication.volume;
										}
										if( typeof itemPublication.date != 'undefined' ){
											venueText += " " + itemPublication.date.substring(0, 4);
											//venueHref += "&year=" + itemPublication.date.substring(0, 4);
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
										//var venueHref = "<@spring.url '/venue' />?type=" + itemPublication.type.toLowerCase() + "&name=" + itemPublication.venue.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + itemPublication.id ;
										
										if( typeof itemPublication.volume != 'undefined' ){
											venueText += " (" + itemPublication.volume + ")";
											//venueHref += "&volume=" + itemPublication.volume;
										}
										if( typeof itemPublication.date != 'undefined' ){
											venueText += " " + itemPublication.date.substring(0, 4);
											//venueHref += "&year=" + itemPublication.date.substring(0, 4);
										}
										
										var eventPart = $( '<span/>' )
																//.attr({ "href" : venueHref })
																//.addClass( "text-gray" )
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

									<#-- add clcik event -->
									pubDetail.on( "click", function(){
										<#-- remove active class -->
										if( $.PALM.selected.record( "publication", itemPublication.id, pubDetail.parent() )){
											<#-- push history -->
											history.pushState( null, "Publication " + itemPublication.title, "<@spring.url '/publication' />?id=" + itemPublication.id + "&title=" + itemPublication.title);
											getPublicationDetails( itemPublication.id);
										}
									});

									publicationListContainer.append( publicationItem );
								
									<#-- display first publication detail -->
									if( targetId == "" ){
										if( index == 0 ){
											if( $.PALM.selected.record( "publication", itemPublication.id, pubDetail.parent() )){
												<#-- push history -->
												history.pushState( null, "Publication " + itemPublication.title, "<@spring.url '/publication' />?id=" + itemPublication.id + "&title=" + itemPublication.title);
												getPublicationDetails( itemPublication.id );
											}
										}
									} else {
										if( targetId == itemPublication.id ){
											if( $.PALM.selected.record( "publication", itemPublication.id, pubDetail.parent() )){
												<#-- push history -->
												//history.pushState( null, "Publication " + itemPublication.title, "<@spring.url '/publication' />?id=" + itemPublication.id + "&title=" + itemPublication.title);
												getPublicationDetails( itemPublication.id );
												<#-- add related publication header if necessary -->
												$("<div/>").attr("class","widget-section").html("Related Publications").prependTo( publicationListContainer );
												<#-- put to the top list -->
												publicationItem.prependTo( publicationListContainer );
												targetId == "";
											}										
										}
									}
								
								});
								var maxPage = Math.ceil(data.totalCount/data.maxresult);
								
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								
								<#-- set page number -->
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.totalCount;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );
							}
							else{
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying publications 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
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
		
		<#--// first time on load, list 50 publications-->
		//$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		publicationSearch( $( "#publication_search_field" ).val()  , "first" );

	});
	
	function publicationSearch( query , jumpTo ){
		//find the element option
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "PUBLICATION" && obj.group === "sidebar" ){
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
					obj.options.source = "<@spring.url '/publication/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					obj.options.source = "<@spring.url '/publication/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
					
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}

	<#-- when publication list clciked --> 
	function getPublicationDetails( publicationId ){
		<#-- put loading overlay -->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
				obj.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				obj.options.queryString = "?id=" + publicationId;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
</script>