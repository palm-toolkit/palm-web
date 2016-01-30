<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	<form role="form" action="<@spring.url '/venue' />" method="post">
	</form>
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
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				targetContainer.html( "" );
				
				<#-- check data status -->
				
				
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
						targetContainer.append(
							$( '<dt/>' ).addClass("capitalize").html( data.eventGroup.type )
						)
						.append(
							$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.name )
						);
						
						if( typeof data.eventGroup.abbreviation !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Abbreviation" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.abbreviation )
							);
						}
						
						if( typeof data.eventGroup.description !== "undefined" ){
							targetContainer.append(
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
							
							targetContainer
								.append( $( '<dt/>' ).html( "Main <span class='capitalize'>" + data.eventGroup.type + "</span> on Academic Networks:" ) )
								.append( onAcademicNetwork);
							
						}
						
					}
				}
				<#-- Event Basic Statistic -->
				else{
					<#-- event group -->
					if( typeof data.eventGroup !== "undefined" ){
						targetContainer.append(
							$( '<dt/>' ).addClass("capitalize").html( data.eventGroup.type )
						)
						.append(
							$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.name )
						);
						
						if( typeof data.eventGroup.abbreviation !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Abbreviation" )
							)
							.append(
								$( '<dd/>' ).addClass("capitalize").html( data.eventGroup.abbreviation )
							);
						}
						
						if( typeof data.eventGroup.description !== "undefined" ){
							targetContainer.append(
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
							
							targetContainer
								.append( $( '<dt/>' ).html( "Main <span class='capitalize'>" + data.eventGroup.type + "</span> on Academic Networks:" ) )
								.append( onAcademicNetwork);
							
						}
						
					}
					
					<#-- event -->
					if( typeof data.event !== "undefined" ){
					
						
						if( typeof data.event.name !== "undefined" ){
							targetContainer
							.append(
								$( '<dt/>' ).html( "Editorship" )
							)
							.append(
								$( '<dd/>' ).html( data.event.name )
							);
						}
						
						if( typeof data.event.date !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Date" )
							)
							.append(
								$( '<dd/>' ).html( data.event.date + ", " + data.event.year )
							);
						}
						
						if( typeof data.event.location !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Location" )
							)
							.append(
								$( '<dd/>' ).html( data.event.location )
							);
						}
						
						if( typeof data.event.volume !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Volume" )
							)
							.append(
								$( '<dd/>' ).html( data.event.volume )
							);
						}
						
						if( typeof data.event.numberOfPaper !== "undefined" ){
							targetContainer.append(
								$( '<dt/>' ).html( "Number of Publications" )
							)
							.append(
								$( '<dd/>' ).html( data.event.numberOfPaper )
							);
						}
						
						if( typeof data.event.numberOfParticipant !== "undefined" ){
							targetContainer.append(
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
							
							targetContainer
								.append( $( '<dt/>' ).html( "<span class='capitalize'>" + data.eventGroup.type + "</span> in " + data.event.year + " on Academic Networks:" ) )
								.append( onAcademicNetwork);
							
						}
						
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