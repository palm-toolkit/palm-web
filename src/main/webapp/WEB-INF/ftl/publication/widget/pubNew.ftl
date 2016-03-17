<div id="boxbody${wUniqueName}" class="box-body">

	<div class="col-md-6">
		<div class="box box-default box-solid">
			<div class="box-header">
				<h3 class="box-title">Extract publication from PDF</h3>
				<div class="box-tools pull-right">
	            	<button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
	            	<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
	           </div>
			</div>
			
			<div class="box-body">
				
				<table style="width:100%">
			        <tr style="background:transparent">
			            <td style="width:70%;padding:0">
			            	<span style="margin-top:5px;">Upload your publication (PDF format) : </span>
			            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/publication/upload' />" multiple />
						</td>
			            <td style="padding:0">
			            	<div id="progress" class="progress" style="width:70%;display:none">
						        <div class="bar" style="width: 0%;"></div>
						    </div>
						</td>
			        </tr>
			    </table>
	    
			</div>
		</div>
	</div>
	
	 <br/>

	 <form role="form" id="addPublication" action="<@spring.url '/publication/add' />" method="post" style="clear:both">
		
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication">
	    </div>
	    
	    <div id="similar-publication-container" class="form-group" style="display:none">
	    	<div class="callout callout-warning">
	            <h4>Similar publication is found on PALM database!</h4>
	            <div class="content-list info-box">
	            </div>
	        </div>
	    </div>

		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <div id="authors-tag" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="" placeholder="Add an author from PALM database" />
	      </div>
	      <input type="hidden" id="author-list" name="author-list" value="">
	      <input type="hidden" id="author-list-ids" name="author-list-ids" value="">
	    </div>
	    
		<#-- abstract -->
		<div class="form-group">
	      <label>Abstract</label>
	      <textarea name="abstractText" id="abstractText" class="form-control" rows="3" placeholder="Abstract"></textarea>
	    </div>

		<#-- keyword -->
		<div class="form-group">
	      <label>Keywords</label>
	      <div id="keywords" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="" placeholder="Keywords, separated by comma" />
	      </div>
	      <input type="hidden" id="keyword-list" name="keyword-list" value="">
	    </div>
	    

		<#-- publication-date -->
		<div class="form-group">
			<label>Publication Date</label>
			<div class="input-group" style="width:140px">
				<div class="input-group-addon">
					<i class="fa fa-calendar"></i>
				</div>
	      		<input type="text" id="publication-date" name="publication-date" class="form-control" data-inputmask="'alias': 'dd/mm/yyyy'" data-mask="">
			</div>
	    </div>

		<#-- Venue -->
		<div class="form-group">
          <label>Publication Type</label>
          <select id="venue-type" name="venue-type" class="form-control" style="width:120px">
            <option value="conference">Conference</option>
            <option value="workshop">Workshop</option>
            <option value="journal">Journal</option>
            <option value="book">Book</option>
          </select>
        </div>
        
        <#-- Conference/Journal -->
		<div id="venue-title" class="form-group">
          <label><span>Conference</span> Name</label>
          <div style="width:100%">
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="venue" name="venue" class="form-control" placeholder="e.g. Educational Data Mining">
	          	<input type="hidden" id="venue-id" name="venue-id" value="">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="volume-container" class="col-xs-2 minwidth150Px">
				<label>Volume</label>
				<input type="text" id="volume" name="volume" class="form-control">
			</div>
			<#--
			<div id="issue-container" class="col-xs-2 minwidth150Px" style="display:none">
				<label>Issue</label>
				<input type="text" id="issue" name="issue" class="form-control">
			</div>
			-->
			<div id="pages-container" class="col-xs-3 minwidth150Px">
				<label>Pages</label>
				<input type="text" id="pages" name="pages" class="form-control">
			</div>
			<div id="publisher-container" class="col-xs-3 minwidth150Px">
				<label>Publisher</label>
				<input type="text" id="publisher" name="publisher" class="form-control">
			</div>
		</div>

		<#-- content -->
<#--
		<div class="form-group">
	      <label>Content</label>
	      <textarea name="contentText" id="contentText" class="form-control" rows="3" placeholder="Publication body/content"></textarea>
	    </div>
-->
		<#-- references -->
<#--
		<div class="form-group">
	      <label>References</label>
	      <textarea name="referenceText" id="referenceText" class="form-control" rows="3" placeholder="References"></textarea>
	    </div>
-->
		<#-- conference/journal -->
<#--		<div class="form-group">
	      <label>Venue</label>
	      <input type="text" id="venue" name="venue" class="form-control" placeholder="Venue">
	    </div>
-->
	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Save</button>
</div>

<script>
	$(function(){
	
		 $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			alwaysVisible: true
		  });

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );

		<#-- activate input mask-->
		$( "[data-mask]" ).inputmask();

		$( "#submit" ).click( function(){
			<#-- todo check input valid -->
			$.post( $("#addPublication").attr( "action" ), $("#addPublication").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload main page with target author -->
					if( inIframe() ){
						window.top.location = "<@spring.url '/publication' />?id=" + data.publication.id + "&title=" + data.publication.title
					} else {
						window.location = "<@spring.url '/publication' />?id=" + data.publication.id  + "&title=" + data.publication.title
					}
				}
			});
		});
		
		$( "#venue-type" ).change( function(){
			var selectionValue = $(this).val();
			if( selectionValue == "conference" ){
				$( "#venue-title>label>span" ).html( "Conference" );
				<#--$( "#volume-container,#issue-container" ).hide();-->
			} else if( selectionValue == "journal" || selectionValue == "book"){
				$( "#venue-title>label>span" ).html( "Journal" );
				<#--$( "#volume-container,#issue-container" ).show();-->
			}
		});
		
		$("#venue").autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/venue/search' />",
		            dataType: "json",
		            data: {
						query: request.term
					},
		            success: function (data) {
		            	if( data.count == 0){
		            		$('#venue').removeClass( "ui-autocomplete-loading" );
		            		<#--return false;-->
							var result = [{
       									label: 'No matching conference/journal found, please add later on Conference page', 
   										value: response.term
										}];
										
       						response(result);
		            	}
		            	else{
			                response($.map(data.eventGroups, function(v,i){
			                    return {
			                    		id: v.id,
			                            label: v.name,
			                            value: v.name,
			                            labelShort: v.abbr,
			                            url: v.url,
			                            type: v.type
			                           };
			                }));
		                }
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- select appropriate vanue type -->
				$( '#venue-type' ).val( ui.item.type ).change();
				<#-- store the conference id -->
				$( '#venue-id' ).val( ui.item.id );
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			},
			change: function(event,ui){
		        if (ui.item == null) {
		            $('#venue').val('').focus();
	            }
	        }
		})
		.autocomplete( "instance" )._renderItem = function( ul, item ) {
			if( typeof item.id != "undefined" ){
		      	return $( "<li>" + item.label + "</li>" ).appendTo( ul );
	      	} else{
	      		return $('<li class="ui-state-disabled">'+item.label+'</li>').appendTo( ul );
	      	}
	    };
	    
		<#-- focus in and out on tag style -->
		$(".palm-tagsinput").on('focusin',function() {
		  	$( this ).addClass( "palm-tagsinput-focus" );
		});
		$(".palm-tagsinput").on('focusout',function() {
		  	$( this ).removeClass( "palm-tagsinput-focus" );
		});
		$(".palm-tagsinput").on('click',function() {
			$( this ).find( 'input' ).focus();
		});
		
		<#-- keyword tags -->
		$('#keywords input')
		.on('focusout',function(){    
			addKeyword( this );	
  		})
  		.on('keyup',function( e ){
   			if(/(188|13)/.test(e.which)) 
   				$(this).focusout().focus();
  		})
  		.on('keydown', function( e ){
  			if( this.value.length == 0)
    			return e.which !== 32;
		})
		.on('paste', function () {
			var element = this;
			setTimeout(function () {
				$( element ).focusout().focus();
			}, 100);
		});
		
		function addKeyword( inputElem ){
			<#-- allowed characters -->
    		var inputKeywords = inputElem.value.replace(/[^a-zA-Z0-9\+\-\.\#\s\,]/g,'');
    		
    		<#-- split by comma -->
			$.each( inputKeywords.split(","), function(index, inputKeyword ){
	    		<#-- remove multiple spaces -->
				inputKeyword = inputKeyword.replace(/ +(?= )/g,'').trim();
				if( inputKeyword.length > 2 && !isTagDuplicated( '#keyword-list', inputKeyword )) {
	      			$( inputElem ).before(
	      				$( '<span/>' )
	      					.addClass( "tag-item" )
	      					.html( inputKeyword )
	      					.append(
	      						$( '<i/>' )
	      						.addClass( "fa fa-times" )
	      						.click( function(){ 
	      							$( this ).parent().remove()
	      							updateInputList( '#keywords' )
	      						})
	      					)
	  				);
	  				<#-- update stored value -->
					updateInputList( '#keywords' );
	    		}
    		});
   			inputElem.value="";
		}
  		
  		function isTagDuplicated( inputListSelector, newText){
  			var keywordList = $( inputListSelector ).val().split('_#_');
  			if( $.inArray( newText , keywordList ) > -1 )
  				return true;
  			else
  				return false;
  		}
  		
  		function updateInputList( tagContainerSelector ){
  			var keywordList = "";
			$( tagContainerSelector ).find( "span" ).each(function(index, item){
				if( index > 0)
					keywordList += "_#_";
				keywordList += $( item ).text();
			});
			$( tagContainerSelector ).next( "input" ).val( keywordList );
  		}
  		
  		<#-- check against exisiting publication on PALM -->
		$( "#title" ).on( "blur", function( e ){
			$( "#similar-publication-container" ).hide();
			checkForSimilarPublication( $( this ).val() );
		});
  		
  		function checkForSimilarPublication( targetTitle ){
  			<#-- clean non alpha numeric from title -->
			var cleanTitle = targetTitle.replace(/[^\w\s]/gi, '');
			var jqXHR =	$.getJSON( "<@spring.url '/publication/similar' />?title=" + cleanTitle, function( data ){
				if( data.totalCount > 0){
					<#-- unhide container -->
					$( "#similar-publication-container" ).slideDown( "slow" );
				  	var publicationListContainer = $( "#addPublication" ).find( ".content-list:first" );
				  	publicationListContainer.html( "" );
					<#-- build the publication table -->
					$.each( data.publications, function( index, itemPublication ){

						var publicationItem = 
							$('<div/>')
							.addClass( "publication width-full" )
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
						var pubDetail = $('<div/>').addClass( "detail default-cursor width-auto" );
						
						
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
							.html( "Use this publication" )
							.attr({
								'title':'Use publication ' + itemPublication.title,
								'data-url':'<@spring.url '/publication/edit' />' + '?id=' + itemPublication.id
							})
							.on( "click", function( e ){
								e.preventDefault();
								parent.$.PALM.popUpIframe.create( $(this).data("url") , {}, "Edit Publication");
							});
						
						pubDetailOption.append( circleAddButton );
						
						pubDetail.append( pubDetailOption );

						<#-- append to item -->
						publicationItem.append( pubDetail );
						
						publicationListContainer.append( publicationItem );
					
					});
				}
				//else{
					//alert( "no similar publication found" );
				//}
			});
  		}
  		
  		<#-- author -->
		$('#authors-tag input')
  		.on('keyup',function( e ){
   			if(/(188|13)/.test(e.which)) 
   				$(this).focusout().focus();
  		})
  		.on('keydown', function( e ){
  			if( this.value.length == 0)
    			return e.which !== 32;
    		else
    			return this.value.replace(/[^a-zA-Z\s]/g,'');
		})
		.autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/researcher/search' />",
		            dataType: "json",
		            data: {
						query: request.term,
						addedAuthor:"yes"
					},
		            success: function (data) {
		            	if( data.count == 0){
		            		$('#authors-tag input').removeClass( "ui-autocomplete-loading" );
		            		var result = [{
       									label: 'No matching researcher found, please add first on Researcher page', 
   										value: response.term
										}];
										
       						response(result);
		            	}
		            	else{
		            		response($.map(data.researchers , function(v,i){
			                	var researcherMap = {
			                		id: v.id,
		                            label: v.name,
		                            value: v.name,
			                	};
			                	
			                	if( typeof v.photo !== "undefined" )
			                		researcherMap['photo'] = v.photo;
	
								if( typeof v.detail !== "undefined" )
			                		researcherMap['detail'] = v.detail;
			                		
			                	if( typeof v.aff !== "undefined" )
			                		researcherMap['aff'] = v.aff;
			                		
			                	if( typeof v.status !== "undefined" )
			                		researcherMap['status'] = v.status;
			                		
			                    return researcherMap;
			                }));
		                }
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				if( !isTagDuplicated( '#author-list', ui.item.label )) {
					<#-- append result --> 	
					$('#authors-tag input').before( createAutocompleteOutput( ui.item , "tagview") );
					updateAuthorList( "#authors-tag" );
				}
				<#-- clear input and focus -->
				$('#authors-tag input').val( '' ).focus();
				return false;
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			},
			change: function( event, ui ) {
			  	if ( ui.item == null ) {
					<#-- clear input and focus -->
					$('#authors-tag input').val( '' ).focus();
				}
			}
		})
		.autocomplete( "instance" )._renderItem = function( ul, item ) {
			if( typeof item.id != "undefined" ){
				var itemElem = createAutocompleteOutput( item );
		      	return itemElem.appendTo( ul );
	      	} else{
	      		return $('<li class="ui-state-disabled">'+item.label+'</li>').appendTo( ul );
	      	}
	    };
	    
	    function updateAuthorList( tagContainerSelector ){
  			var authorList = "";
  			var authorIdList = "";
			$( tagContainerSelector ).find( "span" ).each(function(index, item){
				var authorNameElem = $( item ).find(".f-a-name");
				if( index > 0){
					authorList += "_#_";
					authorIdList += "_#_";
				}
				authorList += authorNameElem.text().trim();
				authorIdList += authorNameElem.data( "id" );
			});
			$( "#author-list" ).val( authorList );
			$( "#author-list-ids" ).val( authorIdList );
  		}
		
	    function createAutocompleteOutput( item , viewType){
	    	var itemElem;
	    	
	    	if( typeof viewType === "undefined" ){
	    		viewType = "optionview";
	    	}
	    	
	    	if( viewType == "optionview" ){
	    		itemElem = $( "<li/>" )
							.addClass( "f-a-cont" );
			} else {
				itemElem = $( '<span/>' )
      					.addClass( "tag-item" );
			}
			
			if( typeof item.photo !== "undefined" ){
	        	itemElem.append( $( "<img/>" )
	        						 .attr({ 'class':'author-circle-img f-a-img','src': item.photo})
	        					);
	        } else {
	        	itemElem.append( $( "<i/>" )
	        						 .attr({ 'class':'fa fa-user bg-aqua'})
	        					);
	        }
	        var itemDesc = $( "<div/>" )
        						 .attr({'class':'f-a-desc'})
        						
        						 
        	var itemLabel = $( "<div/>" )
    						 .attr({'class':'f-a-name' , 'data-id': item.id})
    						 .html( item.label )
    						 
    		if( viewType !== "optionview" )
    			itemLabel.addClass( "no-max-width" );
    						 
    		itemDesc.append( itemLabel );
					 
        	if( typeof item.aff !== "undefined" ){
        		var itemAff = $( "<div/>" )
								 .attr({'class':'f-a-aff'})
								 .html( item.aff );
								 
				if( viewType !== "optionview" )
    				itemAff.addClass( "no-max-width" );
								 
				itemDesc.append( itemAff );
        	}
        					 
	        itemElem.append( itemDesc );
	        
	        if( viewType !== "optionview" ){
	        	 itemElem
	        			.append( 
      						$( '<i/>' )
      						.addClass( "fa fa-times" )
      						.click( function(){ 
      							$(this).parent().remove();
      							updateAuthorList( '#authors-tag' );
      						})
      					);
	        }
	        
	        return itemElem;
	    }
	});

</script>