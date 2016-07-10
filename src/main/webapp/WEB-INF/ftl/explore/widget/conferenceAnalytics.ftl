<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_conferences" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_locations" class="active">
				<a href="#tab_locations" data-toggle="tab" aria-expanded="true">
					Locations
				</a>
			</li>
			<li id="header_conference_list">
				<a href="#tab_conference_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_conference_comparison">
				<a href="#tab_conference_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_locations" class="tab-pane" active>
			</div>
			<div id="tab_conference_list" class="tab-pane">
			</div>
			<div id="tab_conference_comparison" class="tab-pane" >
			</div>
        </div>
	</div>
	</div>

<script>
	$( function(){
		
		<#-- add slimscroll to widget body -->
		$("#boxbody-${wUniqueName} #tab_va_conferences").slimscroll({
			height: "40vh",
	        size: "5px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });


		<#-- generate unique id for progress log -->
		var uniquePidConferenceWidget = $.PALM.utility.generateUniqueId();

		id="none";

		var options ={
			source : "<@spring.url '/explore/conference' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading conference...", { uniqueId:uniquePidConferenceWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			<#-- switch tab -->
			$('a[href="#tab_conference_list"]').tab('show');
				
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidConferenceWidget );
				
				
				var tabContainer = $( widgetElem ).find( "#boxbody-${wUniqueName}" ).find( ".nav-tabs-custom" );
				
				<#-- Bubble tab -->
				var tabHeaderLocation = $( widgetElem ).find( "#header_location" ).first();
				var tabContentLocation = $( widgetElem ).find( "#tab_location" ).first();
				tabContentLocation.html( "" );

				<#-- List tab -->
				var tabHeaderConferenceList = $( widgetElem ).find( "#header_conference_list" ).first();
				var tabContentConferenceList = $( widgetElem ).find( "#tab_conference_list" ).first();
				tabContentConferenceList.html("");

				<#-- Comparison tab -->
				var tabHeaderTopicComparison = $( widgetElem ).find( "#header_topic_comparison" ).first();
				var tabContentTopicComparison = $( widgetElem ).find( "#tab_topic_comparison" ).first();
				tabContentTopicComparison.html("");

				<#-- build the topic list -->
				$.getJSON( "<@spring.url '/explore/conference' />" , function( data ) {
  					
							$.each( data.conferences, function( index, item){
							<#--	console.log(data.topics[1].termvalues.length); -->

								console.log(item);
								
								var conference = $( '<div/>' )
										.append(
											$( '<div/>' )
												.html( item )
												.css({'display':'block','cursor':'pointer'})
												.on( "click", function(e){
												console.log(e.currentTarget.childNodes[0].data);

												if(e.currentTarget.childNodes[0].data == "LAK 15")
													id="05e68e30-fbdc-483a-8187-3ecf72d3984d";
												if(e.currentTarget.childNodes[0].data == "LAK 16")
													id="b35ed624-5f43-426f-858c-d26b6f44acc0";	
												if(e.currentTarget.childNodes[0].data == "EDM 15")												
													id="baace68d-9b18-4eeb-930e-a77c7d9775f3";
													
													
												var topicsWidget = $.PALM.boxWidget.getByUniqueName( 'explore_topics' ); 
												topicsWidget.options.queryString = "?id="+id;
												topicsWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
												$.PALM.boxWidget.refresh( topicsWidget.element , topicsWidget.options );

												var researchersWidget = $.PALM.boxWidget.getByUniqueName( 'explore_researchers' ); 
												researchersWidget.options.queryString = "?id="+id;
												researchersWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
												$.PALM.boxWidget.refresh( researchersWidget.element , researchersWidget.options );

												var publicationsWidget = $.PALM.boxWidget.getByUniqueName( 'explore_publications' ); 
												publicationsWidget.options.queryString = "?id="+id;
												publicationsWidget.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
												$.PALM.boxWidget.refresh( publicationsWidget.element , publicationsWidget.options );
												
												
											})
										);
								
								tabContentConferenceList
										.append( 
											conference
										);
								
								});
					});			
						
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
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		
	});
</script>