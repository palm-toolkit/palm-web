<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding whistory">
  	<div class="history-list">
    </div>
</div>

<script>
	$( function(){
		
		var targetDiv = document.getElementById("widget-explore_history").getElementsByClassName("box")[0];
		targetDiv.className += ' collapsed-box'
		var iElements = targetDiv.getElementsByTagName("i");
		for(var i=0;i<iElements.length;i++)
		{
			if(iElements[i].className == "fa fa-minus")
			iElements[i].className = "fa fa-plus"
			
		}
		
			<#-- add slim scroll -->
	      $(".history-list").slimscroll({
				height: "100%",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
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
			
			var targetContainer = $(".history-list" );
			
				targetContainer.html("");
				//localStorage.clear();
				
				var retrievedObject = localStorage.getItem('history_data');
				if(retrievedObject!=null)
				{
					var json = JSON.parse(retrievedObject);
					
					var keys = Object.keys(json).reverse();
					var sortedJson = new Object();
					for(var k=keys.length; k>0; k--){
						sortedJson[keys.length - k + 1] = json[k];
					}
					
					$.each( sortedJson, function( index, item){
						var historyDiv = 
						$( '<div/>' )
							.addClass( 'explore' )
							.attr({ 'id' : "" });
							
						var historyNav =
						$( '<div/>' )
							.addClass( 'nav' );
						
						var historyNamesList = $( '<div/>' )
						.addClass( 'name' )
						for(var v = 0; v < item.names.length; v++)
						{
							historyNamesList.append(
											$('<div/>')
											.append( 
													$( '<i/>' )
													.addClass( 'fa fa-angle-right icon font-xs' )
													.append('&nbsp;')
												)
											.append(
												$( '<span/>' )
													.html( item.names[v] )
											)	
										)	
						} 
									
							
						var historyDetail =
						$( '<div/>' )
							.addClass( 'detail' )
							.append(
								$('<div/>')
								.addClass( 'text-gray' )
								.html( item.time )	
							)	
							.append(
								historyNamesList
							);	
							
						historyDiv
							.append(
								historyNav
							).append(
								historyDetail
							);
						
						
						historyDiv
							.on("mouseover", blue);
						historyDiv
							.on("mouseout", black);
							
						<#-- add click event -->
						historyDiv
							.on( "click", function(){
									$( this ).parent().context.style.color="black";
									console.log(item.ids)
									var id = item.ids
									var type = item.type
									var replace = "true" 
									var queryString = "?id="+id+"&type="+type+"&replace="+replace;
									console.log(queryString)
									<#-- update search widget -->
									searchWidget = $.PALM.boxWidget.getByUniqueName( 'explore_search' );
									searchWidget.options.queryString = queryString;
									$.PALM.boxWidget.refresh( searchWidget.element , searchWidget.options );
							} );
							
						targetContainer
							.append( 
								historyDiv
							)
							.css({ "cursor":"pointer"});
						
					});
				}	
			}
		};	
		
		function blue(){
				$( this ).parent().context.style.color="blue";
		}
		
		function black(){
				$( this ).parent().context.style.color="black";
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
		
		<#--// first time on load, list 50 histories-->
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		
	});
	
</script>
