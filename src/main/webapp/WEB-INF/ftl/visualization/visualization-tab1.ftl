<style>

.node {
  cursor: pointer;
  stroke: #3182bd;
  stroke-width: 1.5px;
}

.link {
  fill: none;
  stroke: #9ecae1;
  stroke-width: 1.5px;
}

</style>
<form id="form-visualization-tab1" action="<@spring.url '/visualization/tab1' />" style="padding-left: 25px" class="MISSY_round_right" >	
	
	<div id="layout" style="width:100%;height:500px;background-color:white;">
	<div>
	<#-- Import button -->
  	<input 
	  type="button" 
	  name="detail-button" 
	  id="detail-button" 
	  value="Get Details" 
	  class="buttonSubmit MISSY_loginSubmit" 
	  style="float: right; margin-top: 10px">
	<hr>
	
</form>
<script>
	$(function() {
		
	});	

	var width = 870,
	    height = 500,
	    root;
	
	var force = d3.layout.force()
	    .size([width, height])
	    .on("tick", tick);
	
	var svg = d3.select("#layout").append("svg")
	    .attr("width", width)
	    .attr("height", height);
	
	var link = svg.selectAll(".link"),
	    node = svg.selectAll(".node");
	
	d3.json("<@spring.url '/resources/json/readme.json' />", function(json) {
	  root = json;
	  update();
	});
	
	function update() {
	  var nodes = flatten(root),
	      links = d3.layout.tree().links(nodes);
	
	  // Restart the force layout.
	  force
	      .nodes(nodes)
	      .links(links)
	      .start();
	
	  // Update the links…
	  link = link.data(links, function(d) { return d.target.id; });
	
	  // Exit any old links.
	  link.exit().remove();
	
	  // Enter any new links.
	  link.enter().insert("line", ".node")
	      .attr("class", "link")
	      .attr("x1", function(d) { return d.source.x; })
	      .attr("y1", function(d) { return d.source.y; })
	      .attr("x2", function(d) { return d.target.x; })
	      .attr("y2", function(d) { return d.target.y; });
	
	  // Update the nodes…
	  node = node.data(nodes, function(d) { return d.id; }).style("fill", color);
	
	  // Exit any old nodes.
	  node.exit().remove();
	
	  // Enter any new nodes.
	  node.enter().append("circle")
	      .attr("class", "node")
	      .attr("cx", function(d) { return d.x; })
	      .attr("cy", function(d) { return d.y; })
	      .attr("r", function(d) { return Math.sqrt(d.size) / 10 || 4.5; })
	      .style("fill", color)
	      .on("click", click)
	      .call(force.drag);
	}
	
	function tick() {
	  link.attr("x1", function(d) { return d.source.x; })
	      .attr("y1", function(d) { return d.source.y; })
	      .attr("x2", function(d) { return d.target.x; })
	      .attr("y2", function(d) { return d.target.y; });
	
	  node.attr("cx", function(d) { return d.x; })
	      .attr("cy", function(d) { return d.y; });
	}
	
	// Color leaf nodes orange, and packages white or blue.
	function color(d) {
	  return d._children ? "#3182bd" : d.children ? "#c6dbef" : "#fd8d3c";
	}
	
	// Toggle children on click.
	function click(d) {
	  if (!d3.event.defaultPrevented) {
	    if (d.children) {
	      d._children = d.children;
	      d.children = null;
	    } else {
	      d.children = d._children;
	      d._children = null;
	    }
	    update();
	  }
	}
	
	// Returns a list of all nodes under the root.
	function flatten(root) {
	  var nodes = [], i = 0;
	
	  function recurse(node) {
	    if (node.children) node.children.forEach(recurse);
	    if (!node.id) node.id = ++i;
	    nodes.push(node);
	  }
	
	  recurse(root);
	  return nodes;
	}
	
</script>
