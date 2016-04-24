<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="researcher_search_field" name="researcher_search_field" class="form-control input-sm pull-right" 
	      placeholder="Search researchers on database" value="<#if targetName??>${targetName!''}</#if>">
	      <div id="researcher_search_button" class="input-group-btn">
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
			<ul id="researcherPaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying researchers 0 - 0 of 0</span>
	</div>
</div>

<script>
	$( function(){
		
	    <#-- event for searching researcher -->
		var tempInput = $( "#researcher_search_field" ).val();
	    $( "#researcher_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 /* || e.keyCode == 32*/ )
			    researcherSearch( $( this ).val().trim() , "first", "&addedAuthor=yes");
			 tempInput = $( this ).val().trim();
		})
		<#-- when pressing backspace until -->
		.on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#researcher_search_field" ).val().length == 0 && tempInput != $( this ).val().trim())
			    	researcherSearch( $( this ).val().trim() , "first", "&addedAuthor=yes");
			  tempInput = $( this ).val().trim();
		});
		

		<#-- icon search presed -->
		$( "#researcher_search_button" ).click( function(){
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first", "&addedAuthor=yes");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "next", "&addedAuthor=yes");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "prev", "&addedAuthor=yes");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "first", "&addedAuthor=yes");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "end", "&addedAuthor=yes");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			researcherSearch( $( "#researcher_search_field" ).val() , $( this ).val() , "&addedAuthor=yes");
		});

		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/search' />",
			query: "",
			queryString : "&addedAuthor=yes",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading researchers...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			
				<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );
				

							var targetContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'author static' )
										.attr({ 'id' : item.id });
										
									var researcherNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var researcherDetail =
									$( '<div/>' )
										.addClass( 'detail static' )
										.append(
											$( '<div/>' )
												.addClass( 'name' )
												.html( item.name )
										);
										
									researcherDiv
										.append(
											researcherNav
										).append(
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDiv.css("display","none");
										data.count--;
									}
									
									if( typeof item.status != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'status' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-briefcase icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.status )
											)
										);
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);
									if( typeof item.publicationsNumber != 'undefined'){
										var citedBy = 0;
										if( typeof item.citedBy !== "undefined" )
											citedBy = item.citedBy;
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + citedBy )
										);
									}
										
									if( typeof item.photo != 'undefined'){
										researcherNav
											.append(
											$( '<div/>' )
												.addClass( 'photo' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.photo })
												)
											);
									} else {
										researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									}
									researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'btn btn-default btn-xs pull-left visible' )
											.attr({ "data-url":"<@spring.url '/researcher/edit' />?id=" + item.id, "title":"Update " + item.name + " Profile"})
											.append(
												$( '<i/>' )
													.addClass( 'fa fa-edit' )
											).append( "Update" )
											.on( "click", function(e){
												e.preventDefault;
												$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
											})
										);

									
								<#-- researcherDetailOption -->
								var researcherDetailOption = $('<div/>').addClass( "option" );
								
								<#-- fill researcher detail option -->
								var removeDuplicatedPublication = $('<button/>')
									.addClass( "btn btn-default btn-xs width130px pull-left" )
									.attr({ "data-id": item.id, "data-name": item.name, "title":"remove duplicated publications and researcher's sources from researcher " + item.name })
									.html( "remove duplicated publications" )
									.on( "click", function( e ){
										e.preventDefault();
										if ( confirm("Do you want to remove duplicated publications and researcher's sources from researcher " + item.name+ "? If yes, you will redirected to researcher page") ) {
										    $.post( "<@spring.url '/researcher/removeDuplicatedPublication' />", { id:item.id }, function( data ){
										    	if( data.status == "ok")
										    		window.location.href = "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name ;
										    } )
										}
									});
								
								researcherDetailOption.append( removeDuplicatedPublication );
								
								<#-- fill researcher detail option -->
								var reCollectPublication = $('<button/>')
									.addClass( "btn btn-default btn-xs width130px pull-left" )
									.attr({ "data-id": item.id, "data-name": item.name, "title":"re collect/update " + item.name + " publications" })
									.html( "re-collect publications" )
									.on( "click", function( e ){
										e.preventDefault();
										if ( confirm("Do you want to make recollect " + item.name+ "'s publications? If yes, you will redirected to researcher page") ) {
										    $.post( "<@spring.url '/researcher/removeRequestTime' />", { id:item.id }, function( data ){
										    	if( data.status == "ok")
										    		window.location.href = "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name ;
										    } )
										}
									});
								
								researcherDetailOption.append( reCollectPublication );
									
								var researcherDeleteButton = $('<button/>')
									.addClass( "btn btn-danger btn-xs width130px pull-right" )
									.attr({ "data-id": item.id, "data-name": item.name, "title":"make author not visible from researchers page" })
									.html( "set invisible" )
									.on( "click", function( e ){
										e.preventDefault();
										if ( confirm("Do you want to make this researcher invisible from researcher page, you may set it visible again from Add Researcher form?") ) {
										    $.post( "<@spring.url '/researcher/setInvisible' />", { id:item.id }, function( data ){
										    	if( data.status == "ok")
										    		location.reload();
										    } )
										}
									});
								
								researcherDetailOption.append( researcherDeleteButton );
								
								researcherDetail.append( researcherDetailOption );
									
									targetContainer
										.append( 
											researcherDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = researcherDiv.find( "img:first" );
											if( imageAuthor.width() > 30 )
												imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);

								});
									
								var maxPage = Math.ceil(data.totalCount/data.maxresult);
								var $pageDropdown = $( widgetElem ).find( "select.page-number" );
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								<#-- //enable bootstrap tooltip -->
								<#-- $( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip(); -->
								
								<#--// set page number-->
								
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.totalCount;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );
							
								
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
		
		<#-- remove old widget -->
		$.PALM.boxWidget.removeRegisteredWidget( '${wUniqueName}' ); 
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 researchers-->
		researcherSearch( $( "#researcher_search_field" ).val().trim() , "first");
	});
	
	function researcherSearch( query , jumpTo , additionalQueryString){
		if( typeof additionalQueryString === "undefined" )
			additionalQueryString = "";
		<#--//find the element option-->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "ADMINISTRATION" && obj.group === "data-researcher" ){
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
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + additionalQueryString;
				else
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + additionalQueryString;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
</script>