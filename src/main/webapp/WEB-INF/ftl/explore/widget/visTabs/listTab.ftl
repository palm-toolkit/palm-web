<#-- LIST TAB -->
function tabVisList(uniqueVisWidget, url, widgetElem, tabContent, visType, type)
{
	$.getJSON( url , function( data ) 
	{
		if(data.oldVis=="false")
		{
			if( data.map == null )
			{
				$.PALM.callout.generate( tabContent , "warning", "No data found!!", "Insufficient Data!" );
				return false;
			}

			var namesList = data.dataList;
					
			var listSection = $( '<div/>' );
						
			tabContent.append(listSection);
			listSection.addClass('_list overflow-height')
						
			$("._list").slimscroll({
				height: "74vh",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			alwaysVisible: true,
	   			railVisible: true
	       });
						
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );
						
			if(visType == "researchers")
			{
				if( data.map.coAuthors.length == 0 )
				{
					tabContent.html("")
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No researchers satisfy the specified criteria!" );
					return false;
				}
							
				if( data.map.coAuthors.length > 0 )
				{
					<#-- build the researcher list -->
					$.each( data.map.coAuthors, function( index, item)
					{
						var researcherDiv = $( '<div/>' )
												.addClass( 'author cursor-p' )
												.attr({ 'id' : item.id });
						
						var researcherNav = $( '<div/>' )
												.addClass( 'nav' );
										
						if(objectType=="publication" || objectType=="topic" || objectType=="circle")
							text = item.name
						if(objectType=="researcher")
						{
							text = " <b> " + item.name + " </b> "  ;

							if(data.idsList.length > 1 )
							{
								for(var i=0;i<data.idsList.length;i++)
									text = text + " <br />   Co-authored in <b>" + data.map.collaborationMaps[data.idsList[i]][item.id]+  "</b> publication(s) with" + " " + namesList[i];
						 	}
							else
							 	text = text + " <br />   Co-authored in <b> " + data.map.collaborationMaps[data.idsList[0]][item.id]+ "</b> publication(s)" ;
						}
						if(objectType=="conference")
						{
							text = " <b> " + item.name + " </b> "  ;
							if(data.idsList.length > 1 && yearFilterPresent=="false")
							{
								for(var i=0;i<data.idsList.length;i++)
									text = text + " <br /> <b>" + data.map.collaborationMaps[data.idsList[i]][item.id]+  "</b> publication(s) in" + " " + namesList[i];
							 }
							 else
							 	text = text + " <br /> <b> " + data.map.collaborationMaps[data.idsList[0]][item.id]+ "</b> publication(s)" ;
						}

						var researcherDetail = $( '<div/>' )
													.addClass( 'detail' )
													.append(
														$( '<div/>' )
															.addClass( 'name capitalize' )
															.html( text )
													);
						researcherDiv.append(
											researcherNav
										).append(
											researcherDetail
										).append('&nbsp;')
										.on('mouseover', blue)
										.on('mouseout', originalColor)
										.on('click', function(d){ 
											obj = {
													  type:"listItem",
											          clientX:d.clientX,
											          clientY:d.clientY,
											          itemId:item.id,
											          itemName:item.name,
											          objectType:"researcher"
												};
													if(item.isAdded)
														showmenudiv(obj, 'menu')
													else
														showhoverdiv(obj, 'divtoshow', item.name.toUpperCase() + " is currently not added to PALM")
										});
										
						if( !item.isAdded )
							researcherDetail.addClass( "text-gray" );

						listSection
							.append( 
										researcherDiv
									);
					});						
				}
			}
						
			if(visType == "conferences")
			{
				if( data.map.events.length == 0 )
				{
					tabContent.html("")
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No conferences locations satisfy the specified criteria!" );
					return false;
				}
				else
				{	
					var previousEG = "";
							
					<#-- build the conference list -->
					$.each( data.map.events, function( index, item)
					{
						if(type=="researcher")
						{
							conferenceDiv =	$( '<div/>' )
											.addClass( 'author' )
						}
						if(type=="conference" || type=="publication" || type=="topic" || type=="circle" )
						{
							conferenceDiv = $( '<div/>' )
												.addClass( 'author' )
												.attr({ 'id' : item.id });
						}
									
						var eventLocation = "";
						if(item.location!="")
							eventLocation = item.location + " : " + item.year;
						else
							eventLocation = "Unknown Location : " + item.year;
							
						var conferenceNav =
						$( '<div/>' )
							.addClass( 'nav' )
							.append( 
								$( '<i/>' )
								.addClass( 'fa fa-angle-right icon font-xs' )
								.append('&nbsp;')
							)
							.append(
								$( '<span/>' )
									.addClass( 'name capitalize' )
									.html( eventLocation )
							);

						var conferenceDetail = $( '<div/>' )
													.addClass( 'detail cursor-p' )
													.append(
														$( '<span/>' )
															.addClass( 'name capitalize bold-text' )
															.html( " " + item.groupName )
													)
													.on('mouseover',blue)
													.on('mouseout',originalColor)
													.on('click', function(d){ 
															if(type=="conference")
															{
																obj = {
																		type:"listItem",
																        clientX:d.clientX,
																        clientY:d.clientY,
																        itemId:item.eventGroupId,
																        itemName: item.groupName,
																        objectType:"conference"
																	  };
																showhoverdiv(obj,'divtoshow', "This conference is already added");
															}
															else
															{
																obj = {
																		  type:"listItem",
																          clientX:d.clientX,
																          clientY:d.clientY,
																          itemId:item.eventGroupId,
																          itemName: item.groupName,
																          objectType:"conference"
																};
																if(item.eventGroupIsAdded)
																	showmenudiv(obj, 'menu')
																else
																	showhoverdiv(obj, 'divtoshow', item.groupName.toUpperCase() + " is currently not added to PALM")
															}
					});

					if(previousEG != item.groupName)	
					{
						previousEG = item.groupName;

						conferenceDiv
							.append('&nbsp;')
							.append(
										conferenceDetail
									)
					}	
										
					conferenceDiv.append(
											conferenceNav
										)
										
					if( !item.isAdded )
						conferenceNav.addClass( "text-gray" );
					if(!item.eventGroupIsAdded)
						conferenceDetail.addClass( "text-gray" );
									
						listSection
							.append( 
										conferenceDiv
									);
					});
				}				
			}
						
			if(visType == "topics")
			{
				if( data.map.list.length == 0 )
				{
					tabContent.html("")	

					if(objectType == "publication" )
						$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No topics satisfy the specified criteria!" );
					else
						$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No interests satisfy the specified criteria!" );

					return false;
				}
				else
				{
					var sortedList = data.map.list.sort();

					<#-- build the conference list -->
					$.each( sortedList , function( index, item)
					{
						var topicDiv = $( '<div/>' )
										.addClass( 'author cursor-p' )
										.attr({ 'id' : item[2] });
						
						var topicNav = $( '<div/>' )
										.addClass( 'nav' )
										.append(
											$( '<div/>' )
												.addClass( 'name capitalize bold-text' )
												.html( item[0] )
										);
						topicDiv
							.append(
										topicNav
									)
							.append('&nbsp;')
							.on('mouseover',blue)
							.on('mouseout',originalColor)
							.on('click', function(d)
							{ 
								obj = {
										  type:"listItem",
								          clientX:d.clientX,
								          clientY:d.clientY,
								          itemId:item[2],
								          itemName: item[0],
								          objectType:"topic"
    								  };
								showmenudiv(obj, 'menu')
							});
										
						listSection
							.append( 
										topicDiv
									);
					});
				}				
			}
			
			if(visType == "publications")
			{
				if( data.map.pubDetailsList.length == 0 )
				{
					tabContent.html("")								
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No publications satisfy the specified criteria!" );
					return false;
				}
				else
				{
					<#-- build the conference list -->
					$.each( data.map.pubDetailsList, function( index, item)
					{
						var conferenceDiv = $( '<div/>' )
												.addClass( 'author cursor-p' )
												.attr({ 'id' : item.id });
											
						var conferenceDetail = $( '<div/>' )
												.addClass( 'name capitalize' )
												.html( item.title )
												.append(
															$( '<span/>' )
															.addClass( 'name capitalize' )
															.html( " : " + item.year )
												)
						conferenceDiv
								.append(
											conferenceDetail
										)
								.append('&nbsp;')
								.on('mouseover',blue)
								.on('mouseout',originalColor)
								.on('click', function(d)
								{ 
									obj = {
											  type:"listItem",
									          clientX:d.clientX,
									          clientY:d.clientY,
									          itemId:item.id,
									          itemName:item.title,
									          pubUrl:item.url,
									          objectType:"publication"
										};
									showmenudiv(obj, 'menu')
								});
										
						listSection
							.append( 
								conferenceDiv
							);
					});	
				}			
			}
		}
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}