<div id="boxbody${wUniqueName}" class="box-body no-padding">
	<#--  search block -->
	<div class="box-tools">
		<div class="input-group" style="width: 100%;">
	      <input type="text" id="circle_search_field" name="circle_search_field" class="form-control input-sm pull-right" 
	      placeholder="Search circle on database"/>
	      <div id="circle_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
  	</div>
  	
  	<div class="content-list height610px">
    </div>
</div>

<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="circlePaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying circles 0 - 0 of 0</span>
	</div>
</div>

<script>
	$( function(){

	    <#-- event for searching researcher -->
	   	var tempInput = $( "#circle_search_field" ).val();
	    $( "#circle_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    circleSearch( $( this ).val() , "first");
			 tempInput = $( this ).val().trim();
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 ){
			    if( $( "#circle_search_field" ).val().length < 2 && tempInput != $( this ).val().trim()){
			    	circleSearch( "" , "first");
			    	tempInput = "";
			    } else
			    	tempInput = $( this ).val().trim();
			  }
		});

		<#-- icon search presed -->
		$( "#circle_search_button" ).click( function(){
			circleSearch( $( "#circle_search_field" ).val() , "first");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				circleSearch( $( "#circle_search_field" ).val() , "next");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				circleSearch( $( "#circle_search_field" ).val() , "prev");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				circleSearch( $( "#circle_search_field" ).val() , "first");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				circleSearch( $( "#circle_search_field" ).val() , "end");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			circleSearch( $( "#circle_search_field" ).val() , $( this ).val() );
		});

		<#-- button search loading -->
		$( "#circle_search_button" ).find( "i" ).removeClass( "fa-search" ).addClass( "fa-refresh fa-spin" );
		
		<#-- generate unique id for progress log -->
		var uniquePidCircleWidget = $.PALM.utility.generateUniqueId();
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/circle/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){

							var circleListContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous result -->
							circleListContainer.html( "" );
							<#-- button search loading -->
							$( "#circle_search_button" ).find( "i" ).removeClass( "fa-refresh fa-spin" ).addClass( "fa-search" );

							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
							
								<#-- build the circle table -->
								$.each( data.circles, function( index, itemCircle ){

									var circleItem = 
										$('<div/>')
										.addClass( "circle static" )
										.attr({ "data-id": itemCircle.id });
										
									<#-- circle menu -->
									var circleNav = $( '<div/>' )
										.attr({'class':'nav'});
						
									<#-- circle icon -->
									var pubIcon = $('<i/>');
									<#--
									
									if( typeof itemCircle.type !== "undefined" ){
										if( itemCircle.type == "Conference" )
											pubIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemCircle.type == "Journal" )
											pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemCircle.type == "Book" )
											pubIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
									}else{
										pubIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown circle type" });
									}
									
									
									-->
									
									pubIcon
										.addClass( "fa fa-circle-o" )
										.attr({ "title":"Circle Readonly" })
										.css({"color":"#0073b7","font-size":"22px"});
									circleNav.append( pubIcon );
									<#-- edit option -->
<#--
									var circEdit = $('<i/>')
												.attr({
													'class':'fa fa-edit', 
													'title':'edit circle',
													'data-url':'<@spring.url '/circle/edit' />' + '?id=' + itemCircle.id,
													'style':'display:none'
												});
												-->
									<#-- add click event to edit circle -->
<#--
									circEdit.click( function( event ){
										event.preventDefault();
										$.PALM.popUpIframe.create( $(this).data("url") , {}, "Edit Circle");
									});
									-->
									<#-- append edit  -->
									<#--circleNav.append( circEdit );-->
									
									circleItem.append( circleNav );
									
									<#--
									circleItem.hover(function()
									{
									     circEdit.show();
									}, function()
									{ 
									     circEdit.hide();
									});
									-->
									<#-- circle detail -->
									var circleDetail = $('<div/>').addClass( "detail static" );
									<#-- title -->
									var circleName = $('<div/>').addClass( "title" ).html( itemCircle.name );

									<#-- append detail -->
									circleDetail.append( circleName );
									
									circleDetail.append(
										$( '<div/>' )
										.addClass( 'prop' )
										.append( 
											$( '<i/>' )
											.addClass( 'fa fa-archive icon font-xs' )
										).append( 
											$( '<span/>' )
											.addClass( 'info font-xs' )
											.html( itemCircle.numberAuthors + " researchers, " + itemCircle.numberPublications + " publications")
										)
									);
									
									if( typeof itemCircle.description !== "undefined")
										circleDetail.append(
											$( '<div/>' )
											.addClass( 'prop' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-info  icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( itemCircle.description )
											)
										);

									<#-- circleDetailOption -->
									var circleDetailOption = $('<div/>').addClass( "option" );
									<#-- fill circle detail option -->
									<#-- remove circle button -->
									var circleDeleteButton = $('<button/>')
										.addClass( "btn btn-danger btn-xs width130px pull-right" )
										.attr({ "data-id": itemCircle.id, "title":"remove " + itemCircle.title + " from PALM database" })
										.html( "delete circle" )
										.on( "click", function( e ){
											e.preventDefault();
											if ( confirm("Do you really want to remove this circle?") ) {
											    $.post( "<@spring.url '/circle/delete' />", { id:itemCircle.id }, function( data ){
											    	if( data.status == "ok")
											    		location.reload();
											    } )
											}
										});
									
									circleDetailOption.append( circleDeleteButton );
									
									circleDetail.append( circleDetailOption );
								
																	<#-- append to item -->
									circleItem.append( circleDetail );


									circleListContainer.append( circleItem );
								
								});
								var maxPage = Math.ceil(data.count/data.maxresult);
								
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								
								<#-- set page number -->
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.count;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying circles " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
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
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 circles-->
		//$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		circleSearch( $( "#circle_search_field" ).val()  , "first" );

	});
	
	function circleSearch( query , jumpTo ){
		//find the element option
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "ADMINISTRATION" && obj.group === "data-circle" ){
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
					obj.options.source = "<@spring.url '/circle/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					obj.options.source = "<@spring.url '/circle/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				$.PALM.boxWidget.refresh( obj.element , obj.options );	
			}
		});
	}
	
</script>