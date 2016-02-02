<div id="boxbody<#--${wUniqueName}-->" class="box-body">

	 <form role="form" id="addResearcher" action="<@spring.url '/researcher/edit' />" method="post">
		
		<#-- hidden attribute store author id from selected autocomplete -->
		<#-- name -->
		<div class="form-group">
	      <label><i style="width: 20px;" class="fa fa-user"></i>Name</label>
	      <input type="text" id="name" name="name" class="form-control" value="${author.name}" />
	    </div>

		<#-- academic status -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-graduation-cap"></i>Academic Status *</label>
          <input type="text" id="academicStatus" name="academicStatus" class="form-control" value="${author.academicStatus!''}" />
        </div>
        
        <#-- affiliation -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-institution"></i>Affiliation *</label>
         <input type="text" id="affiliation" name="affiliation" class="form-control" value="${author.affiliation!''}" />
        </div>
        
        <#-- email -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-envelope"></i>Email</label>
         <input type="text" id="email" name="email" class="form-control" value="${author.email!''}"/>
        </div>
        
        
        <#-- homepage -->
		<div class="form-group">
          <label><i style="width: 20px;" class="fa fa-globe"></i>Homepage</label>
         <input type="text" id="homepage" name="homepage" class="form-control" value="${author.homepage!''}"/>
        </div>
        
        <#-- picture url -->
        <div id="picture-container" class="form-group" style="margin-bottom:40px;">
          <label><i style="width: 20px;" class="fa fa-camera"></i>Picture URL</label>
          <div style="width:100%">
          	<div class="form-control palm_atr_photo <#if author.photoUrl??><#else>fa fa-user </#if>pull-left" style="margin:0;padding:0">
	          	<img id="resPicture" src="${author.photoUrl!''}" style="vertical-align:top">
          	</div>
          	<span style="display:block;overflow:hidden;padding:0 5px">
          		<input type="text" id="photoUrl" name="photoUrl" class="form-control" placeholder="picture url, e.g. http://example.org/img.jpg" value="${author.photoUrl!''}"/>
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
	function setAuthorPicture( photoUrl ){
		var imageDiv = $( "#picture-container" ).find( ".palm_atr_photo" );
		if( typeof photoUrl != "undefined" ){
			if( photoUrl.indexOf('http') == 0 ){
				imageDiv.removeClass( "fa-user" );
				imageDiv.find( "img" ).attr( "src", photoUrl );
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
		$( "#photoUrl" ).on( "paste blur focusout", function( e ){
			setTimeout(function () {
				var photoUrl = $( e.target ).val();
				setAuthorPicture( photoUrl );
			}, 100);
		});
		
  		
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

		<#-- add additional css -->
		
	});

</script>