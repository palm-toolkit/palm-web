<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="similarcircle-list">
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.similarcircle-list").slimscroll({
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/circle/similarCircleList' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:20,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				<#--$.PALM.popUpMessage.create( "loading similarcircle list" );-->
						},
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".similarcircle-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the circle list -->
								$.each( data.similarCircles, function( index, item){
									var circleDiv = 
									$( '<div/>' )
										.addClass( 'circle' )
										.attr({ 'id' : item.id });
										
									var circleNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var circleDetail =
									$( '<div/>' )
										.addClass( 'detail' )
										.append(
											$( '<div/>' )
												.addClass( 'name capitalize' )
												.html( item.name )
										);
										
									circleDiv
										.append(
											circleNav
										).append(
											circleDetail
										);
										
									<#--
									if( typeof item.status != 'undefined')
										circleDetail.append(
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
									-->
									
									<#-- List of objects name and value -->
									var similarity_topic_list = [{"name":"word_1", value:2.3}, {"name":"word_12322 ", value:2.3}, {"name":"word_dgagadfgadfg", value:2.2},{"name":"word_agadgadfvadfgrtrt", value:2.0},{"name":"word_fagartgaebadfb", value:2.0}];
									
									if( typeof item.similarity != 'undefined'){
										circleDetail.append(
											$( '<div/>' )
											.addClass( 'similarity' )
											.css({ "clear" : "both"})
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-share-alt icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.attr('data-toggle', 'collapse')
												.attr('href', '#similarity_topics_list_' + index)
												.html( "Degree Similarity: " + Math.round(item.similarity * 100) / 100))
										);
										circleDetail.append(
													$('<div/>')
													.attr('id', 'similarity_topics_list_' + index)
													.addClass('panel-collapse collapse')
													.append(function(){															
														var list = $('<ul/>')
																		.addClass('list-group  font-xs similarity_topics_list_' + index);																										
														$.each( similarity_topic_list, function( ind, similarTopic){																										
																var element_list = $('<li/>')
																						.addClass('list-group-item')
																						.html(similarTopic.name + " " + similarTopic.value);
																list.append(element_list);
																
														});		
														return list;													
													})													
												);
												
										<#-- this function populates the list of similar topics in the similar circles list !! it is called too soon and the list ul is not there when trying to add the li element -->										
										function addSimilary_Topics_list(){
														$.each( similarity_topic_list, function( ind, similarTopic){
															var current_list = $('.similarity_topics_list_' + index);
															current_list.append(
																$('<li/>')
																.addClass('list-group-item')
																.html(similarTopic.name + " " + similarTopic.value)
															);		
														});	
													}
										
										
									}
								
										
									<#--
									if( typeof item.citedBy != 'undefined')
										circleDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + item.citedBy)
										);
									-->
								<#--	if( typeof item.photo != 'undefined'){
										circleNav
											.append(
											$( '<div/>' )
												.addClass( 'photo round' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.photo })
												)
											);
									} else {-->
										circleNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									<#--}-->
									<#-- add click event -->
									$(".detail .name")
										.on( "click", function(){
											if( item.isAdded ){
												window.location = "<@spring.url '/circle' />?id=" + item.id + "&name=" + item.name;
											} else {
												$.PALM.popUpIframe.create( "<@spring.url '/circle/add' />?id=" + item.id + "&name=" + item.name , {popUpHeight:"416px"}, "Add " + item.name + " to PALM");
											}
										} );
									
									targetContainer
										.append( 
											circleDiv
										);
								});						
								
							}
							else{
							<#-- no cocircle -->
							<#--
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying circles 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
								-->
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
	});
</script>