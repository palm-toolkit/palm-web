<div id="boxbody${wUniqueName}" class="box-body">

	 <form role="form" id="editPublication" action="<@spring.url '/publication/edit' />" method="post">
		<#-- hidden publication id -->
		<input type="hidden" name="publication-id" value="${publication.id}">
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication" value="${publication.title}">
	    </div>
	    
		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <div id="authors-tag" class="palm-tagsinput" tabindex="-1">
	    <#assign authorList = "">
	    <#assign authorListIds = "">
	    <#list publication.authors as eachAuthor>
	    	<span class="tag-item">
	    		<#if eachAuthor.photoUrl??>
	    			<img class="author-circle-img f-a-img" src="${eachAuthor.photoUrl}">
	    		<#else>
	    			<i class="fa fa-user bg-aqua"></i>
	    		</#if>
	    		
	    		<div class="f-a-desc">
					<div class="f-a-name no-max-width" data-id="${eachAuthor.id}">
						${eachAuthor.name}
					</div>
					<div class="f-a-aff no-max-width">
						<#if eachAuthor.institution??>
							${eachAuthor.institution.name}
						</#if>
					</div>
				</div>
	    	
	    		<i class="fa fa-times"></i>
			</span>
	    	<#if eachAuthor_index gt 0 >
	    		<#assign authorList = authorList +  "_#_">
	    		<#assign authorListIds = authorListIds +  "_#_">
	    	</#if>
	    	<#assign authorList = authorList + eachAuthor.name>
	    	<#assign authorListIds = authorListIds + eachAuthor.id>
	    </#list>
	      		<input type="text" value="" placeholder="Add an author from PALM database" />
	      </div>
	      <input type="hidden" id="author-list" name="author-list" value="${authorList}">
	      <input type="hidden" id="author-list-ids" name="author-list-ids" value="${authorListIds}">
	    </div>

		<#-- abstract -->
		<div class="form-group">
	      <label>Abstract</label>
	      <textarea name="abstractText" id="abstractText" class="form-control" rows="3" placeholder="Abstract">${publication.abstractText!''}</textarea>
	    </div>

		<#-- keyword -->
		<div class="form-group">
	      <label>Keywords</label>
	      <div id="keywords" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="${publication.keywordText!''}" placeholder="Keywords, separated by comma" />
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
	      		<input type="text"<#if publication.publicationDate??> value="${publication.publicationDate?string["dd/MM/yyyy"]}"</#if> id="publication-date" name="publication-date" class="form-control" data-inputmask="'alias': 'dd/mm/yyyy'" data-mask="">
			</div>
	    </div>

		<#-- Venue -->
		<div class="form-group">
          <label>Publication Type</label>
          <select id="venue-type" name="venue-type" class="form-control" style="width:120px">
            <option value="conference"<#if publication.publicationType??><#if publication.publicationType == "CONFERENCE"> selected</#if></#if>>Conference</option>
            <option value="workshop"<#if publication.publicationType??><#if publication.publicationType == "WORKSHOP"> selected</#if></#if>>Workshop</option>
            <option value="journal"<#if publication.publicationType??><#if publication.publicationType == "JOURNAL"> selected</#if></#if>>Journal</option>
            <option value="book"<#if publication.publicationType??><#if publication.publicationType == "BOOK"> selected</#if></#if>>Book</option>
          </select>
        </div>
        
        <#-- Conference/Journal -->
		<div id="venue-title" class="form-group">
          <label><span>Conference</span> Name</label>
          <div style="width:100%">
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" <#if publication.event??>value="${publication.event.eventGroup.getName()}"</#if> id="venue" name="venue" class="form-control" placeholder="e.g. Educational Data Mining">
	          	<input type="hidden" id="venue-id" name="venue-id"<#if publication.event??> value="${publication.event.eventGroup.id}"</#if>>
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="volume-container" class="col-xs-2 minwidth150Px"<#-- style="display:none"-->>
				<label>Volume</label>
				<input type="text" id="volume" name="volume"<#if publication.event??><#if publication.event.volume??> value="${publication.event.volume}"</#if></#if> class="form-control">
			</div>
			<#--
			<div id="issue-container" class="col-xs-2 minwidth150Px" style="display:none">
				<label>Issue</label>
				<input type="text" id="issue" name="issue" class="form-control">
			</div>
			-->
			<div id="pages-container" class="col-xs-3 minwidth150Px">
				<label>Pages</label>
				<input type="text" id="pages" name="pages"<#if publication.startPage gt 0> value="${publication.startPage} - ${publication.endPage}"</#if> class="form-control" placaholder="e.g. 5-10">
			</div>
			<#--
			<div id="publisher-container" class="col-xs-3 minwidth150Px">
				<label>Publisher</label>
				<input type="text" id="publisher" name="publisher" class="form-control">
			</div>
			-->
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
	<button id="submit" type="submit" class="btn btn-primary">Submit</button>
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

		<#-- activate input mask-->
		$( "[data-mask]" ).inputmask();
		
		$( "#submit" ).click( function(){
			<#-- todo check input valid -->
			$.post( $("#editPublication").attr( "action" ), $("#editPublication").serialize(), function( data ){
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
       									label: 'No matches Conference/Journal found, please add first on Conference page', 
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
       									label: 'No matches researcher found, please add first on Researcher page', 
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
      							$(this).parent().remove()
      							updateAuthorList( '#authors-tag' )
      						})
      					);
	        }
	        
	        return itemElem;
	    }
	    
	    <#-- activate keyword -->
		$('#keywords input').focusout();
		<#-- activate author close function -->
		$('#authors-tag').find( "i.fa-times" ).on( "click", function( e ){
			$(this).parent().remove();
      		updateAuthorList( '#authors-tag' );
		});
	});

</script>