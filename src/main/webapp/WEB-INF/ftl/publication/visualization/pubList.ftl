<div class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" placeholder="Search">
	      <div id="publication_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
  	</div>
  	
  	<div id="table-container-${wId}" class="table-container">
	  <table id="publicationTable" class="table table-condensed table-hover" style>
	    <tbody>
	  	</tbody>
	  </table>
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
		<span class="paging-info">Displaying publications 1 - 50 of 462</span>
	</div>
</div>

<script>
	$( function(){
	
		// add slimscroll to table
		$("#table-container-${wId}").slimscroll({
			height: "100%",
	        size: "3px"
	    });
	    
	    // event for searching publication
	    $( "#publication_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    publicationSearch( $( this ).val() , "first");
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#publication_search_field" ).val().length == 0 )
			    	publicationSearch( $( this ).val() , "first");
		});
		// icon search presed
		$( "#publication_search_button" ).click( function(){
			publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		// pagging next
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "next");
		});
		
		// pagging prev
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "prev");
		});
		
		// pagging to first
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		// pagging to end
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "end");
		});
		
		// jump to specific page
		$( "select.page-number" ).change( function(){
			publicationSearch( $( "#publication_search_field" ).val() , $( this ).val() );
		});
		
		var options ={
			source : "<@spring.url '/publication/search' />",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){
							// remove any remaing tooltip
							$( "body .tooltip" ).remove();
							// build the publication table
							var targetContainer = $( widgetElem ).find( "#publicationTable" ).find("tbody");
							// remove existing
							targetContainer.html( "" );
							$.each( data.publication, function( index, item){
								$.each( item, function( key, value){
									if( key == "title" ){
										$( widgetElem ).find( "#publicationTable" ).find("tbody").append( "<tr><td title='" + value + "' data-original-title='" + value + "' data-toggle='tooltip' data-placement='bottom' data-container='body'>" + value + "</td></tr>" )
									}
								});
							});
							var maxPage = Math.ceil(data.count/data.maxresult);
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							// set dropdown page
							for( var i=1;i<maxPage;i++){
								$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
							}
							// enable bootstrap tooltip
							$( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip();
							
							// set page number
							$pageDropdown.val( data.page + 1 );
							$( widgetElem ).find( "span.total-page" ).html( maxPage );
							var endRecord = (data.page + 1) * data.maxresult;
							if( data.page == maxPage - 1 ) 
							endRecord = data.count;
							$( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
						}
		};
		
		// register the widget
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
		
		// adapt the height for first time
		$(document).ready(function() {
		    var bodyheight = $(window).height();
		    $("#table-container-${wId}").height(bodyheight - 192);
		});
		
		// first time on load, list 50 publications
		$.PALM.boxWidget.refresh( $( "#widget-${wId}" ) , options );
	});
	
	function publicationSearch( query , jumpTo ){
		//find the element option
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "PUBLICATION" && obj.group === "sidebar" ){
				var maxPage = parseInt($( obj.element ).find( "span.total-page" ).html()) - 1;
				console.log( maxPage );
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
					console.log( $( this ).attr( "class" ) );
				});
				
				console.log( "page " +  obj.options.page);
				
				if( obj.options.page === 0 ){
					$( obj.element ).find( "li.toFirst" ).addClass( "disabled" );
					$( obj.element ).find( "li.toPrev" ).addClass( "disabled" );
				} else if( obj.options.page > maxPage - 1){
					$( obj.element ).find( "li.toNext" ).addClass( "disabled" );
					$( obj.element ).find( "li.toEnd" ).addClass( "disabled" );
				}
					
				obj.options.source = "<@spring.url '/publication/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
	// for the window resize
	$(window).resize(function() {
	    var bodyheight = $(window).height();
	    $("#table-container-${wId}").height(bodyheight - 192);
	});
</script>