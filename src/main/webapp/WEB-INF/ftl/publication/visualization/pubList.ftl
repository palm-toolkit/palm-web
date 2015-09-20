<div class="box-body no-padding">
	<div class="box-filter">
		<div class="box-filter-option" style="display:none">

		<div id="author_block">
	    	<div class="input-group" id="author_search_block" style="width:100%">
	      		<input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" placeholder="Search saved author">
	      		<div id="publication_search_button" class="input-group-btn">
	        		<button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      		</div>
	    	</div>

			<div class="palm_pub_atr" id="selected_author" data_author_id="all">
				<div class="palm_pub_atr_photo" style="font-size: 14px;">
					<img src="https://scholar.google.com/citations?view_op=view_photo&amp;user=gyLI8FYAAAAJ&amp;citpid=1" class="palm_pub_atr_img">
				</div>
				<div class="palm_atr_name">mohamed amine chatti</div>
				<div class="palm_atr_aff">rwth aachen university</div>
			</div>
        </div>

		</div>
		<button class="btn btn-block btn-default box-filter-button" onclick="$( this ).prev().slideToggle( 'slow' )">
			<i class="fa fa-filter pull-left"></i>
			<span>Something</span>
		</button>
	</div>
	<div class="box-content">
	</div>
	<div class="box-tools">
		<div class="input-group" style="width: 100%;">
	      <input type="text" id="publication_search_field" name="publication_search_field" class="form-control input-sm pull-right" placeholder="Search publication">
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
	
		<#-- add slimscroll to table -->
		$("#table-container-${wId}").slimscroll({
			height: "100%",
	        size: "3px"
	    });
	    
	    <#-- event for searching researcher -->
	    $( "#publication_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    publicationSearch( $( this ).val() , "first");
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#publication_search_field" ).val().length == 0 )
			    	publicationSearch( $( this ).val() , "first");
		});

		<#-- icon search presed -->
		$( "#publication_search_button" ).click( function(){
			publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "next");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "prev");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "first");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				publicationSearch( $( "#publication_search_field" ).val() , "end");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			publicationSearch( $( "#publication_search_field" ).val() , $( this ).val() );
		});
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/publication/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){
							var targetContainer = $( widgetElem ).find( "#publicationTable" ).find("tbody");
							<#-- remove previous result -->
							targetContainer.html( "" );
							<#-- remove any remaing tooltip -->
							$( "body .tooltip" ).remove();
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
							
								<#-- build the publication table -->
								$.each( data.publication, function( index, item){

									var publicationRow = 
										$('<tr/>')
										.attr({ "id" : item.id })
										.css({"cursor":"pointer"})
										.append(
											$('<td/>')
											.attr({ "title": item.title, "data-original-title":item.title, "data-toggle":"tooltip","data-placement":"bottom","data-container":"body"})
											.html( item.title)
										);

									<#-- add clcik event -->
									publicationRow.on( "click", function(){
										getPublicationDetails( $( this ).attr( 'id' ));
									});

									targetContainer.append( publicationRow );
								});
								var maxPage = Math.ceil(data.count/data.maxresult);
								
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								<#-- enable bootstrap tooltip -->
								$( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip();
								
								<#-- set page number -->
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.count;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
							}
							else{
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
							}
						}
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
		
		<#--// adapt the height for first time-->
		$(document).ready(function() {
		    var bodyheight = $(window).height();
		    $("#table-container-${wId}").height(bodyheight - 192);
		});
		
		<#--// first time on load, list 50 publications-->
		$.PALM.boxWidget.refresh( $( "#widget-${wId}" ) , options );

		<#-- autocomplete -->
		$( "#author_search_block" ).autocomplete({
      			source: function( request, response ) {
        			$.ajax({
          			url: "http://gd.geobytes.com/AutoCompleteCity",
          			dataType: "jsonp",
          			data: {
            			q: request.term
          			},
          			success: function( data ) {
            			response( data );
          			}
        		});
      		},
      		minLength: 3,
      		select: function( event, ui ) {
        		log( ui.item ?"Selected: " + ui.item.label : "Nothing selected, input was " + this.value);
      		},
      		open: function() {
        		$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      		},
      		close: function() {
        		$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      		}
    	});
	});
	
	function publicationSearch( query , jumpTo ){
		//find the element option
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "PUBLICATION" && obj.group === "sidebar" ){
				var maxPage = parseInt($( obj.element ).find( "span.total-page" ).html()) - 1;
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
				});
								
				if( obj.options.page === 0 ){
					$( obj.element ).find( "li.toFirst" ).addClass( "disabled" );
					$( obj.element ).find( "li.toPrev" ).addClass( "disabled" );
				} else if( obj.options.page > maxPage - 1){
					$( obj.element ).find( "li.toNext" ).addClass( "disabled" );
					$( obj.element ).find( "li.toEnd" ).addClass( "disabled" );
				}
					
				if( jumpTo === "first") // if new searching performed
					obj.options.source = "<@spring.url '/publication/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					obj.options.source = "<@spring.url '/publication/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
					
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}

	<#-- when publication list clciked --> 
	function getPublicationDetails( publicationId ){
		<#-- put loading overlay -->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
				obj.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				obj.options.queryString = "?id=" + publicationId;
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