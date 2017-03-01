<div id="boxbody-${wUniqueName}" class="box-body no-padding">
  	<div class="coauthor-list">
    </div>
    
    <div id="chart" style="width:1000px;height:400px">
    <svg>
    </svg>
    </div>
</div>

<script>
	$ ( function() {
		  var t1 = [],
		      t2 = [],
		      t3 = [],
		      t4 = [],
		      t5 = [];
		 
		    t1.push({x: 2005, y: 0.459});
		    t1.push({x: 2006, y: 0.15613383054733276});
		    t1.push({x: 2007, y: 0.17970401048660278});
		    t1.push({x: 2008, y: 0.0984455943107605});
		    t1.push({x: 2009, y: 0.06666667014360428});
		    t1.push({x: 2010, y: 0.10569106042385101});
		    t1.push({x: 2011, y: 0.05528846010565758});
		    t1.push({x: 2012, y: 0.13787639141082764});
		    t1.push({x: 2013, y: 0.35483869910240173});
		    t1.push({x: 2014, y: 0.15052509307861328});
		    t1.push({x: 2015, y: 0.15052509307861328});
		    
		    t2.push({x: 2005, y: 0.16091954708099365});
		    t2.push({x: 2006, y: 0.048327136784791946});
		    t2.push({x: 2007, y: 0.05919661745429039});
		    t2.push({x: 2008, y: 0.07253886014223099});
		    t2.push({x: 2009, y: 0.04814814776182175});
		    t2.push({x: 2010, y: 0.06707317382097244});
		    t2.push({x: 2011, y: 0.08653846383094788});
		    t2.push({x: 2012, y: 0.16640253365039825});
		    t2.push({x: 2013, y: 0.17419354617595673});
		    t2.push({x: 2014, y: 0.5624270439147949});
		    t2.push({x: 2015, y: 0.47983309626579285});
            
		    t3.push({x: 2005, y: 0.14942528307437897});
		    t3.push({x: 2006, y: 0.15613383054733276});
		    t3.push({x: 2007, y: 0.49894291162490845});
		    t3.push({x: 2008, y: 0.32642486691474915});
		    t3.push({x: 2009, y: 0.15925925970077515});
		    t3.push({x: 2010, y: 0.22560974955558777});
		    t3.push({x: 2011, y: 0.07211538404226303});
		    t3.push({x: 2012, y: 0.21711568534374237});
		    t3.push({x: 2013, y: 0.12903225421905518});
		    t3.push({x: 2014, y: 0.1855309158563614});
		    t3.push({x: 2015, y: 0.14325451850891113});
		     
		    t4.push({x: 2005, y: 0.1149425283074379 });
		    t4.push({x: 2006, y: 0.460966557264328});
		    t4.push({x: 2007, y: 0.15433403849601746});
		    t4.push({x: 2008, y: 0.1347150206565857});
		    t4.push({x: 2009, y: 0.42222222685813904});
		    t4.push({x: 2010, y: 0.396341472864151});
		    t4.push({x: 2011, y: 0.3197115361690521});
		    t4.push({x: 2012, y: 0.3645007908344269});
		    t4.push({x: 2013, y: 0.22580644488334656});
		    t4.push({x: 2014, y: 0.08984830975532532});
		    t4.push({x: 2015, y: 0.19749651849269867});
		    
		    t5.push({x: 2005, y: 0.1149425283074379});
		    t5.push({x: 2006, y: 0.17843866348266602});
		    t5.push({x: 2007, y: 0.10782241076231003});
		    t5.push({x: 2008, y: 0.3678756356239319});
		    t5.push({x: 2009, y: 0.3037036955356598});
		    t5.push({x: 2010, y: 0.20528455078601837});
		    t5.push({x: 2011, y: 0.4663461446762085});
		    t5.push({x: 2012, y: 0.11410459876060486});
		    t5.push({x: 2013, y: 0.11612903326749802});
		    t5.push({x: 2014, y: 0.011668611317873001});
		    t5.push({x: 2015, y: 0.02920723147690296});
		    
		  var data =  [
		    {
		      values: t1,
		      key: 'technology learner provide based enhanced ',
		      color: '#ff7f0e'
		    },
		    {
		      values: t2,
		      key: 'moocs tel support learners context ',
		      color: '#77ff33'
		    },
		    {
		      values: t3,
		      key: 'learning social web la km',
		      color: '#8800cc'
		    },
		    {
		      values: t4,
		      key: 'learning knowledge paper personal mobile ',
		      color: '#0080c1'
		    },
		    {
		      values: t5,
		      key: 'driven ple explore framework community',
		      color: '#00f892'
		    },
		  ];

		nv.addGraph(function() {
		  var chart = nv.models.lineChart()
		    .useInteractiveGuideline(true)
		    ;
		
		  chart.xAxis
		    .axisLabel('Years')
		    .tickFormat(d3.format(',r'))
		    ;
		
		  chart.yAxis
		    .axisLabel('Topic Evolution')
		    .tickFormat(d3.format('.02f'))
		    ;
		
		  d3.select('#chart svg')
		    .datum(data)
		    .transition().duration(500)
		    .call(chart)
		    ;
		
		  nv.utils.windowResize(chart.update);
		
		  return chart;
		});
});
</script>