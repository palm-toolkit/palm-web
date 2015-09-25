<div id="boxbody${wId}" class="box-body">
	<div id="tab_publication_detail" class="nav-tabs-custom" style="display:none">
        <ul class="nav nav-tabs">
			<li id="header_publicationresult" class="active">
				<a href="#tab_publicationresult" data-toggle="tab" aria-expanded="true">Detail</a>
			</li>
			<li id="header_sources">
				<a href="#tab_publicationsources" data-toggle="tab" aria-expanded="true">Sources</a>
			</li>
			<li id="header_htmlpdf">
				<a href="#tab_publicationhtmlpdf" data-toggle="tab" aria-expanded="true">Html & Pdf</a>
			</li>
			<li id="header_revision">
				<a href="#tab_publicationrevision" data-toggle="tab" aria-expanded="true">Revision</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_publicationresult" class="tab-pane active">
			</div>
			<div id="tab_publicationsources" class="tab-pane">
			</div>
			<div id="tab_publicationhtmlpdf" class="tab-pane">
			</div>
			<div id="tab_publicationrevision" class="tab-pane">
			</div>
        </div>
	</div>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId}").slimscroll({
			height: "550px",
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
				<#-- show tab -->
				var tabPublicationDetail = $( widgetElem ).find( "#tab_publication_detail" ).first();
				tabPublicationDetail.show();

				<#-- publication tab -->
				var tabHeaderPublicationResult = $( widgetElem ).find( "#header_publicationresult" ).first();
				var tabContentPublicationResult = $( widgetElem ).find( "#tab_publicationresult" ).first();

				<#-- sources tab -->
				var tabHeaderPublicationSources = $( widgetElem ).find( "#header_publicationsources" ).first();
				var tabContentPublicationSources = $( widgetElem ).find( "#tab_publicationsources" ).first();


				<#--remove previous content -->
				tabContentPublicationResult.html( "" );
				tabContentPublicationSources.html( "" );


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
						.click( function( event ){ event.preventDefault();openPfdOnDialog( data.publication.pdfurl)})
					).append(
						$('<button/>')
						.addClass( "btn btn-block btn-default palm_option_btn" )
						.html( "Extract Pdf"  )
						.click( function( event ){ event.preventDefault();extractPdf( data.publication.id )})
					);

					tabContentPublicationResult
					.append( pubOption );

				}

				<#-- title -->
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

				<#-- authors -->
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

				tabContentPublicationResult
					.append( pubTitle )
					.append( pubCoauthor );

				<#-- keywords -->
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
							
				tabContentPublicationResult
					.append( pubKeyword );
				}	

				<#-- abstract -->
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
							
				tabContentPublicationResult
					.append( pubAbstract );
				}	

				<#-- content -->
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
							
				tabContentPublicationResult
					.append( pubContent );
				}

				<#-- references -->
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
							
				tabContentPublicationResult
					.append( pubReference );
				}

				<#-- publication sources -->
				var publicationSourceInnerTabs = $( '<div/>' )
													.attr({"id":"tab_inner_publication_sources"})
													.addClass( "nav-tabs-custom" );
				var publicationSourceInnerTabsHeaders = $( '<ul/>' )
													.addClass( "nav nav-tabs" );
				var publicationSourceInnerTabsContents = $( '<div/>' )
													.addClass( "tab-content" );

				<#-- append tab header and content -->
				publicationSourceInnerTabs.append( publicationSourceInnerTabsHeaders ).append( publicationSourceInnerTabsContents );

				<#-- set inner tab into main tab -->
				tabContentPublicationSources.html( publicationSourceInnerTabs );

				<#-- fill with sources -->
				$.each( data.publication.sources , function( index, source_item ){
					<#-- tab header -->
					var tabHeaderText = capitalizeFirstLetter( source_item.source );
					var tabHeaderTextShort = tabHeaderText;
					if( tabHeaderText.length > 6 )
						tabHeaderTextShort = tabHeaderText.substring(0,6);

					var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tab_" + tabHeaderText, "data-toggle":"tab" , "aria-expanded" : "true", "title" : tabHeaderText})
							.html( tabHeaderTextShort )
						);
		
					<#-- tab content -->
					var tabContent = $( '<div/>' )
						.attr({ "id" : "tab_" + tabHeaderText })
						.addClass( "tab-pane" )
						.html( printKeyValue( source_item ));

					if( index == 0 ){
						tabHeader.addClass( "active" );
						tabContent.addClass( "active" );
					}

					<#-- append tab header and content -->
					publicationSourceInnerTabsHeaders.append( tabHeader );
					publicationSourceInnerTabsContents.append( tabContent );

				});

				function printKeyValue( jsObject ){
					var descriptionList = $( '<dl/>' );
					$.each( jsObject , function( k, v){
						if( k == "source" )
							return;
						descriptionList.append(
											$( '<dt/>' ).html( k )
										)
										.append(
											$( '<dd/>' ).html( v )
										);
					});
					return descriptionList;
				} 

				function capitalizeFirstLetter(string) {
    				return string.charAt(0).toUpperCase() + string.toLowerCase().slice(1);
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

		function openPfdOnDialog( pdfUrl ){
			var pdfDialog = $( '<div/>' )
								.addClass( "palm_pdf_dialog" )
								.append(
									$( '<iframe/>' )
									.addClass( "externalContent" )
									.attr({ "scrolling":"yes" , "frameborder":"no" , "marginheight":"0" , "marginwidth":"0", "border":"0" , "src": pdfUrl })
								);
			$( 'body' ).append( pdfDialog );
			pdfDialog.dialog( 
    		{ 
        		title: 'Pdf View',
				height: 460,
				width: 600,
        		close: function(event, ui) 
       			{ 
            		pdfDialog.dialog( "destroy" ).remove();
        		} 
    		});
			pdfDialog.dialog( "open" );
		}


<#-- IFRAME LOAD READY -->
<#-- http://stackoverflow.com/questions/205087/jquery-ready-in-a-dynamically-inserted-iframe -->



	});<#-- end document ready -->
</script>