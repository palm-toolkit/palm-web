<div id="boxbody<#--${wId}-->" class="box-body">

	 <form role="form" id="addCircle" action="<@spring.url '/circle/add' />" method="post">
		
		<#-- name -->
		<div class="form-group">
	      <label>TItle *</label>
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
	    
	    <div style="float:left;clear:both;">
	    
		    <div id="inputAuthPub" class="col-md-4" style="border:1px solid #dedede">
		    
		    	<div id="inputAuth">
		    		
		    		<strong>Researcher List</strong>
		    		<div class="box-body no-padding">
						<div class="box-tools">
						    <div class="input-group" style="width: 100%;">
						      <input type="text" id="researcher_search_field" name="researcher_search_field" class="form-control input-sm pull-right" 
						      placeholder="Search researchers on database" value="<#if targetName??>${targetName!''}</#if>">
						      <div id="researcher_search_button" class="input-group-btn">
						        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
						      </div>
						    </div>
					  	</div>
					  	
					  	<div class="content-list">
					    </div>
					</div>
					
					<div class="box-footer no-padding">
						<div class="col-xs-12  no-padding alignCenter">
							<div class="paging_simple_numbers">
								<ul id="researcherPaging" class="pagination marginBottom0">
									<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
									<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
									<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">20</span></span></li>
									<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
									<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
								</ul>
							</div>
							<span class="paging-info">&nbsp;</span>
						</div>
					</div>
					
		    	</div>
		    	
		    	<div id="inputPub">
		    	
		    		<strong>Publicaion List</strong>
		    	
		    		<div class="box-body no-padding">
						<div class="box-tools">
							<div class="input-group" style="width: 100%;">
						      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" 
						      placeholder="Search publication on database" value="<#if targetTitle??>${targetTitle!''}</#if>"/>
						      <div id="publication_search_button" class="input-group-btn">
						        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
						      </div>
						    </div>
					  	</div>
					  	
					  	<div class="content-list">
					    </div>
					</div>
					
					<div class="box-footer no-padding">
						<div class="col-xs-12  no-padding alignCenter">
							<div class="paging_simple_numbers">
								<ul id="publicationPaging" class="pagination marginBottom0">
									<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
									<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
									<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">20</span></span></li>
									<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
									<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
								</ul>
							</div>
							<span class="paging-info">&nbsp;</span>
						</div>
					</div>
		    		
		    		
		    	</div>
		    	
		    </div>
		    <div id="previewAuth" class="col-md-4" style="border:1px solid #dedede;height:1232px;">
		    	<strong>Researchers on Circle</strong>
		    </div>
		    <div id="previewPub" class="col-md-4" style="border:1px solid #dedede;height:1232px;">
		    	<strong>Publications on Circle</strong>
		    </div>
        
        </div>
        

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
		<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
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
			<#-- todo check input valid -->
			$.post( $("#addCircle").attr( "action" ), $("#addCircle").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload main page with target author -->
					if( inIframe() ){
						window.top.location = "<@spring.url '/circle' />?id=" + data.author.id + "&name=" + data.author.name
					} else {
						window.location = "<@spring.url '/circle' />?id=" + data.author.id  + "&name=" + data.author.name
					}
				}
			});
		});
		
		<#-- get publicazion list -->
		publicationSearch( "" , "first" );

		function publicationSearch( query , jumpTo ){
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
				<#--if( jumpTo === "first") // if new searching performed -->
					var url = "<@spring.url '/publication/search?query=' />" + query;<#-- + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult; -->
				<#--
				else
					obj.options.source = "<@spring.url '/publication/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				-->
			getPublicationList( url );
		}
		
		
		<#-- related to publication -->
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
							
								<#-- build the publication table -->
								$.each( data.publication, function( index, itemPublication ){

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
									
									publicationItem.hover(function()
									{
									     pubEdit.show();
									}, function()
									{ 
									     pubEdit.hide();
									});

									<#-- publication detail -->
									var pubDetail = $('<div/>').addClass( "detail" );
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
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.count;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
								-->
							}
							else{
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
							}
					});
  		}
  		
  		<#-- End of related to publication -->

		
		<#-- related to researcher list and search -->

<#-- end related to researcher list and search -->
	});

</script>