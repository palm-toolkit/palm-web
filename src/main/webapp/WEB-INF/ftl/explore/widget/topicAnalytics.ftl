<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_topics" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_bubble" class="active">
				<a href="#tab_bubble" data-toggle="tab" aria-expanded="true">
					Bubbles
				</a>
			</li>
			<li id="header_evolution">
				<a href="#tab_evolution" data-toggle="tab" aria-expanded="true">
					Evolution
				</a>
			</li>
			<li id="header_topic_list">
				<a href="#tab_topic_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_topic_comparison">
				<a href="#tab_topic_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_bubble" class="tab-pane">
			</div>
			<div id="tab_evolution" class="tab-pane">
			</div>
			<div id="tab_topic_list" class="tab-pane" active>
			</div>
			<div id="tab_topic_comparison" class="tab-pane">
			</div>
        </div>
	</div>
</div>

<script>
	$( function(){
		
		<#-- add slimscroll to widget body -->
		$("#boxbody-${wUniqueName} #tab_va_topics").slimscroll({
			height: "500px",
	        size: "5px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });
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

		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();

		var options ={
			source : "<@spring.url '/explore/researchers' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading resksdfhSDJHGFearchers...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			<#-- switch tab -->
			$('a[href="#tab_topic_list"]').tab('show');
				
				<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );
				
				
				<#-- Bubble tab -->
				var tabHeaderBubble = $( widgetElem ).find( "#header_bubble" ).first();
				var tabContentBubble = $( widgetElem ).find( "#tab_bubble" ).first();

				<#-- Evolution tab -->
				var tabHeaderEvolution = $( widgetElem ).find( "#header_evolution" ).first();
				var tabContentEvolution = $( widgetElem ).find( "#tab_evolution" ).first();

				<#-- List tab -->
				var tabHeaderTopicList = $( widgetElem ).find( "#header_topic_list" ).first();
				var tabContentTopicList = $( widgetElem ).find( "#tab_topic_list" ).first();

				<#-- Comparison tab -->
				var tabHeaderTopicComparison = $( widgetElem ).find( "#header_topic_comparison" ).first();
				var tabContentTopicComparison = $( widgetElem ).find( "#tab_topic_comparison" ).first();


			<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'author' )
										.attr({ 'name' : item.name });
										
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
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDiv.css("display","none");
										data.count--;
									}
									

									tabContentTopicList
										.append( 
											researcherDiv
										);
			
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