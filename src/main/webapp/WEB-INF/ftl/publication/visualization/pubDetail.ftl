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
			source : "<@spring.url '/publication/detail' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				targetContainer.html( "" );

				if( typeof data.publication.pdfurl != 'undefined'){
					var pdfSource;
					if( typeof data.publication.pdf != 'undefined')
						pdfSource = data.publication.pdf;
					else
						pdfSource = data.publication.pdfurl;
					var pubOption = 
					$('<div/>')
					.addClass( "palm_option" )
					.append(
						$('<button/>')
						.addClass( "btn btn-block btn-default palm_option_btn" )
						.attr({ "title":  "open " + pdfSource} )
						.html( "Open Pdf"  )
						.click( function( event ){ event.preventDefault();window.open( data.publication.pdfurl)})
					).append(
						$('<button/>')
						.addClass( "btn btn-block btn-default palm_option_btn" )
						.html( "Extract Pdf"  )
						.click( function( event ){ event.preventDefault();extractPdf( data.publication.id )})
					);

					targetContainer
					.append( pubOption );

				}
				var pubTitle = 
					$('<div/>')
					.addClass( "palm_section" )
					.append(
						$('<div/>')
						.addClass( "palm_label" )
						.html( "Title :" )
					).append(
						$('<div/>')
						.addClass( "palm_content" )
						.html( data.publication.title )
					);


				var pubCoauthor = 
					$('<div/>')
					.addClass( "palm_pub_coauthor_blck" );

				var pubCoauthorHeader =
					$('<div/>')
					.addClass( "palm_label" )
					.html( "Coauthor :" );

				var pubCoauthorContainer =
					$('<div/>')
					.addClass( "palm_pub_coauthor_ctr" );
									
				$.each( data.publication.coauthor, function( index, eachauthor){
					var eachAuthor =
						$( '<div/>' )
							.addClass( 'palm_pub_atr' )
							.attr({ 'id' : eachauthor.id })
							.append(
								$( '<div/>' )
								.addClass( 'palm_pub_atr_photo fa fa-user' )
							).append(
								$( '<div/>' )
								.addClass( 'palm_atr_name' )
								.html( eachauthor.name )
							);

					if( typeof eachauthor.aff != 'undefined')
						eachAuthor.append(
							$( '<div/>' )
								.addClass( 'palm_atr_aff' )
								.html( eachauthor.aff )
							);
					if( typeof eachauthor.photo != 'undefined'){
						eachAuthor
							.find( '.palm_pub_atr_photo' )
							.removeClass( "fa fa-user" )
							.css({ 'font-size':'14px'})
							.append(
								$( '<img/>' )
									.attr({ 'src' : eachauthor.photo })
									.addClass( "palm_pub_atr_img" )
							);
					}
					<#-- put click action here -->
					pubCoauthorContainer.append( eachAuthor)
				});

				pubCoauthor
					.append( pubCoauthorHeader )
					.append( pubCoauthorContainer );

				targetContainer
					.append( pubTitle )
					.append( pubCoauthor );

				if( typeof data.publication.keyword != 'undefined'){
					var pubKeyword = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Keywords :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.keyword )
						);
							
				targetContainer
					.append( pubKeyword );
				}	

				if( typeof data.publication.abstract != 'undefined'){
					var pubAbstract = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Abstract :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.abstract )
						);
							
				targetContainer
					.append( pubAbstract );
				}	

				if( typeof data.publication.content != 'undefined'){
					var pubContent = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Content :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.content.replace(/(\t\n)+/g, '<br /><strong>').replace(/(\n\t)+/g, '</strong><br />').replace(/(\n)/g, '<br />') )
						);
							
				targetContainer
					.append( pubContent );
				}

				if( typeof data.publication.reference != 'undefined'){
					var pubReference = 
						$('<div/>')
						.addClass( "palm_section" )
						.append(
							$('<div/>')
							.addClass( "palm_label" )
							.html( "Reference :" )
						).append(
							$('<div/>')
							.addClass( "palm_content" )
							.html( data.publication.reference )
						);
							
				targetContainer
					.append( pubReference );
				}
			}
		};


		var publicationDetailObject = {
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		}
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push( publicationDetailObject );
	    
	    function extractPdf( publicationId ){
			<#-- add overlay  -->
			publicationDetailObject.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
			$.getJSON( "<@spring.url '/publication/pdfExtract' />?id=" + publicationId, function( data ){
				if( data.status == "Ok" ){
					publicationDetailObject.options.queryString = "?id=" + publicationId;
					$.PALM.boxWidget.refresh( publicationDetailObject.element , publicationDetailObject.options );
				} else {
					alert( data.status );
    				// remove overlay and loading 
    				publicationDetailObject.element.find( ".overlay" ).remove();
				}
    		});
		}
	});<#-- end document ready -->
</script>