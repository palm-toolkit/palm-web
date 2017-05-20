<div id="boxbody-${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box similarity-criteria row">
			<div class="filter groupedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-5  col-sm-5"> Similarity Based On: </span>
  				<div class="dropdown col-md-6 col-sm-6">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Topics of Interest</button>	
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4 hidden"></div>
		</div>
	</div>
</div>

<script>
	$( function(){
		<#-- add slim scroll -->
    <#--   $("#boxbody-${wUniqueName} .box-content").slimscroll({
			height: "500px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
	 -->   
	    <#-- generate unique id for progress log -->
		var uniquePidSimilarResearchers = $.PALM.utility.generateUniqueId();	

	 <#--	  data1 = {"author":{"aff":{"institution":"Rheinisch Westfalische Technische Hochschule Aachen","country":"Germany"},"name":"Mohamed Amine Chatti","isAdded":true,"photo":"https://scholar.google.com/citations?view_op=view_photo&user=gyLI8FYAAAAJ&citpid=1","hindex":22,"id":"07397ed7-3deb-442f-a297-bdb5b476d3e6"},"countTotal":29,"count":29,"similarAuthors":[{"id":"40da1aa2-86d6-4df6-9d75-f59e51031675","name":"Hendrik Thus","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"http://lufgi9.informatik.rwth-aachen.de/dl997","status":"Computer Science","citedBy":885,"publicationsNumber":90,"hindex":4,"isAdded":true,"similarity":26.666666666666668,"topicdetail":[{"name":"learning analytics,knowledge management,usage data formats,usage data,knowledge overload,technology enhanced,laan theory,learning tools,learning tools,","value":""}]},{"id":"d461fd05-f5ea-4504-8bbb-6fa9084deaf4","name":"matthias jarke","citedBy":0,"publicationsNumber":18,"hindex":0,"isAdded":true,"similarity":43.333333333333336,"topicdetail":[{"name":"social software,knowledge management,personal learning,personal learning,technology enhanced professional learning,knowledge networking,learning model,personal learning environments,personal learning environments,technology enhanced,desired state,personal learning environment framework,personal learning environment framework,learning environment,mobile social software,mobilehost colearn system,","value":""}]},{"id":"d8d387b2-440a-464e-bfaf-ae152f375827","name":"simona dakova","citedBy":0,"publicationsNumber":2,"hindex":0,"isAdded":true,"similarity":20,"topicdetail":[{"name":"personal learning,personal learning,personal learning,personal learning,learning model,personal learning environments,personal learning environments,personal learning environments,knowledge overload,personal learning environment framework,personal learning environment framework,learning environment,learning environment,","value":""}]},{"id":"302add2e-862a-4ee7-946f-9fb22832001d","name":"Ahmed Mohamed Fahmy Yousef","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"https://scholar.google.com/citations?view_op=view_photo&user=We0GhPQAAAAJ&citpid=2","status":"Social Sciences","citedBy":745,"publicationsNumber":59,"hindex":7,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"learning analytics,","value":""}]},{"id":"d74383c3-c2bf-4575-af4d-06719d6e9e2c","name":"daniel dahl","citedBy":0,"publicationsNumber":2,"hindex":0,"isAdded":true,"similarity":6.666666666666667,"topicdetail":[{"name":"learning environment,automatic service invocation,automatic service invocation,","value":""}]},{"id":"0d21e6b1-9127-4b86-8333-d325aabe2a2c","name":"marold wosnitza","affiliation":"RWTH Aachen University","citedBy":482,"publicationsNumber":33,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"learning analytics,","value":""}]},{"id":"780e18e8-2c22-4a03-adb0-b9f1fa1daa8e","name":"marcus specht","affiliation":"Slovak University of Technology","photo":"https://photos.mendeley.com/e6/2b/e62b9ab2ae00bbaf6f75b97aad09514f3a02f9fd-standard.jpg","status":"Unspecified","citedBy":4599,"publicationsNumber":203,"hindex":16,"isAdded":true,"similarity":26.666666666666668,"topicdetail":[{"name":"social software,personal learning,personal learning,personal learning,personal learning,technology enhanced professional learning,learning model,personal learning environments,personal learning environments,personal learning environments,personal learning environments,personal learning environment framework,personal learning environment framework,learning environment,learning environment,learning environment,mobile social software,","value":""}]},{"id":"e7676fcf-2143-4109-a620-48aecde9978e","name":"zhaohui wang","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"3fdca071-720a-44dd-bb1b-c2eee810f9ca","name":"xiao pu","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"b83d71f9-d971-41d6-a714-5ff3ce119a69","name":"arnab chakrabarti","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"learning analytics,","value":""}]},{"id":"8e19fbd2-2068-42a9-b2f5-ae71c15b6e49","name":"Christoph Greven","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"http://lufgi9.informatik.rwth-aachen.de/dl1175","status":"Computer Science","citedBy":97,"publicationsNumber":51,"hindex":2,"isAdded":true,"similarity":33.33333333333333,"topicdetail":[{"name":"learning analytics,knowledge management,usage data formats,personal learning,personal learning,usage data,personal learning environments,personal learning environments,technology enhanced,laan theory,personal learning environment framework,personal learning environment framework,learning environment,","value":""}]},{"id":"8ef4eb1c-b1c3-4d68-98ad-4f0d4f89a09b","name":"darko dugoija","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"learning environment,","value":""}]},{"id":"821552ea-5b39-4969-a6d7-ff56fba42d70","name":"usman wahid","status":"Computer Science","citedBy":61,"publicationsNumber":15,"hindex":0,"isAdded":true,"similarity":13.333333333333334,"topicdetail":[{"name":"learning analytics,personal learning environments,personal learning environment framework,learning environment,","value":""}]},{"id":"52378999-47c5-47c6-9907-b6dc7d9a1c0e","name":"Ulrik Schroeder","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"https://scholar.google.com/citations?view_op=view_photo&user=8EYyC1MAAAAJ&citpid=1","status":"Professor","citedBy":3910,"publicationsNumber":469,"hindex":18,"isAdded":true,"similarity":6.666666666666667,"topicdetail":[{"name":"learning analytics,learning analytics,knowledge management,","value":""}]},{"id":"5382e7d1-3a05-4626-9c19-e58d4c007fb0","name":"harald jakobs","status":"Arts and Humanities","citedBy":183,"publicationsNumber":9,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"b17f7bec-4a00-4259-9da3-6b44f7dbe058","name":"mohammad ridwan agustiawan","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":13.333333333333334,"topicdetail":[{"name":"personal learning,personal learning,personal learning environments,personal learning environment framework,learning environment,learning environment,","value":""}]},{"id":"4a90ca2d-2e36-401b-8283-192f3706c01b","name":"dirk froschwilke","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":10,"topicdetail":[{"name":"social software,social software,social software,knowledge networking,mobile social software,","value":""}]},{"id":"1cb70bc1-5b6a-47bb-903c-206014bba5c6","name":"roman brandt","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":10,"topicdetail":[{"name":"personal learning environments,personal learning environment framework,learning environment,","value":""}]},{"id":"c592a0d5-2e87-4ac2-b2d2-b8ca0ede54c6","name":"narek danoyan","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"2ca1d87f-2c5e-4239-88f9-01dd87da05cd","name":"navid gooranourimi","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":13.333333333333334,"topicdetail":[{"name":"personal learning,personal learning environments,personal learning environment framework,learning environment,learning environment,","value":""}]},{"id":"4a632383-0521-4f52-b331-586818773444","name":"mostafa akbari","affiliation":"Luxembourg Institute of Science and Technology","photo":"https://scholar.google.com/citations?view_op=view_photo&user=XUp4uUEAAAAJ&citpid=1","status":"Environmental Science","citedBy":569,"publicationsNumber":62,"hindex":13,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"10b19f3e-1320-4d83-b150-2d370d2011a6","name":"anggraeni","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":6.666666666666667,"topicdetail":[{"name":"personal learning,knowledge overload,","value":""}]},{"id":"ff737f17-a9d3-47b5-82ad-4e5db0f8f19b","name":"malinka ivanova","citedBy":0,"publicationsNumber":2,"hindex":0,"isAdded":true,"similarity":13.333333333333334,"topicdetail":[{"name":"personal learning,personal learning,personal learning environments,personal learning environment framework,learning environment,learning environment,","value":""}]},{"id":"c1754c93-2092-4278-8674-c282543b59f8","name":"katherine maillet","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":6.666666666666667,"topicdetail":[{"name":"personal learning,knowledge overload,","value":""}]},{"id":"41264551-d078-4bde-aac6-ecb6e1f557c7","name":"gottfried vossen","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":10,"topicdetail":[{"name":"learning model,technology enhanced,learning environment,","value":""}]},{"id":"be0d3b1b-d832-4094-a458-a654777b65b5","name":"tim paehler","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":3.3333333333333335,"topicdetail":[{"name":"","value":""}]},{"id":"93e5672b-85d9-4167-859b-fc20315766ef","name":"Vlatko Lukarov","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"https://scholar.google.com/citations?view_op=view_photo&user=2IYFx1QAAAAJ&citpid=1","status":"Researcher","citedBy":168,"publicationsNumber":19,"hindex":3,"isAdded":true,"similarity":10,"topicdetail":[{"name":"learning analytics,learning analytics,learning analytics,learning analytics,usage data formats,usage data,usage data,usage data,usage data,","value":""}]},{"id":"fa08e021-ac6b-4e76-8bf5-00bd3734c3fc","name":"shima amin sharifi","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":13.333333333333334,"topicdetail":[{"name":"personal learning,personal learning environments,personal learning environment framework,learning environment,learning environment,","value":""}]},{"id":"f81a9e61-46b7-4e86-990e-aa1af59cc696","name":"theresia devi indriasari","citedBy":0,"publicationsNumber":1,"hindex":0,"isAdded":true,"similarity":10,"topicdetail":[{"name":"personal learning,personal learning environments,learning environment,","value":""}]}]};
	 	$.SIMILAR.create("${wUniqueName}", data1);
	-->				
		$( ".similar-author" ).click( function( event ){		
			$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
			
			var _thisData = d3.select(this).datum();
			if (_thisData.topicdetail != undefined && _thisData.topicdetail.length > 0){
				$.get( "<@spring.url '/researcher/papersByTopicAndAuthor' />?id=" + _thisData.id + "&topic=" + JSON.stringify(_thisData.topicdetail),
					function( response ){
					console.log("list papers on topics:");
					console.log( response );
						var data = response.topicPapers[0].papers;
						response.topicPapers.forEach(function(topic, i){
							var accordionBox = $( "#boxbody-${wUniqueName} #accordion" ).children("div")[i];
							if ( topic.papers!= null && topic.papers.length > 0 ) 
								$( accordionBox ).append($(addList(topic.papers))[0]);
							else
								$( accordionBox ).append($("<p/>").text("No paper available"));
						});		
						$("#boxbody-${wUniqueName} #accordion .content-list").slimscroll({
							height: "100%",
	        				size: "6px",
							allowPageScroll: true,
   							touchScrollStep: 50,
   							alwaysVisible: true,
   							railVisible: true   						
	    				});			
				}).done(function() {
    				$( "#boxbody-${wUniqueName} #accordion-container .loading-icon" ).remove();
  				});
			}							
	});
		<#-- source : "<@spring.url '/researcher/similarAuthorList' />", -->
	    <#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/similarAuthorListTopicLevelRevised' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading similar researchers list", {uniqueId: uniquePidSimilarResearchers, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem , data ){
				console.log("similar researchers");
				console.log( data );
			
				var targetContainer = $( "#boxbody-${wUniqueName}" ).find( ".visualization-main" );
					targetContainer.html( "" );
				if( data.count == 0 ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Similar Researchers!", "Researcher does not have any similar researchers on PALM (insufficient data)" );
					return false;
				}							
				if( data.count > 0 ){ 
					<#-- remove any remaing tooltip -->
					$( "body .tooltip" ).remove(); 
					 $.SIMILAR.create("${wUniqueName}", data);
				} 

				$.PALM.popUpMessage.remove( uniquePidSimilarResearchers );
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
	} );
</script>