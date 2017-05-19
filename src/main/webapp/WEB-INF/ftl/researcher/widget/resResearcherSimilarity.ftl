<div id="boxbody-${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box similarity-criteria row">
			<div class="filter groupedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-5  col-sm-5"> Similarity Based On: </span>
  				<div class="dropdown col-md-6 col-sm-6">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Topics of Interest<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
    					<li data-value="topics" class="selected" ><a href="#">Topics of Interest</a></li>
    					<li data-value="venues"><a href="#">Venues</a></li>
    				</ul>
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

		  data1 = {"author":{"aff":{"institution":"Rheinisch Westfalische Technische Hochschule Aachen","country":"Germany"},"name":"Mohamed Amine Chatti","isAdded":true,"hindex":22,"id":"07397ed7-3deb-442f-a297-bdb5b476d3e6"},"countTotal":9,"count":9,"similarAuthors":[{"id":"40da1aa2-86d6-4df6-9d75-f59e51031675","name":"Hendrik Thus","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"http://lufgi9.informatik.rwth-aachen.de/dl997","isAdded":true,"similarity":"0.06287256986455675","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":1},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":1},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":1}]},{"id":"1cb70bc1-5b6a-47bb-903c-206014bba5c6","name":"roman brandt","isAdded":true,"similarity":"0.05026288091070903","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":0},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":0},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":0}]},{"id":"3fdca071-720a-44dd-bb1b-c2eee810f9ca","name":"xiao pu","isAdded":true,"similarity":"0.05723562256989808","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":0},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":0},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":0}]},{"id":"302add2e-862a-4ee7-946f-9fb22832001d","name":"Ahmed Mohamed Fahmy Yousef","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"https://scholar.google.com/citations?view_op=view_photo&user=We0GhPQAAAAJ&citpid=2","isAdded":true,"similarity":"0.0625641568833984","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":0},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":0},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":0}]},{"id":"0d21e6b1-9127-4b86-8333-d325aabe2a2c","name":"marold wosnitza","affiliation":"RWTH Aachen University","isAdded":true,"similarity":"0.06287641433203002","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":0},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":0},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":0}]},{"id":"fa08e021-ac6b-4e76-8bf5-00bd3734c3fc","name":"shima amin sharifi","isAdded":true,"similarity":"0.08421841890286998","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":1},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":1},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":1}]},{"id":"8e19fbd2-2068-42a9-b2f5-ae71c15b6e49","name":"Christoph Greven","affiliation":"Rheinisch Westfalische Technische Hochschule Aachen","photo":"http://lufgi9.informatik.rwth-aachen.de/dl1175","isAdded":true,"similarity":"0.08697765786319694","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":1},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":1},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":1}]},{"id":"c592a0d5-2e87-4ac2-b2d2-b8ca0ede54c6","name":"narek danoyan","isAdded":true,"similarity":"0.08859514188302908","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":1},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":1},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":1}]},{"id":"d8d387b2-440a-464e-bfaf-ae152f375827","name":"simona dakova","isAdded":true,"similarity":"0.0888334593379322","topicdetail":[{"name":"learning_analytics usage_data_formats recent_years higher_education learner_modeling case_study harness_educational_data_sets work_proce collaborative_filtering educational_data ","value":1},{"name":"learning_environments ubiquitous_learning_environments combines_latent_dirichlet research_areas learner_driven_knowledge_pull ber_immer learning_methodologies adaptive_web semantic_annotation personal_learning_environments ","value":1},{"name":"mobile_learning technology_enhanced_learning learning_process enhanced_learning personal_learning_environment collaborative_learning higher_education social_software learning_content primary_aim ","value":1}]}]};
		
	 	$.SIMILAR.create("${wUniqueName}", data1);
					
		$( ".similar-author" ).click( function( event ){
			
			$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"456px"}, $(this).attr("title") );
			
			var _thisData = d3.select(this).datum();
			if (_thisData.similarTopics != undefined && _thisData.similarTopics.length > 0){
				$.get( "<@spring.url '/researcher/papersByTopicAndAuthor' />?id=" + _thisData.id + "&topic=" + JSON.stringify(_thisData.similarTopics),
					function( response ){
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
			source : "<@spring.url '/researcher/similarAuthorListTopicLevel' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading similar researchers list", {uniqueId: uniquePidSimilarResearchers, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem , data ){
			console.log( data );
			
				var targetContainer = $( "#boxbody-${wUniqueName}" ).find( ".visualization-main" );
					targetContainer.html( "" );

				console.log( "similarity data" );
				console.log( data );
				<#--data.author.photo = "http://nlp.stanford.edu/manning/images/Christopher_Manning_027_132x132.jpg";-->
				
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
	     	"options": {}
		});
	} );
</script>