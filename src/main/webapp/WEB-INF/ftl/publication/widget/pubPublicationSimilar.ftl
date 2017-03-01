<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="similarpublication-list">
    </div>
</div>

<script>
	$( function(){

		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.similarpublication-list").slimscroll({
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/publication/similarPublicationsList' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:20,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				<#--$.PALM.popUpMessage.create( "loading similarpublication list" );-->
						},
			onRefreshDone: function(  widgetElem , data ){

							var targetContainer = $( widgetElem ).find( ".similarpublication-list" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.similarPublications, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'publication' )
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
												.html( "Degree Similarity: " + Math.round(item.similarity * 100) / 100))
												);	
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
									<#-- add click event 
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
										);-->
								});						
								
							}
							else{
							<#-- no copublication -->
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