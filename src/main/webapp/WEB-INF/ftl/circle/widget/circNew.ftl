<div id="boxbody<#--${wUniqueName}-->" class="box-body">

	 <form role="form" id="addCircle" action="<@spring.url '/circle/add' />" method="post">
		
		<#-- name -->
		<div class="form-group">
	      <label>Title *</label>
	      <input type="text" id="name" name="name" value="" class="form-control" placeholder="researcher name" />
	    </div>

		<#-- abstract -->
		<div class="form-group">
	      <label>Description</label>
	      <textarea name="description" id="description" class="form-control" rows="3" placeholder="Description"></textarea>
	    </div>
	    
	    <div class="pull-left">
          * Mandatory fields
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
				  	
				  	<div class="content-list height500px">
				    </div>
				</div>
				
				<div class="box-footer no-padding">
					<div class="col-xs-12 no-padding alignCenter">
						<div class="paging_simple_numbers">
							<ul id="researcherPaging" class="pagination marginBottom0">
								<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
								<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
								<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
								<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
								<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
							</ul>
						</div>
						<span class="paging-info">&nbsp;</span>
					</div>
				</div>
				
	    	</div>
		    			    
		    <div id="circleAuth" class="circle-input-column circle-input-right">
		    	<strong>Researchers on Circle</strong>
		    	
		    	<div class="content-list height500px">
				</div>
		    </div>
		    
        
        </div>
        
        <#-- related to publication -->
        <div class="circle-input-container">
        
	    	<div id="inputPub" class="circle-input-column">
	    	                                                              
	    		<strong>Publicaion List</strong>
	    	
	    		<div class="box-body no-padding">
					<div class="box-tools">
						<div class="input-group" style="width: 100%;">
					      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" 
					      placeholder="Search publication on database" />
					      <div id="publication_search_button" class="input-group-btn">
					        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
					      </div>
					    </div>
				  	</div>
				  	
				  	<div class="content-list height500px">
				    </div>
				</div>
				
				<div class="box-footer no-padding">
					<div class="col-xs-12  no-padding alignCenter">
						<div class="paging_simple_numbers">
							<ul id="publicationPaging" class="pagination marginBottom0">
								<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
								<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
								<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
								<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
								<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
							</ul>
						</div>
						<span class="paging-info">&nbsp;</span>
					</div>
				</div>
	    		
	    	</div>
		    	        
        	<div id="circlePub" class="circle-input-column circle-input-right">
		    	<strong>Publications on Circle</strong>
		    	
		    	<div class="content-list height500px">
				</div>
		    </div>
		    
        </div>
        
        <input type="hidden" id="circleResearcher" name="circleResearcher" />
        <input type="hidden" id="circlePublication" name="circlePublication" />

	</form>
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
		$.PALM.circle = $.extend( $.PALM.circle, {
					researcherCircleList: $( "#circleAuth>.content-list" ),
					publicationCircleList: $( "#circlePub>.content-list" ),
					researcherInputList: $( "#circleAuth>.box-body>.content-list" ),
					publicationInputList: $( "#circleAuth>.box-body>.content-list" )
				});
					
		<#-- add slim scroll -->
<#--
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		  -->
		   $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			railVisible: true,
    			alwaysVisible: true
		  });
		  
		<#-- jquery post on button click -->
		$( "#submit" ).click( function(){
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
	    <#--
	    .on( "keypress", function(e) {
	    	//e.preventDefault();
			  if ( e.keyCode == 0 || e.keyCode == 13/* || e.keyCode == 32*/ )
			    publicationSearch( $( this ).val() , "first");
		})-->
		.on( "keydown", function(e) {
			//e.preventDefault();
			  if( e.keyCode == 8 || e.keyCode == 46 ){
			    if( $( "#publication_search_field" ).val().length == 0 )
			    	<#--publicationSearch( $( this ).val() , "first");-->
					$( "#inputPub" ).find( ".content-list" );
			   }
		});

		function publicationSearch( query , jumpTo ){
		
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
				
				else
					obj.options.source = "<@spring.url '/publication/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				
			getPublicationList( url );
		}
		
		
		
  		function getPublicationList( url ){
		  	$.getJSON( url, function( data ){
				var publicationListContainer = $( "#inputPub" ).find( ".content-list" );
				<#-- remove previous result -->
				publicationListContainer.html( "" );
				<#-- button search loading -->
				$( "#publication_search_button" ).find( "i" ).removeClass( "fa-refresh fa-spin" ).addClass( "fa-search" );

				var $pageDropdown = $( "#inputPub" ).find( "select.page-number" );
				$pageDropdown.find( "option" ).remove();
				
				if( data.count > 0 ){
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
							if( itemPublication.type == "Conference" )
								pubIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
							else if( itemPublication.type == "Journal" )
								pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
							else if( itemPublication.type == "Book" )
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
					var maxPage = Math.ceil(data.count/data.maxresult);
					
					<#-- set dropdown page -->
					for( var i=1;i<=maxPage;i++){
						$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
					}
					
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
					$pageDropdown.append("<option value='0'>0</option>");
					$( "#inputAuth" ).find( "span.total-page" ).html( 0 );
					$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
					$( "#inputAuth" ).find( "li.toNext" ).addClass( "disabled" );
					$( "#inputAuth" ).find( "li.toEnd" ).addClass( "disabled" );
				}
			});
  		}
  		
  		<#-- End of related to publication -->



		<#-- related to researcher list and search -->

		<#-- get publication list -->
		researcherSearch( "" , "first" );

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
		
		
		function researcherSearch( query , jumpTo ){
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
				
				if( data.count > 0 ){
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
						var circleAddButton = $('<button/>')
							.addClass( "btn btn-success btn-xs width130px pull-right" )
							.html( "+ add to circle" )
							.on( "click", function( e ){
								e.preventDefault();
								$.PALM.circle.addResearcher( item.id, e.target );
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
					var maxPage = Math.ceil(data.count/data.maxresult);
					var $pageDropdown = $( "#inputAuth" ).find( "select.page-number" );
					<#-- set dropdown page -->
					for( var i=1;i<=maxPage;i++){
						$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
					}
					<#-- //enable bootstrap tooltip -->
					<#-- $( "#inputAuth" ).find( "[data-toggle='tooltip']" ).tooltip(); -->
					
					<#--// set page number-->
					$pageDropdown.val( data.page + 1 );
					$( "#inputAuth" ).find( "span.total-page" ).html( maxPage );
					var endRecord = (data.page + 1) * data.maxresult;
					if( data.page == maxPage - 1 ) 
					endRecord = data.count;
					$( "#inputAuth" ).find( "span.paging-info" ).html( "Displaying researchers " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
				
					
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

		
		

		

		<#-- end related to researcher list and search -->
	});

</script>