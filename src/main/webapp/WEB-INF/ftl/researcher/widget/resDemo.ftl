<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="chart" style="width:650px;height:500px">
    <svg>
    </svg>
    </div>
</div>

<script>
	$( function(){
	   var data =  [
      {
        "label": "learning moocs paper personal learners tel knowledge la based support",
        "value" : 0.6851063966751099
      } ,
      {
        "label": "social learning mobile knowledge web model concepts learner present generic",
        "value" : 0.15329280495643616
      } ,
      {
        "label": "driven web primary order plem plef leverage mashup pull user",
        "value" : 0.04883485287427902
      } ,
      {
        "label": "social technology learning knowledge desired life prolearn paper requirements identified",
        "value" : 0.03485308960080147
      } ,
      {
        "label": "organizational seci professional workplace long results organizations research examples prolearn",
        "value" : 0.024012157693505287
      } ,
      {
        "label": "context mobile research content paper enable driven provide usage year",
        "value" : 0.02097264491021633
      } ,
      {
        "label": "computer die der game results developed prototype mint study field",
        "value" : 0.017831813544034958
      } ,
      {
        "label": "user die students software order mobile individual supported computer technology",
        "value" : 0.010638297535479069
      } ,
      {
        "label": "knowledge business companies concept human key challenge term oriented roles",
        "value" : 0.003748733550310135
      } ,
      {
        "label": "information digital user logging paper evaluation daffodil based users supporting",
        "value" : 0.000679027079977095 
      } ,
      {
        "label": "information workshop bibliometric enhanced science social digital ir paper citizens",
        "value" : 0.0001131712042493746 
      } ,
];
		nv.addGraph(function() {
  		var chart = nv.models.pieChart()
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
		    d3.select("#chart svg")
		        .datum(data)
		        .transition().duration(350)
		        .call(chart);
  		return chart; 
  		});
  		
  		
	});
	
</script>