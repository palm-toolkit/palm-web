<div id="boxbody<#--${wId}-->" class="box-body">
	 <form role="form" id="addVenue" action="<@spring.url '/venue/add' />" method="post">
		
		<#-- Venue -->
		<div class="form-group">
          <label>Publication Type</label>
          <select id="venue-type" name="venue-type" class="form-control" style="width:120px">
            <option value="conference">Conference</option>
            <option value="journal">Journal</option>
          </select>
        </div>
        
        <#-- Conference/Journal -->
		<div id="venue-title" class="form-group">
          <label><span>Conference</span> Name</label>
          <div style="width:100%">
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="venue" name="venue" class="form-control" placeholder="e.g. Educational Data Mining">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="venue-abbr-container" class="col-xs-2 minwidth150Px">
				<label><span>Conference</span> Abbr.</label>
				<input type="text" id="venue-abbr" name="venue-abbr" placeholder="e.g. EDM" class="form-control">
			</div>
		</div>

		<#-- description -->
		<div class="form-group">
	      <label>Description</label>
	      <textarea name="descriptionText" id="descriptionText" class="form-control" rows="3" placeholder="Description"></textarea>
	    </div>

	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Submit</button>
</div>

<script>
	$(function(){

		$( "#submit" ).click( function(){
			$("#addVenue").submit();
		});
		
		$( "#venue-type" ).change( function(){
			var selectionValue = $(this).val();
			if( selectionValue == "conference" ){
				$( "#venue-title>label>span,#venue-abbr-container>label>span" ).html( "Conference" );
			} else if( selectionValue == "journal" ){
				$( "#venue-title>label>span,#venue-abbr-container>label>span" ).html( "Journal" );
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
				console.log( ui.item.labelShort );
				$( '#venue-abbr' ).val( ui.item.labelShort );
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		});

	});

</script>