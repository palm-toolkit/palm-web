<div id="boxbody${wUniqueName}" class="box-body">
	 <form role="form" id="editVenue" action="<@spring.url '/venue/eventGroup/edit' />" method="post">
		
		<#-- Venue -->
		<div class="form-group">
          <label>Conference Type </label>
          <select id="type" name="type" class="form-control" style="width:120px">
            <option value="conference">Conference / Workshop</option>
            <option value="journal"<#if eventGroup.publicationType?? && eventGroup.publicationType == "JOURNAL"> selected</#if>>Journal</option>
          </select>
        </div>
        
        <#-- Conference/Journal -->
		<div id="venue-title" class="form-group">
          <label><span>Conference</span> Name </label>
          <div style="width:100%">
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="name" name="name" class="form-control" value="${eventGroup.name}">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="venue-abbr-container" class="col-xs-2 minwidth150Px">
				<label><span>Conference</span> Abbr.</label>
				<input type="text" id="notation" name="notation" class="form-control" value="${eventGroup.notation}">
			</div>
		</div>

		<#-- description -->
		<div class="form-group">
	      <label>Description</label>
	      <textarea name="description" id="description" class="form-control" rows="3" placeholder="Description"></textarea>
	    </div>

	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Save</button>
</div>

<script>
	$(function(){
		function inIframe () {
		    try {
		        return window.self !== window.top;
		    } catch (e) {
		        return true;
		    }
		}
		
		<#-- jquery post on button click -->
		$( "#submit" ).click( function(){
			<#-- add overlay  -->
			$( "#boxbody${wUniqueName}" ).parent().append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
			<#-- todo check input valid -->
			$.post( $("#editVenue").attr( "action" ), $("#editVenue").serialize(), function( data ){
				<#-- todo for error response -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload main page with target author -->
					var url = "<@spring.url '/venue' />?id=" + data.eventGroup.id +
							"&name=" + data.eventGroup.name;
					if( typeof eventId !== "undefined" )
						url += "&eventId=" + data.eventId;
					if( typeof volume !== "undefined" )
						url += "&volume=" + data.volume;
					if( typeof eventId !== "undefined" )
						url += "&year=" + data.year;
						
					if( inIframe() ){
						window.top.location = url;
					} else {
						window.location = url;
					}
				}
			});
		});
		
		$( "#venue-type" ).change( function(){
			setConferenceDropDown( $(this).val() );
			$( "#name,#notation,#description" ).val( "" );
		});
		
		<#if targetType??>
			setConferenceDropDown( "${targetType!''}" );
		</#if>
		
		function setConferenceDropDown( type ){
			if( type == "conference" ){
				$( "#venue-title>label>span,#venue-abbr-container>label>span" ).html( "Conference" );
			} else if( type == "journal" ){
				$( "#venue-title>label>span,#venue-abbr-container>label>span" ).html( "Journal" );
			}
		}

	});

</script>