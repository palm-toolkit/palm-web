<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:100px;overflow:hidden">
  	<div id="setup_widget" class="nav-tabs-custom">
  		<div id="search_words" style="width:50%;float:left;" >
	  		<div class="type_search_words">
	  		</div>
	  		<div class="scroll_search_words" style="overflow-y: scroll; height:400px; ">
	  		</div>
	  	</div>
  		<div class="vis_options" style="width:50%;float:right;height:100px;" >
  		</div>
	</div>
</div>

<script>
	$( function(){
		
			<#-- add slim scroll -->
	      $(".scroll_search_words").slimscroll({
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
		var circleBorderProp = "";
		var resetFlag = "1";
		var currentVisType = "";
		var count= 1;
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
				var id = data.id;
				var wordsContainer = $( widgetElem ).find( ".scroll_search_words" );
				wordsContainer.css("padding-left","5px")
					.css("padding-bottom","5px")
					.css("padding-top","5px")
				visOptionsContainer = $( widgetElem ).find( ".vis_options" );
				visOptionsContainer.html( "" );
		
				for(var i=0;i<data.name.length;i++){
				
							<#-- TO-DO Add css part to palm.css -->
							nameDiv = $( '<span/>' )
							.attr("id",data.id[i])
							.css("color", "black")
							.css("left-margin","2px")
							.css("background-color","#d9c7c6")
							.css("font-size","14px")
							.css("border" ,"1px solid black")
							.css("border-radius","0.5em")
							.css("display","inline-block")
							.css("margin-top","3px")
							.css("margin-left","3px")
							.css("margin-right","3px")
							.css("padding-left","5px")
							.css("padding-right","5px")
							.css({ "cursor":"pointer"})
							.html("  "+data.name[i]+ " X ")
							<#-- click to delete item from setup widget -->
							.on( "click", function(e){
								this.remove();
								var i = ids.indexOf(e.delegateTarget.id);
								names.splice(i, 1);
								ids.splice(i,1);
								updateVisDelete( "true", type);
								if(names.length == 0){
									wordsContainer.html("");
									visOptionsContainer.html( "" );
								}
							});
				
				if(data.replace && i==0){
					type = data.type;
							names = [];
							ids = [];
							wordsContainer.html( "" );
							resetFlag = "1";
							names.push(data.name[i]);
							ids.push(data.id[i]);
							
							if(data.name[i]!=""){
							wordsContainer
								.append(nameDiv)
						
								if(resetFlag=="1" || currentVisType=="" || type!=data.type){
									if(type == "researcher"){
										setBoxes(id, type, "researchers")
									}
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
										setBoxes(id, type, "")
									}
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

							if(data.name[i]!=""){
								wordsContainer
								.append(nameDiv)

								if(resetFlag=="1" || currentVisType=="" || type!=data.type){
									if(type == "researcher"){
										setBoxes(id, type, "researchers")
									}
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
										setBoxes(id, type, "")
									}
								}
							}
							if(i == data.name.length-1)		
								callRefresh(id,type)
						}	
					}
				}		
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
								refreshVisFilter(id, type,  "");
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
			var borderProp = "5px ridge #000000 ";
			<#-- change focus between setup options -->
			if(typeOfBox == "researchers"){
				researcherBorderProp = borderProp;
				conferenceBorderProp = "none";
				publicationBorderProp = "none";
				topicBorderProp = "none";
				circleBorderProp = "none";
			}
			if(typeOfBox == "conferences"){
				researcherBorderProp = "none";
				conferenceBorderProp = borderProp;
				publicationBorderProp = "none";
				topicBorderProp = "none";
				circleBorderProp = "none";
			}
			if(typeOfBox == "publications"){
				researcherBorderProp = "none";
				conferenceBorderProp = "none";
				publicationBorderProp = borderProp;
				topicBorderProp = "none";
				circleBorderProp = "none";
			}
			if(typeOfBox == "topics"){
				researcherBorderProp = "none";
				conferenceBorderProp = "none";
				publicationBorderProp = "none";
				topicBorderProp = borderProp;
				circleBorderProp = "none";
			}
			if(typeOfBox == "circles"){
				researcherBorderProp = "none";
				conferenceBorderProp = "none";
				publicationBorderProp = "none";
				topicBorderProp = "none";
				circleBorderProp = borderProp;
			}
			
		<#-- dynamic widgets depending on type of search object -->
				if(type == "researcher" || type == "publication" || type == "conference" || type == "topic" || type == "circle"){
					
					var specTitle = "Co-Authors";
					if(type!="researcher"){
						specTitle = "Researchers"
					}
					visOptionsContainer.append(
									$('<div/>')
									.addClass('info-box box-home-explore bg-red')
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
									.append($('<h5/>').css("text-align","center").html("Researchers"))
									.css("border" , researcherBorderProp)
									.css({ "cursor":"pointer"})
									.on( "click", function( e){
										setBoxes(id, type, "researchers")
										refreshVisFilter(id, type,  "researchers");
									})
								)
				}
				
				if(type == "researcher" || type == "publication" || type == "conference" || type == "topic" || type == "circle"){
					visOptionsContainer.append(
									$('<div/>')
									.addClass('info-box box-home-explore bg-yellow')
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
									.append($('<h5/>').css("text-align","center").html("Conferences"))
									.css("border" , conferenceBorderProp)
									.css({ "cursor":"pointer"})
									.on( "click", function( e){
										setBoxes(id, type, "conferences")
										refreshVisFilter(id, type,  "conferences");
									})
								)
				}
				
				if(type == "researcher" || type == "publication" || type == "conference" || type == "topic" || type == "circle"){
					visOptionsContainer.append(
									$('<div/>')
									.addClass('info-box box-home-explore bg-green')
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
									.css("border" , publicationBorderProp)
									.css({ "cursor":"pointer"})
									.on( "click", function( e){
										setBoxes(id, type, "publications")
										refreshVisFilter(id, type,  "publications");
									})
								)
				}

				if(type == "researcher" || type == "publication" || type == "conference" || type == "topic" || type == "circle"){
					visOptionsContainer.append(
									$('<div/>')
									.addClass('info-box box-home-explore bg-blue')
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
									.append($('<h5/>').css("text-align","center").html("Topics"))
									.css("border" , topicBorderProp)
									.css({ "cursor":"pointer"})
									.on( "click", function( e){
										setBoxes(id, type, "topics")
										refreshVisFilter(id, type,  "topics");
									})
								)
				}
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