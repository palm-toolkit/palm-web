<div id="boxbody<#--${wUniqueName}-->" class="box-body">

	 <form role="form" id="addCircle" action="<@spring.url '/circle/edit' />" method="post">
		<#-- circle Id -->
		<#if circleId??>
			<input type="hidden" id="circleId" name="id" value="${circleId}" />
		</#if>

		<#-- name -->
		<div class="form-group">
	      <label>Title *</label>
	      <input type="text" id="circleName" name="name" class="form-control" placeholder="circle name" />
	    </div>

		<#-- abstract -->
		<div class="form-group">
	      <label>Description *</label>
	      <textarea name="description" id="circleDescription" class="form-control" rows="3" placeholder="Description"></textarea>
	    </div>
	    
        <br/>
        <br/>
	    
	    <div class="circle-input-container">
	    		    
	    	<div id="inputAuth" class="circle-input-column">
	    		
	    		<strong>Researcher List</strong>
	    		<div class="box-body no-padding">
					<div class="box-tools">
					    <div class="input-group" style="width: 100%;">
					      <input type="text" id="researcher_search_field" name="researcher_search_field" class="form-control input-sm pull-right" 
					      placeholder="Search researchers on database">
					      <div id="researcher_search_button" class="input-group-btn">
					        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
					      </div>
					    </div>
				  	</div>
				  	
				  	<div class="content-list height580px">
				    </div>
				</div>
				
	    	</div>
		    			    
		    <div id="circleAuth" class="circle-input-column circle-input-right">
		    	<strong>Researchers on Circle</strong>
		    	
		    	<div class="content-list height610px">
				</div>
		    </div>
		    
        
        </div>
        
        <#-- related to publication -->
        <div class="circle-input-container">
        
	    	<div id="inputPub" class="circle-input-column">
	    	                                                              
	    		<strong>Publications List</strong>
	    	
	    		<div class="box-body no-padding">
					<div class="box-tools">
						
						<div class="input-group" style="width: 100%;">
					      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" 
					      placeholder="Search publication on database" />
					      <div id="publication_search_button" class="input-group-btn">
					        <button class="btn btn-sm btn-default btn-search"><i class="fa fa-search"></i></button>
					      </div>
					    </div>
					    <#-- add note -->
						<div id="auth-info" style="position:relative;height:0;width:100%;display:none">
							<div style="position:absolute;width:100%;height:30px;top:-30px;left:0px;z-index:500;background-color:#eee">
								<span class="btn btn-sm btn-success" style="white-space:nowrap;line-height:30px;padding:0 6px"
									onclick="$.each( $( '#inputPub' ).find( '.content-list' ).find( 'button' ), function(){$( this ).click()});$( this ).parent().parent().hide()">
									+ Add all <strong></strong> publications
								</span>
								<span onclick="$( this ).parent().parent().hide()" title="close to start new search" style="display:block;float:right;width:30px;height:30px;cursor: pointer;padding:0 8px;background-color:#fff;line-height:25px;"> X </span>
							</div>
						</div>
				  	</div>
				  	
				  	<div class="content-list height580px">
				    </div>
				</div>
	    	</div>
		    	        
        	<div id="circlePub" class="circle-input-column circle-input-right">
		    	<strong>Publications on Circle</strong>
		    	
		    	<div class="content-list height610px">
				</div>
		    </div>
		    
        </div>
        
        <input type="hidden" id="circleResearcher" name="circleResearcher" />
        <input type="hidden" id="circlePublication" name="circlePublication" />

	</form>
	<div class="pull-left">
          * Mandatory fields
        </div>
        <div id="error-div"></div>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Save</button>
</div>

<script>
	

	
	function inIframe () {
	    try {
	        return window.self !== window.top;
	    } catch (e) {
	        return true;
	    }
	}
	
	$(function(){
		<#if circleId??>
			<#-- first ger circle detail -->
			$.getJSON( "<@spring.url '/circle/detail?id=' />${circleId}&retrieveAuthor=yes&retrievePubication=yes", function( data ){
				<#-- circle information -->
				$( "#circleId" ).val( data.circle.id );
				$( "#circleName" ).val( data.circle.name );
				$( "#circleDescription" ).val( data.circle.description );
				
				<#-- researchers on circle -->
				if( typeof data.circle.researchers != "undefined" ){
					var targetContainer = $( "#inputAuth" ).find( ".content-list" );
					printResearcherList( data.circle , targetContainer )
					<#-- add all publication to circle author -->
					$.each( targetContainer.find( 'button' ), function(){
						if( $( this ).addClass( "btn-success" ) )
							$( this ).click();
					});
					
					<#-- fill author list -->
					<#--researcherSearch( "" , "first" );-->
					
					<#-- hide add all publications option -->
					$( "#auth-info" ).hide();
				} else{
					<#-- fill author list -->
					<#--researcherSearch( "" , "first" );-->
				}
						
				<#--publications on circle -->
				if( typeof data.circle.publications != "undefined" ){
					var publicationListContainer = $( "#inputPub" ).find( ".content-list" )
					printPublicationList( data.circle , publicationListContainer );
					
					<#-- add all publication to circle publication -->
					
					$.each( publicationListContainer.find( 'button' ), function(){
						if( $( this ).hasClass( "btn-search" ) )
							return;
						$( this ).click();
					});
					
				}
				
				setTimeout( function(){
					var inputPub = $( "#inputPub" ).find( ".content-list" );
					inputPub.html( "" );
					$.PALM.callout.generate( inputPub , "normal", "Please search first to get the publications" );
				}, 1000);
				
			});
		</#if>
	
		$.PALM.circle = $.extend( $.PALM.circle, {
					researcherCircleList: $( "#circleAuth>.content-list" ),
					publicationCircleList: $( "#circlePub>.content-list" ),
					researcherInputList: $( "#circleAuth>.box-body>.content-list" ),
					publicationInputList: $( "#circleAuth>.box-body>.content-list" )
				});
		  
		<#-- jquery post on button click -->
		$( "#submit" ).click( function(){
			<#-- todo check input valid -->
			if( $( "#circleName" ).val() == "" || $( "#circleDescription" ).val() == "" ){
				$.PALM.utility.showErrorTimeout( $( "#error-div" ) , "&nbsp<strong>Please fill all required fields (title and description)</strong>")
				return false;
			}
			
			<#-- put researcher & publication on circle into hidden input -->
			if( $.PALM.circle.circleResearcher.length > 0){
				var circleResearcherIds = "";
				$.each( $.PALM.circle.circleResearcher , function( index, item ){
					if( index > 0 )
						circleResearcherIds += "_";
					circleResearcherIds += item.id;
				});
				$( "#circleResearcher" ).val( circleResearcherIds );
			} else
				$( "#circleResearcher" ).val( "" );
			
			if( $.PALM.circle.circlePublication.length > 0){
				var circlePublicationIds = "";
				$.each( $.PALM.circle.circlePublication , function( index, item ){
					if( index > 0 )
						circlePublicationIds += "_";
					circlePublicationIds += item.id;
				});
				$( "#circlePublication" ).val( circlePublicationIds );
			} else
				$( "#circlePublication" ).val( "" );

			$.post( $("#addCircle").attr( "action" ), $("#addCircle").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload main page with target author -->
					if( inIframe() ){
						window.top.location = "<@spring.url '/circle' />?id=" + data.circle.id;
					} else {
						window.location = "<@spring.url '/circle' />?id=" + data.circle.id;
					}
				}
			});
		});
		
		<#-- related to publication -->
		
		<#-- get publication list -->
		<#-- publicationSearch( "" , "first" ); -->
		
		<#-- icon search presed -->
		$( "#publication_search_button" ).click( function( e ){
			e.preventDefault();
			publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		   <#-- event for searching researcher -->
	    $( "#publication_search_field" )
	    .on( "keypress", function(e) {
	    	//e.preventDefault();
			  if ( e.keyCode == 0 || e.keyCode == 13/* || e.keyCode == 32*/ )
			    publicationSearch( $( this ).val() , "first");
		})
		<#--
		.on( "keydown", function(e) {
			//e.preventDefault();
			  if( e.keyCode == 8 || e.keyCode == 46 ){
			    	if( $( "#publication_search_field" ).val().length == 0 ){
			    		publicationSearch( $( "#publication_search_field" ).val().trim() , "first");
			    	}
			   }
		});
		-->
		function publicationSearch( query , jumpTo ){
			var publicationListContainer = $( "#inputPub" ).find( ".content-list" );
			if( query.trim() == "" ){
				publicationListContainer.html( "" );
				return false;
			}
			<#--
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
		
				if ( jumpTo === "first") // if new searching performed -->
					var url = "<@spring.url '/publication/search?query=' />" + query + "&publicationType=conference-journal";<#-- + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult; -->
				<#--
				else
					obj.options.source = "<@spring.url '/publication/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				-->
			getPublicationList( url );
		}
		
		
		
  		function getPublicationList( url ){
		  	$.getJSON( url, function( data ){
				var publicationListContainer = $( "#inputPub" ).find( ".content-list" );
				<#-- remove previous result -->
				publicationListContainer.html( "" );
				<#-- button search loading -->
				$( "#publication_search_button" ).find( "i" ).removeClass( "fa-refresh fa-spin" ).addClass( "fa-search" );

<#--
				var $pageDropdown = $( "#inputPub" ).find( "select.page-number" );
				$pageDropdown.find( "option" ).remove();
-->				
				if( data.count == 0 ){
					$.PALM.callout.generate( publicationListContainer , "warning", "Empty search results!", "No publications found with query \"" + data.query + "\"" );
					return false;
				}
				
				if( data.count > 0 ){
					
					printPublicationList( data, publicationListContainer);
					
					<#--var maxPage = Math.ceil(data.count/data.maxresult);-->
					
					<#-- set dropdown page -->
					<#--
					for( var i=1;i<=maxPage;i++){
						$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
					}
					-->
					
					<#-- set page number -->
					<#--
					$pageDropdown.val( data.page + 1 );
					$( "#inputAuth" ).find( "span.total-page" ).html( maxPage );
					var endRecord = (data.page + 1) * data.maxresult;
					if( data.page == maxPage - 1 ) 
					endRecord = data.count;
					$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
					-->
				}
				else{
					<#--
					$pageDropdown.append("<option value='0'>0</option>");
					$( "#inputAuth" ).find( "span.total-page" ).html( 0 );
					$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
					$( "#inputAuth" ).find( "li.toNext" ).addClass( "disabled" );
					$( "#inputAuth" ).find( "li.toEnd" ).addClass( "disabled" );
					-->
				}
			});
  		}
  		
  		<#-- display publication on publication input -->
  		function printPublicationList( data , publicationListContainer ){
  			<#-- put data into PALM.circle object -->
			$.PALM.circle.setCurrentPublicationData( data.publications );
			<#-- build the publication table -->
			$.each( $.PALM.circle.getCleanPublicationData(), function( index, itemPublication ){

				var publicationItem = 
					$('<div/>')
					.addClass( "publication" )
					.attr({ "data-id": itemPublication.id });
					
				<#-- publication menu -->
				var pubNav = $( '<div/>' )
					.attr({'class':'nav'});
	
				<#-- publication icon -->
				var pubIcon = $('<i/>');
				if( typeof itemPublication.type !== "undefined" ){
					if( itemPublication.type == "Conference" || itemPublication.type == "CONFERENCE" )
						pubIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
					if( itemPublication.type == "Workshop" || itemPublication.type == "WORKSHOP" )
						pubIcon.addClass( "fa fa-file-text-o bg-blue-dark" ).attr({ "title":"Workshop" });
					else if( itemPublication.type == "Journal" || itemPublication.type == "JOURNAL" )
						pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
					else if( itemPublication.type == "Book" || itemPublication.type == "BOOK" )
						pubIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
				}else{
					pubIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown publication type" });
				}
				
				pubNav.append( pubIcon );
				
				publicationItem.append( pubNav );

				<#-- publication detail -->
				var pubDetail = $('<div/>').addClass( "detail default-cursor" );
				
				
				
				<#-- title -->
				var pubTitle = $('<div/>').addClass( "title" ).html( itemPublication.title );

				<#--author-->
				var pubAuthor = $('<div/>').addClass( "author" );
				$.each( itemPublication.authors , function( index, itemAuthor ){
					if( index > 0)
						pubAuthor.append(", ");
					pubAuthor.append( itemAuthor.name );
				});

				<#-- append detail -->
				pubDetail.append( pubTitle );
				pubDetail.append( pubAuthor );
				
				if( typeof itemPublication.event !== 'undefined' ){
					var eventElem = $( '<div/>' )
									.addClass( 'event-detail font-xs' );
					
										
					var venueText = itemPublication.event.name;
					//var venueHref = "<@spring.url '/venue' />?eventId=" + itemPublication.event.id + "&type=" + itemPublication.type.toLowerCase() + "&name=" + itemPublication.event.name.toLowerCase().replace(/[^\w\s]/gi, '');
					
					if( typeof itemPublication.volume != 'undefined' ){
						venueText += " (" + itemPublication.volume + ")";
						//venueHref += "&volume=" + itemPublication.volume;
					}
					if( typeof itemPublication.date != 'undefined' ){
						venueText += " " + itemPublication.date.substring(0, 4);
						//venueHref += "&year=" + itemPublication.date.substring(0, 4);
					}
					
					var eventPart = $( '<span/>' )
											.html( venueText );
					eventElem.append( eventPart );
					
					if( itemPublication.event.isAdded ){
						eventPart.removeClass( "text-gray" );
					}
					
					<#-- pages -->
					if( typeof itemPublication.pages !== 'undefined' ){
						eventElem.append( " pp. " + itemPublication.pages );
					}

					pubDetail.append( eventElem );			
				} else if( typeof itemPublication.venue !== 'undefined'){
					var eventElem = $( '<div/>' )
									.addClass( 'event-detail font-xs' );
												
					var venueText = itemPublication.venue;
					//var venueHref = "<@spring.url '/venue' />?type=" + itemPublication.type.toLowerCase() + "&name=" + itemPublication.venue.toLowerCase().replace(/[^\w\s]/gi, '') + "&publicationId=" + itemPublication.id ;
					
					if( typeof itemPublication.volume != 'undefined' ){
						venueText += " (" + itemPublication.volume + ")";
						//venueHref += "&volume=" + itemPublication.volume;
					}
					if( typeof itemPublication.date != 'undefined' ){
						venueText += " " + itemPublication.date.substring(0, 4);
						//venueHref += "&year=" + itemPublication.date.substring(0, 4);
					}
					
					var eventPart = $( '<span/>' )
											//.attr({ "href" : venueHref })
											//.addClass( "text-gray" )
											.html( venueText );
					eventElem.append( eventPart );
					
					<#-- pages -->
					if( typeof itemPublication.pages !== 'undefined' ){
						eventElem.append( " pp. " + itemPublication.pages );
					}

					pubDetail.append( eventElem );
				}
				
				<#-- publicationDetailOption -->
				var pubDetailOption = $('<div/>').addClass( "option" );
				<#-- fill pub detail option -->
				var circleAddButton = $('<button/>')
					.addClass( "btn btn-success width130px btn-xs pull-right" )
					.html( "+ add to circle" )
					.on( "click", function( e ){
						e.preventDefault();
						$.PALM.circle.addPublication( itemPublication.id, e.target );
					});
				
				pubDetailOption.append( circleAddButton );
				
				pubDetail.append( pubDetailOption );

				<#-- append to item -->
				publicationItem.append( pubDetail );
				
				publicationListContainer.append( publicationItem );
			
			});
  		}
  		
  		<#-- End of related to publication -->



		<#-- related to researcher list and search -->

		<#-- get publication list -->
		<#--researcherSearch( "" , "first" );-->
		$.PALM.callout.generate( $( "#inputAuth" ).find( ".content-list" ) , "normal", "Please search first to get the researchers" );
		$.PALM.callout.generate( $( "#inputPub" ).find( ".content-list" ) , "normal", "Please search first to get the publications" );
		

		<#-- event for searching researcher -->
		
		var tempInput = $( "#researcher_search_field" ).val();
	    $( "#researcher_search_field" )
	    <#--
	    .on( "keypress", function(e) {
	    	//e.preventDefault();
			if ( e.keyCode == 0 || e.keyCode == 13 /* || e.keyCode == 32*/ )
				researcherSearch( $( this ).val().trim() , "first");
			tempInput = $( this ).val().trim();
		})
		-->
		.on( "keydown", function(e) {
			//e.preventDefault();
		  	if( e.keyCode == 8 || e.keyCode == 46 )
		    	if( $( "#researcher_search_field" ).val().length == 0 && tempInput != $( this ).val().trim())
		    		researcherSearch( $( this ).val().trim() , "first");
		  	tempInput = $( this ).val().trim();
		});
		

		<#-- icon search presed -->
		$( "#researcher_search_button" ).click( function( e ){
			e.preventDefault();
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first");
		});
		
		<#-- search researcher -->
		function researcherSearch( query , jumpTo ){
		
			var targetContainer = $( "#inputAuth" ).find( ".content-list" );
			if( query.trim() == "" )
			{
				targetContainer.html( "" );
				return false;
			}
			<#--//find the element option-->
			<#--
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
			-->
			<#--				
				if( obj.options.page === 0 ){
					$( obj.element ).find( "li.toFirst" ).addClass( "disabled" );
					$( obj.element ).find( "li.toPrev" ).addClass( "disabled" );
				} else if( obj.options.page > maxPage - 1){
					$( obj.element ).find( "li.toNext" ).addClass( "disabled" );
					$( obj.element ).find( "li.toEnd" ).addClass( "disabled" );
				}
			-->
			<#--
				if( jumpTo === "first") // if new searching performed
			-->
					var url = "<@spring.url '/researcher/search?query=' />" + query;<#-- + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;-->
			<#--	
				else
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			-->
			getAuthorList( url );
		}
		
		function getAuthorList( url ){
			$.getJSON( url, function( data ){
				<#-- remove  pop up progress log -->
<#--
				$.PALM.popUpMessage.remove( uniquePidResearcherWidget );
-->
				var targetContainer = $( "#inputAuth" ).find( ".content-list" );
				<#-- remove previous list -->
				targetContainer.html( "" );
				
				var $pageDropdown = $( "#inputAuth" ).find( "select.page-number" );
				$pageDropdown.find( "option" ).remove();
				
				if( data.count == 0 ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
					return false;
				}
				
				if( data.count > 0 ){
					
					printResearcherList( data , targetContainer );
					
				}
				else{
					$pageDropdown.append("<option value='0'>0</option>");
					$( "#inputAuth" ).find( "span.total-page" ).html( 0 );
					$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
					$( "#inputAuth" ).find( "li.toNext" ).addClass( "disabled" );
					$( "#inputAuth" ).find( "li.toEnd" ).addClass( "disabled" );
				}
		});
	}

	<#-- show researcher on the list -->
	function printResearcherList( data , targetContainer ){
		<#-- put data into PALM.circle object -->
		$.PALM.circle.setCurrentResearcherData( data.researchers );

		<#-- build the researcher list -->
		$.each( $.PALM.circle.getCleanResearcherData(), function( index, item){
			var researcherDiv = 
			$( '<div/>' )
				.addClass( 'author' )
				.attr({ 'id' : item.id });
				
			var researcherNav =
			$( '<div/>' )
				.addClass( 'nav' );
				
			var researcherDetail =
			$( '<div/>' )
				.addClass( 'detail' )
				.css({"cursor":"auto"})
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
			if( typeof item.citedBy != 'undefined')
				researcherDetail.append(
					$( '<div/>' )
					.addClass( 'paper font-xs' )
					.html( "Publications: " + item.publicationsNumber + " || Cited by: " + item.citedBy)
				);
				
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
			
			<#-- researcherDetailOption -->
			var researcherDetailOption = $('<div/>').addClass( "option" );
			<#-- fill researcher detail option -->
			<#-- circle add button -->
			var circlePublicationButton = $('<div/>')
				.addClass( "btn btn-success bg-blue btn-xs width80px pull-left" )
				.attr({ "data-id": item.id, "data-name": item.name , "title":"show list of publications not in circle"})
				.html( "publications" )
				.on( "click", function( e ){
					e.preventDefault();
					<#-- get list of publication -->
					getPublicationList( "<@spring.url '/publication/search?authorId=' />" + $( this ).data( "id" ) + "&maxresult=300" );
					<#-- show info -->
					var authInfo = $( "#auth-info" );
					authInfo.show();
					authInfo.find( "strong" ).html( $( this ).data( "name" ) );
					<#-- scroll to -->
					$(".content-wrapper>.content").animate({
			            scrollTop: $( "#inputPub" ).offset().top
			        }, 500);
				});
			
			researcherDetailOption.append( circlePublicationButton );
			<#-- circle add button -->
			var circleAddButton = $('<button/>')
				.addClass( "btn btn-success btn-xs width110px pull-right" )
				.attr({ "data-id": item.id, "data-name": item.name })
				.html( "+ add to circle" )
				.on( "click", function( e ){
					e.preventDefault();
					$.PALM.circle.addResearcher( item.id, e.target );
					
					
					<#-- get list of researcher -->
					getPublicationList( "<@spring.url '/publication/search?authorId=' />" + $( this ).data( "id" ) + "&maxresult=300" );
					<#-- show info -->
					var authInfo = $( "#auth-info" );
					authInfo.show();
					authInfo.find( "strong" ).html( $( this ).data( "name" ) );
					<#-- scroll to -->
					$(".content-wrapper>.content").animate({
			            scrollTop: $( "#inputPub" ).offset().top
			        }, 500);
				});
			
			researcherDetailOption.append( circleAddButton );
			
			
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
		<#--
		var maxPage = Math.ceil(data.count/data.maxresult);
		var $pageDropdown = $( "#inputAuth" ).find( "select.page-number" );
		for( var i=1;i<=maxPage;i++){
			$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
		}
		
		$pageDropdown.val( data.page + 1 );
		$( "#inputAuth" ).find( "span.total-page" ).html( maxPage );
		var endRecord = (data.page + 1) * data.maxresult;
		if( data.page == maxPage - 1 ) 
		endRecord = data.count;
		$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying researchers " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
		-->
	}

		

		<#-- end related to researcher list and search -->
	});

</script>