<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="researcher_search_field" name="researcher_search_field" class="form-control input-sm pull-right" 
	      placeholder="Search researchers on database" value="<#if targetName??>${targetName!''}</#if>">
	      <div id="researcher_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
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
		<span class="paging-info">Displaying researchers 0 - 0 of 0</span>
	</div>
</div>

<script>
	$( function(){
		<#-- set target author id -->
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>
		<#if targetAdd??>
			var targetAdd = "${targetAdd!''}";
		<#else>
			var targetAdd = "";
		</#if>

			<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		  
		  var widgetHeader = $("#widget-${wUniqueName} h3");
		  
		  <#if targetName??>
		  	widgetHeader
		  	.html( "<i class='fa fa-arrow-left'></i>&nbsp;&nbsp;All researchers" )
		  	//.attr({ "class":"urlstyle" })
		  	.css({ "cursor":"pointer"})
	    	.click( function(){ window.location.href = "<@spring.url '/researcher' />"});
	    	
	    	widgetHeader
	    	.parent()
	    	.attr({ "class":"urlstyle" })
	    	.css({ "cursor":"auto"});
		  </#if>
	    	
		  <#--
		   $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			railVisible: true,
    			alwaysVisible: true
		  });
	    -->
	    <#-- event for searching researcher -->
		var tempInput = $( "#researcher_search_field" ).val();
		
	    $( "#researcher_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    researcherSearch( $( this ).val().trim() , "first", "&addedAuthor=yes");
			 tempInput = $( this ).val().trim();
		})
		<#-- when pressing backspace until -->
		.on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 ){
				    if( $( "#researcher_search_field" ).val().length < 2 && tempInput != $( this ).val().trim()){
				    	researcherSearch( "", "first", "&addedAuthor=yes");
				    	history.pushState( null, "Researcher page", "<@spring.url '/researcher' />");
				    	tempInput = "";
				    } else
				    	tempInput = $( this ).val().trim();
			  }
		});
		

		<#-- icon search presed -->
		$( "#researcher_search_button" ).click( function(){
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first", "&addedAuthor=yes");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "next", "&addedAuthor=yes");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "prev", "&addedAuthor=yes");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "first", "&addedAuthor=yes");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "end", "&addedAuthor=yes");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			researcherSearch( $( "#researcher_search_field" ).val() , $( this ).val() , "&addedAuthor=yes");
		});

		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading researchers...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){	
							var targetContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );

							<#-- check for error  -->
							<#--
							if( typeof data.researchers === "undefined"){
								$.PALM.callout.generate( targetContainer , "warning", "Empty Researchers!", "An error occured - please try again later" );
								return false;
							}
							-->

							<#-- remove previous list -->
							targetContainer.html( "" );
							
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							<#-- callout -->
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no researchers found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'author' )
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
									
									if( typeof item.status != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'status' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-briefcase icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.status )
											)
										);
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);
									if( typeof item.publicationsNumber != 'undefined'){
										var citedBy = 0;
										if( typeof item.citedBy !== "undefined" )
											citedBy = item.citedBy;
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + citedBy )
										);
									}
										
									if( typeof item.photo != 'undefined'){
										researcherNav
											.append(
											$( '<div/>' )
												.addClass( 'photo' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.photo })
												)
											);
									} else {
										researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									}
									<#-- add edit button -->
									<#if loggedUser??>
									<#-- add edit button -->
									researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'btn btn-default btn-xs pull-left' )
											.attr({ "data-url":"<@spring.url '/researcher/edit' />?id=" + item.id, "title":"Update " + item.name + " Profile"})
											.append(
												$( '<i/>' )
													.addClass( 'fa fa-edit' )
											).append( "Update" )
											.on( "click", function(e){
												e.preventDefault;
												$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
											})
										);
									</#if>

									<#-- add clcik event -->
									researcherDetail
										.on( "click", function(){
											if( item.isAdded ){
												if( $.PALM.selected.record( "researcher", item.id, $( this ).parent() )){
													<#-- push history -->
													history.pushState(null, "Researcher " + item.name, "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name );
													getAuthorDetails( item.id );
												}
											} else {
												$.PALM.popUpIframe.create( "<@spring.url '/researcher/add' />?id=" + item.id + "&name=" + item.name , {popUpHeight:"456px"}, "Add " + item.name + " to PALM");
											}
										} );
									
									targetContainer
										.append( 
											researcherDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = researcherDiv.find( "img:first" );
											if( imageAuthor.width() > 30 )
												imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);
									
									<#-- display first author detail -->
									if( item.isAdded ){
										if( targetId == "" ){
											if( index == 0 ){
												<#-- record selection -->
												if( $.PALM.selected.record( "researcher", item.id, researcherDiv ) ){
													<#-- push history -->
													history.pushState(null, "Researcher " + item.name, "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name );
													<#-- add active class -->
													getAuthorDetails( item.id );
												}
											}
										}
										if( targetId == item.id ){
											<#-- add active class -->
											if( $.PALM.selected.record( "researcher", item.id, researcherDiv )){
												<#-- push history -->
												history.pushState(null, "Researcher " + item.name, "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name );
												getAuthorDetails( item.id );
												targetId = "";
											}
										}
									} else {
										$.PALM.popUpIframe.create( "<@spring.url '/researcher/add' />?id=" + item.id + "&name=" + item.name , {popUpHeight:"456px"}, "Add " + item.name + " to PALM");
									}

								});
								if( targetAdd == "yes" )
									data.totalCount = data.count;
									
								var maxPage = Math.ceil(data.totalCount/data.maxresult);
								var $pageDropdown = $( widgetElem ).find( "select.page-number" );
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								<#-- //enable bootstrap tooltip -->
								<#-- $( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip(); -->
								
								<#--// set page number-->
								
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.totalCount;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );
							
								
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
		//$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		if( targetAdd == "yes" )
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first");
		else
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first", "&addedAuthor=yes");
	});
	
	function researcherSearch( query , jumpTo , additionalQueryString){
		if( typeof additionalQueryString === "undefined" )
			additionalQueryString = "";
		<#--//find the element option-->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "RESEARCHER" && obj.group === "sidebar" ){
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
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + additionalQueryString;
				else
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult + additionalQueryString;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
	<#-- when author list clicked --> 
	function getAuthorDetails( authorId ){
		<#-- put loading overlay -->
    	$.each( $.PALM.options.registeredWidget, function(index, obj){
				if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
					obj.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				}
			});

		<#-- show pop up progress log -->
		var uniquePid = $.PALM.utility.generateUniqueId();
		$.PALM.popUpMessage.create( "Collecting author publications...", { uniqueId:uniquePid, popUpHeight:100, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid} );
		<#-- check and fetch publication from academic network if necessary -->
		$.getJSON( "<@spring.url '/researcher/fetch?id=' />" + authorId + "&pid=" + uniquePid + "&force=false", function( data ){
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniquePid );
			
			<#-- update number of publication and citation if necessary -->
			<#-- somehow the number of publication is not really correct -->
			<#-- moving this code to author basic information -->
<#--
			if( data.fetchPerformed === "yes" ){
					var updatedPublicationNumber; 
					if( typeof data.author.publicationsNumber != 'undefined'){
						var citedBy = 0;
						if( typeof data.author.citedBy !== "undefined" )
							citedBy = data.author.citedBy;
						
						updatedPublicationNumber = "Publications: " + data.author.publicationsNumber + " || Cited by: " + citedBy;
					}
									
					var researcherListWidget = $.PALM.boxWidget.getByUniqueName( 'researcher_list' ); 
					researcherListWidget.element.find( "#" + authorId ).find( ".paper" ).html( updatedPublicationNumber );
			}
-->			
			if( data.fetchPublicationPerformed == "yes" ){
				<#-- refresh some widgets -->
				refreshSelectedWidget( authorId, [ "researcher_basic_information", "researcher_publication","researcher_conference_tree","researcher_publication_top","researcher_coauthor_affiliation" ] );
				
				<#-- get publication details -->
				<#-- show pop up progress log -->
				var uniquePid = $.PALM.utility.generateUniqueId();
				
				$.PALM.popUpMessage.create( "Extracting publication's details...", { uniqueId:uniquePid, popUpHeight:100, directlyRemove:false , polling:true, pollingUrl:"<@spring.url '/log/process?pid=' />" + uniquePid} );
				<#-- check and fetch publication from academic network if necessary -->
				$.getJSON( "<@spring.url '/researcher/fetchPublicationDetail?id=' />" + authorId + "&pid=" + uniquePid + "&force=false", function( data ){
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniquePid );
					
					if( data.fetchPublicationDetailPerformed == "yes" ){
						refreshAllWidget( authorId );
					} else {
						<#-- refresh some widgets -->
						refreshSelectedWidget( authorId, [ "researcher_interest_cloud", "researcher_interest_evolution","researcher_topicmodel_cloud","researcher_topicmodel_evolution" ] );
					}
				
				}).fail(function() {
		   	 		$.PALM.popUpMessage.remove( uniquePid );
		  		}).always(function() {
		   	 		$.PALM.popUpMessage.remove( uniquePid );
		  		});
			} else{
				refreshAllWidget( authorId );
			}

		
		}).fail(function() {
   	 		$.PALM.popUpMessage.remove( uniquePid );
  		}).always(function() {
   	 		$.PALM.popUpMessage.remove( uniquePid );
  		});
	}
	
	<#-- refresh selected widget -->
	function refreshSelectedWidget( authorId , arrayOfUniqueWidgetName){
		
		<#-- widget researcher_interest_cloud and researcher_interest_evolution can not run simultaneusly together,
		therefore put it in order -->
		var isInterestCloudWidgetExecuted = false;
		var isInterestEvolutionWidgetExecuted = false;
		var isTopicModelCloudWidgetExecuted = false;
		var isTopicModelEvolutionWidgetExecuted = false;
		
		$.each( arrayOfUniqueWidgetName, function( index, item ){
			var obj = $.PALM.boxWidget.getByUniqueName( item );
			
			<#-- if not installed just continue -->
			if( typeof obj === "undefined" )
				return;
				
			obj.options.queryString = "?id=" + authorId;
			
			<#-- special for publication list, set only query recent 10 publication -->
			if( obj.selector === "#widget-researcher_publication" )
				obj.options.queryString += "&maxresult=10";
				
			<#-- check for cloud and evolution widget -->
			if( obj.selector === "#widget-researcher_interest_cloud" && isInterestEvolutionWidgetExecuted )
				return;
			else if( obj.selector === "#widget-researcher_interest_evolution" && isInterestCloudWidgetExecuted )
				return;
				
			<#-- check for cloud and evolution widget (topic model)-->
			if( obj.selector === "#widget-researcher_topicmodel_cloud" && isTopicModelEvolutionWidgetExecuted )
				return;
			else if( obj.selector === "#widget-researcher_topicmodel_evolution" && isTopicModelCloudWidgetExecuted )
				return;
									
			<#-- add new flag (has been executed once)  -->
			obj.executed = true;
			
			<#-- refresh widget -->
			$.PALM.boxWidget.refresh( obj.element , obj.options );
			
			<#-- set flag for cloud and evolution widget -->
			if( obj.selector === "#widget-researcher_interest_cloud" )
				isInterestCloudWidgetExecuted = true;
			else if( obj.selector === "#widget-researcher_interest_evolution" )
				isInterestEvolutionWidgetExecuted = true;
				
			<#-- set flag for cloud and evolution widget (topicmodel) -->
			if( obj.selector === "#widget-researcher_topicmodel_cloud" )
				isTopicModelCloudWidgetExecuted = true;
			else if( obj.selector === "#widget-researcher_topicmodel_evolution" )
				isTopicModelEvolutionWidgetExecuted = true;
		});
		
	}
	
	<#-- refresh all widget -->
	function refreshAllWidget( authorId ) {
		<#-- widget researcher_interest_cloud and researcher_interest_evolution can not run simultaneusly together,
		therefore put it in order -->
		var isInterestCloudWidgetExecuted = false;
		var isInterestEvolutionWidgetExecuted = false;
		var isTopicModelCloudWidgetExecuted = false;
		var isTopicModelEvolutionWidgetExecuted = false;
		<#-- refresh registered widget -->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
				obj.options.queryString = "?id=" + authorId;
				<#-- special for publication list, set only query recent 10 publication -->
				if( obj.selector === "#widget-researcher_publication" )
					obj.options.queryString += "&maxresult=10";
					
				<#-- check for cloud and evolution widget -->
				if( obj.selector === "#widget-researcher_interest_cloud" && isInterestEvolutionWidgetExecuted )
					return;
				else if( obj.selector === "#widget-researcher_interest_evolution" && isInterestCloudWidgetExecuted )
					return;
					
				<#-- check for cloud and evolution widget (topic model)-->
				if( obj.selector === "#widget-researcher_topicmodel_cloud" && isTopicModelEvolutionWidgetExecuted )
					return;
				else if( obj.selector === "#widget-researcher_topicmodel_evolution" && isTopicModelCloudWidgetExecuted )
					return;
				
				<#-- add new flag (has been executed once)  -->
				obj.executed = true;
				
				<#-- refresh widget -->
				$.PALM.boxWidget.refresh( obj.element , obj.options );
				
				<#-- set flag for cloud and evolution widget -->
				if( obj.selector === "#widget-researcher_interest_cloud" )
					isInterestCloudWidgetExecuted = true;
				else if( obj.selector === "#widget-researcher_interest_evolution" )
					isInterestEvolutionWidgetExecuted = true;
					
				<#-- set flag for cloud and evolution widget (topicmodel) -->
				if( obj.selector === "#widget-researcher_topicmodel_cloud" )
					isTopicModelCloudWidgetExecuted = true;
				else if( obj.selector === "#widget-researcher_topicmodel_evolution" )
					isTopicModelEvolutionWidgetExecuted = true;
			}
		});
	}
</script>