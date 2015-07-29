<div id="boxbody${wId}" class="box-body">
	<form role="form" action="<@spring.url '/publication' />" method="post">
	</form>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId}").slimscroll({
			height: "500px",
	        size: "3px"
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
				targetContainer.html( "" );

				if( typeof data.publication.date != 'undefined'){
					var pubDate = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Publication date :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.date )
						);
							
				targetContainer
					.append( pubDate );
				}

				if( typeof data.publication.language != 'undefined'){
					var pubLanguage = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Language :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.language )
						);
							
				targetContainer
					.append( pubLanguage );
				}

				if( typeof data.publication.cited != 'undefined'){
					var pubCited = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Total citations :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.cited )
						);
							
					targetContainer
						.append( pubCited );
				}

				if( typeof data.publication.type != 'undefined'){
					var pubType = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Publication type :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.type )
						);
							
					targetContainer
						.append( pubType );
				}

				if( typeof data.publication.event != 'undefined'){
					var pubEvent = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Event :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.event.name )
						);
							
					targetContainer
						.append( pubEvent );
				}

				if( typeof data.publication.volume != 'undefined'){
					var pubVolume = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Volume :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.volume )
						);
							
					targetContainer
						.append( pubVolume );
				}

				if( typeof data.publication.issue != 'undefined'){
					var pubIssue = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Issue :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.issue )
						);
							
					targetContainer
						.append( pubIssue );
				}

				if( typeof data.publication.pages != 'undefined'){
					var pubPages = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Pages :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.pages )
						);
							
					targetContainer
						.append( pubPages );
				}

				if( typeof data.publication.publisher != 'undefined'){
					var pubPublisher = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Publisher :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.publisher )
						);
							
					targetContainer
						.append( pubPublisher );
				}


				if( targetContainer.html() == "" ){
					var pubInfo = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "No statistical data available" )
						);
							
					targetContainer
						.append( pubInfo );
				}
					
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