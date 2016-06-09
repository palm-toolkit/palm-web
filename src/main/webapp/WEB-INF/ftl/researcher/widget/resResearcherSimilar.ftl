<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="similarauthor-list">
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.similarauthor-list").slimscroll({
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/similarAuthorList' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:20,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				<#--$.PALM.popUpMessage.create( "loading similarauthor list" );-->
						},
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".similarauthor-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.similarAuthors, function( index, item){
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
												.addClass( 'name capitalize' )
												.html( item.name )
										);
										
									researcherDiv
										.append(
											researcherNav
										).append(
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDetail.addClass( "text-gray" );
									}
									<#--
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
									-->
									<#-- affiliation -->
									if( typeof item.affiliation != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.affiliation )
											)
										);
									
									var similarity_topic_list = [{"name":"word_1", value:2.3}, {"name":"word_12322 ", value:2.3}, {"name":"word_dgagadfgadfg", value:2.2},{"name":"word_agadgadfvadfgrtrt", value:2.0},{"name":"word_fagartgaebadfb", value:2.0}];
									
									if( typeof item.similarity != 'undefined'){
										researcherDetail.append(
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
										researcherDetail.append(
													$('<div/>')
													.attr('id', 'similarity_topics_list_' + index)
													.addClass('panel-collapse collapse')
													.append(
														$('<ul/>')														
														.addClass('list-group  font-xs similarity_topics_list_' + index)
													)
													,
													function(iiii, html){
												
													}
												);
												
										<#-- this function populates the list of similar topics in the similar authors list !! it is called too soon and the list ul is not there when trying to add the li element -->
										addSimilary_Topics_list();	
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
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + item.citedBy)
										);
									-->
								<#--	if( typeof item.photo != 'undefined'){
										researcherNav
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
										researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									<#--}-->
									<#-- add click event -->
									$(".detail .name")
										.on( "click", function(){
											if( item.isAdded ){
												window.location = "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name;
											} else {
												$.PALM.popUpIframe.create( "<@spring.url '/researcher/add' />?id=" + item.id + "&name=" + item.name , {popUpHeight:"416px"}, "Add " + item.name + " to PALM");
											}
										} );
									
									targetContainer
										.append( 
											researcherDiv
										);
								});						
								
							}
							else{
							<#-- no coauthor -->
							<#--
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
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