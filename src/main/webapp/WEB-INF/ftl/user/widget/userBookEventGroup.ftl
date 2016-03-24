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
			source : "<@spring.url '/user/bookmark/eventGroup' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){

							var eventListContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove previous result -->
							eventListContainer.html( "" );
							
							if( data.count > 0 ){
							
								<#-- build the conference list -->
								$.each( data.eventGroups, function( index, itemEvent ){
									var eventItem = 
										$('<div/>')
										.addClass( "eventgroup-item" )
										.attr({ "data-id": itemEvent.id });
										
									<#-- hide unevaluated event -->
									if( !itemEvent.isAdded ){
										eventItem.css("display","none");
										data.count--;
									}
										
									<#-- event group -->
									var eventGroup = $( '<div/>' )
										.attr({'class':'eventgroup'})
										.attr({ "data-id": itemEvent.id });
										
									<#-- put event group into event item -->
									eventItem.append( eventGroup );
										
									<#-- event menu -->
									var eventNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append to event group -->
									eventGroup.append( eventNav );
									
									<#-- event detail -->
									var eventDetail = $('<div/>')
										.addClass( "detail" );
									
									<#-- append to event group -->
									eventGroup.append( eventDetail );
						
									<#-- event icon -->
									var eventIcon = $('<i/>');
									if( typeof itemEvent.type !== "undefined" ){
										if( itemEvent.type == "conference" )
											eventIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemEvent.type == "journal" )
											eventIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemEvent.type == "book" )
											eventIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
									}else{
										eventIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown event type" });
									}
									
									eventNav.append( eventIcon );

									<#-- title -->
									var eventName = $('<div/>').addClass( "title" ).html( typeof itemEvent.abbr != "undefined" ? itemEvent.name + " (" + itemEvent.abbr + ")" : itemEvent.name );

									
									<#-- append detail -->
									eventDetail.append( eventName );

									
									
									<#-- event list on event group -->
									eventItem.append( 
										$('<div/>')
										.attr({ "class":"eventyear-list" })
									 );

									<#-- add click event -->
									eventDetail.on( "click", function( e){
										<#-- remove active class -->
										if( $.PALM.selected.record(  "eventGroup", $( this ).parent().data( 'id' ) , $( this ).parent() )){
											getVenueGroupDetails( $( this ).parent().data( 'id' ) , eventGroup);
										}
									});
									
									eventListContainer.append( eventItem );
																		
								});
								
								<#-- $( widgetElem ).find( "span.paging-info" ).html( "Displaying publications " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );-->
							}
							else{
								$.PALM.callout.generate( eventListContainer, "warning", "Empty Bookmark !", "No Conference/Journal bookmarked" );
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