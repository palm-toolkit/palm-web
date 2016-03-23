<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="chart2" style="width:1200px;height:450px">
    <svg>
    </svg>
    </div>
</div>

<script>
	$( function(){
	   var data =  [
      {
        "label": "learning_analytics enhanced_learning personal_learning_environment higher_education learning_process knowledge_management",
        "value" : 0.6851063966751099
      } ,
      {
        "label": "social_software learning_content learner_models ubiquitous_technologies cultural_heritage_management rapid_development social_software_applications increasing_focus collaborative_learning ",
        "value" : 0.15329280495643616
      } ,
      {
        "label": "learning_suggests learning_analytics_toolkit recommend_learning_entities learning_sequence learning_mashups",
        "value" : 0.04883485287427902
      } ,
      {
        "label": "long_learning desired_state technology_enhanced_professional_learning professional_learning knowledge_society workplace_learning gap_analysis",
        "value" : 0.03485308960080147
      } ,
      {
        "label": "organizational_knowledge_management social_software professional_learning learning_management_strategies prolearn_network observed_interaction_processes seci_process_framework",
        "value" : 0.024012157693505287
      } ,
      {
        "label": "mobile_learning driven_freeform online_content paper_notes central_topic research_opportunities deliver_significant_benefits",
        "value" : 0.02097264491021633
      } ,
      {
        "label": "computer_science middleware_environment_developed isis_platform processes_sensor_data_streams retrieved_information relevance_feedback_tools information_visualization visual_searching",
        "value" : 0.017831813544034958
      } ,
      {
        "label": "learning_scenarios domain_knowledge automatic_assessment learning_tools learning_systematically training_wheels_interfaces technology_expertise",
        "value" : 0.010638297535479069
      } ,
      {
        "label": "knowledge_work key_challenge increase_business_performance competency_development organization_intended oriented_learning learning_management",
        "value" : 0.003748733550310135
      } ,
      {
        "label": "digital_libraries strategic_support digital_libraries_assesses dl_evaluation logging_schema comparative_digital_library_evaluation shared_information experimental_framework heterogeneous_digital_libraries",
        "value" : 0.000679027079977095 
      } ,
      {
        "label": "information_retrieval enhanced_information_retrieval network_analysis enhance_retrieval_processes bibliometric_techniques social_networking_sites statistical_modelling",
        "value" : 0.0001131712042493746 
      } ,
];
		nv.addGraph(function() {
  		var chart2 = nv.models.pieChart()
	      .x(function(d) { return d.label })
	      .y(function(d) { return d.value })
	      .showLabels(true)     //Display pie labels
	      .labelThreshold(.05)  //Configure the minimum slice size for labels to show up
	      .labelType("percent") //Configure what type of data to show in the label. Can be "key", "value" or "percent"
	      .donut(true)          //Turn on Donut mode. Makes pie chart look tasty!
	      .donutRatio(0.35)     //Configure how big you want the donut hole size to be.
	      .showLegend(true)
	     //	 .tooltipContent()
	      ;
		    d3.select("#chart2 svg")
		        .datum(data)
		        .transition().duration(350)
		        .call(chart2);
  		return chart2; 
  		});
  		
  		
	});
	
</script>