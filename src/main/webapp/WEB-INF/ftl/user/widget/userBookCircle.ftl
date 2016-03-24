<div id="boxbody${wUniqueName}" class="box-body no-padding">
  	<div class="content-list">
    </div>
</div>

<script>
	$( function(){
		
		<#-- add slim scroll -->
	      $("#boxbody${wUniqueName}>.content-list").slimscroll({
				height: "500px",
		        size: "3px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
	
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/user/bookmark/circle' />",
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
										.addClass( "circle" )
										.attr({ "data-id": itemCircle.id });
										
									<#-- circle menu -->
									var circleNav = $( '<div/>' )
										.attr({'class':'nav'});
						
									<#-- circle icon -->
									var circIcon = $('<i/>');
									<#--
									
									if( typeof itemCircle.type !== "undefined" ){
										if( itemCircle.type == "Conference" )
											circIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemCircle.type == "Journal" )
											circIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemCircle.type == "Book" )
											circIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
									}else{
										circIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown circle type" });
									}
									
									
									-->
									
									circIcon
										.addClass( "fa fa-circle-o" )
										.attr({ "title":"Circle Readonly" })
										.css({"color":"#0073b7","font-size":"22px"});
									circleNav.append( circIcon );
									
									circleItem.append( circleNav );

									<#-- circle detail -->
									var circleDetail = $('<div/>').addClass( "detail" );
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

									<#-- append to item -->
									circleItem.append( circleDetail );

									<#-- add clcik event -->
									circleDetail.on( "click", function(){
										window.location.href = "<@spring.url '/circle' />?id=" + itemCircle.id;
									});
									circleListContainer.append( circleItem );
								
								});
								
							}
							else{
								$.PALM.callout.generate( circleListContainer, "warning", "Empty Bookmark !", "No Circle bookmarked" );
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
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
	});
</script>