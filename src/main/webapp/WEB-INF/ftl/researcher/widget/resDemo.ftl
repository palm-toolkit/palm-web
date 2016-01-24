<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="chart" style="width:400px;height:100%">
    <svg>
    </svg>
    </div>
</div>

<script>
	$( function(){
	   var data =  [
      {
        "label": "One",
        "value" : 29.765957771107
      } ,
      {
        "label": "Two",
        "value" : 0
      } ,
      {
        "label": "Three",
        "value" : 32.807804682612
      } ,
      {
        "label": "Four",
        "value" : 196.45946739256
      } ,
      {
        "label": "Five",
        "value" : 0.19434030906893
      } ,
      {
        "label": "Six",
        "value" : 98.079782601442
      } ,
      {
        "label": "Seven",
        "value" : 13.925743130903
      } ,
      {
        "label": "Eight",
        "value" : 5.1387322875705
      }
];
	   
	   
	   
		nv.addGraph(function() {
		  var chart = nv.models.pieChart()
		      .x(function(d) { return d.label })
		      .y(function(d) { return d.value })
		      .showLabels(true);
		
		    d3.select("#chart svg")
		        .datum(data)
		      .transition().duration(1200)
		        .call(chart);
		
		  return chart;
		});
		
	});
</script>