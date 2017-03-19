<#-- TIMELINE TAB -->
function tabVisTimeline(uniqueVisWidget, url, widgetElem, tabContent)
{
	var prevYear = 1000;
	$.getJSON( url , function( data ) 
	{
		<#-- remove  pop up progress log -->
		$.PALM.popUpMessage.remove( uniqueVisWidget );
		if(data.oldVis=="false")
		{
			if( data.map.pubDetailsList.length == 0 )
			{
				$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No publications satisfy the specified criteria" );
				return false;
			}
		
			var timeDiv = $('<div/>')
								.addClass("timeline")
								.css('overflow-y','scroll')
					
			tabContent.addClass("timeline-body").append(timeDiv);
		
			$(".timeline").slimscroll({
						height: "66vh",
				        size: "5px",
			        	allowPageScroll: true,
			   			touchScrollStep: 50,
			});
		
			var innerTimeDiv = $('<div/>')
		
			timeDiv.append(innerTimeDiv)
		
			var section = innerTimeDiv.append(
				$('<section/>'))
					.attr("id","cd-timeline")
					.addClass("cd-container")
				
			var inner;	
			$.each( data.map.pubDetailsList, function( index, item)
			{
				 h2=$('<h2/>').css("text-align","center").html(item.year)	
				 inner = $('<div/>')
							.addClass("cd-timeline-block")
							.click(function(e){
								hidemenudiv('menu');
							})

				if(prevYear!=item.year)
				{		
					var categoriesMap = data.map.yearWisePublicationCategories[item.year];
					var keys = Object.keys(categoriesMap)
					var categoriesStr = "";
		            for(var i = 0; i<keys.length; i++)
					{
					 	categoriesStr = categoriesStr + " " + keys[i] + "S:  " + categoriesMap[keys[i]];
					 	if(i!=keys.length-1)
					 		categoriesStr = categoriesStr + "  ||  "
					}	 
					yearWiseCategories = $('<span/>').css({"margin":"auto","display":"table", "position":"inherit", "font-size":"13px", "background-color":"lightslategray", "color":"white", "padding":"5px"}).html(categoriesStr)
					section.append(h2)
					section.append(yearWiseCategories)
					prevYear = item.year
				}		
				section.append(inner)
					
				if(item.type=="CONFERENCE")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-conference")
							.attr({ "title" : "Conference" })
							.append(
								$( '<img/>' )
									.attr("src","<@spring.url '/resources/images/document.svg' />")
							)
					)
				}
				else if(item.type=="JOURNAL")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-journal")
							.attr({ "title" : "Journal" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/newspaper.svg' />")
							)
					)
				}
				else if(item.type=="WORKSHOP")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-workshop")
							.attr({ "title" : "Workshop" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/copy.svg' />")
							)
					)
				}
				else if(item.type=="INFORMAL")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-informal")
							.attr({ "title" : "Informal" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/copy.svg' />")
							)
					)
				}
				else if(item.type=="BOOK")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-book")
							.attr({ "title" : "Book" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/open-book.svg' />")
							)
					)
				}
				else if(item.type=="THESES")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-theses")
							.attr({ "title" : "Theses" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/open-book.svg' />")
							)
					)
				}
				else if(item.type=="EDITORSHIP")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-editorship")
							.attr({ "title" : "Editorship" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/newspaper.svg' />")
							)
					)
				}
				else if(item.type=="SPECIALISSUE")	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-specialissue")
							.attr({ "title" : "Special Issue" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/document.svg' />")
							)
					)
				}
				else	
				{
					inner.append(
						$('<div/>')
							.addClass("cd-timeline-img cd-unknown")
							.attr({ "title" : "Unknown" })
							.append(
								$('<img/>')
									.attr("src","<@spring.url '/resources/images/exclamation.svg' />")
							)
					)
				}
				inner.append(
						$('<div/>')
							.addClass("cd-timeline-content cursor-p")
							.append(
								$('<p/>')
								.html(item.title)
								.click(function(e){
										obj = {
												  type:"clickPublication",
										          clientX:e.pageX,
										          clientY:e.pageY,
										          itemName: item.title,
										          pubId:item.id,
										          pubUrl: item.url
										};
										showmenudiv(obj,'menu');
										e.stopPropagation()
								})
							)
							.append(
								$('<span/>')
								.addClass("cd-date")
								.html(item.date)
							)
				)
			});
		}	
	}).fail(function() 
	{
 		$.PALM.popUpMessage.remove( uniquePid );
	});
}