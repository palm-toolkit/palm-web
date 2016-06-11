<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_topics" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_bubble">
				<a href="#tab_bubble" data-toggle="tab" aria-expanded="true">
					Bubbles
				</a>
			</li>
			<li id="header_evolution">
				<a href="#tab_evolution" data-toggle="tab" aria-expanded="true">
					Evolution
				</a>
			</li>
			<li id="header_topic_list" active>
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
			<div id="tab_bubble" class="tab-pane" active>
			</div>
			<div id="tab_evolution" class="tab-pane">
			</div>
			<div id="tab_topic_list" class="tab-pane">
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
			height: "40vh",
	        size: "5px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });


		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();



		var options ={
			source : "<@spring.url '/explore/topic' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading topics/interests...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){
			<#-- switch tab -->
			$('a[href="#tab_bubble"]').tab('show');
				
				<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );
				
				
				var tabContainer = $( widgetElem ).find( "#boxbody-${wUniqueName}" ).find( ".nav-tabs-custom" );
				
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


			<#-- build the topic list -->
								$.each( data.topics, function( index, item){
								
								var topicExtractor = $( '<div/>' )
										.append(
											$( '<div/>' )
												.html( item.extractor)
										);
								
								tabContentTopicList
										.append( 
											topicExtractor
										);
								for (i = 0, len = item.termvalues.length, text = ""; i < len; i++) {
									topicNames =
									$( '<div/>' )
										.append(
											$( '<div/>' )
												.html( item.termvalues[i].term )
										);
										
									tabContentTopicList
										.append( 
											topicNames
										);
								}
								});
								
								
				visualizeBubbles(data.topics, tabContainer);								
								
			}
		};
		
		
		function visualizeBubbles(data,tabContainer){
		
			var margin = {top: -5, right: -5, bottom: -5, left: -5};
			
			var color = d3.scale.category20();
			var width = tabContainer.width()* 2;
			var height = width/1.5;
		
			var bubble = d3.layout.pack()
		    .size([width, height])
		    .padding(1.5);
		
			<#--var svg = d3.select("#tab_bubble" )
		      .append("svg")
		      .classed("svg-container", true) //container class to make it responsive-->
		
			var zoom = d3.behavior.zoom()
						.scaleExtent([1, 10])
						.on("zoom", zoomed);
						
			vis = d3.select("#tab_bubble")
					  .append("div")
				      .classed("svg-container", true)
				      .call(zoom) //container class to make it responsive
					  .append("svg:svg")
				   	  .attr("preserveAspectRatio", "xMinYMin meet")
				      .attr("viewBox", "0 0 " + width + " " + height)
				      .classed("svg-content-responsive", true)
				      .classed( "bubble-chart", true);
			
			
				     
			var rect = vis.append("rect")
						    .attr("width", width)
						    .attr("height", height)
						    .style("fill", "none")
						    .style("pointer-events", "all");
		
			var node = vis.selectAll(".node")
		      			.data(bubble.nodes(topics(data))
		      			.filter(function(d) { return !d.children; }))
		    			.enter().append("g")
		      			.attr("class", "node")
		      			.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

			 node.append("title")
		      	  	.text(function(d) { return d.className + ": " + d.packageName; });
		
		  	 node.append("circle")
			      	.attr("r", function(d) { return d.r; })
			        .style("fill", function(d) { return color(d.value); });
		
		  	 node.append("text")
				      .attr("dy", ".3em")
				      .style("text-anchor", "middle")
				      .text(function(d) { return d.className.substring(0, d.r / 4); })
		      		  .style( "cursor", "default" )
		      		  .attr("class", "value")
      		  
		}
	
	function topics(data) {
			var topiccs = [];
		
			for(var i=0; i<data.length; i++) {
				console.log(data[i].extractor);
				for(var j=0; j<data[i].termvalues.length;j++) {
					topiccs.push({packageName: data[i].extractor, className: data[i].termvalues[j].term, value: data[i].termvalues[j].value});
				}
		
			}
		
			console.log(topiccs);
			return {children: topiccs};
	}
		
	function zoomed() {
	  	vis.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
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