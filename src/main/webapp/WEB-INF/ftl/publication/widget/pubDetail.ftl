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
				<a href="#tab_publicationhtmlpdf" data-toggle="tab" aria-expanded="true">Html&Pdf</a>
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
		$("#boxbody${wId} #tab_publication_detail").slimscroll({
			height: "550px",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
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

				<#-- htmlpdf tab -->
				var tabHeaderPublicationHtmlPdfs = $( widgetElem ).find( "#header_publicationhtmlpdf" ).first();
				var tabContentPublicationHtmlPdfs = $( widgetElem ).find( "#tab_publicationhtmlpdf" ).first();


				<#--remove previous content -->
				tabContentPublicationResult.html( "" );
				tabContentPublicationSources.html( "" );

				<#-- title -->
				var pubTitle = 
					$('<dl/>')
					.addClass( "palm_section" )
					.append(
						$('<dt/>')
						.addClass( "palm_label" )
						.html( "Title :" )
					).append(
						$('<dd/>')
						.addClass( "palm_content" )
						.html( data.publication.title )
					);

				<#-- authors -->
				var pubCoauthor = 
					$('<dl/>')
					.addClass( "palm_pub_coauthor_blck" );

				var pubCoauthorHeader =
					$('<dt/>')
					.addClass( "palm_label" )
					.html( "Coauthor :" );

				var pubCoauthorContainer = $( '<dd/>' )
											.addClass( "author-list" );

				$.each( data.publication.coauthor, function( index, authorItem ){
					var eachAuthor = $( '<span/>' );
					
					<#-- photo -->
					var eachAuthorImage = null;
					if( typeof authorItem.photo !== 'undefined' ){
						eachAuthorImage = $( '<img/>' )
							.addClass( "timeline-author-img" )
							.attr({ "width":"40px" , "src" : authorItem.photo , "alt" : authorItem.name });
					} else {
						eachAuthorImage = $( '<i/>' )
							.addClass( "fa fa-user bg-aqua" )
							.attr({ "title" : authorItem.name });
					}
					eachAuthor.append( eachAuthorImage );

					<#-- name -->
					var eachAuthorName = $( '<a/>' )
										.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name})
										.css({"padding" : "0 15px 0 5px"})
										.html( authorItem.name );
					eachAuthor.append( eachAuthorName );
					
					pubCoauthorContainer.append( eachAuthor );
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
						$('<dl/>')
						.addClass( "palm_section" )
						.append(
							$('<dt/>')
							.addClass( "palm_label" )
							.html( "Keywords :" )
						).append(
							$('<dd/>')
							.addClass( "palm_content" )
							.html( data.publication.keyword )
						);
							
				tabContentPublicationResult
					.append( pubKeyword );
				}	

				<#-- abstract -->
				if( typeof data.publication.abstract != 'undefined'){
					var pubAbstract = 
						$('<dl/>')
						.addClass( "palm_section" )
						.append(
							$('<dt/>')
							.addClass( "palm_label" )
							.html( "Abstract :" )
						).append(
							$('<dd/>')
							.addClass( "palm_content" )
							.html( data.publication.abstract )
						);
							
				tabContentPublicationResult
					.append( pubAbstract );
				}	

				<#-- content -->
				if( typeof data.publication.content != 'undefined'){
					var pubContent = 
						$('<dl/>')
						.addClass( "palm_section" )
						.append(
							$('<dt/>')
							.addClass( "palm_label" )
							.html( "Content :" )
						).append(
							$('<dd/>')
							.addClass( "palm_content" )
							.html( data.publication.content.replace(/(\t\n)+/g, '<br /><strong>').replace(/(\n\t)+/g, '</strong><br />').replace(/(\n)/g, '<br />') )
						);
							
				tabContentPublicationResult
					.append( pubContent );
				}

				<#-- references -->
				if( typeof data.publication.reference != 'undefined'){
					var pubReference = 
						$('<dl/>')
						.addClass( "palm_section" )
						.append(
							$('<dt/>')
							.addClass( "palm_label" )
							.html( "Reference :" )
						).append(
							$('<dd/>')
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

				<#-- publication htmlpdfs -->
				var publicationHtmlPdfInnerTabs = $( '<div/>' )
													.attr({"id":"tab_inner_publication_htmlpdfs"})
													.addClass( "nav-tabs-custom" );
				var publicationHtmlPdfInnerTabsHeaders = $( '<ul/>' )
													.addClass( "nav nav-tabs" );
				var publicationHtmlPdfInnerTabsContents = $( '<div/>' )
													.addClass( "tab-content" );

				<#-- append tab header and content -->
				publicationHtmlPdfInnerTabs.append( publicationHtmlPdfInnerTabsHeaders ).append( publicationHtmlPdfInnerTabsContents );

				<#-- set inner tab into main tab -->
				tabContentPublicationHtmlPdfs.html( publicationHtmlPdfInnerTabs );

				<#-- fill with htmlpdfs -->
				$.each( data.publication.files , function( index, htmlpdf_item ){
					<#-- tab header -->
					var tabHeaderText = htmlpdf_item.type + " from " + htmlpdf_item.label;
					var tabHeaderTextShort = ( index + 1 ) + "-" + htmlpdf_item.type;

					var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tab_" + tabHeaderTextShort, "data-toggle":"tab" , "aria-expanded" : "true", "title" : tabHeaderText})
							.html( tabHeaderTextShort )
						);

					<#-- content detail -->
					var contentDetail = $( '<dl/>' )
										.addClass( "dl-horizontal" )
										.append(
											$( '<dt/>' ).html( "Obtained from : " )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.source )
										)
										.append(
											$( '<dt/>' ).html( "Source name:" )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.label )
										)
										.append(
											$( '<dt/>' ).html( "Source url:" )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.url )
										)

					<#-- content extractedContent -->
					var contentExtractedResult = $( '<div/>' )
													.attr({ "id" : "result" + tabHeaderTextShort })
													.css({ "width" : "100%" })
													.html( 'Please press "Extract ' + htmlpdf_item.type + '" button to see the extracted result here'  );

					<#-- content navigation -->
					var contentNavigation = 
					$('<div/>')
					.addClass( "palm_option" )
					.append(
						$('<button/>')
						.addClass( "btn btn-block btn-default palm_option_btn" )
						.attr({ "title":  "open " + tabHeaderText} )
						.html( "Open " + htmlpdf_item.type + " in new small window" )
						.click( function( event ){ event.preventDefault();window.open( htmlpdf_item.url , tabHeaderText ,'scrollbars=yes,width=650,height=500')})
					).append(
						$('<button/>')
						.addClass( "btn btn-block btn-default palm_option_btn" )
						.html( "Extract " + htmlpdf_item.type )
						.click( function( event ){ event.preventDefault();extractHtmlOrPublication( htmlpdf_item.url , htmlpdf_item.type , contentExtractedResult );})
					);
		
					<#-- tab content -->
					var tabContent = $( '<div/>' )
						.attr({ "id" : "tab_" + tabHeaderTextShort })
						.addClass( "tab-pane" )
						.append( contentNavigation )
						.append( contentDetail )
						.append( contentExtractedResult );

					if( index == 0 ){
						tabHeader.addClass( "active" );
						tabContent.addClass( "active" );
					}

					<#-- append tab header and content -->
					publicationHtmlPdfInnerTabsHeaders.append( tabHeader );
					publicationHtmlPdfInnerTabsContents.append( tabContent );

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

				function extractHtmlOrPublication( sourceUrl , targetType, contentExtractedResult ){
					contentExtractedResult.html( "Extracting " + targetType + " from " + sourceUrl + " ..."  );
					if( targetType == "PDF" ){
						$.getJSON( "<@spring.url '/publication/pdfExtractTest' />" + "?url=" + encodeURIComponent(sourceUrl) , function( data ) {
  							contentExtractedResult.html( printKeyValue( data ));
  						});
					} else if( targetType == "HTML" ){
						$.getJSON( "<@spring.url '/publication/htmlExtractTest' />" + "?url=" + encodeURIComponent(sourceUrl) , function( data ) {
  							contentExtractedResult.html( printKeyValue( data ));
  						});
					}
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