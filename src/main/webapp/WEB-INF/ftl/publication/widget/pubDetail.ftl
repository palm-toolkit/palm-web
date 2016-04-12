<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div id="tab_publication_detail" class="nav-tabs-custom" style="display:none">
        <ul class="nav nav-tabs">
			<li id="header_publicationresult" class="active">
				<a href="#tab_publicationresult" data-toggle="tab" aria-expanded="true">Details</a>
			</li>
			<li id="header_sources">
				<a href="#tab_publicationsources" data-toggle="tab" aria-expanded="true">
					Sources
					<span data-toggle="tooltip" data-placement="bottom" data-html="true" data-original-title="The academic networks sources of this publication, such as Google Scholar, CiteseerX, DBLP, etc.">
						&nbsp;<i class="fa fa-info-circle"></i>
					</span>
				</a>
			</li>
			<li id="header_htmlpdf">
				<a href="#tab_publicationhtmlpdf" data-toggle="tab" aria-expanded="true">
					Web & Pdf
					<span data-toggle="tooltip" data-placement="bottom" data-html="true" data-original-title="The links to digital libraries pages and PDF files of this publication, such as IEEE.explorer, acm.org, DOI, etc.">
						&nbsp;<i class="fa fa-info-circle"></i>
					</span>
				</a>
			</li>
			<#--
			<li id="header_revision">
				<a href="#tab_publicationrevision" data-toggle="tab" aria-expanded="true">Revision</a>
			</li>
			-->
        </ul>
        <div class="tab-content">
			<div id="tab_publicationresult" class="tab-pane active">
			</div>
			<div id="tab_publicationsources" class="tab-pane">
			</div>
			<div id="tab_publicationhtmlpdf" class="tab-pane">
			</div>
			<#--
			<div id="tab_publicationrevision" class="tab-pane">
			</div>
			-->
        </div>
	</div>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} #tab_publication_detail").slimscroll({
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
				<#if loggedUser??>
				<#-- box footer -->
					var addImproveButton = true;
					var isFilesAvailable = true;
					
					if( typeof data.publication.abstractStatus !== "undefined" && data.publication.abstractStatus == "complete" && 
						typeof data.publication.keywordStatus !== "undefined" && data.publication.keywordStatus == "complete")
						addImproveButton = false;
						
					<#-- check publication.files -->
					if( typeof data.publication.files === "undefined" || data.publication.files.length == 0 )
						isFilesAvailable = false;
					
					var boxFooter = $( "#boxbody${wUniqueName}" ).next();
					boxFooter.html( "" );
					
					if( addImproveButton ){
						
						var improveInfoButton = $('<a/>')
													.addClass( "btn btn-block btn-social btn-twitter btn-sm width220px pull-right" )
													.html( "<strong>Improve Abstract & Keywords</strong>" )
													.click( function(){
														improveAbstractAndKeyword( data.publication.id, $( this ) , isFilesAvailable);
													})
						boxFooter.html( improveInfoButton );
					}
					
				</#if>
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
					.html( "Authors :" );

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
										.css({"padding" : "0 15px 0 5px"})
										.html( authorItem.name );
					
					if( authorItem.isAdded )			
						eachAuthorName.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name});
					else
						eachAuthorName
							.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name + "&add=yes"})
							.addClass( "text-gray" );
					
					eachAuthor.append( eachAuthorName );
					
					pubCoauthorContainer.append( eachAuthor );
				});

				pubCoauthor
					.append( pubCoauthorHeader )
					.append( pubCoauthorContainer );

				tabContentPublicationResult
					.append( pubTitle )
					.append( pubCoauthor );

				<#-- abstract -->
				if( typeof data.publication.abstract != 'undefined'){
					var pubAbstract = 
						$('<dl/>')
						.addClass( "palm_section abstractSec" )
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
				
				<#-- keywords -->
				if( typeof data.publication.keyword != 'undefined'){
					var pubKeyword = 
						$('<dl/>')
						.addClass( "palm_section keywordSec" )
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
					//if( tabHeaderText.length === "googlescholar" )
						//tabHeaderTextShort = tabHeaderText.substring(0,6);

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
										.css( "clean","both" );
										
					contentDetail.append(
											$( '<dt/>' ).html( "Obtained from : " )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.source )
										);
					if( typeof htmlpdf_item.label !== "undefoned" && htmlpdf_item.label != "" )
						contentDetail.append(
											$( '<dt/>' ).html( "Source name:" )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.label )
										)
					contentDetail.append(
											$( '<dt/>' ).html( "Source url:" )
										)
										.append(
											$( '<dd/>' ).html( htmlpdf_item.url )
										)

					<#-- content extractedContent -->
					var contentExtractedResult = $( '<div/>' )
													.attr({ "id" : "result" + tabHeaderTextShort })
													.css({ "width" : "100%" });
													
					<#--if( data.publication.type !== "BOOK" )-->
						contentExtractedResult.html( 'Please press "Extract ' + htmlpdf_item.type + '" button to see the extracted result here'  );

					<#-- content navigation -->
					var contentNavigation = 
					$('<div/>')
					.css({ "height":"40px"})
					.append(
						$('<button/>')
						.addClass( "btn btn-default btn-sm pull-left" )
						.css({ "width":"40%"})
						.attr({ "title":  "open " + tabHeaderText} )
						.html( "Open " + htmlpdf_item.type + " in new small window" )
						.click( function( event ){ event.preventDefault();window.open( htmlpdf_item.url , tabHeaderText ,'scrollbars=yes,width=650,height=500')})
					)
					
					<#--if( data.publication.type !== "BOOK" ) -->
						contentNavigation.append(
							$('<button/>')
							.addClass( "btn btn-default btn-sm pull-right" )
							.css({ "width":"40%"})
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
							
						if( typeof v == "string")
							v = v.replace(/(?:\r\n|\r|\n)/g, '<br />');
						descriptionList.append(
											$( '<dt/>' ).addClass( "capitalize" ).html( k )
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
						$.getJSON( "<@spring.url '/publication/pdfExtract' />" + "?url=" + encodeURIComponent(sourceUrl) , function( data ) {
  							contentExtractedResult.html( printKeyValue( data ));
  						});
					} else if( targetType == "HTML" ){
						$.getJSON( "<@spring.url '/publication/htmlExtract' />" + "?url=" + encodeURIComponent(sourceUrl) , function( data ) {
  							contentExtractedResult.html( printKeyValue( data ));
  						});
					}
				}
				
				function improveAbstractAndKeyword( publicationId, triggerElem , isFilesAvailable ){
					<#-- publication improveinfo -->
					<#-- container -->
					var publicationImproveContainer = $( '<div/>' )
														.addClass( "box box-default box-solid" )
														.attr({"id":"improveBox"})
														.append(
															 $( '<div/>' )
															.addClass( "box-header" )
															.append(
																 $( '<h3/>' )
																 	.addClass( "box-title" )
																	.html( "Improve Abstract and Keywords" )
																)
														);
														
					var publicationImproveBody = $( '<div/>' )
													.addClass( "box-body" )
													.append("Please select one of the following options. Please check the correctness of abstract and keywords before submitting. You may edit the content if it is necessary.");
					publicationImproveContainer.append( publicationImproveBody );
					
					var publicationImproveInfoInnerTabs = $( '<div/>' )
														.attr({"id":"tab_inner_publication_improveinfo"})
														.addClass( "nav-tabs-custom" );
					var publicationImproveInfoInnerTabsHeaders = $( '<ul/>' )
														.addClass( "nav nav-tabs" );
					var publicationImproveInfoInnerTabsContents = $( '<div/>' )
														.addClass( "tab-content" );
	
					<#-- append tab header and content -->
					publicationImproveInfoInnerTabs.append( publicationImproveInfoInnerTabsHeaders ).append( publicationImproveInfoInnerTabsContents );
	
					<#-- set inner tab into main tab -->
					publicationImproveContainer.append( publicationImproveInfoInnerTabs );
					tabContentPublicationResult.append( publicationImproveContainer );
					
					<#-- get original value -->
					var origAbstractElem = tabContentPublicationResult.find( ".abstractSec" );
					var origKeywordElem = tabContentPublicationResult.find( ".keywordSec" );
					var origAbstractText = "";
					var origKeywordText = "";
					
					if( origAbstractElem.length ){
						origAbstractText = origAbstractElem.find( ".palm_content" ).text();
						origAbstractElem.hide();
					}
					if( origAbstractElem.length ){
						origKeywordText = origKeywordElem.find( ".palm_content" ).text();
						origKeywordElem.hide();
					}
					<#-- hide button -->
					triggerElem.hide();
					
					<#-- generate first tab -->
					var dataOriginal = { "result":{ "abstract":origAbstractText, "keyword":origKeywordText } };
					addImprovementForm( publicationId, tabContentPublicationResult, triggerElem, publicationImproveInfoInnerTabsHeaders , publicationImproveInfoInnerTabsContents, "Database", dataOriginal , true);
		
					<#-- generate other tabs -->
					if( isFilesAvailable ){
						<#-- show pop up progress log -->
						var uniquePid = $.PALM.utility.generateUniqueId();
						$.PALM.popUpMessage.create( "Trying to extract information from PDF or digital libraries...", { uniqueId:uniquePid, popUpHeight:150, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid, pollingTime:500} );
		
						$.getJSON( "<@spring.url '/publication/pdfHtmlExtract' />" + "?id=" + data.publication.id + "&pid=" + uniquePid, function( dataFiles ) {
							
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePid, { pollingTime:500} );
			
							$.each( dataFiles.files , function( index, dataFile ){
								var tableHeader = ( index + 1) + "_" + dataFile.type;
								addImprovementForm( publicationId, tabContentPublicationResult, triggerElem, publicationImproveInfoInnerTabsHeaders , publicationImproveInfoInnerTabsContents, tableHeader, dataFile);
							});
						});
					}
				}
				
				function addImprovementForm( publicationId, tabContentPublicationResult, triggerElem, publicationImproveInfoInnerTabsHeaders , publicationImproveInfoInnerTabsContents, tabTitleText, tabContentObj , isActive){
					var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tabs_" + tabTitleText, "data-toggle":"tab" , "aria-expanded" : "true"})
							.html( tabTitleText )
						);
						
					<#-- tab content -->
					var tabContent = $( '<div/>' )
						.attr({ "id" : "tabs_" + tabTitleText })
						.addClass( "tab-pane" )
	
					
					
					<#-- source detail -->
					if( typeof tabContentObj.url !== "undefined" ){
						var sourceElem = $( '<div/>' )
											.append( "Source: (click to view)" )
											.append(
												$( '<div/>' )
													.addClass( "font-xs urlstyle" )
													.append( 
														tabContentObj.url 
													)
													.click( function( event ){ event.preventDefault();window.open( tabContentObj.url, "link to source" ,'scrollbars=yes,width=650,height=500')})
											);
						
						tabContent.append( sourceElem );
					}
					
					<#-- abstract detail -->
					
					var abstractElem = $( '<div/>' )
										.append( "Abstract*:" );
										
					
					tabContent.append( abstractElem );
					if( typeof tabContentObj.result.abstract !== "undefined" ){
						abstractElem.append(
											$( '<textarea/>' )
											.addClass("abstractText")
											.attr({"placeholder":"abstract, minimal 200 characters length"})
											.css({ "width":"100%","height":"140px"})
											.val( tabContentObj.result.abstract )
										);
					} else {
						abstractElem.append(
											$( '<textarea/>' )
											.addClass("abstractText")
											.attr({"placeholder":"abstract, minimal 200 characters length"})
											.css({ "width":"100%","height":"140px"})
										);
					}
					
					<#-- keywords detail -->
					
					var keywordElem = $( '<div/>' )
										.append( "Keywords:" );
										
					
					tabContent.append( keywordElem );
					
					if( typeof tabContentObj.result.keyword !== "undefined" ){
						keywordElem.append(
							$( '<textarea/>' )
							.addClass("keywordText")
							.css({ "width":"100%","height":"40px"})
							.attr({"placeholder":"keywords, separated by comma"})
							.val( tabContentObj.result.keyword )
						);
					} else {
						keywordElem.append(
							$( '<textarea/>' )
							.addClass("keywordText")
							.css({ "width":"100%","height":"40px"})
							.attr({"placeholder":"keywords, separated by comma"})
						);
					}
					
					<#-- required field -->
					var infoElem = $( '<div/>' )
										.append( "* required field" );
					tabContent.append( infoElem );
					
					<#-- required field -->
					var errorElem = $( '<div/>' )
										.addClass(".errorBlock");
					tabContent.append( errorElem );			
					
					<#-- cancel button -->
					var cancelButton = $( "<a/>" )
        					.attr({
        						"class":"btn btn-block btn-default btn-sm pull-left",
        						"style":"width:80px"
        						})
        					.append(
        						"<strong>Cancel</strong>"
        					)
							.click( function( event ){
								event.preventDefault();
								triggerElem.show();
								var origAbstractElem = tabContentPublicationResult.find( ".abstractSec" );
								var origKeywordElem = tabContentPublicationResult.find( ".keywordSec" );
								if( origAbstractElem.length )
									origAbstractElem.show();
								if( origAbstractElem.length )
									origKeywordElem.show();
								tabContentPublicationResult.find( "#improveBox" ).remove();
							});
					tabContent.append( cancelButton );
					
				
					
					<#-- submit button -->
					var saveButton = $( "<a/>" )
        					.attr({
        						"class":"btn btn-block btn-social btn-twitter btn-sm pull-right",
        						"style":"width:80px;margin-top:0;padding:5px 0 !important;text-align:center"
        						})
        					.append(
        						"<strong>Save</strong>"
        					)
							.click( function( event ){
								event.preventDefault();
								<#-- validation -->
								var abstractText = tabContent.find( ".abstractText" ).val();
								var keywordText = tabContent.find( ".keywordText" ).val();
								if( abstractText.length < 200 ){
									$.PALM.utility.showErrorTimeout( errorElem , "Abstract is empty or too short")
									return false;
								}
								<#-- save changes -->
								<#--refresh widgets-->
								var thisWidget = $.PALM.boxWidget.getByUniqueName( '${wUniqueName}' );
								<#-- add overlay -->
								thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					
								$.post("<@spring.url '/publication/edit' />", { publicationId:publicationId, abstractText:abstractText,keywordList:keywordText}, function( dataSave ) {
									if( dataSave.status == "ok" ){
										<#-- add overlay -->
										thisWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					
										$.PALM.boxWidget.refresh( thisWidget.element , thisWidget.options );
										
										<#-- topic widget-->
										
										var widgetTopicComposition = $.PALM.boxWidget.getByUniqueName( 'publication_topic_composition' );
										<#-- add overlay -->
										widgetTopicComposition.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
					
										$.PALM.boxWidget.refresh( widgetTopicComposition.element , widgetTopicComposition.options );
									}
								});
									
							});
					tabContent.append( saveButton );
					
					<#-- container closing -->
					tabContent.append( "<br class='clear'>" );
									
					if( isActive ){
						tabHeader.addClass( "active" );
						tabContent.addClass( "active" );
					}
	
					<#-- append tab header and content -->
					publicationImproveInfoInnerTabsHeaders.append( tabHeader );
					publicationImproveInfoInnerTabsContents.append( tabContent );
				}
			
			}
		};


		var publicationDetailObject = {
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
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