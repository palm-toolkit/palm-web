<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" >
  	<div class="box-tools">
  	<div>
	    <div class="drop-down">
	    	<select id="select-drop-down" class="form-control" >
			  <option value="researchers" selected>RESEARCHERS</option>
			  <option value="conferences">CONFERENCES</option>
			  <option value="publications">PUBLICATIONS</option>
			  <option value="topics">TOPICS</option>
			  <option value="circles">CIRCLES</option>
			</select>
	    </div>
	    
	    <div class="input-group width100p">
	      <input type="text" id="search_field" class="form-control input-sm pull-right" placeholder="Enter search text">
	      <div id="search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
	   </div> 
  	</div>

	<div class="content-list">
    </div>
</div>
<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="researcherPaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<#--<span class="paging-info">Displaying records 0 - 0 of 0</span>-->
	</div>
</div>

<script>
	$( function(){
		
			data = new Object();
			<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		  
		  var targetContainer = $(".content-list" );
		  <#-- pagging next -->
				$( "li.toNext" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "next", data, targetContainer);
				});
				
				<#-- pagging prev -->
				$( "li.toPrev" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "prev", data, targetContainer);
				});
				
				<#-- pagging to first -->
				$( "li.toFirst" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "first", data, targetContainer);
				});
				
				<#-- pagging to end -->
				$( "li.toEnd" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "end", data, targetContainer);
				});
				
				<#-- jump to specific page -->
				$( "select.page-number" ).change( function(){
					itemSearch( $( "#search_field" ).val() , $( this ).val(), data, targetContainer);
				});
				
			
				<#-- search icon presed -->
				$( "#search_button" ).click( function(){
					//searchText = $( "#search_field" ).val();
					itemSearch( $( "#search_field" ).val() , "first", data, targetContainer);
				});
				
				$( "#search_field" )
	    			.on( "keypress", function(e) {
			  			if ( e.keyCode == 13)
			  			{
			    			itemSearch( $( "#search_field" ).val() , "first", data, targetContainer);
			    		}	
					})
				
		
		<#-- event for searching researcher -->
		var searchText = $( "#search_field" ).val();
		var popUp = 0;
		var itemType = "researchers";
		var url = "searchResearchers";
		<#-- generate unique id for progress log -->
		var uniqueSearchWidget = $.PALM.utility.generateUniqueId();
		
		var options ={
			source : "<@spring.url '/explore/' />"+url,
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Loading "+itemType+" ..", { uniqueId:uniqueSearchWidget, popUpHeight:40, directlyRemove:false , polling:false});
			},

			onRefreshDone: function(  widgetElem , data ){
				
				targetContainer.html( "" );
				//$( "#search_field" ).val("");
			
				getData(data, targetContainer, widgetElem);
				
				<#-- drop down change event-->
				dropDown = $( widgetElem ).find( "#select-drop-down" );
				var sel = document.getElementById('select-drop-down');
   				sel.onchange = function() {
      				itemType = dropDown.val();
					
   					getURL(itemType);
	   				$( "#search_field" ).val("");
   					targetContainer.html( "" );
   					//getData(data, targetContainer, widgetElem);
   					var obj = $.PALM.boxWidget.getByUniqueName( 'explore_search' ); 
					obj.options.source = "<@spring.url '/explore/' />"+ url
   					$.PALM.boxWidget.refresh( obj.element , obj.options );
				}	
			}
		};	
		
		function getURL(itemType){
					if(itemType == "researchers"){
	   					url = "searchResearchers";
	   				}
	   				if(itemType == "conferences"){
	   					url = "searchConferences";
	   				}
	   				if(itemType == "publications"){
	   					url = "searchPublications";
	   				}
	   				if(itemType == "topics"){
	   					url = "searchTopics";
	   				}
	   				if(itemType == "circles"){
	   					url = "searchCircles";
	   				}
		}
		
		function getData(data, targetContainer, widgetElem){
			<#-- Content List -->
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniqueSearchWidget );
					//popUp = 0;
				
   				   	if(itemType == "researchers"){
   						
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no researchers found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
								
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'explore' )
										.attr({ 'id' : item.id });
										
									var researcherNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var researcherDetail =
									$( '<div/>' )
										.addClass( 'detail' )
										.append(
											$( '<div/>' )
												.addClass( 'name' )
												.html( item.name )
										);
										
									researcherDiv
										.append(
											researcherNav
										).append(
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDiv.css("display","none");
										data.count--;
									}
									
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')	
											.append('&nbsp;')	
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											.append('&nbsp;')	
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);

									researcherDetail
										.on("mouseover", gray);
									researcherDetail
										.on("mouseout", black);

									<#-- add click event -->
									researcherDetail
										.on( "click", function(){
												$( this ).parent().context.style.color="black";
												itemSelection(item.id, "researcher");
										} );
									
									targetContainer
										.append( 
											researcherDiv
										)
										.css({ "cursor":"pointer"});
									
								});
								setFooter(data, widgetElem);								
							}	
						}	//if			
						
						
					if(itemType == "conferences"){
   						
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no conferences/journals found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No conferences/journals found with query \"" + data.query + "\"" );
								//return false;
							}
							
							if( data.count > 0 ){
							
								// build the conference list
								$.each( data.eventGroups, function( index, itemEvent ){
									var eventItem = 
										$('<div/>')
										.addClass( "explore" )
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
									var conferenceType="fa fa-file-text-o";
									var eventIcon = $('<div/>').css("width","4%").css("float","left").append($('<i/>'));
									if( typeof itemEvent.type !== "undefined" ){
										if( itemEvent.type == "conference" )
											conferenceType = "fa fa-file-text-o";
										else if( itemEvent.type == "journal" )
											conferenceType = "fa fa-files-o";
										else if( itemEvent.type == "book" )
											conferenceType = "fa fa-book";
									}else{
										conferenceType = "fa fa-question";
									}
									

									<#-- title -->

									if( typeof itemEvent.type != 'undefined')
										eventDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')
											.append( 
												$( '<i/>' )
												.addClass( conferenceType )
													.append('&nbsp;')
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( typeof itemEvent.abbr != "undefined" ? itemEvent.name  +" (" + itemEvent.abbr + ")" : itemEvent.name )											
											)
										);
									
									
									<#-- append detail -->
									//eventDetail.append( eventIcon ).append('&nbsp;').append( eventName );

									eventDetail
										.on("mouseover", gray);
									eventDetail
										.on("mouseout", black);

									<#-- add click event -->
									eventDetail.on( "click", function( e){
										$( this ).parent().context.style.color="black";
										itemSelection(itemEvent.id, "conference");
									});
									
									targetContainer
									.append( eventItem )
									.css({ "cursor":"pointer"});
									
																	
								});
								
								setFooter(data, widgetElem);
							}	
						}	//if	
						
						if(itemType == "publications"){
   						
	   						if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no publications found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No publications found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
							
								<#-- build the publication table -->
								$.each( data.publications, function( index, itemPublication ){
									var publicationItem = 
										$('<div/>')
										.addClass( "explore" )
										.attr({ "data-id": itemPublication.id });
										
									<#-- event menu -->
									var publicationNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append to event group -->
									publicationItem.append( publicationNav );
									
									<#-- event detail -->
									var publicationDetail = $('<div/>')
										.addClass( "detail" );
									
									<#-- append to event group -->
									publicationItem.append( publicationDetail );
						
									<#-- event icon -->
									var publicationType="fa fa-file-text-o";
									var eventIcon = $('<div/>').css("width","4%").css("float","left").append($('<i/>'));
									if( typeof itemPublication.type !== "undefined" ){
										if( itemPublication.type == "Conference" )
											publicationType = "fa fa-file-text-o";
										else if( itemPublication.type == "Journal" )
											publicationType = "fa fa-files-o";
										else if( itemPublication.type == "Book" )
											publicationType = "fa fa-book";
										else
											publicationType = "fa fa-file-text-o";	
									}else{
										publicationType = "fa fa-question";
									}
									

									<#-- title -->

									if( typeof itemPublication.type != 'undefined')
										publicationDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')
											.append( 
												$( '<i/>' )
												.addClass( publicationType )
													.append('&nbsp;')
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( itemPublication.title )											
											)
										);
									
								publicationDetail
										.on("mouseover", gray);
									publicationDetail
										.on("mouseout", black);
									
									<#-- add click event -->
									publicationDetail.on( "click", function( e){
										$( this ).parent().context.style.color="black";
										itemSelection(itemPublication.id, "publication");
									});
									targetContainer
									.append( publicationItem )
									.css({ "cursor":"pointer"});
								});
								setFooter(data, widgetElem);
							}
						}	//if
						
						if(itemType == "topics"){
   						
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no topics found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No topics found with query \"" + data.query + "\"" );
								//return false;
							}
							
							if( data.count > 0 ){
							
								// build the topics list
								var sortedList = data.topicsList.sort();
								$.each( sortedList, function( index, item ){
									var topicItem = 
										$('<div/>')
										.addClass( "explore" )
										.attr({ "data-id": item.id });
										
									<#-- topic detail -->
									var topicDetail = $('<div/>')
										.addClass( 'name capitalize' )
										.append(
											$( '<div/>' )
											.append('&nbsp;')
											.append( 
												$( '<i/>' )
												.addClass( "fa fa-comments-o" )
													.append('&nbsp;')
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.name )											
											)
										);
										
									
									<#-- append to event group -->
									topicItem.append( topicDetail );
						
									topicDetail
										.on("mouseover", gray);
									topicDetail
										.on("mouseout", black);

									<#-- add click event -->
									topicDetail.on( "click", function( e){
										$( this ).parent().context.style.color="black";
										itemSelection(item.id, "topic");
									});
									
									targetContainer
									.append( topicItem )
									.css({ "cursor":"pointer"});
																	
								});
								
								setFooter(data, widgetElem);
							}	
						}
						
						if(itemType == "circles"){
	   						if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no circles found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No circles found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
							
								<#-- build the publication table -->
								$.each( data.circles, function( index, itemCircle ){
									var circleItem = 
										$('<div/>')
										.addClass( "explore" )
										.attr({ "data-id": itemCircle.id });
										
									<#-- event menu -->
									var circleNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append to event group -->
									circleItem.append( circleNav );
									
									<#-- event detail -->
									var circleDetail = $('<div/>')
										.addClass( "detail" );
									
									<#-- append to event group -->
									circleItem.append( circleDetail );
						
									<#-- title -->
										circleDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')
											.append( 
												$( '<i/>' )
												.addClass( "fa fa-circle-o" )
													.append('&nbsp;')
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( itemCircle.name )											
											)
										);
									
								circleDetail
										.on("mouseover", gray);
									circleDetail
										.on("mouseout", black);
									
									<#-- add click event -->
									circleDetail.on( "click", function( e){
										$( this ).parent().context.style.color="black";
										itemSelection(itemCircle.id, "circle");
									});
									
									targetContainer
									.append( circleItem )
									.css({ "cursor":"pointer"});
								});
								setFooter(data, widgetElem);
							}
						}
		}
		
		function itemSearch( query , jumpTo, data, targetContainer)
		{
			<#-- update setup widget -->
			var obj = $.PALM.boxWidget.getByUniqueName( 'explore_search' ); 
			
		
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
				
				getURL(itemType);
				if( jumpTo === "first") // if new searching performed
					obj.options.source = "<@spring.url '/explore/' />"+ url + "?query=" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					obj.options.source = "<@spring.url '/explore/' />"+ url + "?query=" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
	
				targetContainer.html( "" );
				$.PALM.boxWidget.refresh( obj.element , obj.options );
	}
	
	function itemSelection(id, type){
		var queryString = "?id="+id+"&type="+type;
		
		<#-- update setup widget -->
		var stageWidget = $.PALM.boxWidget.getByUniqueName( 'explore_setup' ); 
		stageWidget.options.queryString = queryString;
		$.PALM.boxWidget.refresh( stageWidget.element , stageWidget.options );
	}
	
	
	function setFooter(data, widgetElem){
		var maxPage = Math.ceil(data.totalCount/data.maxresult);
		var $pageDropdown = $( widgetElem ).find( "select.page-number" );
		$pageDropdown.html( "" );
		<#-- set dropdown page -->
		for( var i=1;i<=maxPage;i++){
			$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
		}
		<#--// set page number-->
		$pageDropdown.val( data.page + 1 );
		$( widgetElem ).find( "span.total-page" ).html( maxPage );
		var endRecord = (data.page + 1) * data.maxresult;
		if( data.page == maxPage - 1 ) 
		endRecord = data.totalCount;
	
		if( maxPage == 1 ){
			$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
			$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
		}
	}
	
	function gray(){
			$( this ).parent().context.style.color="gray";
	}
	
	function black(){
			$( this ).parent().context.style.color="black";
	}
	
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 researchers-->
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		
	});
</script>