<div id="boxbody<#--${wId}-->" class="box-body">

	 <form role="form" id="addResearcher" action="<@spring.url '/researcher/add' />" method="post">
		
		<#-- hidden attribute store author id from selected autocomplete -->
		<input type="hidden" name="tempId" id="tempId" />
		<#-- name -->
		<div class="form-group">
	      <label><i style="width: 20px;" class="fa fa-user"></i>Name *</label>
	      <input type="text" id="name" name="name" value="" class="form-control" placeholder="researcher name" />
	    </div>

		<#-- academic status -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-graduation-cap"></i>Academic Status *</label>
          <input type="text" id="academicStatus" name="academicStatus" class="form-control" placeholder="" />
        </div>
        
        <#-- affiliation -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-institution"></i>Affiliation *</label>
         <input type="text" id="affiliation" name="affiliation" class="form-control" placeholder="" />
        </div>
        
        <#-- picture url -->
        <div id="picture-container" class="form-group" style="margin-bottom:40px;">
          <label><i style="width: 20px;" class="fa fa-camera"></i>Picture URL</label>
          <div style="width:100%">
          	<div class="form-control palm_atr_photo fa fa-user pull-left" style="margin:0;padding:0">
	          	<img id="resPicture" src="">
          	</div>
          	<span style="display:block;overflow:hidden;padding:0 5px">
          		<input type="text" id="photoUrl" name="photoUrl" class="form-control"  placeholder="picture url, e.g. http://example.org/img.jpg" />
          	</span>
          </div>
         
        </div>
        
        <div class="pull-left">
          * Mandatory fields
        </div>

	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Save</button>
</div>

<script>
	function setAuthorPicture( pictureUrl ){
		var imageDiv = $( "#picture-container" ).find( ".palm_atr_photo" );
		if( typeof pictureUrl != "undefined" ){
			if( pictureUrl.indexOf('http') == 0 ){
				imageDiv.removeClass( "fa-user" );
				imageDiv.find( "img" ).attr( "src", pictureUrl );
			} else {
				imageDiv.addClass( "fa-user" );
				imageDiv.find( "img" ).attr( "src", "" );
			}
		} else {
			imageDiv.addClass( "fa-user" );
			imageDiv.find( "img" ).attr( "src", "" );
		}
	}
	
	function inIframe () {
	    try {
	        return window.self !== window.top;
	    } catch (e) {
	        return true;
	    }
	}
	
	$(function(){
		<#-- jquery post on button click -->
		$( "#submit" ).click( function(){
			<#-- todo check input valid -->
			$.post( $("#addResearcher").attr( "action" ), $("#addResearcher").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload main page with target author -->
					if( inIframe() ){
						window.top.location = "<@spring.url '/researcher' />?id=" + data.author.id + "&name=" + data.author.name
					} else {
						window.location = "<@spring.url '/researcher' />?id=" + data.author.id  + "&name=" + data.author.name
					}
				}
			});
		});
		
		<#-- related with author picture -->
		$( "#pictureUrl" ).on( "paste blur focusout", function( e ){
			setTimeout(function () {
				var pictureUrl = $( e.target ).val();
				setAuthorPicture( pictureUrl );
			}, 100);
		});
		
  		<#-- author -->
		$('#name')
		.autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/researcher/search' />",
		            dataType: "json",
		            data: {
						query: request.term,
						source: "all"
					},
		            success: function (data) {
		            	if( data.count == 0){
		            		$('#name').removeClass( "ui-autocomplete-loading" );
		            		return false;
		            	}
		            		
		                response($.map(data.researcher , function(v,i){
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
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- fill the inputs  -->
				<#-- id -->
				$( '#tempId' ).val( ui.item.id );
				<#-- status -->
				if( typeof ui.item.status !== "undefined" ){
					$( '#academicStatus' ).val( ui.item.status );
				}
				<#-- aff -->
				if( typeof ui.item.aff !== "undefined" ){
					$( '#affiliation' ).val( ui.item.aff )
					.attr( "readonly" , true);
				}
				<#-- picture -->
				if( typeof ui.item.photo !== "undefined" ){
					$( '#photoUrl' ).val( ui.item.photo );
				}
				setAuthorPicture( ui.item.photo );
				
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
	    
	    $('#name')
	    .on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 ){
			  		if( $( e.target ).val() == "" ){
					    $( '#tempId' ).val( "" );
						$( '#academicStatus' ).val( "" );
						$( '#affiliation' ).val( "" ).attr( "readonly" , false);
						$( '#photoUrl' ).val( "" );
						setAuthorPicture( "clear" );
					}
			   }
		});
		
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
		
		$( "#affiliation" ).autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/institution/search' />",
		            dataType: "json",
		            data: {
						query: request.term
					},
		            success: function (data) {
		            	if( data.count > 0 ){
			                response($.map( data.institutions, function(v,i){
			                    return {
			                    		id: v.id,
			                            label: v.name,
			                            value: v.name,
			                           };
			                }));
		                }
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {

			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		});
		
		<#-- trigger autocomplete is there is value on name input -->
		<#if author.name??>
			$('#name').bind('focus', function(){ $(this).autocomplete("search"); } );
			$('#name').val("${author.name}").focus();
			var textToShow = $('#name').find(":selected").text();
   			$('#name').parent().find("span").find("input").val(textToShow);
		</#if>
	});

</script>