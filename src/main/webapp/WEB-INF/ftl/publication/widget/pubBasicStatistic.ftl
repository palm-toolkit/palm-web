<div id="boxbody${wId}" class="box-body">
	<form role="form" action="<@spring.url '/publication' />" method="post">
	</form>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId} form").slimscroll({
			height: "250px",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/publication/basicstatistic' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				if( typeof data.publication !== "undefined" ){
					if( typeof data.publication.publicationDate !== "undefined" ){
						targetContainer.append(
											$( '<dt/>' ).html( "Publication Date:" )
										)
										.append(
											$( '<dd/>' ).html( data.publication.publicationDate )
										);
					}
					if( typeof data.publication.type !== "undefined" ){
						var venueName = "";
						var venueUrl = "<@spring.url '/venue' />?type=" + data.publication.type.toLowerCase();
						if( typeof data.publication.eventGroup != "undefined" ){
							venueUrl += "&id=" + data.publication.eventGroup.id
							if( typeof data.publication.eventGroup.abbr  != "undefined"){
								venueName += data.publication.eventGroup.abbr;
							} else {
								venueName += data.publication.eventGroup.name;
							}
							venueUrl += "&name=" + data.publication.eventGroup.name;
						}
						
						if( typeof data.publication.event != "undefined" ){
							venueUrl += "&eventId=" + data.publication.event.id
							//if( typeof data.publication.event.volume != "undefined"){
							//	venueName += " (" + data.publication.event.volume + ") ";
							//} 
							//if( typeof data.publication.event.year != "undefined"){
							//	venueName += data.publication.event.year;
							//}
						}
						targetContainer.append(
											$( '<dt/>' ).html( data.publication.type + ":" )
										)
										.append(
											$( '<dd/>' ).append( $( '<a/>' )
																		.attr({"href": venueUrl})
																		.html( venueName )
															)
										);
					}
					if( typeof data.publication.event != "undefined" ){
						if( typeof data.publication.event.volume != "undefined"){
							targetContainer.append(
								$( '<dt/>' ).html( "Volume:" )
							)
							.append(
								$( '<dd/>' ).html( data.publication.event.volume )
							);
						}
					}
					if( typeof data.publication.pages != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Pages:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.pages )
						);
					}
					if( typeof data.publication.publisher != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Publisher:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.publisher )
						);
					} 
					if( typeof data.publication.cited != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Cited by:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.cited )
						);
					}
					if( typeof data.publication.language != "undefined"){
						targetContainer.append(
							$( '<dt/>' ).html( "Language:" )
						)
						.append(
							$( '<dd/>' ).html( data.publication.language )
						);
					} 
				}
				else
					targetContainer.html( $( '<dl/>' ).append( $( '<dt/>' ).html( "No information available" ) ) );
					
			}
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>