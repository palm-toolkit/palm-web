<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding wsetup">
  	<div id="search-widget" class="nav-tabs-custom display-none">
  		<div id="search_words" class="fleft width50p" >
	  		<div class="type_search_words">
	  		</div>
	  		<div class="scroll-search-words">
	  		</div>
	  	</div>
  		<div class="vis_options">
  		</div>
  		<div class="clear_search">
  		</div>
	</div>
</div>

<script>
	$( function(){
		
		<#-- add slim scroll -->
	      $(".scroll-search-words").slimscroll({
				height: "100px",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		
		var names = [];
		var ids = [];
		var type = "";
		var researcherBorderProp = "";
		var conferenceBorderProp = "";
		var publicationBorderProp = "";
		var topicBorderProp = "";
		var researcherBackground = "#c0c5bf";
		var conferenceBackground = "#c0c5bf";
		var publicationBackground = "#c0c5bf";
		var topicBackground = "#c0c5bf";
		var resetFlag = "1";
		var currentVisType = "";
		
		<#-- generate unique id for progress log -->
		var uniquePidTopicWidget = $.PALM.utility.generateUniqueId();
		var options ={
			source : "<@spring.url '/explore/setupStage' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
						},
			onRefreshDone: function(  widgetElem , data ){
			console.log("REFRESHED")
			history_data = new Object();
			count = 1;
			var retrievedHistoryObject = localStorage.getItem('history_data');
			
			if(retrievedHistoryObject!=null)
			{
				history_data = JSON.parse(retrievedHistoryObject)
				count= Object.keys(history_data).length+1;
			}
			
				var search_widget = document.getElementById("search-widget")
				search_widget.style.display="block";
				var id = data.id;
				var wordsContainer = $( widgetElem ).find( ".scroll-search-words" );
				wordsContainer.css("padding-left","5px")
					.css("padding-bottom","5px")
					.css("padding-top","5px")
				visOptionsContainer = $( widgetElem ).find( ".vis_options" );
				visOptionsContainer.html( "" );
				
				for(var i=0;i<data.name.length;i++){
				
					nameDiv = $( '<span/>' )
					.attr("id",data.id[i])
					.addClass( 'name capitalize search-item' )
					.html("  "+data.name[i])
					.append($( '<span/>' )
						.addClass( 'name capitalize search-item-del' )
						.append($( '<i/>' ).addClass('fa fa-times'))
						//.html("X")
					<#-- click to delete item from search widget -->
					.on( "click", function(e){
					
						console.log(e)
						$(this).parent().remove();
						var i = ids.indexOf(e.delegateTarget.parentNode.childNodes[0].parentElement.id);
						names.splice(i, 1);
						ids.splice(i,1);
						console.log(names)
						updateVisDelete( "true", type);
						if(names.length == 0){
							wordsContainer.html("");
							visOptionsContainer.html( "" );
						}
						else
							addToHistory();
					}))
				
				if(data.replace && i==0){
					type = data.type;
					names = [];
					ids = [];
					wordsContainer.html( "" );
					resetFlag = "1";
					names.push(data.name[i]);
					ids.push(data.id[i]);
					
					if(i == data.name.length-1)		
						addToHistory();

					if(data.name[i]!=""){
					wordsContainer
						.append(nameDiv)
				
						if(resetFlag=="1" || currentVisType=="" || type!=data.type){
							<#-- if(type == "researcher"){ -->
								setBoxes(id, type, "researchers")
							<#--}
							if(type == "publication"){
								setBoxes(id, type, "conferences")
							}
							if(type == "conference"){
								setBoxes(id, type, "publications")
							}
							if(type == "topic"){
								setBoxes(id, type, "publications")
							}
							if(type == "circle"){
								setBoxes(id, type, "researchers")
							}-->
						}
					}
							
					if(i == data.name.length-1)		
						callRefresh(id,type)
				}
				else{
				<#-- update list of items chosen from search widget -->
				if(names.indexOf(data.name[i])== -1 ){	
					if(type!=""){
						if(type!=data.type){
							type = data.type;
							names = [];
							ids = [];
							wordsContainer.html( "" );
							resetFlag = "1";
						}
					}
					else{
						type = data.type;
						resetFlag = "0";
					}
					
					names.push(data.name[i]);
					ids.push(data.id[i]);
					if(i == data.name.length-1)		
						addToHistory();
								
							if(data.name[i]!=""){
								wordsContainer
								.append(nameDiv)
								if(resetFlag=="1" || currentVisType=="" || type!=data.type){
									<#-- if(type == "researcher"){ -->
									setBoxes(id, type, "researchers")
									<#--}
									if(type == "publication"){
										setBoxes(id, type, "conferences")
									}
									if(type == "conference"){
										setBoxes(id, type, "publications")
									}
									if(type == "topic"){
										setBoxes(id, type, "publications")
									}
									if(type == "circle"){
										setBoxes(id, type, "researchers")
									}-->
								}
							}
							if(i == data.name.length-1)		
								callRefresh(id,type)
						}	
					}
				}	
				
			if(data.name.length>0)		
				setBoxes(id, type, currentVisType);
		}
	};
	
		function callRefresh(id,type){
							if(type == "researcher"){
								refreshVisFilter(id, type,  "researchers");
							}
							if(type == "publication"){
								refreshVisFilter(id, type, "conferences");
							}
							if(type == "conference"){
								refreshVisFilter(id, type, "publications");
							}
							if(type == "topic"){
								refreshVisFilter(id, type,  "publications");
							}
							if(type == "circle"){
								refreshVisFilter(id, type,  "researchers");
							}
		}
		
		function updateVisDelete( deleteFlag, type){
			dataTransfer = "true";
			checkedPubValues=[];
			checkedConfValues=[];
			checkedTopValues=[];
			checkedCirValues=[];
		
			var queryString = "?deleteFlag="+deleteFlag+"&type="+type+"&dataList="+names+"&idList="+ids+"&dataTransfer="+dataTransfer;
			
			<#-- update visualize widget -->
			var visualizeWidget = $.PALM.boxWidget.getByUniqueName( 'explore_visualize' ); 
			visualizeWidget.options.queryString = queryString+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues;
			$.PALM.boxWidget.refresh( visualizeWidget.element , visualizeWidget.options );
			
			<#-- update filter widget -->
			var filterWidget = $.PALM.boxWidget.getByUniqueName( 'explore_filter' ); 
			filterWidget.options.queryString = queryString;
			$.PALM.boxWidget.refresh( filterWidget.element , filterWidget.options );
		}
		
		function refreshVisFilter(id, type, visType){
			dataTransfer = "true";
			checkedPubValues=[];
			checkedConfValues=[];
			checkedTopValues=[];
			checkedCirValues=[];
			var updateString = "?id="+id+"&type="+type+"&dataList="+names+"&idList="+ids+"&visType="+currentVisType+"&dataTransfer="+dataTransfer;
					
			<#-- update visualize widget -->
			var visualizeWidget = $.PALM.boxWidget.getByUniqueName( 'explore_visualize' ); 
			visualizeWidget.options.queryString = updateString+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues;
			$.PALM.boxWidget.refresh( visualizeWidget.element , visualizeWidget.options );
			
			<#-- update filter widget -->
			var filterWidget = $.PALM.boxWidget.getByUniqueName( 'explore_filter' ); 
			filterWidget.options.queryString = updateString;
			$.PALM.boxWidget.refresh( filterWidget.element , filterWidget.options );
		}
		
		function setBoxes(id, type, typeOfBox){
			visOptionsContainer.html("");
			currentVisType = typeOfBox;
			resetFlag = "0";
			var borderProp = "3px solid #000000 ";
			<#-- change focus between search options -->
			if(typeOfBox == "researchers"){
				researcherBorderProp = borderProp;
				conferenceBorderProp = "none";
				publicationBorderProp = "none";
				topicBorderProp = "none";
				researcherBackground = "#db845c";
				conferenceBackground = "#c0c5bf";
				publicationBackground = "#c0c5bf";
				topicBackground = "#c0c5bf";
			}
			if(typeOfBox == "conferences"){
				researcherBorderProp = "none";
				conferenceBorderProp = borderProp;
				publicationBorderProp = "none";
				topicBorderProp = "none";
				researcherBackground = "#c0c5bf";
				conferenceBackground = "#db845c";
				publicationBackground = "#c0c5bf";
				topicBackground = "#c0c5bf";
			}
			if(typeOfBox == "publications"){
				researcherBorderProp = "none";
				conferenceBorderProp = "none";
				publicationBorderProp = borderProp;
				topicBorderProp = "none";
				researcherBackground = "#c0c5bf";
				conferenceBackground = "#c0c5bf";
				publicationBackground = "#db845c";
				topicBackground = "#c0c5bf";
			}
			if(typeOfBox == "topics"){
				researcherBorderProp = "none";
				conferenceBorderProp = "none";
				publicationBorderProp = "none";
				topicBorderProp = borderProp;
				researcherBackground = "#c0c5bf";
				conferenceBackground = "#c0c5bf";
				publicationBackground = "#c0c5bf";
				topicBackground = "#db845c";
			}
			
		<#-- dynamic widgets depending on type of search object -->
					var specTitle = "Co-Authors";
					
					if(type!="researcher"){
						specTitle = "Researchers";
						//caption = "Corresponding researchers";
					}
					
					var caption = "Click to generate/refresh "+"\n"+"visualizations";
					
					visOptionsContainer.append(
						$('<div/>')
						.addClass('info-box box-home-explore')
						.append(
							$('<i/>')
							.addClass('fa fa-users fa-lg'))
							.css("text-align","center")
						.append(
							$('<div/>')
							.addClass('info-box-content info-box-home-text')
							.append(
								$('<span/>')
								.addClass('info-box-number fontsize24')
							)
						)		
						.append($('<h5/>').css("text-align","center").html(specTitle))
						.css({ "cursor":"pointer", "border":researcherBorderProp, "color":"black", "background-color":researcherBackground})
						.addClass('box-border')
						.attr("title",caption)
						.on( "click", function( e){
							setBoxes(id, type, "researchers")
							refreshVisFilter(id, type,  "researchers");
						})
					)
				
				//	caption = "Corresponding " + "<br/>" +"conferences";
				
				var specTitle = "Events";
					
					if(type!="conference"){
						specTitle = "Conferences";
					}
					visOptionsContainer.append(
						$('<div/>')
						.addClass('info-box box-home-explore')
						.append(
							$('<i/>')
							.addClass('fa fa-globe fa-lg'))
							.css("text-align","center")
						.append(
							$('<div/>')
							.addClass('info-box-content info-box-home-text')
							.append(
								$('<span/>')
								.addClass('info-box-number fontsize24')
							)
						)		
						.append($('<h5/>').css("text-align","center").html(specTitle))
						.css({ "cursor":"pointer", "border":conferenceBorderProp, "color":"black", "background-color":conferenceBackground})
						.addClass('box-border')
						.attr("title",caption)
						.on( "click", function( e){
							setBoxes(id, type, "conferences")
							refreshVisFilter(id, type,  "conferences");
						})
					)
	
				//	caption = "Corresponding publications";	
					visOptionsContainer.append(
						$('<div/>')
						.addClass('info-box box-home-explore')
						.append(
							$('<i/>')
							.addClass('fa fa-file-text-o fa-lg'))
							.css("text-align","center")
						.append(
							$('<div/>')
							.addClass('info-box-content info-box-home-text')
							.append(
								$('<span/>')
								.addClass('info-box-number fontsize24')
							)
						)		
						.append($('<h5/>').css("text-align","center").html("Publications"))
						.css({ "cursor":"pointer", "border":publicationBorderProp, "color":"black", "background-color":publicationBackground})
						.addClass('box-border')
						.attr("title",caption)
						.on( "click", function( e){
							setBoxes(id, type, "publications")
							refreshVisFilter(id, type,  "publications");
						})
					)

				//	caption = "Corresponding topics";
				//	if(type!="publication" && type!="topic")
				//		caption = "Corresponding interests";
				
				specTitle = "Topics";
				if(type!="publication"){
					specTitle = "Interests";
					//caption = "Corresponding researchers";
				}
				
					visOptionsContainer.append(
						$('<div/>')
						.addClass('info-box box-home-explore')
						.append(
							$('<i/>')
							.addClass('fa fa-comments-o fa-lg'))
							.css("text-align","center")
						.append(
							$('<div/>')
							.addClass('info-box-content info-box-home-text')
							.append(
								$('<span/>')
								.addClass('info-box-number fontsize24')
							)
						)		
						.append($('<h5/>').css("text-align","center").html(specTitle))
						.css({ "cursor":"pointer", "border":topicBorderProp, "color":"black", "background-color":topicBackground})
						.addClass('box-border')
						.attr("title",caption)
						.on( "click", function( e){
							setBoxes(id, type, "topics")
							refreshVisFilter(id, type,  "topics");
						})
					)
					
					visOptionsContainer.append(
								$('<i/>')
									.addClass('fa fa-trash fa-lg clear_search cursor-p')
									.css('color','#c0c5bf')
									.attr("title","Clear all visualization criteria")
									.on("click",function(e){
									
									// clear current names and ids lists
									names = [];
									ids = [];
										
									// send blank values in query string and refresh search widget	
									id="";
									type="";
									var queryString = "?id="+id+"&type="+type;
									<#-- update search widget -->
									var searchWidget = $.PALM.boxWidget.getByUniqueName( 'explore_search' ); 
									searchWidget.options.queryString = queryString;
									$.PALM.boxWidget.refresh( searchWidget.element , searchWidget.options );
										
									// remove DOM elements from search widget 	
									$(".search-item").each(function(){
										$(this).remove();
									})
									$(".box-home-explore").each(function(){
										$(this).remove();
									})
									
									// clear visualization and filter widget
									refreshVisFilter(id, type, visType)
										
									})
							)
		}
		
		function addToHistory()
		{
			var historyIds = [];
			var historyNames = [];
			
			var date = new Date();
			var day = date.getDate();
			var month = date.getMonth();
			var year = date.getFullYear();
			var hour = date.getHours();
			var minute = date.getMinutes();
			var second = date.getSeconds();
			var timestamp = day + "/" + month + "/" + year + " " + hour + ":" + minute + ":" + second;
			
			for(var c=0;c<ids.length;c++)
			historyIds.push(ids[c]);
			for(var c=0;c<names.length;c++)
			historyNames.push(names[c]);
			var historyGroup = new Object();
			historyGroup.names = historyNames;
			historyGroup.ids = historyIds;
			historyGroup.type = type;
			historyGroup.time = timestamp;
			
			if(count == 21)
			{
				for(var i=1; i<21; i++)
				{
					history_data[i] = history_data[i+1]
				}	
				count--;
			}
			history_data[count] = historyGroup;
			window.localStorage.removeItem(history_data);
			localStorage.setItem('history_data',JSON.stringify(history_data));
			
			<#-- update history widget -->
			var historyWidget = $.PALM.boxWidget.getByUniqueName( 'explore_history' ); 
			$.PALM.boxWidget.refresh( historyWidget.element , historyWidget.options );
			
			count++;
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