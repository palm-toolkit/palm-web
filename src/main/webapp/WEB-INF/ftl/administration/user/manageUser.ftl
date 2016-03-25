<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="user_search_field" name="user_search_field" class="form-control input-sm pull-right" 
	      placeholder="Search users on database" value="<#if targetName??>${targetName!''}</#if>">
	      <div id="user_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
  	</div>
  	
  	<div class="content-list height610px">
    </div>
</div>

<div class="box-footer no-padding">
</div>

<script>
	$( function(){
		
	    <#-- event for searching user -->
		var tempInput = $( "#user_search_field" ).val();
	    $( "#user_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 /* || e.keyCode == 32*/ )
			    userSearch( $( this ).val().trim() , "first", "&addedAuthor=yes");
			 tempInput = $( this ).val().trim();
		})
		<#-- when pressing backspace until -->
		.on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#user_search_field" ).val().length == 0 && tempInput != $( this ).val().trim())
			    	userSearch( $( this ).val().trim() , "first", "&addedAuthor=yes");
			  tempInput = $( this ).val().trim();
		});
		

		<#-- icon search presed -->
		$( "#user_search_button" ).click( function(){
			userSearch( $( "#user_search_field" ).val().trim() , "first", "&addedAuthor=yes");
		});

		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/admin/user/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){
			
							var targetContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the user list -->
								$.each( data.users, function( index, item){
									var userDiv = 
									$( '<div/>' )
										.addClass( 'author small' )
										.attr({ 'id' : item.id });
										
									var userNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var userDetail =
									$( '<div/>' )
										.addClass( 'detail static' )
										.css({"background-color":"transparent"})
										.append(
											$( '<div/>' )
												.addClass( 'name' )
												.html( item.name )
										)
										.append(
											$( '<div/>' )
												.addClass( 'info' )
												.html( "join " + $.PALM.utility.parseDateType1( item.joinDate) )
										);
										
									userDiv
										.append(
											userNav
										).append(
											userDetail
										);

										
									if( typeof item.author !== 'undefined' && typeof item.author.photo !== 'undefined'){
										userNav
											.append(
											$( '<div/>' )
												.addClass( 'photo' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.author.photo })
												)
											);
									} else {
										userNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									}
									userDetail
										.append(
											$( '<div/>' )
											.addClass( 'btn btn-default btn-xs pull-left visible' )
											.attr({ "data-url":"<@spring.url '/user/edit' />?id=" + item.id, "title":"Edit " + item.name + " account"})
											.append(
												$( '<i/>' )
													.addClass( 'fa fa-edit' )
											).append( "Edit" )
											.on( "click", function(e){
												e.preventDefault;
												$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
											})
										);

									
								<#-- userDetailOption -->
								var userDetailOption = $('<div/>').addClass( "option" );
								
								userDetail.append( userDetailOption );
									
									targetContainer
										.append( 
											userDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = userDiv.find( "img:first" );
											if( imageAuthor.width() > 30 )
												imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);

								});
							}
							else{
								$.PALM.callout.generate( targetContainer, "warning", "No user names contain " + data.query, "" );
							}
						}
		};
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#if targetName??>
			$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		</#if>

	});
	
	
		
	function userSearch( query , jumpTo , additionalQueryString){
		if( typeof additionalQueryString === "undefined" )
			additionalQueryString = "";
		<#--//find the element option-->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "ADMINISTRATION" && obj.group === "admin-manage-user" ){
				obj.options.source = "<@spring.url '/admin/user/search?name=' />" + query ;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
</script>