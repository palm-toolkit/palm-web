<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding wfilter">
  	<div class="filter_widget" class="nav-tabs-custom">
  		<div id="apply_button" class="display-none">
  			<input type="button" value="Apply" id="button" class="apply-button" onclick="checkBoxChange()">
  		</div>
  		<div class="widget_body height120">
  		</div>
	</div>
</div>

<script>
	$( function(){
		
		var pubList = [];
		objectType = "";
		filterList = [];
		checkedPubValues = [];
		checkedConfValues = [];
		checkedTopValues = [];
		checkedCirValues = [];
		startYear = 0;
		endYear = 0;
		visType = "";
		var filterPopUpIds = [];
		
		$('body').on('click', '#pub_filter_search', function () {
		     $('#pub_filter_search')
 				.on( "keypress", function(e) {
		    				var term = $( this ).val();
				  			if ( e.keyCode == 13)
				  			{							
				  				fillFilter(pubList, term, pubCount, publicationsFilter, pubSectionHeader, 'publicationCB', 'hsla(120, 100%, 50%, 0.2)')
				  				//fillPublicationFilter(pubList, term);
				  			}
					})
		});
		$('body').on('click', '#conf_filter_search', function () {
		     $('#conf_filter_search')
 				.on( "keypress", function(e) {
		    				var term = $( this ).val();
				  			if ( e.keyCode == 13)
				  			{
				  				//fillConferenceFilter(confList, term);
				  				fillFilter(confList, term, confCount, conferencesFilter, confSectionHeader, 'conferenceCB', 'hsla(70,100%,50%,0.2)')
				  			}
					})
		});
		$('body').on('click', '#top_filter_search', function () {
		     $('#top_filter_search')
 				.on( "keypress", function(e) {
		    				var term = $( this ).val();
				  			if ( e.keyCode == 13)
				  			{
				  				//fillTopicFilter(topList, term);
				  				fillFilter(topList, term, topCount, topicsFilter, topSectionHeader, 'topicCB', 'hsla(240, 83%, 47%, 0.2)')
				  			}
					})
		});
		$('body').on('click', '#cir_filter_search', function () {
		     $('#cir_filter_search')
 				.on( "keypress", function(e) {
		    				var term = $( this ).val();
				  			if ( e.keyCode == 13)
				  			{
				  				//fillCircleFilter(cirList, term);
				  				fillFilter(cirList, term, cirCount, circlesFilter, cirSectionHeader, 'circleCB', '#f9f5f5')
				  			}
					})
		});
		$('body').on('click', '#pub_filter_all', function () {
		     $("#pub_filter_all").on("click", function(){togglePub(this)})
		});
		$('body').on('click', '#conf_filter_all', function () {
		     $("#conf_filter_all").on("click", function(){toggleConf(this)})
		});
		$('body').on('click', '#top_filter_all', function () {
		     $("#top_filter_all").on("click", function(){toggleTop(this)})
		});
		$('body').on('click', '#cir_filter_all', function () {
		     $("#cir_filter_all").on("click", function(){toggleCir(this)})
		});
		
		<#-- generate unique id for progress log -->
		var uniquePidTopicWidget = $.PALM.utility.generateUniqueId();
		var options ={
			source : "<@spring.url '/explore/filter' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
					
			},
			onRefreshDone: function(  widgetElem , data ){
			$(".widget_body").slimscroll({
				height: "75vh",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			//alwaysVisible: true
		  });
			
				names = data.dataList;
				ids = data.idsList;
			
				var targetContainer = $( widgetElem ).find( ".widget_body" );
				
				<#-- update type of visualization depending on selection-->
				if(objectType == ""){
					objectType = data.type;
					visType = data.visType;
				}
				if(data.type!==objectType){
					objectType = data.type;
					visType = data.visType;
				}
				if(data.type==objectType && visType!=data.visType && data.visType!=""){
					visType = data.visType;
				}	
				
				<#-- Filters depending on type of visualization-->
				if(objectType=="researcher")
				{
					if(visType=="researchers"){
						filterList = ["Time", "Publications", "Conferences", "Topics", "Circles"];
					}
					if(visType=="conferences"){
						filterList = ["Time", "Topics", "Conferences"];
					}		
					if(visType=="publications"){
						filterList = ["Time", "Topics", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Time", "Publications", "Conferences"];
					}
				}
				
				if(objectType=="conference")
				{
					if(visType=="researchers"){
						filterList = ["Time", "Topics", "Publications"];
					}
					if(visType=="conferences"){
						filterList = ["Time", "Topics"];
					}		
					if(visType=="publications"){
						filterList = ["Time", "Topics"];
					}
					if(visType=="topics"){
						filterList = ["Time", "Publications"]; 
					}
				}
				
				if(objectType=="publication")
				{
					if(visType=="researchers"){
						filterList = [ "Topics", "Conferences"];
					}
					if(visType=="conferences"){
						filterList = [ "Topics", "Conferences"];
					}		
					if(visType=="publications"){
						filterList = [ "Topics", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Conferences"];
					}
				}
				
				if(objectType=="topic")
				{
					if(visType=="researchers"){
						filterList = ["Time", "Publications", "Conferences"];
					}
					if(visType=="conferences"){
						filterList = ["Time", "Publications"];
					}		
					if(visType=="publications"){
						filterList = ["Time", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Time",  "Conferences"]; //, "Publications",
					}
				}
				if(objectType=="circle")
				{
					if(visType=="researchers"){
						filterList = ["Time", "Publications", "Conferences", "Topics"];
					}
					if(visType=="conferences"){
						filterList = ["Time", "Topics", "Conferences"]; // ,"Publications"
					}		
					if(visType=="publications"){
						filterList = ["Time", "Topics", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Time", "Publications", "Conferences"];
					}
				}
				
				<#-- generate unique id for progress log -->
				uniqueFilterWidget = $.PALM.utility.generateUniqueId();
					
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "Loading Filters..", { uniqueId:uniqueFilterWidget, popUpHeight:40, directlyRemove:false , polling:false});
				filterPopUpIds.push(uniqueFilterWidget);
				
				$.getJSON( "<@spring.url '/explore/filter' />"+"?filterList="+filterList+"&dataList="+names+"&idList="+ids+"&type="+objectType+"&visType="+visType+"&startYear="+startYear+"&endYear="+endYear , function( data ) {
					console.log("filter data: ")
					console.log(data)
				
				if(data.oldFilters=="false")
				{
					for(var i=0;i<filterPopUpIds.length;i++)
					{	 
						<#-- remove  pop up progress log -->
						$.PALM.popUpMessage.remove( filterPopUpIds[i] );
						filterPopUpIds.splice(i,1);
						i--;
					}
					
					if(data.type!="undefined" && data.visType!="undefined")
					{
						targetContainer.html("");
		    			if(ids.length!=0)
		    			{
			    			var applyButton = $( widgetElem ).find( "#apply_button" );
			    			applyButton.css("display","block");
			    			
			    			if(data.TimeFilter != undefined)
			    			{
			    				yearFilter = $('<div/>')
				    					.attr("id","year_filter")
				    					.css("width","100%")
				    			targetContainer.append(yearFilter)		
				    			yearFilter
				    				.append(
				    					$('<div/>')
				    						.css("width","20%")
				    						.css("padding-left","6px")
				    						.css("padding-top","20px")
				    						.css("float","left")
				    						.append(
				    							$('<label/>')
				    								.attr("for","year_range")
				    								.html("Year(s):")		
				    						)
				    				)	
									.append(
										$('<div/>')
											.css("padding-left","10px")
											.css("padding-right","10px")
											.css("width","80%")
											.css("float","right")
											.append(
												$('<input/>')
													.attr('type','text')
													.attr('id','year_range')
											)
									)				
								
								startYear = data.TimeFilter.startYear; 
								endYear = data.TimeFilter.endYear;	
									
								$("#year_range").html("");
								$("#year_range").ionRangeSlider({
						            hide_min_max: true,
						            keyboard: true,
						            min: data.TimeFilter.startYear,
						            max: data.TimeFilter.endYear,
						            type: 'double',
						            step: 1,
						            grid: true
					        	});
					        	
					        	var $range = $("#year_range");
					
								$range.on("change", function () {
								    var $this = $(this),
								        value = $this.prop("value").split(";");
								
								    startYear = value[0]; 
								    endYear = value[1];
								});
							}			    		
			    			var filters = $('<div/>')
			    						.attr("id","other_filters");
			    			targetContainer.append(filters);
						}
									
						var filterContent = $( widgetElem ).find( "#other_filters" );
						filterContent.html("");			
			
						publicationsFilter = $('<div/>').addClass("publicationsFilter")
						filterContent.append(publicationsFilter);
						
						conferencesFilter = $('<div/>').addClass("conferencesFilter")
						filterContent.append(conferencesFilter);
						
						topicsFilter = $('<div/>').addClass("topicsFilter")
						filterContent.append(topicsFilter);
						
						circlesFilter = $('<div/>').addClass("circlesFilter")
						filterContent.append(circlesFilter);
						
							<#-- PUBLICATIONS FILTER -->
							if(data.publicationFilter != undefined && data.publicationFilter.publicationsList.length!=0){
								pubList = data.publicationFilter.publicationsList;
								pubCount = $( '<span/>' )
								pubSectionHeader = $( '<span/>' ).addClass('filter-name').html("PUBLICATIONS")
												.append('&nbsp;')
												.append(
													$('<span/>')
													.append(
														$('<input/>')
														.attr('type','checkbox')
														.attr('value', 'All')
														.attr("id" , "pub_filter_all")
														.on("click", function(){togglePub(this)})
													 )
													).append('&nbsp;')
													.append(
													$('<input/>')
													.attr("id" , "pub_filter_search")
													.addClass('text-field')
												 )
								//fillPublicationFilter(pubList,"");
								fillFilter(pubList, "", pubCount, publicationsFilter, pubSectionHeader, 'publicationCB', 'hsla(120, 100%, 50%, 0.2)')
							}	
								
							<#-- CONFERENCE FILTER -->
							if(data.conferenceFilter != undefined && data.conferenceFilter.eventsList.length!=0){
								confList = data.conferenceFilter.eventsList;
								confCount = $( '<span/>' )
								confSectionHeader = $( '<span/>' ).addClass('filter-name').html("CONFERENCES")
												.append('&nbsp;')
												.append(
													$('<span/>')
													.append(
														$('<input/>')
														.attr('type','checkbox')
														.attr('value', 'All')
														.attr("id" , "conf_filter_all")
														.on("click", function(){toggleConf(this)})
													 )
													).append('&nbsp;')
													.append(
													$('<input/>')
													.attr("id" , "conf_filter_search")
													.addClass('text-field')
												 	)
								
								//fillConferenceFilter(confList,"");
								fillFilter(confList, "", confCount, conferencesFilter, confSectionHeader, 'conferenceCB', 'hsla(70,100%,50%,0.2)')
							}	
							
							<#-- TOPIC FILTER -->
							if(data.topicFilter != undefined && data.topicFilter.topicDetailsList.length!=0){
							 	topList = data.topicFilter.topicDetailsList;
								topCount = $( '<span/>' )
							 	topSectionHeader = $( '<span/>' ).addClass('filter-name').html("TOPICS/INTERESTS")
												.append('&nbsp;')
												.append(
													$('<span/>')
													.append(
														$('<input/>')
														.attr('type','checkbox')
														.attr('value', 'All')
														.attr("id" , "top_filter_all")
														.on("click", function(){toggleTop(this)})
													 )
												).append('&nbsp;')
													.append(
													$('<input/>')
													.attr("id" , "top_filter_search")
													.addClass('text-field')
												 	)
								//fillTopicFilter(topList,"");	
								fillFilter(topList, "", topCount, topicsFilter, topSectionHeader, 'topicCB', 'hsla(240, 83%, 47%, 0.2)')			 	
							}	
							
							<#-- CIRCLES FILTER -->
							if(data.circleFilter != undefined && data.circleFilter.circles !=undefined && data.circleFilter.circles.length!=0){
								cirList = data.circleFilter.circles;
								cirCount = $( '<span/>' )
								cirSectionHeader = $( '<span/>' ).addClass('filter-name').html("CIRCLES ")
												.append('&nbsp;')
												.append(
													$('<span/>')
													.append(
														$('<input/>')
														.attr('type','checkbox')
														.attr('value', 'All')
														.attr("id" , "cir_filter_all")
														.on("click", function(){toggleCir(this)})
													 )
												).append('&nbsp;')
													.append(
													$('<input/>')
													.attr("id" , "cir_filter_search")
													.addClass('text-field')
												 	)
								//fillCircleFilter(cirList,"");
								fillFilter(cirList, "", cirCount, circlesFilter, cirSectionHeader, 'circleCB', '#f9f5f5')
							}
						}						
					}
				
					<#-- hide filters in specific cases -->
					var other_filters = document.getElementById("other_filters")
					if(other_filters!=null)
					{
				 		if(currentTabName == "Comparison")
				 			other_filters.style.display = "none";
						else
							other_filters.style.display = "block";
			 		}
			 		var year_filter = document.getElementById("year_filter")
					if(year_filter!=null)
					{
				 		if(currentTabName == "Similar")
				 		{
				 			year_filter.style.display = "none";
				 			other_filters.style.visibility = "hidden";
						}
						else
						{
							year_filter.style.display = "block";
							other_filters.style.visibility = "visible";
						}	
			 		}
						
				
				});
				
							
			
			}
			
		};	
		
		function togglePub(source) {
		  checkboxesPub = document.getElementsByName('publicationCB');
		  for(var i=0, n=checkboxesPub.length;i<n;i++) {
		    checkboxesPub[i].checked = source.checked;
		  }
		}
		
		function toggleConf(source) {
		  checkboxesConf = document.getElementsByName('conferenceCB');
		  for(var i=0, n=checkboxesConf.length;i<n;i++) {
		    checkboxesConf[i].checked = source.checked;
		  }
		}
		
		function toggleTop(source) {
		  checkboxesTop = document.getElementsByName('topicCB');
		  for(var i=0, n=checkboxesTop.length;i<n;i++) {
		    checkboxesTop[i].checked = source.checked;
		  }
		}
		
		function toggleCir(source) {
		  checkboxesCir = document.getElementsByName('circleCB');
		  for(var i=0, n=checkboxesCir.length;i<n;i++) {
		    checkboxesCir[i].checked = source.checked;
		  }
		}
		
		function sortList(a,b){
			a = a.toLowerCase();
			b = b.toLowerCase();
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		}
		
		function fillFilter(data,term, sectionCount, typeFilter, filterHeader, sectionName, color){
			var array = [];
				if(term!=""){
					$.each(data,function(index, item){
	  					if(item!=undefined){
		  					if(item.name.toLowerCase().indexOf(term.toLowerCase()) != -1)
		  						array.push(item)
	  					}	
	  				})
				}
				else
					array = data;
		
			var itemSection = $( '<div/>' );
								
			sectionCount.html("");
			sectionCount.html("(" + array.length + "/" + data.length + ")") 
			typeFilter.html("");
			typeFilter.append(filterHeader);
			filterHeader.append(sectionCount);
			typeFilter.append(itemSection);
	
			itemSection.addClass('top_list')
				.css('overflow-y','scroll')
				.css('height', 'auto')
				.css('background-color', color)
				.css('max-height', '23vh')
			
			$(".top_list").slimscroll({
				height: "23vh",
		        size: "10px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			color: '#008000'
	       });
	
			<#-- build the Topic Filter list -->
			var sortedList = array.sort(function(a, b) 
			{
				return sortList(a.name, b.name);
			})
			$.each( sortedList, function( index, item){
			if(item.name!=null)
			{
				var itemDiv = 
						$( '<div/>' )
							.attr({ 'id' : item.id })
							.css('padding-left','4px')
							.css('padding-right','4px')
							.append(
								$('<input/>')
									.attr('type','checkbox')
									.attr('name',sectionName)
									.attr('value', item.name)
									.attr({ 'id' : item.id })
								 )
							.append(
								$( '<span/>' )
									.addClass( 'name' )
									.html( " " +  item.name )
							)
								
							itemSection
								.append( 
									itemDiv
								);
				}
			});
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
	
			function checkBoxChange(){
			checkedPubValues = [];
			checkedConfValues = [];
			checkedTopValues = [];
			checkedCirValues = [];
		
			checkboxesPub = document.getElementsByName('publicationCB');
		  	for(var i=0; i<checkboxesPub.length;i++) {
		    	if(checkboxesPub[i].checked)
		    		checkedPubValues.push(checkboxesPub[i].id)
		  	}	
		
			checkboxesConf = document.getElementsByName('conferenceCB');
		  	for(var i=0; i<checkboxesConf.length;i++) {
		    	if(checkboxesConf[i].checked)
		    		checkedConfValues.push(checkboxesConf[i].id)
		  	}
		  	
		  	checkboxesTop = document.getElementsByName('topicCB');
		  	for(var i=0; i<checkboxesTop.length;i++) {
		    	if(checkboxesTop[i].checked)
		    		checkedTopValues.push(checkboxesTop[i].id)
		  	}
		  	
		  	checkboxesCir = document.getElementsByName('circleCB');
		  	for(var i=0; i<checkboxesCir.length;i++) {
		    	if(checkboxesCir[i].checked)
		    		checkedCirValues.push(checkboxesCir[i].id)
		  	}
			
			<#-- update visualize widget -->
			var yearFilterPresent = "true";
			var updateString = "?type="+objectType+"&dataList="+names+"&idList="+ids+"&visType="+visType+"&dataTransfer="+dataTransfer+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues+"&startYear="+startYear+"&endYear="+endYear+"&yearFilterPresent="+yearFilterPresent;
			var visualizeWidget = $.PALM.boxWidget.getByUniqueName( 'explore_visualize' ); 
			visualizeWidget.options.queryString = updateString;
			$.PALM.boxWidget.refresh( visualizeWidget.element , visualizeWidget.options );
			
	
		}
</script>