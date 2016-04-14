<div id="boxbody-${wUniqueName}" class="box-body">
	  <form role="form" id="profileForm" action="<@spring.url '/user/profile' />" method="post">
		<#if author??><#-- if author not null -->
			<h1>
				${author.name!''}
			</h1>
			<hr style="margin-top:5px; margin-bottom:5px; margin-right:0 !important">
			<div style="width:100%">
				<div style="float:left;width:80px;height:120px;">
					<#if author.photo??>
						<img src="${author.photo}" style="width:100%">
					<#else>
						<div class="photo fa fa-user"></div>
					</#if>
				</div>
				<div style="float:left;padding:0 0 0 10px">
					<#-- email / username -->
					<p>
						<i style="width: 20px;" class="fa fa-envelope"></i>
						<span>${user.username}</span>
					</p>
					<p>
						<i style="width: 20px;" class="fa fa-briefcase"></i>
						<span>${author.status}</span>
					</p>
					<p>
						<i style="width: 20px;" class="fa fa-institution"></i>
						<span>${author.aff}</span>
					</p>
					<p>
						<strong>Publications: ${author.publicationsNumber} || Cited By: ${author.citedBy}</strong>
					</p>
				</div>
			</div>
			
			
		<#else><#-- if author null -->
			<h1>
				${user.name}
			</h1>
			
			<hr style="margin-top:5px; margin-bottom:5px; margin-right:0 !important">
			<input type="hidden" id="userId" name="userId" value="${user.id}"/>
			<#-- email / username -->
			<p>
				<i style="width: 20px;" class="fa fa-envelope"></i>
				<span>${user.username}</span>
			</p>
		
			<input type="hidden" id="authorId" name="authorId" />
		</#if>

	</form>
	
	<#if author??><#-- if author not null -->
	<#else><#-- if author null -->
		<div id="author-selection">
			Link me to a researcher on PALM. Please be careful, you can only do this once.
			<#-- name -->
			<div class="form-group">
		      <input type="text" id="name" name="name" value="" class="form-control" placeholder="researcher name" />
		    </div>
			Note: If you couldn't find yourself, please add yourself first on Researcher page.
		</div>
		
		<div id="chosen-author" style="display:none">
			Linked researcher on PALM
			<ul id="selected-author" class="no-style"></ul>
			
			<button type="submit" id="submit" class="btn btn-primary">Save Changes</button>
		</div>
	</#if>
  
</div>

<script>
	$(function(){
		<#if author??>
			$( "#boxbody-${wUniqueName}" )
			.find( "h1" )
			.css({ "cursor":"pointer"})
			.on( "click", function(){
				window.location.href = "<@spring.url '/researcher' />?id=${author.id}";
			});
		
		<#else>
		<#-- user profile select submit -->
		<#-- jquery post on button click -->
		$( "#submit" ).click( function( e ){
			e.preventDefault();
			<#-- todo check input valid -->

			<#-- send via ajax -->
			$.post( $("#profileForm").attr( "action" ), $("#profileForm").serialize(), function( data ){
				<#-- if status ok (regitered successfully )-->
				if( data.status == "ok" ){
					<#-- reload page-->
					location.reload();
				}
			});
		});
	
		<#-- author autocomplete -->
		$('#name')
		.autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/researcher/search' />",
		            dataType: "json",
		            data: {
						query: request.term,
						source: "internal"
					},
		            success: function (data) {
		            	if( data.count == 0){
		            		$('#name').removeClass( "ui-autocomplete-loading" );
		            		<#--return info message -->
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
			minLength: 2,
			select: function( event, ui ) {
				<#-- fill the inputs  -->
				<#-- id -->
				$( '#authorId' ).val( ui.item.id );
				
				$( "#chosen-author").show();
				$( "#author-selection" ).hide();
				
				$( "#selected-author" ).append( createAutocompleteOutput( ui.item ) );
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			},
			change: function( event, ui ) {
			  	if ( ui.item == null ) {
					<#-- pop up information here -->
					$('#name').val( '' ).focus();
				}
			}
		})
		.data("ui-autocomplete")._renderItem = function( ul, item ) {
			if( typeof item.id != "undefined" ){
				var itemElem = createAutocompleteOutput( item );
		      	return itemElem.appendTo( ul );
	      	} else{
	      		return $('<li class="ui-state-disabled">'+item.label+'</li>').appendTo( ul );
	      	}
	    };
	    
	    function createAutocompleteOutput( item ){
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
	        
	        return itemElem;
	    }
	    </#if>
	});
</script>