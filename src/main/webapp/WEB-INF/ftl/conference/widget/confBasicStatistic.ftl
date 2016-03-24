<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-margin no-padding" style="overflow:hidden">
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
			source : "<@spring.url '/venue/basicinformation' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "#boxbody${wUniqueName}");

				<#--remove previous content -->
				targetContainer.html( "" );
				
				<#-- bookmark button -->
				<#if currentUser??>
					if( !data.booked ){
	                	var butBook = $( "<a/>" )
	                					.attr({
	                						"class":"btn btn-block btn-social btn-twitter btn-sm width110px pull-right",
	                						"onclick":"$.PALM.bookmark.eventGroup( $( this ), '${currentUser.id}', '" + data.eventGroup.id + "' )",
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
	                						"onclick":"$.PALM.bookmark.eventGroup( $( this ), '${currentUser.id}', '" + data.eventGroup.id + "' )",
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
				
				<#-- check data status -->
				var genaralBoxBody = $( '<div/>' )
										.attr({'class':'box-body'})

				<#-- create generalBox -->
				var generalBox = $( '<div/>' )
									.attr({'class':'col-md-12'})
									.css({"clear":"both"})
									.append(
										$( '<div/>' )
										.attr({'class':'box box-default box-solid no-border'})
										.append(
											$( '<div/>' )
											.attr({'class':'box-header'})
											.append(
												$( '<h3/>' )
												.attr({'class':'box-title'})
												.html( "General" )
											)
											.append(
												$( '<div/>' )
												.attr({'class':'box-tools pull-right'})
												<#if currentUser??>
												.append(
													$( '<div/>' )
													.attr({'class':'btn btn-default btn-xs','data-url': '<@spring.url '/venue/eventGroup/edit' />?id=' + data.eventGroup.id, 'title':'Update ' + data.eventGroup.name})
													.css({'background-color':'#fff','margin-top':'5px'})
													.append(
														$( '<i/>' )
														.attr({'class':'fa fa-edit'})
													)
													.append( "Update" )
													.on( "click", function(e){
														e.preventDefault;
														$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
													})
												)
												</#if>
											)
										)
										.append(
											genaralBoxBody
										)
									)
				
				<#-- find active option -->
				var currentQueryArray = this.queryString.split( "&" );
				var informationType = "event";
				$.each( currentQueryArray , function( index, partQuery){
					if( partQuery.lastIndexOf( 'type', 0) === 0 && partQuery == "type=eventGroup")
						informationType = "eventGroup";
				});
				<#-- remove additional query string -->
				this.queryString = this.queryString.replace( "type=eventGroup","");
				
				<#-- Event Group Basic Statistic -->
				if( informationType == "eventGroup" ){
					if( typeof data.eventGroup !== "undefined" ){
						genaralBoxBody.append(
							$( '<dt/>' ).addClass("capitalize").html( data.eventGroup.type )
						)
						.append(
							$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.name )
						);
						
						if( typeof data.eventGroup.abbreviation !== "undefined" ){
							genaralBoxBody.append(
								$( '<dt/>' ).html( "Abbreviation" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.abbreviation )
							);
						}
						
						if( typeof data.eventGroup.description !== "undefined" ){
							genaralBoxBody.append(
								$( '<dt/>' ).html( "Description" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.description )
							);
						}
						
						<#-- Academic Networks -->
						if( typeof data.eventGroup.sources!= "undefined"){
							var onAcademicNetwork = $( '<dd/>' );
							$.each( data.eventGroup.sources , function( index, sourceItem ){							
								onAcademicNetwork.append( 
									$( '<div/>' )
										.addClass( "nowarp urlstyle" )
										.attr( "title", sourceItem.source + " - " + sourceItem.url)
										.html( "<i class='fa fa-globe'></i> " + sourceItem.source + " - " + sourceItem.url)
										.click( function( event ){ event.preventDefault();window.open( sourceItem.url, sourceItem.source ,'scrollbars=yes,width=650,height=500')})
								);
							});
							
							genaralBoxBody
								.append( $( '<dt/>' ).html( "On Academic Networks" ) )
								.append( onAcademicNetwork);
							
						}
						
						targetContainer.append( generalBox );
					}
				}
				<#-- Event Basic Statistic -->
				else{
					<#-- event group -->
					if( typeof data.eventGroup !== "undefined" ){
						genaralBoxBody.append(
							$( '<dt/>' ).addClass("capitalize").html( data.eventGroup.type )
						)
						.append(
							$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.name )
						);
						
						if( typeof data.eventGroup.abbreviation !== "undefined" ){
							genaralBoxBody.append(
								$( '<dt/>' ).html( "Abbreviation" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.abbreviation )
							);
						}
						
						if( typeof data.eventGroup.description !== "undefined" ){
							genaralBoxBody.append(
								$( '<dt/>' ).html( "Description" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.description )
							);
						}
						
						<#-- Academic Networks -->
						if( typeof data.eventGroup.sources!= "undefined"){
							var onAcademicNetwork = $( '<dd/>' );
							$.each( data.eventGroup.sources , function( index, sourceItem ){							
								onAcademicNetwork.append( 
									$( '<div/>' )
										.addClass( "nowarp urlstyle" )
										.attr( "title", sourceItem.source + " - " + sourceItem.url)
										.html( "<i class='fa fa-globe'></i> " + sourceItem.source + " - " + sourceItem.url)
										.click( function( event ){ event.preventDefault();window.open( sourceItem.url, sourceItem.source ,'scrollbars=yes,width=650,height=500')})
								);
							});
							
							genaralBoxBody
								.append( $( '<dt/>' ).html( "On Academic Networks" ) )
								.append( onAcademicNetwork);
							
						}
						
						targetContainer.append( generalBox );
						
					}
					
					<#-- event -->
					if( typeof data.event !== "undefined"){
					
						var boxHeaderTitle = data.eventGroup.name;
						if( typeof data.eventGroup.abbreviation !== "undefined" )
							boxHeaderTitle = data.eventGroup.abbreviation + " " + data.event.year;
							
						<#-- check data status -->
						var specificBoxBody = $( '<div/>' )
												.attr({'class':'box-body'})
		
						<#-- create generalBox -->
						var specificBox = $( '<div/>' )
											.attr({'class':'col-md-12'})
											.append(
												$( '<div/>' )
												.attr({'class':'box box-default box-solid no-border'})
												.append(
													$( '<div/>' )
													.attr({'class':'box-header'})
													.append(
														$( '<h3/>' )
														.attr({'class':'box-title'})
														.html( boxHeaderTitle )
													)
													<#if currentUser??>
													<#--
													.append(
														$( '<div/>' )
														.attr({'class':'box-tools pull-right'})
														.append(
															$( '<div/>' )
															.attr({'class':'btn btn-default btn-xs','data-url':'collapse'})
															.css({'background-color':'#fff','margin-top':'5px'})
															.append(
																$( '<i/>' )
																.attr({'class':'fa fa-edit'})
															)
															.append( "Update" )
														)
													)
													-->
													</#if>
												)
												.append(
													specificBoxBody
												)
											)
						if( typeof data.event.name !== "undefined" && data.eventGroup.type == "Conference" ){
							specificBoxBody
							.append(
								$( '<dt/>' ).html( "Editorship" )
							)
							.append(
								$( '<dd/>' ).html( data.event.name )
							);
						}
						
						if( typeof data.event.date !== "undefined" ){
							specificBoxBody.append(
								$( '<dt/>' ).html( "Date" )
							)
							.append(
								$( '<dd/>' ).html( data.event.date + ", " + data.event.year )
							);
						}
						
						if( typeof data.event.location !== "undefined" ){
							specificBoxBody.append(
								$( '<dt/>' ).html( "Location" )
							)
							.append(
								$( '<dd/>' ).html( data.event.location )
							);
						}
						
						if( typeof data.event.volume !== "undefined" ){
							specificBoxBody.append(
								$( '<dt/>' ).html( "Volume" )
							)
							.append(
								$( '<dd/>' ).html( data.event.volume )
							);
						}
						
						if( typeof data.event.numberOfPaper !== "undefined" ){
							specificBoxBody.append(
								$( '<dt/>' ).html( "Number of Publications" )
							)
							.append(
								$( '<dd/>' ).html( data.event.numberOfPaper )
							);
						}
						
						if( typeof data.event.numberOfParticipant !== "undefined" ){
							specificBoxBody.append(
								$( '<dt/>' ).html( "Number of Participants" )
							)
							.append(
								$( '<dd/>' ).html( data.event.numberOfParticipant )
							);
						}
						
						<#-- Academic Networks -->
						if( typeof data.event.sources!= "undefined"){
							var onAcademicNetwork = $( '<dd/>' );
							$.each( data.event.sources , function( index, sourceItem ){							
								onAcademicNetwork.append( 
									$( '<div/>' )
										.addClass( "nowarp urlstyle" )
										.attr( "title", sourceItem.source + " - " + sourceItem.url)
										.html( "<i class='fa fa-globe'></i> " + sourceItem.source + " - " + sourceItem.url)
										.click( function( event ){ event.preventDefault();window.open( sourceItem.url, sourceItem.source ,'scrollbars=yes,width=650,height=500')})
								);
							});
							
							specificBoxBody
								.append( $( '<dt/>' ).html( "On Academic Networks" ) )
								.append( onAcademicNetwork);
						}
						
						targetContainer.append( specificBox );
					}<#-- end of event details -->
						
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