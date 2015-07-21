<div id="boxbody${wId}" class="box-body">
	researcher interest cloud
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId}").slimscroll({
			height: "250px",
	        size: "3px"
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/interest' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
							var targetContainer = $( widgetElem ).find( "#boxbody${wId}" );
							// remove previous list
							targetContainer.append( data.id + " - " + data.name + "<br/>" );
							
						}
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>

<script>
var fill = d3.scale.category20();
var words = [{"text":"This", "url":"http://google.com/"},
             {"text":"is", "url":"http://bing.com/"},
             {"text":"some", "url":"http://somewhere.com/"},
             {"text":"random", "url":"http://random.org/"},
             {"text":"text", "url":"http://text.com/"}]
var width = 800;
var height = 300;
for (var i = 0; i < words.length; i++) {
 words[i].size = 10 + Math.random() * 90;
}

d3.layout.cloud()
  .size([width, height])
  .words(words)
  .padding(5)
  .rotate(function() { return 0; })
  .font("Impact")
  .fontSize(function(d) { return d.size;})
  .on("end", draw)
  .start();

function draw(words) {
    d3.select("#widget-${wId} .box-body")
      .append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate("+ width/2 +","+ height/2 +")")
      .selectAll("text")
      .data(words)
      .enter()
      .append("text")
      .style("font-size", function(d) { return d.size + "px"; })
      .style("font-family", "Impact")
      .style("fill", function(d, i) { return fill(i); })
      .attr("text-anchor", "middle")
      .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")"; 
      })
      .text(function(d) { return d.text; })
      .on("click", function (d, i){
          window.open(d.url, "_blank");
      });
}
</script>