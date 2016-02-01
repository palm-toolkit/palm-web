<div id="boxbody<#--${wUniqueName}-->" class="box-body">
	 <form role="form" id="addVenue" action="<@spring.url '/venue/add' />" method="post">
		
		<#-- Venue -->
		<div class="form-group">
          <label>Publication Type *</label>
          <select id="type" name="type" class="form-control" style="width:120px">
            <option value="conference">Conference / Workshop</option>
            <option value="journal"<#if targetType?? && targetType == "journal"> selected</#if>>Journal</option>
          </select>
        </div>
        
        <#-- Conference/Journal -->
		<div id="venue-title" class="form-group">
          <label><span>Conference</span> Name *</label>
          <div style="width:100%">
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="name" name="name" class="form-control" placeholder="e.g. Educational Data Mining">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="venue-abbr-container" class="col-xs-2 minwidth150Px">
				<label><span>Conference</span> Abbr.</label>
				<input type="text" id="notation" name="notation" placeholder="e.g. EDM" class="form-control">
			</div>
		</div>

		<#-- description -->
		<div class="form-group">
	      <label>Description</label>
	      <textarea name="description" id="description" class="form-control" rows="3" placeholder="Description"></textarea>
	    </div>
	    
	    
	    <input type="hidden" id="dblpUrl" name="dblpUrl">
	    
	    <#if targetEventId??>
	    	<input type="hidden" id="eventId" name="eventId" value="${targetEventId!''}">
	    </#if>
		
		<#if targetVolume??>
	    	<input type="hidden" id="volume" name="volume" value="${targetVolume!''}">
	    </#if>

		<#if targetYear??> 
	    	<input type="hidden" id="year" name="year"value="${targetYear!''}">
	    </#if>
	    
	    <#if publicationId??>
	    	<input type="hidden" id="publicationId" name="publicationId" value="${publicationId!''}">
	    </#if>
	    
	    <div class="pull-left">
          * Mandatory fields
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
			<#-- todo check input valid -->
			$.post( $("#addVenue").attr( "action" ), $("#addVenue").serialize(), function( data ){
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
		
		$("#name").autocomplete({
		    source: function (request, response) {
		    	var _this = this;
		        $.ajax({
		            url: "<@spring.url '/venue/search' />",
		            dataType: "json",
		            data: {
						query: request.term,
						source: "all",
						type: $( "#venue-type" ).val()
					},
		            success: function (data) {
		            	$("#name").removeClass( "ui-autocomplete-loading" );
		            	
		            	if( typeof data.eventGroups === "undefined" )
		            		return false;
		            			            	
		                response($.map(data.eventGroups, function(v,i){
		                	var results = {
		                			id: v.id,
		                            label: v.name,
		                            value: v.name,
		                            url: v.url,
		                            type: v.type
		                	};
		                	if( typeof v.abbr !== "undefined" ){
		                		results.labelShort = v.abbr;
		                		results.label = v.name + " (" + v.abbr + ")";
		                	}
		                    return results;
		                }));
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- select appropriate vanue type -->
				$( '#venue-type' ).val( ui.item.type ).change();
				$( '#dblpUrl' ).val( ui.item.url );
				$( '#type' ).val( ui.item.type )
				$( '#notation' ).val( ui.item.labelShort );
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		}).keypress(function(e){ 
		    if (!e) e = window.event;   
		    if (e.keyCode == '13'){
		      $('#search').autocomplete('close');
		      return false;
		    }
		  });
		
		<#-- trigger autocomplete is there is value on name input -->
		<#if targetName??>
			$('#name').bind('focus', function(){ $(this).autocomplete("search"); } );
			$('#name').val("${targetName}").focus();
			var textToShow = $('#name').find(":selected").text();
   			$('#name').parent().find("span").find("input").val(textToShow);
		</#if>

	});

</script>