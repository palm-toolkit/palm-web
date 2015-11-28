<div id="boxbody<#--${wId}-->" class="box-body">

	 <form role="form" id="addPublication" action="<@spring.url '/publication/edit' />" method="post">
		
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication" value="${publication.title}">
	    </div>
	    
	    <#assign authorText = "">
	    <#list publication.authors as eachAuthor>
	    	<#assign authorText = authorText + eachAuthor.name + ",">
	    </#list>

		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <div id="authors" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="${authorText}" placeholder="Author fullname, separated by comma" />
	      </div>
	      <input type="hidden" id="author-list" name="author-list" value="">
	    </div>

		<#-- publication-date -->
		<div class="form-group">
			<label>Publication Date</label>
			<div class="input-group" style="width:120px">
				<div class="input-group-addon">
					<i class="fa fa-calendar"></i>
				</div>
	      		<input type="text" id="publication-date" name="publication-date" class="form-control" data-inputmask="'alias': 'mm/yyyy'" data-mask="">
			</div>
	    </div>

		<#-- Venue -->
		<div class="form-group">
          <label>Venue</label>
          <div style="width:100%">
	          <select id="venue-type" name="venue-type" class="form-control pull-left" style="width:120px">
	            <option value="conference">Conference</option>
	            <option value="journal">Journal</option>
	          </select>
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="venue" name="venue" class="form-control">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="volume-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Volume</label>
				<input type="text" id="volume" name="volume" class="form-control">
			</div>
			<div id="issue-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Issue</label>
				<input type="text" id="issue" name="issue" class="form-control">
			</div>
			<div id="pages-container" class="col-xs-3 minwidth150Px">
				<label>Pages</label>
				<input type="text" id="pages" name="pages" class="form-control">
			</div>
			<div class="col-xs-3 minwidth150Px">
				<label>Publisher</label>
				<input type="text" id="publisher" name="publisher" class="form-control">
			</div>
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
	      <input type="hidden" id="keyword-list" name="keywordText" value="">
	    </div>

		<#-- content -->
		<div class="form-group">
	      <label>Content</label>
	      <textarea name="contentText" id="contentText" class="form-control" rows="3" placeholder="Publication body/content">${publication.contentText!''}</textarea>
	    </div>

		<#-- references -->
		<div class="form-group">
	      <label>References</label>
	      <textarea name="referenceText" id="referenceText" class="form-control" rows="3" placeholder="References"></textarea>
	    </div>

		<#-- conference/journal -->
<#--		<div class="form-group">
	      <label>Venue</label>
	      <input type="text" id="venue" name="venue" class="form-control" placeholder="Venue">
	    </div>
-->
	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Save Changes</button>
</div>

<script>
	$(function(){

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );

		<#-- activate input mask-->
		$( "[data-mask]" ).inputmask();

		$( "#submit" ).click( function(){
			$("#addPublication").submit();
		});
		
		$( "#venue-type" ).change( function(){
			var selectionValue = $(this).val();
			if( selectionValue == "conference" ){
				$( "#volume-container,#issue-container" ).hide();
			} else if( selectionValue == "journal" ){
				$( "#volume-container,#issue-container" ).show();
			}
		});
		
		$("#venue").autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/venue/autocomplete' />",
		            dataType: "json",
		            data: {
						query: request.term
					},
		            success: function (data) {
		                response($.map(data, function(v,i){
		                    return {
		                            label: v.name,
		                            value: v.name,
		                            labelShort: v.abbr,
		                            url: v.url,
		                            type: v.type
		                           };
		                }));
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- select appropriate vanue type -->
				$( '#venue-type' ).val( ui.item.type ).change();
				console.log( ui.item ?
					"Selected: " + ui.item.label :
					"Nothing selected, input was " + this.value);
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		});

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
  			var keywordList = $( inputListSelector ).val().split(',');
  			if( $.inArray( newText , keywordList ) > -1 )
  				return true;
  			else
  				return false;
  		}
  		
  		function updateInputList( tagContainerSelector ){
  			var keywordList = "";
			$( tagContainerSelector ).find( "span" ).each(function(index, item){
				if( index > 0)
					keywordList += ",";
				keywordList += $( item ).text();
			});
			$( tagContainerSelector ).next( "input" ).val( keywordList );
  		}
  		
  		<#-- author -->
		$('#authors input')
		.on('focusout',function(){    
			addAuthor( this );
  		})
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
		.on('paste', function () {
			
		})
		.autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/researcher/autocomplete' />",
		            dataType: "json",
		            data: {
						name: request.term
					},
		            success: function (data) {
		                response($.map(data.author , function(v,i){
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
		                		
		                    return researcherMap;
		                }));
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- select appropriate vanue type -->
				$( '#venue-type' ).val( ui.item.type ).change();
				console.log( ui.item ?
					"Selected: " + ui.item.label :
					"Nothing selected, input was " + this.value);
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		})
		.autocomplete( "instance" )._renderItem = function( ul, item ) {
			var itemElem = $( "<li/>" )
							.addClass( "f-a-cont" );
			
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
        						
        						 
        	itemDesc.append(
				 		$( "<div/>" )
    						 .attr({'class':'f-a-name'})
    						 .html( item.label )
					 );
					 
        	if( typeof item.aff !== "undefined" ){
        		itemDesc.append(
				 		$( "<div/>" )
    						 .attr({'class':'f-a-aff'})
    						 .html( item.aff )
					 );
        	}
        					 
	        itemElem.append( itemDesc );
	      	
	      	return itemElem.appendTo( ul );
	    };
		
		function addAuthor( inputElem ){
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
		
		
		$('#keywords input').focusout();
		//$('#authors input').focusout();
	});

</script>