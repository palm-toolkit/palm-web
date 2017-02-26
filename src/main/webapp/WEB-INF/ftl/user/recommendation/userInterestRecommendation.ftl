<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="background-color:#f2f2f2;">
	<div class="general-box-filter">
		
		<div class="panel panel-primary">
		      	<div class="panel-heading" style="text-align: center; padding: 5px 5px;" onclick="toggleSearch()">
		      		<i class="fa fa-search"></i>
					<span>Recommendation Parameters</span>
				</div>
		      	<div class="panel-body" id="search_body">
					<div class="dropdown">
						<div style="margin:5px 0px 0 0;">
							<span>Search:</span>
						</div>
						<div class="input-group" style="width: 100%;">
							<div class="general-box-search-option input-group-btn"></div>
							<span style="margin-left: 10px;">Max results: </span>
							<input type="number" id="maxResults" name="maxResults" min="5" max="100" step="5" value="10" style="margin-right: 10px;">
							<input type="text" id="searchItem" name="searchItem" class="form-control input-sm pull-left" style="width: initial;"
							 placeholder="Search Interest item" value="<#if targetName??>${targetName!''}</#if>"/>
							<button class="btn btn-sm btn-default" onclick="generateSearchItems()"><i class="fa fa-search"></i></button>
							<div id="searchSpinner" class="fa fa-refresh fa-spin" style="margin-left: 8px; display: none;"></div>
						</div>
						<div id="searchedItems" class="dropdown-content" ></div>
					</div>
		      		<div class="general-box-filter-option" style="margin: 15px 10px 10px;"></div>
				</div>
		</div>
	</div>
	<div class="panel panel-primary">
		<div class="panel-heading" style="text-align: center; padding: 5px 5px;" onclick="toggleSteps()">
			<span>Recommendation Steps</span>
		</div>
		<div class="panel-body" id="graph_recommender" style="margin: 8px; padding: 0px; display: none;">
			<div class="line"></div>
			<div class="line" style="left:14.5%"></div>
			<div class="line" style="left:34%"></div>
			<div class="line" style="left:66%"></div>
			<div class="line" style="left:82%"></div>
			
			<div width="100%" style="height: 35px; background-color: #fff; border-bottom-style: ridge;">
				<span style="font-family: 'Times New Roman'; color: #8f8e8e; text-align: center; font-size: 25px; width: 49.8%; display:inline-block; height: 100%;">Why is this recommended?</span>
				<span style="font-family: 'Times New Roman'; color: #8f8e8e; text-align: center; font-size: 25px; width: 49.5%; display:inline-block; border-left-style: dashed; height: 100%;">What is recommended?</span>
			</div>
			<div>
				<span style=" position: absolute; text-align: center; text-transform: uppercase; color: #8f8e8e; font-family: 'Times New Roman'; font-weight: bolder;">Steps:</span>
			    <div class="container">
			      	<ul class="progressbar" id="interest_progress">
			  		</ul>
			  	</div>
		  	</div>
		  	<div>
			  	<div id="legendGraph" style="border-top-style: dashed; border-top-width: 2px; border-top-color: #aaaaaa;">
				<span style=" position: absolute; text-align: center; text-transform: uppercase; color: #8f8e8e; margin-top: 10px; font-family: 'Times New Roman'; font-weight: bolder;">Legend:</span>
			  	</div>
		  	</div>
		  	<div id="singleTreeTab" class="singleTree-box-filter" width="100%" style="height: 300px; background-color: #fff; border-top-style: dashed; border-top-width: 2px; border-top-color: #aaaaaa;">
				<span width="100%" style="opacity: 0.75; text-align: center; font-size: 24px; background-color: white;">Show recommendation details of a selected node.</br>No item selected.</span>
			</div>
  		</div>
  	</div>
	<div class="panel panel-primary">
		      	<div class="panel-heading" style="text-align: center; padding: 5px 5px;" onclick="$( this ).next().slideToggle( 'slow' )">
		      		
					<span>Recommendations</span>
				</div>
		      	<div class="panel-body" id="recommendation_body" style="margin: 5px 5px;">
	<table width="100%" border="0">
		<tr valign="top">
			<td id="filter_tab" width="15%" style="display: none; background-color: #fafafa;
			 border-bottom: 1px solid #b3b3b3;  border-top: 1px solid #b3b3b3;  border-right: 1px solid #b3b3b3;">
				<div style="float: left;  
				padding: 8px; overflow-x: block;">
							<div class="general-box-filter">
								<div class="input-group" style="width: 100%;">
							      <input type="text" id="filterItem" name="filterItem" class="form-control input-sm pull-right" autocomplete="on" placeholder="Filter item" value="">
							      <div id="filter_item_button" class="input-group-btn">
							        <button class="btn btn-sm btn-default" onclick="filterQuery()"><i class="fa fa-search"></i></button>
							      </div>
							    </div>
								<div style="margin:15px 15px 0px 0px;">
									<span id="node_range_title">Publication:</span>
									<div style="margin: 0px 10px 0px 0px;">
								  		<input id="nodes_range" type="range"
								  		oninput="changeRange(this.value)" onchange="changeRange(this.value)">
								  		<output id="range_output">10</output>
								  	</div>
								
								</div>
								</div>
							</div>
				</div>
			</td>
			<td style="background-color:#fff;">
				<button id="zoomInBtn"
					style="margin-left: 8px; margin-top: 8px; z-index: 1; background-color: transparent; border-color: transparent; position: absolute;">
						<i class="large material-icons" id="zoomInBtnIcn" style="font-size: 30px;">zoom_in</i>
				</button>
				
				<button id="zoomOutBtn"
				style="margin-left: 8px; margin-top: 48px; z-index: 1; background-color: transparent; border-color: transparent; position: absolute;">
						<i class="large material-icons" id="zoomOutBtnIcn" style="font-size: 30px;">zoom_out</i>
				</button>
				
				<button   
					class="btn btn-block btn-default bo
					x-filter-button btn-xs sliderBtn" id="filterBtn"
					onclick="toggleFilterTab()">
					<div>
						<span class="textHidden">Filter's</span>
						<i class="large material-icons" id="filterBtnIcn" id="filterBtnIcn" style="font-size: 60px; color: #3366ff">chevron_right</i>
					</div>
				</button>
			  	<div class="general-content-graph" style="height:800px !important; background-color:#fff;">
			    </div>
			    <button type="button" id="detailBtn" onclick="toggleDetailsTab()"  
				class="btn btn-block btn-default box-filter-button btn-xs sliderBtn"
				style="width:50px; float: right; margin-top: -40%; position: relative; background-color: transparent; border-color: transparent;">
					<div>
						<i class="large material-icons" id="detailBtnIcn" style="font-size: 60px; color: #3366ff">chevron_left</i>
						<span class="textHidden" style="float: right;">Detail's</span>
					</div>
				</button>
			</td>
			<td id="node_tab" width="20%" style="display: none; background-color: #fafafa;">
				<div id="node_details" class="Scrollable" style="float: right; width: 450px; max-height: 800px; 
				padding: 15px; border-bottom: 1px solid #b3b3b3;  border-top: 1px solid #b3b3b3;  border-left: 1px solid #b3b3b3;">	
				</div>
			</td>
    	</tr>
    </table>
				</div>
		</div>
	<div id="msg_content">
	</div>
</div>

<style>

.sliderBtn {
	width: 50px; 
	float: left; 
	margin-top: 27%; 
	position: absolute; 
	z-index: 1; 
	background-color: transparent; 
	border-color: transparent;
}

.textHidden {
	display: none;
    float: left;
    vertical-align: middle;
    text-align: center;
    font-size: 19px;
    margin-top: 16px;
}

.sliderBtn:hover .textHidden {
	display: table-cell;
}

.sliderBtn:focus {
	background-color: transparent;
}

.line {
	position: absolute;
    border-left-style: ridge;
    width: 5px;
    height: 25.5vh;
    top: 157px;
    left: 50%;
    border-left-color: #aaaaaa;
    border-left-width: 2px;
    -webkit-transition: all 0.85s;
    transition: all 0.85s;
}
.container {
	width: 100%;
	height: 65px;
    margin: 12px auto 0px; 
}
.progressbar {
  margin: 0;
  padding: 0;
  counter-reset: step;
}
.progressbar li {
  list-style-type: none;
  width: 16.5%;
  float: left;
  font-size: 12px;
  position: relative;
  text-align: center;
  text-transform: uppercase;
  color: #7d7d7d;
}
.progressbar li:before {
  width: 30px;
  height: 30px;
  content: counter(step);
  counter-increment: step;
  line-height: 30px;
  border: 2px solid #7d7d7d;
  display: block;
  text-align: center;
  margin: 0 auto 10px auto;
  border-radius: 50%;
  background-color: white;
}
.progressbar li:after {
  width: 100%;
  height: 2px;
  content: '';
  position: absolute;
  background-color: #7d7d7d;
  top: 15px;
  left: -50%;
  z-index: -1;
}
.progressbar li:first-child:after {
  content: none;
}
.progressbar li.active {
  color: steelblue;
}
.progressbar li.active:before {
  border-color: steelblue;
}
.progressbar li.active + li:after {
  background-color: steelblue;
}
.progressbar li.selected:before {
  background-color: steelblue;
  color: white;
}
.d3-tip {
  line-height: 1;
  font-weight: bold;
  padding: 12px;
  background: rgba(0, 0, 0, 0.8);
  color: #fff;
  border-radius: 2px;
  -webkit-transition: opacity 0.3s; /* For Safari 3.1 to 6.0 */
  transition: opacity 0.3s;   
}

/* Creates a small triangle extender for the tooltip */
.d3-tip:after {
  box-sizing: border-box;
  display: inline;
  font-size: 10px;
  width: 100%;
  line-height: 1;
  color: rgba(0, 0, 0, 0.8);
  content: "\25BC";
  position: absolute;
  text-align: center;
}

/* Style northward tooltips differently */
.d3-tip.n:after {
  margin: -1px 0 0 0;
  top: 100%;
  left: 0;
}

.progress-box {
	width: 100%;
	margin: 20px 0;
}

.progress-box .percentage-cur .num {
	margin-right: 5px;
}

.progress-box .progress-bar {
	width: 100%;
	height: 12px;
	background: #f2f1f1;
	margin-bottom: 3px;
	border: 1px solid #dfdfdf;
	box-shadow: 0 0 2px #D5D4D4 inset;
  position: relative;
}

.progress-box .progress-bar .inner {
  position: relative;
	width: 0;
	height:100%;
	background: #239bd6; 
}

.progress-bar .inner {
	height: 0;
	width: 0;
	transition: all 1s ease-out;
}

.progress-bar-slider .inner {
  transition: none;
}

.progress-bar-slider .inner:after {
  content: " ";
  width: 5px;
  height: 14px;;
  background-color:#ccc;
  position: absolute;
  right: -2px;
  top: -2px;
  border: 1px solid #bbb;
  border-radius: 2px;
  box-shadow: 0px 0px 2px rgba(0,0,0,0.3);
  margin: 0px;
}

.progress-slider {
  opacity: 0;
  width: 100%;
  height: 15px;
  position: absolute;
  top: 0px;
  left: 0px;
  cursor: pointer;
  z-index: 1;
}

/* Dropdown choices */
.dropbtn {
    background-color: #4CAF50;
    color: white;
    padding: 16px;
    font-size: 16px;
    border: none;
    cursor: pointer;
}

.dropbtn:hover, .dropbtn:focus {
    background-color: #3e8e41;
}

.dropdown {
    position: relative;
    display: inline-block;
}

.dropdown-content {
    position: absolute;
    background-color: #f6f6f6;
    min-width: 230px;
    max-height: 150px;
    overflow-y: scroll;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
}

.dropdown-content a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
}

.dropdown a:hover {
	background-color: #ddd;
}

.show {
	display:block;
}

/* spinner css */
.loader {
  border: 16px solid #ccc;
  border-radius: 50%;
  border-top: 16px solid #3498db;
  width: 120px;
  height: 120px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

</style>
<script>

	(function() {
  d3.layout.grid = function() {
    var mode = "equal",
        layout = _distributeEqually,
        x = d3.scale.ordinal(),
        y = d3.scale.ordinal(),
        size = [1, 1],
        actualSize = [0, 0],
        nodeSize = false,
        bands = false,
        padding = [0, 0],
        cols, rows;

    function grid(nodes) {
      return layout(nodes);
    }

    function _distributeEqually(nodes) {
      var i = -1, 
          n = nodes.length,
          _cols = cols ? cols : 0,
          _rows = rows ? rows : 0,
          col, row;

      if (_rows && !_cols) {
        _cols = Math.ceil(n / _rows)
      } else {
        _cols || (_cols = Math.ceil(Math.sqrt(n)));
        _rows || (_rows = Math.ceil(n / _cols));
      }

      if (nodeSize) {
        x.domain(d3.range(_cols)).range(d3.range(0, (size[0] + padding[0]) * _cols, size[0] + padding[0]));
        y.domain(d3.range(_rows)).range(d3.range(0, (size[1] + padding[1]) * _rows, size[1] + padding[1]));
        actualSize[0] = bands ? x(_cols - 1) + size[0] : x(_cols - 1);
        actualSize[1] = bands ? y(_rows - 1) + size[1] : y(_rows - 1);
      } else if (bands) {
        x.domain(d3.range(_cols)).rangeBands([0, size[0]], padding[0], 0);
        y.domain(d3.range(_rows)).rangeBands([0, size[1]], padding[1], 0);
        actualSize[0] = x.rangeBand();
        actualSize[1] = y.rangeBand();
      } else {
        x.domain(d3.range(_cols)).rangePoints([0, size[0]]);
        y.domain(d3.range(_rows)).rangePoints([0, size[1]]);
        actualSize[0] = x(1);
        actualSize[1] = y(1);
      }

      while (++i < n) {
        col = i % _cols;
        row = Math.floor(i / _cols);

        nodes[i].x = x(col);
        nodes[i].y = y(row);
      }

      return nodes;
    }

    grid.size = function(value) {
      if (!arguments.length) return nodeSize ? actualSize : size;
      actualSize = [0, 0];
      nodeSize = (size = value) == null;
      return grid;
    }

    grid.nodeSize = function(value) {
      if (!arguments.length) return nodeSize ? size : actualSize;
      actualSize = [0, 0];
      nodeSize = (size = value) != null;
      return grid;
    }

    grid.rows = function(value) {
      if (!arguments.length) return rows;
      rows = value;
      return grid;
    }

    grid.cols = function(value) {
      if (!arguments.length) return cols;
      cols = value;
      return grid;
    }

    grid.bands = function() {
      bands = true;
      return grid;
    }

    grid.points = function() {
      bands = false;
      return grid;
    }

    grid.padding = function(value) {
      if (!arguments.length) return padding;
      padding = value;
      return grid;
    }

    return grid;
  };
})();
	
	
	function toggleSteps() {
		if ( $( "#search_body" ).css( 'display' ) == 'none' ) {
			$( '.line' ).css( { "top": "157px" } );
		} else {
			$( '.line' ).css( { "top": "294px" } );
		}
	
		$( "#graph_recommender" ).slideToggle( 'slow' );
	}
	function toggleSearch() {
		if ( $( "#search_body" ).css('display') == 'none' ) {
			$( '.line' ).css( { "top": "294px" } );
		}
		else {
			$( '.line' ).css( { "top": "157px" } );
		}
		$( "#search_body" ).slideToggle( 'slow' );
	}

	function toggleDetailsTab() {
		
		if ( $( "#node_tab" ).css('display') == 'none' ) {
			//$( "#detailBtn" ).css( "margin-top", "-45%" );
			$( "#detailBtnIcn" ).html( "chevron_right" );
		}
		else {
			//$( "#detailBtn" ).css( "margin-top", "-30%" );
			$( "#detailBtnIcn" ).html( "chevron_left" );
		}
		
		var tab = document.getElementById("node_tab");
		$( tab ).slideToggle( "fast" );
	}
	
	function toggleSearchTab() {
		if ( $( this ).css( 'display' ) == 'none' ) {
			//$( '.line' ).css( { "height": "14.5%" } );
			$( '.line' ).css( { "height": "27vh" } );
		}
		else {
			//$( '.line' ).css( { "height": "14.5%" } );
			$( '.line' ).css( { "height": "27vh" } );
		}
	}
	
	function toggleFilterTab() {
		
		if ( $( "#filter_tab" ).css('display') == 'none' ) {
			$( "#filterBtnIcn" ).html( "chevron_left" );
		}
		else {
			$( "#filterBtnIcn" ).html( "chevron_right" );
		}
		
		var tab = document.getElementById("filter_tab");
		$( tab ).slideToggle( 'slow' );
	}
	
	function switchDetailsTab( shouldClose ) {
		if ( shouldClose ) {
			$( "#node_tab" ).slideUp( 'fast' );
			$( "#detailBtn" ).css( "margin-top", "-30%" );
			$( "#detailBtnIcn" ).html( "chevron_left" );
		} else {
			$( "#node_tab" ).slideDown( 'fast' );
			$( "#detailBtn" ).css( "margin-top", "-45%" );
			$( "#detailBtnIcn" ).html( "chevron_right" );
		}
	}
	
	function toggleSingleTreeTab( shouldClose ) {
		//var tab = document.getElementById("singleTreeTab");
		if ( shouldClose ) {
			$( "#singleTreeTab" ).slideUp( 'fast' );
			//$( '.line' ).css( { "height": "15.4%" } );
			$( '.line' ).css( { "height": "25.5vh" } );
		} else {
			$( "#singleTreeTab" )
				.slideDown( 'fast' )
				.html("");
			$( '.line' ).css( { "height": "67vh" } );
			//$( '.line' ).css( { "height": "31.8%" } );
		}
		
		if ( $( "#graph_recommender" ).css( 'display' ) == 'none' ) {
			toggleSteps();
		}
	}

	function switchSingleTreeTab() {
		if ( $( "#singleTreeTab" ).css('display') == 'none' ) {
			$( '.line' ).css( { "height": "67vh" } );
			//$( '.line' ).css( { "height": "31.8%" } );
		}
		else {
			//$( '.line' ).css( { "height": "15.4%" } );
			$( '.line' ).css( { "height": "25.5vh" } );
		}
		
		$( '#singleTreeTab' ).slideToggle( 'slow' );
	}

	function displayTopNodes( range, nodeType ) {
		var pubNodes = nodes.filter( function(d){
			return d.nodeType == nodeType;
		} )
		.sort( function( a, b ) {
			if (a.group < b.group)
		    	return -1;
		  	if (a.group > b.group)
		    	return 1;
		  	return 0;
		} );
		
		var top = pubNodes.slice(range, pubNodes.length);
		
		return top;
	}

	function stepDisplayNodes( stepNodes, range ) {
		var topNodes = [];
		for ( var i = 0; i < stepNodes.length; i++ ) {
			otherNodes = displayTopNodes( range, stepNodes[i] );
			topNodes = topNodes.concat(otherNodes);
			range = 10;
		}
		return topNodes;
	}

	function changeRange( range ) {
		$( "#range_output" ).html(range);
		
		var stepNo = selectedStep;
		var stepNodes = [];
				
		//if ( stepNo < 4 )
		//	return;
		
		if ( generalAlgorithmID == "interest" ) {
			if ( stepNo == 5 ) {
				stepNodes = [3, 2, 1];
			}
			<#--else if ( stepNo == 4 || stepNo == 2 ) {
				stepNodes = [2, 1];
			}
			else if ( stepNo == 3 ) {
				stepNodes = [2];
			}
			else {
				stepNodes = [3, 2, 1];
			}-->
		}
		else {
			if ( stepNo == 5 ) {
				stepNodes = [3, 2, 1];
			}
			else if ( stepNo == 1 || stepNo == 2 || stepNo == 3 ) {
				stepNodes = [1];
			}
			else if ( stepNo == 4 ) {
				stepNodes = [1, 2];
			}
			else {
				stepNodes = [3, 2, 1];
			}
		}
		
		if ( stepNo == 1 && generalAlgorithmID == "interest" ) {
			if ( range > 3 ) {
				range = 1;
				$( "#nodes_range" )
					.attr("step", 1)
					.attr("min", 1) 
					.attr("max", 3)
					.attr("value", 1);
			}
			var displayNodes = nodes.filter( function(d){
					return d.group <= (range-1);
				} );
		}
		if ( stepNo == 2 && generalAlgorithmID == "c2d" ) {
			return;
		}
		else {
			var top = stepDisplayNodes( stepNodes, range );
			var displayNodes = nodes.filter( function( el ) {
			  return top.indexOf( el ) < 0;
			} );
		}
		
		
		//var displayNodes = pubNodes.slice( 0, range );
		
		//$( "#nodes_range" ).attr("max", pubNodes.length);
		
		//var svgGraph = d3.selectAll( ".general-content-graph" )
		//	.selectAll("g.network");
		
		updateStepGrap( stepNo, displayNodes, true );
	}

	<#-- generate unique id for progress log -->
	var uniquePidGerneraRecommendationCloud = $.PALM.utility.generateUniqueId();
	var uniquePidGerneraGraphCloud = $.PALM.utility.generateUniqueId();
	var uniquePidCode = $.PALM.utility.generateUniqueId();
	
	<#-- Selected algorithm selected in options--> 
	var generalAlgorithmID = "interest",
		filterItem = "author";
	<#-->var generalAlgorithmID = "c3d interest";
					
	<#-- Global variables -->
	var nodes = [];
	var edges = [];
	
	var selectedStep = -1;
	var nodesMap = {};
	var stepsNodes = {};
	var stepsEdges = {};
	var generalGraph;
	var link, genralNodes, force;
	var tipCirclePack;
	var previousStep = -1;
	var width,
		height,
		selectedItem;
	const MAP_SIZE = "map_size";
	nodesMap[MAP_SIZE] = 0;
		
	
	<#-- Graph zoom functionality -->
	var zoom = d3.behavior.zoom().scaleExtent([0.5, 1.5]).on("zoom", zoomed);
	function zoomed() {
	    d3.selectAll( ".general-content-graph" ).selectAll("g.network")
	    	.attr("transform",
		        "translate(" + zoom.translate() + ")" +
		        "scale(" + zoom.scale() + ")"
		    );
	}
	function interpolateZoom (translate, scale) {
	    var self = this;
	    return d3.transition().duration(350).tween("zoom", function () {
	        var iTranslate = d3.interpolate(zoom.translate(), translate),
	            iScale = d3.interpolate(zoom.scale(), scale);
	        return function (t) {
	            zoom
	                .scale(iScale(t))
	                .translate(iTranslate(t));
	            zoomed();
	        };
	    });
	}
	function zoomClick() {
	    var clicked = d3.event.target,
	        direction = 1,
	        factor = 0.2,
	        target_zoom = 1,
	        center = [width / 2, height / 2],
	        extent = zoom.scaleExtent(),
	        translate = zoom.translate(),
	        translate0 = [],
	        l = [],
	        view = {x: translate[0], y: translate[1], k: zoom.scale()};
	
	    d3.event.preventDefault();
	    direction = (this.id === 'zoomInBtn') ? 1 : -1;
	    target_zoom = zoom.scale() * (1 + factor * direction);
	
	    if (target_zoom < extent[0] || target_zoom > extent[1]) { return false; }
	
	    translate0 = [(center[0] - view.x) / view.k, (center[1] - view.y) / view.k];
	    view.k = target_zoom;
	    l = [translate0[0] * view.k + view.x, translate0[1] * view.k + view.y];
	
	    view.x += center[0] - l[0];
	    view.y += center[1] - l[1];
	
	    interpolateZoom([view.x, view.y], view.k);
	}
	
	function translate() {
		var clicked = d3.event.target,
	        direction = 1,
	        factor = 0.2,
	        target_zoom = 1,
	        center = [width / 2, height / 2],
	        extent = zoom.scaleExtent(),
	        translate = zoom.translate(),
	        translate0 = [],
	        l = [],
	        view = {x: d3.event.dx, y: d3.event.dy, k: zoom.scale()};
	
	    //d3.event.preventDefault();
	    direction = (this.id === 'zoomInBtn') ? 1 : -1;
	    target_zoom = zoom.scale() * (1 + factor * direction);
	
	    //if (target_zoom < extent[0] || target_zoom > extent[1]) { return false; }
	
	    translate0 = [(center[0] - view.x) / view.k, (center[1] - view.y) / view.k];
	    view.k = target_zoom;
	    l = [translate0[0] * view.k + view.x, translate0[1] * view.k + view.y];
	
	    view.x += center[0] - l[0];
	    view.y += center[1] - l[1];
	
	    interpolateZoom([view.x, view.y], view.k);
	}
	
	$( function(){

		<#-- Inserting progress items -->
		$( "#interest_progress" )
			.append( createProgressItem( "Active User", 0 ).addClass( "active" ) )
			.append( createProgressItem( "3D Co-Author's Graph", 1 ) )
			.append( createProgressItem( "Interest Network", 2 ) )
			.append( createProgressItem( "Top N Interests Graph", 3 ) )
			.append( createProgressItem( "Top N Authors Graph", 4 ) )
			.append( createProgressItem( "Recommendations Graph", 5 ) ).show();
		
		function createProgressItem( itemName, stepNo ) {
			var itemElem = $( "<li/>" )
							.attr({ 'id' : "step" + stepNo })
							.click( function(event){
								$( "#singleTreeTab" ).html("");
								toggleSingleTreeTab( true );
								updateLegendSelected( stepNo );
								
								setTimeout( function(){
									$.PALM.popUpMessage.create( ("Simulating graph."), { uniquePidCode, popUpHeight:40, directlyRemove:true , polling:false});
								}, 0 );
								selectedStep = stepNo;
								focus_node = null;
							    updateGraphData( stepNo );
							    var node_range_changed = true;
								
								if ( stepNo == 5 ) {
									$( "#node_range_title" ).html( "Publication:" );
								} else if ( stepNo == 4 ) {
									if ( generalAlgorithmID == "interest" )
										$( "#node_range_title" ).html( "Co-Author:" );
									else
										$( "#node_range_title" ).html( "Interest:" );
								} else if ( stepNo == 2 || stepNo == 3 ) {
									if ( generalAlgorithmID == "interest" )
										$( "#node_range_title" ).html( "Interest:" );
									else
										$( "#node_range_title" ).html( "Author:" );
								} else if ( stepNo == 1 ) {
									$( "#node_range_title" ).html( "Co-Authors:" );
									
									if ( generalAlgorithmID == "interest" ) {
										node_range_changed = false;
										$( "#nodes_range" )
											.attr("step", 1)
											.attr("min", 1) 
											.attr("max", 3)
											.attr("value", 1);
									}
								}
								
								if (node_range_changed) {
									$( "#nodes_range" )
											.attr("step", 10)
											.attr("min", 10) 
											.attr("max", 100)
											.attr("value", 10);
								}
								
								<#-- remove  pop up progress log -->
								$.PALM.popUpMessage.remove( uniquePidCode );
							}) 
							.html( itemName );
			return itemElem;
		}
		
		var options = {
			source : "<@spring.url '/user/recommendation?requestStep=0&creatorId=publication&query=' />",
			query: "",
			queryString : generalAlgorithmID,
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( ("Extracting recommendations for step No. 1"), { uniqueId:uniquePidGerneraRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem, data  ){
				var GernralTarget = $( widgetElem ).find( ".general-content-graph" );
				var targetAlgoFilter = $( widgetElem ).find( ".general-box-filter" );
				
				<#-- remove previous graph -->
				GernralTarget.html( "" );
				targetAlgoFilter.show();
				targetAlgoFilter.find( ".general-box-filter-option" ).html( "" );
				targetAlgoFilter.find( ".general-box-filter-button" ).find( "span" ).html( "Recommendation Algorithm" );
								
				var $pageDropdown = $( widgetElem ).find( "select.page-number" );
				$pageDropdown.find( "option" ).remove();
				
				<#-- create dropdown algorithm profile -->
				var algorithmProfileDropDown = 
					$( '<select/>' )
					.attr({ "id": "algorithm_profile"})
					.addClass( "selectpicker btn-xs" )
					.css({ "max-width": "210px"})
					.on( "change", function(){ getGeneralRecommendationAlogrithm( $( this ).val() , algorithmProfileDropDown ) } );
								
				<#-- interest algorithm profile container -->
				var algorithmProfileContainer = $( "<div/>" )
					.css( { "margin":"0 10px 0 0"} )
					.append( $( "<span/>" ).html( "Algorithm : " ) )
					.append( algorithmProfileDropDown );
				
				<#-- append to container -->
				targetAlgoFilter.find( ".general-box-filter-option" ).append( algorithmProfileContainer );
				
				getGeneralRecommendationAlogrithm( "" , algorithmProfileDropDown );
				
				var filterProfile = 
					$( '<select/>' )
					.attr({ "id": "filter_profile"})
					.addClass( "selectpicker btn-xs" )
					.css({ "max-width": "210px"})
					.on( "change", function(){ getFilterAlgorithm( $( this ).val() , filterProfile ) } );
				var filterProfileContainer = $( "<div/>" )
					.css( { "margin":"0 10px 0 0"} )
					//.append( $( "<span/>" ).html( "Filter by : " ) )
					.append( filterProfile );
				$( widgetElem ).find( ".general-box-search-option" ).append( filterProfileContainer );
				//$( "#search_item" ).append( filterProfile );
				
				getFilterAlgorithm("", filterProfile);
				
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
				
				<#-- adding dropdown scroller -->
				$( '#searchedItems' )
					.slimscroll({
						height: "150px",
						width: "240px",
				        size: "6px",
						allowPageScroll: true,
			   			touchScrollStep: 50,
			   			railVisible: true,
			    		alwaysVisible: true
				    });
				$( '#searchedItems' ).parent()
					.attr( { "id": "searchContent" } )
					.css( {
						overflow: "inherit",
						position: "absolute",
						"z-index": 2
					} ).hide();
				$( "#searchContent" ).blur( function(){
					console.log("hide items");
					$( "#searchSpinner" ).hide(); 
				$( "#searchedItems" ).html(""); } );
				
				$( '#node_details' )
					.slimscroll({
						height: "800px",
						width: "450px",
				        size: "6px",
						allowPageScroll: true,
			   			touchScrollStep: 50,
			   			railVisible: true,
			    		alwaysVisible: false
				    });
								
				<#-- graph items -->
				width = GernralTarget.width();
				height = GernralTarget.height();
				var min_zoom = 0.1;
				var max_zoom = 3;
				
				var svg = d3.selectAll( ".general-content-graph" )
									  .append("div")
								      .classed("svg-container", true).style({"height":"inherit"}).style({"padding-bottom":"0%"})
									  .append("svg:svg")
									  .attr("width", width)
									  .style("height", height)
									  .attr("preserveAspectRatio", "xMinYMin meet")
								      .classed("svg-content-responsive", true);
				$("svg").css({top: 0, left: 0, position:'absolute'});
				svg.append("g")
						.classed("network", true);
				generalGraph = svg.selectAll("g.network")
						.attr("width", width)
						.style("height", "inherit");
						//.attr("transform", "translate(" + (width/2) + "," + (height/2) + ")");
				<#--generalGraph.append("g");
				generalGraph.append("g").attr("class", "labels")
      				.selectAll("g.label");
				var zoom = d3.behavior.zoom()
				    .scaleExtent([min_zoom, max_zoom])
				    .on("zoom", function() {
									generalGraph.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
									
								})-->
				var dragCallback = function(){
				  //console.log(d3.event.dx, d3.event.dy);
				  //generalGraph.attr("transform", "translate(" + d3.event.dx + "," + d3.event.dy + ")");
				  //d3.event.sourceEvent.stopPropagation(); 
				  //translate();
				  var x = d3.event.dx,
				  		y = d3.event.dy;
				  d3.transition().duration(350).tween("transform", function () {
				        var iTranslate = d3.interpolate(zoom.translate(), [x, y]);
				        return function (t) {
				        	console.log(iTranslate(t));
				            zoom
				                .translate(iTranslate(t));
				            zoomed();
				        };
				    })
				    .remove();
				};
				var dragBehavior = d3.behavior.drag()
				                     .on("drag", function (d, i) {
				            var 
					        factor = 0.2,
					        target_zoom = 1;
	    					var target_zoom = zoom.scale() * (1 + factor);
				            zoom
				                .scale(zoom.scale())
				                .translate([(d3.event.x - (width/2)), (d3.event.y - (height/2))]);
				            zoomed();
				            //zoom.translate([(d3.event.x - (width/2)), (d3.event.y - (height/2))]);
				            //translate();
				            //interpolateZoom([(d3.event.x - (width/2)), view.y], zoom.scale());
							generalGraph
				            	.attr('transform', 'translate(' + (d3.event.x - (width/2)) + ' ' + (d3.event.y - (height/2)) +')');

                        });
				svg.call(dragBehavior);
				d3.select( '#zoomOutBtn' ).on( 'click', zoomClick );
				d3.select( '#zoomInBtn' ).on( 'click', zoomClick );
				
				tipCirclePack = d3.tip()
							      .attr('class', 'd3-tip')
							      .offset([-10, 0])
				svg.call(tipCirclePack);
				
				createLegend();
				
				if ( data.pub_recommendation.count > 0 )
				{ 
					$( '#searchItem' ).val( data.pub_recommendation.nodes[0].details );
					
					<#-- update general graph -->
					updateGeneralGraph( data.pub_recommendation, 0 );
				
					$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
					
					<#-- call for next step -->
					callRecommendationStep( 1 );
				}
				else 
				{
					$( "#search_body" ).slideToggle( "slow" );
					$( "#recommendation_body" ).slideToggle( "slow" );					
					
					$.PALM.callout.generate( $( widgetElem ).find( "#msg_content" ), "warning", "No publications found. Please try to search for other authors or interest." , "" );
				}
			}
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );	
	});
	
	function graphFilterAutoComplete( currentNodes ) {
		$( '#filterItem' ).autocomplete( {
			source: function( request, response ) {
				var term = request.term;
				var data = currentNodes.filter( function( n ){
						return n.details.toLowerCase().indexOf(term) >= 0;
					} )
					.map( function( a ) {
						var endString = a.details;
						if ( endString.includes( "</br>" ) )
							endString = endString.substring( 0, endString.indexOf( "</br>" ) ); 
						return { label: endString, value: a }; 
					} );
				response( data );
			},
			select: function( event, ui ) {
				console.log("search item: ", d3.select( "#n_" + ui.item.value.id ).selectAll( "path" ));
				event.preventDefault();
				$( '#filterItem' ).val( ui.item.label );
				d3.select( "#n_" + ui.item.value.id ).selectAll( "path" ).on( "click" )( ui.item.value );
			},
		    focus: function( event, ui ) {
		        event.preventDefault();
		        $( '#filterItem' ).val( ui.item.label );
		    }
		} );
	}
	
	function algorithmSearchAutoComplete(  ) {
		$( '#searchItem' ).autocomplete( {
			source: function( request, response ) {
				var term = request.term;
				var searchOption = $('#filter_profile :selected').text();
				var max = $( '#maxResults' ).text();
				<#-- call to get the autocomplete list -->
				$.ajax( {
					type: "GET",
					url : "<@spring.url '/user/interest_recommendation' />",
					data : { query: request.term, maxresult: maxResults, itemtype: searchOption },
					success : function( data ) {
						var selected = [];
						
						if ( data.count > 0 ) {
							selected = data.interest_recommended;
						} 
						
						response( selected );
					},
					error: function(er) {
						console.log("error", er);
						response( [] );
					}
				} );
			},
			select: function( event, ui ) {
				event.preventDefault();
				$( '#searchItem' ).val( ui.item.label );
				currentRequest = $.ajax({
					type: "GET",
					url : "<@spring.url '/user/recommendation' />",
					data : { requestStep: 0, creatorId: publication, query: generalAlgorithmID, selectedauthor: ui.item.value },
					beforeSend : function()    {           
				        
				    },
				    error:function(e){
				      console.log("Error: ", e);
				    },
					success: function( cdata ){
						<#-- remove  pop up progress log -->
						$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
						
						<#-- update general graph -->
						console.log("data: ", cdata);
						updateGeneralGraph( cdata.pub_recommendation, 0 );
					
						$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
						
						<#-- call for next step -->
						callRecommendationStep( 1 );
					}
				});
			},
			focus: function( event, ui ) {
		        event.preventDefault();
		        $( '#searchItem' ).val( ui.item.label );
		    }
		} )
		.autocomplete( 'disable' );
	}
	
	function setActiveResearcher( rID ) {
		
		$( '#searchContent' )
						.slideUp( 'show' );
		$( '#searchedItems' ).html("");
		
		$( "#recommendation_body" ).slideDown( 'slow' );	
		$( "#msg_content" ).html( "" );
		
		<#-- Deactivate all progress itemd -->
		$( "#interest_progress li" ).each( function( i ) {
			$( this ).removeClass( "active" );
			$( this ).removeClass( "selected" );
			if ( i == 0 )
				$( this ).addClass( "active" );
		} );
		nodes = [],
		edges = [],
		nodesMap = {},
		stepsNodes = {},
		stepsEdges = {},
		previousStep = -1;
		
		$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation' />",
			data : { requestStep: 0, creatorId: "publication", query: generalAlgorithmID, selectedauthor: rID },
			accepts: "application/json, text/javascript, */*; q=0.01",
			beforeSend : function()    {           
		
			},
			error:function(e){
				console.log("Error: ", e);
			},
			success: function( cdata ){
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
				
				<#-- update general graph -->
				console.log("data: ", cdata);
				updateGeneralGraph( cdata.pub_recommendation, 0 );
					
				$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
						
				<#-- call for next step -->
				callRecommendationStep( 1 );
			}
		});
	}
	
	function generateSearchItems() {
	
		var term = $( '#searchItem' ).val();
		var searchOption = $('#filter_profile :selected').text();
		var max = parseInt( $( '#maxResults' ).val(), 10 );
	
		<#-- show spinner -->
		$( '#searchSpinner' ).show();
	
			<#-- call to get the autocomplete list -->
			$.ajax( {
				type: "GET",
				url : "<@spring.url '/user/interest_recommendation' />",
				data : { query: term, maxresult: max, itemtype: filterItem },
				success : function( data ) {
					var selected = [];
					<#-- show spinner -->
					$( '#searchSpinner' ).hide();
				
					if ( data.count > 0 ) {
						selected = data.interest_recommended;
						
						var content = $( '#searchedItems' );
						for ( var i = 0; i < data.count; i++ ) {
							var cItem = selected[ i ];
							var item = 
								$( '<a/>' )
								.css( { "z-index" : 1 } )
								.on( "click", function(){ setActiveResearcher( cItem["value"] ); } )
								.html( cItem["label"] );
							content.append( item );
						} 
						
						$( '#searchContent' )
							.slideDown( 'show' );
					}
				},
				error: function(er) {
					console.log("error", er);
					response( [] );
				}
			} );
	}
	
	function callRecommendationStep( stepNo ) {
		<#-- show pop up progress log -->
		$.PALM.popUpMessage.create( ("Extracting recommendations for step No. " + (stepNo+1)), { uniqueId:uniquePidGerneraRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
			
		$.ajax({
			type: "GET",
			url : "<@spring.url '/user/recommendation?creatorId=publication&query=' />" + generalAlgorithmID + "&requestStep=" + stepNo,
			accepts: "application/json, text/javascript, */*; q=0.01",
			success: function( data ){
			
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
				
				<#-- Activate next progress item -->
				$( "#interest_progress li" ).each(function(i) {
					if ( i == stepNo )
						$(this).addClass( "active" );
					if ( i == stepNo && stepNo == 5 && previousStep == -1 )
						$(this).addClass( "selected" );
				} );
				
				$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );
				
				<#-- call for next step, max 4 -->
				if ( stepNo < 5 )
					callRecommendationStep( stepNo + 1 );
					
				
				<#-- update general graph -->
				updateGeneralGraph( data.pub_recommendation, stepNo );
				
				<#-- update graph if user hadn't selected any yet -->
				if ( stepNo == 5 && previousStep == -1 ) {
					previousStep = stepNo - 1;
					selectedStep = stepNo;
					updateLegendSelected( stepNo );
					updateGraphData( stepNo );
					changeRange( 10, stepNo );
				}
			}
		});
	}
	
	function updateGraphData( stepNo ) {
		<#-- Removing the one step before nodes
		if ( (stepNo-2)  >= 0 ) {
			rSteps = stepsNodes[stepNo - 2];
			nodes = nodes.filter( function( el ) {
			  return rSteps.indexOf( el ) < 0;
			} );
		}-->

		if ( previousStep !== stepNo ) {
			
			<#-- Adding the previous step nodes  -->
			var i,
				check,
				increment,
				noLoops;
			if ( previousStep < stepNo ) {
				<#-- move step in forward direction -->
				i = previousStep + 1;
				check = i <= stepNo;
				increment = 1;
				noLoops = stepNo - previousStep;
			} else {
				<#-- move step in backward direction -->
				i = previousStep - 1;
				check = i >= stepNo;
				increment = -1;
				noLoops = previousStep - stepNo;
			}
			
			(function stepLoop ( index, incrementer, stepNub ) {
				
				<#-- If moving backward clean nodes 
				if ( incrementer < 0 ) {
					nodes = nodes.slice(0,0);
					if ( index > 0 )
						nodes = stepsNodes[index-1];
				} -->
				nodes = [];
				
				edges = edges.slice(0,0);
				nodes = stepsNodes[index]; //nodes.concat( stepsNodes[index] );
				edges = stepsEdges[index]; //edges.concat( stepsEdges[index] );
				
				<#-- Activate all progress item -->
				$( "#interest_progress li" ).each(function(i) {
					$(this).removeClass( "selected" );
				} );
				$( '#step' + index ).addClass( "selected" );
				
				
				setTimeout(function() {
					updateStepGrap( index, nodes, false );
					
					<#-- implementing filter autocomplete functionality -->
					graphFilterAutoComplete( nodes );
					changeRange( 10, stepNub );
				}, 0)
				
				<#-- starting next step after delay -->
				setTimeout(function() {
					index = index + incrementer;
					if ( ( incrementer < 0 && index >= stepNub ) || 
							( incrementer > 0 && index <= stepNub ) ) {
						stepLoop( index, incrementer, stepNub );
					}
				}, 2000)
			})( i, increment, stepNo );
			
			previousStep = stepNo;
			<#-- for ( ; check; i += increment; ) {
				nodes = nodes.concat( stepsNodes[i] );
				edges = edges.concat( stepsEdges[i] );
				
				updateStepGrap( i );
			} -->
		}
	}
	
	function updateGeneralGraph( data, stepNo ) {
		
		var tempNodes = [];
		var tempEdges = [];
		if ( data !== null && data.count > 0 ) {		
			
			<#-- Adding the current step nodes -->
			var index = nodesMap["map_size"];
			
			if ( data.nodes[0].icon !== 'undefined' ){
				stepsNodes["icon"] = data.nodes[0].icon;
			}
			
			data.nodes.forEach( function(e){
				if(!(e.id in nodesMap)) {
					nodesMap[e.id] = index++;
				}
				
				tempNodes.push({
					id: e.id,
					index: nodesMap[e.id],
					group: e.group,
					type: d3.svg.symbolTypes[e.type],
					size: e.size,
					nodeType: e.type,
					title: e.title,
					details: e.details,
					step: e.stepNo,
					orgId: e.id,
					fixed: false
					//x: (e.x !== 'undefined' && e.x !== 0) ? e.x : ((width / 2)+((index-e.group+e.size/2) * Math.cos(index-e.group+e.size/2))),
					//y: (e.y !== 'undefined' && e.y !== 0) ? e.y : ((height / 2)+((index-e.group+e.size/2) * Math.sin(index-e.group+e.size/2)))
					//cx: (e.x !== 'undefined' && e.x !== 0) ? e.x : ((width / 2)+((index-e.group+e.size/2) * Math.cos(index-e.group+e.size/2))),
					//cy: (e.y !== 'undefined' && e.y !== 0) ? e.y : ((height / 2)+((index-e.group+e.size/2) * Math.sin(index-e.group+e.size/2)))
					//x: ((width / 2)+Math.cos(((Math.PI*2)/128.0)*nodesMap[e.id])*e.group*20),
	  				//y: ((height / 2)+Math.sin(((Math.PI*2)/128.0)*nodesMap[e.id])*e.group*20)
				});
			});
					
		    if ( data.links.length > 0 ) {		
		    	data.links.forEach(function(e) {
				
						var allNodes = tempNodes.concat(stepsNodes[stepNo-1]);
						
				 		var sourceNode = allNodes.filter(function(n) {
								return n.orgId === e.source;
							})[0],
				 			targetNode = allNodes.filter(function(n) {
								return n.orgId === e.target;
							})[0];
				 									
							
						<#-- check again if values added 
						if (targetNode == null){
							var tempNodes = stepsNodes[stepNo-1];
							tempNodes = tempNodes.concat(stepsNodes[stepNo]);
							targetNode = tempNodes.filter(function(n) {
								return n.id === e.target;
							})[0];
						}
						if (sourceNode == null){
							var stepTempNodes = stepsNodes[stepNo-1];
							stepTempNodes = stepTempNodes.concat(tempNodes);
							sourceNode = stepTempNodes.filter(function(n) {
								return n.id === e.source;
							})[0];
						}-->
						
						if(sourceNode == null) {
						}
						else if ( sourceNode !== 'undefined' && targetNode !== 'undefined' ) {
							tempEdges.push({
								source: sourceNode,
								target: targetNode,
								weight: 0
							});
						}
				});
			}

			nodesMap["map_size"] = index;				
	
			stepsNodes[stepNo] = tempNodes;							 
			stepsEdges[stepNo] = tempEdges;
		
		}
		
		//console.log("empty edges: ", tempEdges.filter(function(f){
		//	return typeof(f.source) == 'undefined' || typeof(f.target) == 'undefined';
		//}));
		//console.log("edges: ", tempEdges);
		
		//updateStepGrap( stepNo );
	}
	
	// Move nodes toward cluster focus.
	function gravity(alpha) {
	  return function(d) {
	    d.y += (d.cy - d.y) * alpha;
	    d.x += (d.cx - d.x) * alpha;
	  };
	}

	function updateStepGrap( stepNo, nodeData, newPols ){
  				
								
				<#-- Constant values -->
				var default_node_color = "#ccc";
				var color = d3.scale.category10();
				var fill = d3.scale.category10();
				var default_link_color = "#DCDCDC";
				var nominal_base_node_size = 80;
				var nominal_text_size = 15;
				var max_text_size = 24;
				var nominal_stroke = 0.5;
				var max_stroke = 4.5;
				var max_base_node_size = 36;
				var min_zoom = 0.1;
				var max_zoom = 3;
				var radius = 6;
				var text_center = false;
				var tocolor = "fill";
				var towhite = "stroke";
				var highlight_color = "#808080";
				var focus_node = null, highlight_node = null;
				var size = d3.scale.pow()
							.exponent(1)
							.domain([1,10])
							.range([8,24]);
				var colorSpec = d3.scale.linear().domain([0, 1]).range(["#84e184", "#1e7b1e"]); //['lime', 'green']); //d3.scale.linear().domain([0,10]).range(["red","green"]);
				colorSpec.nice();
				generalGraph.html("");
				link = generalGraph.selectAll(".link");
      			
      			genralNodes = generalGraph.selectAll(".node");
      			
      			var topPub = Math.max.apply(Math,nodeData.map(function(o){return (o.nodeType == 3) ? o.group : -1;}));
      			var topAuth = Math.max.apply(Math,nodeData.map(function(o){return (o.nodeType == 1) ? o.group : -1;}));
      			var topInt = Math.max.apply(Math,nodeData.map(function(o){return (o.nodeType == 2) ? o.group : -1;}));
      			
					force = d3.layout.force()
								.charge(-930)
	    						.linkDistance(100 * 100)
	    						.gravity(0.3)
								.size([width,height])
								//.links(edges)
								.nodes(nodeData);
      			
					// Resolves collisions between d and all other circles.
					var  padding = 1.5, // separation between same-color nodes
    					 clusterPadding = 6;
					function collide(node) { 
					    var nodeSize = node.getBBox().height+16;//You can remove/reduce this static value 16 to decrease the gap between nodes.
					    var r = nodeSize / 2 + 16,
					        nx1 = node.x - r,
					        nx2 = node.x + r,
					        ny1 = node.y - r,
					        ny2 = node.y + r;
					    return function(quad, x1, y1, x2, y2) {
					        if (quad.point && (quad.point !== node)) {
					            var x = node.x - quad.point.x,
					                y = node.y - quad.point.y,
					                l = Math.sqrt(x * x + y * y),
					                r = nodeSize / 2 + quad.point.radius;
					            if (l < r) {
					                l = (l - r) / l * .5;
					                node.x -= x *= l;
					                node.y -= y *= l;
					                quad.point.x += x;
					                quad.point.y += y;
					            }
					        }
					        return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
					    };
					}
					
					//link.remove();
					//genralNodes.remove();
					genralNodes.remove();
					//genralNodes.html("");
					
					var drag = force.drag()
    					.on("dragstart", dragstart);
					var node_drag = d3.behavior.drag()
				        .on("dragstart", dragstart)
				        .on("drag", dragmove)
				        .on("dragend", dragend);
				
					function dblclick(d) {
					  d3.select(this).classed("fixed", d.fixed = false);
					}
				    function dragstart(d, i) {
				    	d3.select(this).classed("fixed", d.fixed = true);
				        //force.stop() // stops the force auto positioning before you start dragging
				    }
				
				    function dragmove(d, i) {
				        d.px += d3.event.dx;
				        d.py += d3.event.dy;
				        d.x += d3.event.dx;
				        d.y += d3.event.dy; 
				        force.tick(); // this is the key to make it work together with updating both px,py,x,y on d !
				    }
				
				    function dragend(d, i) {
				        d.fixed = true; // of course set the node to fixed so the force doesn't include the node in its auto positioning stuff
				        force.tick();
				        //force.resume();
				    }
				    
				    var connectedEdges = edges.filter( function( item ) {
					  return nodeData.indexOf( item.source ) >= 0 && nodeData.indexOf( item.target ) >= 0;
					} );
														
					link = link.data( connectedEdges ); //force.links(), function(d) { return d.source + "-" + d.target; });
					
					link.enter().append("line")
						.attr("class", "link").style( "stroke-width", nominal_stroke )
						.style("z-index", -1)
						.style("stroke", function(d) { 
							if ( d.group >= 0 ) return color(d.group);
							else return default_link_color; 
						});
					link.exit().remove();
										
					genralNodes = genralNodes.data(nodeData);
					
					tipCirclePack.html(function(d) {
						return "<strong>" + (d.title) + " :  </strong> <span style='color:GhostWhite; text-transform: capitalize;'>" + (d.details) + "</span>";
					});
					
					
					var c10 = d3.scale.category10();
					
					console.log("scale 10: ", c10(0), " - ", c10(1), " - ", c10(2), " - ", c10(3), " - ", c10(4), " - ", c10(5), " - ", c10(6), " - ", c10(7), " - ", c10(8)
					, " - ", c10(9), " - ", c10(10));
					
					var nodeGroup = genralNodes.enter()
						.append("g")
						.attr("class", "node")
						.attr("id", function(d){return "n_" + d.id});
					var circle = nodeGroup
						.append("path")
						.attr("d", d3.svg.symbol()
							.size( 150 )
							.type(function(d) { 
								return d.type;
							}))
						.style("z-index", 1)
						.style(tocolor, function(d) {
							if ( d.step == 3 || d.step == 4 || d.step == 5 ) {
								if ( d.nodeType == 1 )
									return colorSpec(d.group/topAuth);
								else if ( d.nodeType == 2 )
									return colorSpec(d.group/topInt);
								else if ( d.nodeType == 3 )
									return colorSpec(d.group/topPub);
							} else {
								console.log("item: ", d.group, " = ", c10(d.group));
								return c10(d.group);
							}
							//else
							//	return color(0);
						})
						.on("click", function(e){
							<#-- Toggle selected node highlight -->
							if ( focus_node !== null && focus_node.id == e.id ) {
								exit_highlight();
					            toggleSingleTreeTab(true);
								focus_node = null;
							}
							else {
								focus_node = e;
								set_highlight(e);
								getNodeDetails( e );
								
								
								<#-- Toggle single node tree -->
								toggleSingleTreeTab(false);
				            	
				            	var step = -1;
				            	if ( e.nodeType == 3 )
				            		step = 5;
				            	if ( e.nodeType == 2 )
				            	{
				            		if ( generalAlgorithmID == "interest" )
				            		{
					            		if ( e.step !== 2 )
					            			step = 3;
					            		else
					            			step = 2;
				            		} else {
				            			step = 4;
				            		}
				            	}
				            	else if ( e.nodeType == 1 )
				            	{
				            		if ( generalAlgorithmID == "interest" )
				            		{
					            		if ( e.step !== 1 && e.step !== 2 )
					            			step = 4;
					            		else
					            			step = 1;
				            		} else {
				            			if ( e.step > 2 )
				            				step = 3;
				            			else if ( e.group == 0 )
				            				step = 1;
				            			else
				            				step = 2;
				            		}
				            	}
				            		
								singleTreeGraph( step, e );
							}
							
				        })
						.on('mouseover', function (d,i) {
							generalGraph.style("cursor","pointer");
							tipCirclePack.show(d)
							<#--var selectedCircle = d3.select("#c" + i)
								selectedCircle.transition().duration(250)
						        	.attr("r", selectedCircle.attr("size") * 1.2);-->
						})
						.on('mouseout', function (d,i) {
							tipCirclePack.hide(d)
							<#--var selectedCircle = d3.select("#c" + i)
								selectedCircle.transition()
								.attr("r", selectedCircle.attr("size") );-->
							
						})
						<#--.on("mousedown", function(d) { d3.event.stopPropagation();
							
						})-->;
					//if ( stepNo !== 1 && stepNo !== 2 )	
					var text = nodeGroup.append("text")
							.attr('width', 40)
							.attr("dx", 12)
							.attr("dy", ".35em")
							.text(function(d) { 
								var endString = d.details;
								if ( endString.includes( "</br>" ) )
									endString = endString.substring( 0, endString.indexOf( "</br>" ) );
								endString = (endString.length >= 30) ? endString.substring(0, 30) + "..." : endString;
								return endString; 
							});
						
					<#--	.append("svg:image")
        				.attr("xlink:href", function(d) { return d.type == 0 ? stepsNodes["icon"] : null; })
        				.attr("x", "-8px")
						.attr("y", "-8px")
						.attr("width", "16px")
						.attr("height", "16px");
						
						console.log("icon log: ", stepsNodes[0][0]);
					
					text.data(graphNodes).enter()
						.append("text")
						.attr("class", "label")
						.attr("x", function(d){ return d.x })
						.attr("y", function(d){ return d.y })
						.style("font-size", nominal_text_size + "px")
						.style("font-weight", "normal")
						.text(function(d) { return '\u2002'+d.details; });
					 if (text_center)
						text.text(function(d) {
							if(d.type == '3' || d.type == '2') 
								return d.title; 
							})
						.style("text-anchor", "middle");
					else 
						text.attr("dx", function(d) {return (size(d.group)||nominal_base_node_size);})
							.text(function(d) { 
								if(d.type == '3' || d.type == '2') 
									return d.title; 
								}); -->
				    
				    //genralNodes.style("visibility", "hidden");
					
					<#--if ( stepNo == 0 ) {
						if ( !(data.nodes[0].icon == null) ) {
							circle.append("svg:image")
        							.attr("class", "circle")
        							.attr("xlink:href", function(d) { return data.nodes[0].icon; })
        							.attr("x", "-8px")
							        .attr("y", "-8px")
							        .attr("width", "16px")
							        .attr("height", "16px");							 
						}
						nodes[0].x = width / 2;
						nodes[0].y = height / 2;
						//circle
							//.attr("transform", function(d) { return "translate(" + (width / 2) + "," + (height / 2) + ")"; });
							//.attr("cx", function(d) { return d.x = width / 2; })
	        				//.attr("cy", function(d) { return d.y = height / 2; });
					} else {
						//circle.style("visibility", "hidden");
						//circle
							//.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
					}-->
						
					//genralNodes.exit().remove();
					//var t = d3.transition()
					//		    .duration(750);
					//circle.transition(t)
						//.style("visibility", "visible");
					
					//console.log("nodes: ", nodes);
					//if (shouldUpdate)
					//force.start();
					if ( stepNo > 2 ) {
								force.on("tick", function(e) {  	
									
									if ( e.alpha <= 0.07 ) force.stop();								
									//text.attr("cx", function(d) { return d.x + 6; })
									//	.attr("cy", function(d) { return d.y + 4; })
									//text.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									
									//while (++i < n) q.visit(collide(nodes[i]));
									//	ky = e.alpha;
									//genralNodes//.each(gravity(.2 * e.alpha))
	      										//.each(collide(.8))
									//			.attr("cx", function(d) { return d.x -= (d.x - (width/2) - (d.nodeType + 1) * 55) * 8 * ky; })
									//			.attr("cy", function(d) { return d.y -= (d.y - (d.nodeType + 1) * 55) * 8 * ky; });
									var k = 30 * e.alpha;
									nodeData.forEach(function(o, i) {
									    o.y += o.nodeType & 1 ? k : -k;
									    o.x += o.nodeType & 2 ? k : -k;
									  });
									//var allNodes = d3.selectAll(".node");
									//var q = d3.geom.quadtree(nodeGroup),
								    //    i = 0,
								    //    n = nodeGroup.length;
								
								    //while (++i < n) q.visit(collide(nodeGroup[i]));
								
								    //svg.selectAll(".node")
								    //    .attr("transform", function(d) {
								    //        return "translate(" + d.x + "," + d.y + ")"
								    //    });
									nodeGroup
												//.each(function(d, i){console.log("data item: ", d); collide(d);})
												.attr("cx", function(d){return d.x;})
												.attr("cy", function(d){return d.y;});
									//genralNodes
									nodeGroup
												.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									
									link.attr("x1", function(d) { return d.source.x; })
										.attr("y1", function(d) { return d.source.y; })
									    .attr("x2", function(d) { return d.target.x; })
									    .attr("y2", function(d) { return d.target.y; });									
								});
					}
					else {
						force.on("tick", function(e) {  	
									
									if ( e.alpha <= 0.07 ) force.stop();								
									//text.attr("cx", function(d) { return d.x; })
									//	.attr("cy", function(d) { return d.y; })
									//text.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									
									//while (++i < n) q.visit(collide(nodes[i]));
									var ky = e.alpha;
									genralNodes//.each(gravity(.2 * e.alpha))
	      										//.each(collide(.8))
												.attr("cx", function(d) { return d.x; })
												.attr("cy", function(d) { return d.y; });
									genralNodes.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
									
									link.attr("x1", function(d) { return d.source.x; })
										.attr("y1", function(d) { return d.source.y; })
									    .attr("x2", function(d) { return d.target.x; })
									    .attr("y2", function(d) { return d.target.y; });
								});
					}
					
					setTimeout( function() {
						
							        
						var n = 100;
						force.start();
						if (newPols) {
						for (var i = n * n; i > 0; --i) force.tick();
						force.stop();}
						<#--;
							        genralNodes.exit().transition()
							        .duration(1300)
							        .style("opacity", 0).remove()-->
					}, 0 );
					
					genralNodes.style("opacity", 0)
							        .transition()
							        .delay(300)
							        .duration(300)
							        .style("opacity", 1);	
					<#--circle.transition()
					    .duration(750)
					    .delay(function(d, i) { return i * 5; })
					    .attrTween("r", function(d) {
					      var i = d3.interpolate(0, d.group);
					      return function(t) { return d.group = i(t); };
					    });
					genralNodes.transition()
						    //.attr("r", 0)
						    //.attr("class", function (d) {
						    //  return d.children ? "parent" : "child";
						    //})
						    //.transition()
						    .duration(function (d, i) {
						      return 300;
						    })
						    .delay(function (d, i) {
						      return 10;
						    })						
						    //.attr("cx", function (d) {return d.x;})
						    //.attr("cy", function (d) {return d.y;})
						    //.attr("r", function (d) {return d.size;})
						    .style("visibility", "visible");-->
						
					// Exit
					//genralNodes.exit().remove();
    
    				<#-- Function to highligh the selected node and link -->
    				function set_highlight(d)
					{
						circle.style(towhite, function(o) {
								return isConnected(d, o) ? highlight_color : color(o.group);
							})
							.style("opacity", function(o) {
								return isConnected(d, o) ? 1 : 0.25;
							})
							.style("stroke-width", function(o){
								return (o.id == d.id) ? 3.0 : nominal_stroke;
							});
						link.style("stroke", function(o) {
								return o.source.index == d.index || o.target.index == d.index ? highlight_color : default_link_color;
							})
							.style( "stroke-width", function(o) {
								return o.source.index == d.index || o.target.index == d.index ? 1.0 : nominal_stroke;
							})
							.sort( function( o, b ) {
								return o.source.index == d.index || o.target.index == d.index ? 1 : 0;
							} );
						
						if ( text === "undefined" || text == null ) {
						} else {
							text.style("font-weight", function(o) {
									return isConnected(d, o) ? "bold" : "normal";
								})
								.style("font", function(o){ return (o.id == d.id) ? "20px sans-serif" : ""; });
						}
					}
					
					<#-- Function to exit the highlighted node and link -->
					function exit_highlight()
					{
						circle.style(towhite, "white")
							.style("opacity", 1)
							.style("stroke-width", nominal_stroke);
						link.style("stroke", function(o) {
								return default_link_color
							})
							.style("stroke-width", nominal_stroke);
						
						text.style("font-weight", "normal")
							.style("font", "")
							.text(function(d) {
									if(d.step == 0 || d.step == 3 || d.step == 4 || d.step == 5) { 
										var endString = d.details;
										if ( endString.includes( "</br>" ) )
											endString = endString.substring( 0, endString.indexOf( "</br>" ) );
										endString = (endString.length >= 30) ? endString.substring(0, 30) + "..." : endString;
										return endString; 
									}
									else
										return "";
								});
					}
					
	<#-- Storing the connected nodes -->
					var linkedByIndex = {};
					$.each(edges, function( index, d ) {
						linkedByIndex[d.source.id + "," + d.target.id] = true;
					});
					function isConnected(a, b) {
						return linkedByIndex[a.id + "," + b.id] || linkedByIndex[b.id + "," + a.id] || a.id == b.id;
					}
							
					function hasConnections(a) {
						for (var property in linkedByIndex) {
							s = property.split(",");
							if ((s[0] == a.id || s[1] == a.id) && linkedByIndex[property])
								return true;
						}
						return false;
					}				
	}
	function searchQuery() {
		var test = $( "#searchItem" ).val();

			currentRequest = $.ajax({
				type: "GET",
				url : "<@spring.url '/user/check_recommendation_request?query=' />" + test + "&author=" + test,
				accepts: "application/json, text/javascript, */*; q=0.01",
				beforeSend : function()    {           
			        
			    },
			    error:function(e){
			      console.log("Error: ", e);
			    },
				success: function( cdata ){
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
					
					<#-- update general graph -->

					updateGeneralGraph( cdata.pub_recommendation, 0 );
				
					$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
					
					<#-- call for next step -->
					callRecommendationStep( 1 );
				}
			});
	}
	
	function filterQuery() {
		var query = $( "#filterItem" ).val();
		console.log("filter value: ", query);
		var d = nodes.filter(function(d){return d.details.indexOf(query) !== -1;});
		var node = genralNodes.select("#n_"+d.id);
								
		console.log("test data: ", node);
	}
	
	function getFilterAlgorithm( algo, filterProfile ) {
		if ( algo == "" )
		{
			filterProfile.html( "" );
			
			filterProfile.append( $( '<option/>' )
									.attr({ "value" : "author"  })
									.html( "Author" ));
			filterProfile.append( $( '<option/>' )
									.attr({ "value" : "interest"  })
									.html( "Interest term" )
							);
			filterItem = "author";
		} else {
			<#--$.PALM.popUpMessage.create( "Extracting query result,", { uniqueId:uniquePidGerneraRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
			
			var test = $( "#searchItem" ).val();

			currentRequest = $.ajax({
				type: "GET",
				url : "<@spring.url '/user/check_recommendation_request?query=' />" + algo + "'&author=" + test,
				accepts: "application/json, text/javascript, */*; q=0.01",
				beforeSend : function()    {           
			        if(currentRequest != null) {
			            currentRequest.abort();
			        }
			    },
			    error:function(e){
			      console.log("Error: ", e);
			    },
				success: function( cdata ){
					<#-- remove  pop up progress log 
					$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
					
					<#-- update general graph 
					updateGeneralGraph( data.pub_recommendation, 0 );
				
					$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
					
					<#-- call for next step 
					callRecommendationStep( 1 );
				}
			}); -->
			filterItem = algo;
			if ( algo == "author" )
				$( '#searchItem' ).attr( "placeholder", "Search Author as active researcher" );
			else
				$( '#searchItem' ).attr( "placeholder", "Search Interest item" );
		}
		filterProfile.selectpicker( 'refresh' );
	}
	
	var singleTreeRequest = null;
	<#-- adding recommendation algorithm filters -->
	function getGeneralRecommendationAlogrithm ( algo, algorithmProfileDropDown ) {
		if( algo == "" )
		{
			algorithmProfileDropDown.html( "" );
			
			algorithmProfileDropDown.append( $( '<option/>' )
									.attr({ "value" : "interest"  })
									.html( "Interest Network" )
								);
			algorithmProfileDropDown.append( $( '<option/>' )
									.attr({ "value" : "c2d"  })
									.html( "2D Co-Author Network" )
								);
			algorithmProfileDropDown.append( $( '<option/>' )
									.attr({ "value" : "c3d"  })
									.html( "3D Co-Author Network" )
								);
		}
		else {
			generalAlgorithmID = algo;
			$.PALM.popUpMessage.create( "Extracting recommendations", { uniqueId:uniquePidGerneraRecommendationCloud, popUpHeight:40, directlyRemove:false , polling:false});
			
			$( "#legendGraph" ).children("div:first").remove();
			
			<#-- Deactivate all progress itemd -->
			$( "#interest_progress li" ).each( function( i ) {
				$( this ).removeClass( "active" );
				$( this ).removeClass( "selected" );
				if ( i == 0 )
					$( this ).addClass( "active" );
			} );
				
			createLegend();
			generalGraph.html( "" );
			
			if ( algo == "interest" ){
				$('#step1').html( "3D Co-Author's" );
				$('#step2').html( "Interest Network" );
				$('#step3').html( "Top N Interests" );
				$('#step4').html( "Top N Authors" );				
			}
			else if ( algo == "c3d" ) {
				$('#step1').html( "1D Co-Author's" );
				$('#step2').html( "3D Co-Author's" );
				$('#step3').html( "Top N Authors" );
				$('#step4').html( "Top N Interests" );
			}
			else if ( algo == "c2d" ) {
				$('#step1').html( "1D Co-Author's" );
				$('#step2').html( "2D Co-Author's" );
				$('#step3').html( "Top N Authors" );
				$('#step4').html( "Top N Interests" );
			}
			
			var currentRequest = $.ajax({
				type: "GET",
				url : "<@spring.url '/user/recommendation?requestStep=0&creatorId=publication&query=' />" + algo + "'",
				accepts: "application/json, text/javascript, */*; q=0.01",
				beforeSend : function()    {           
			        if(currentRequest != null) {
			            currentRequest.abort();
			        }
			    },
			    error:function(e){
			      console.log("Error: ", e);
			    },
				success: function( cdata ){
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniquePidGerneraRecommendationCloud );
					
					nodes = [],
					edges = [],
					nodesMap = {},
					stepsNodes = {},
					stepsEdges = {},
					previousStep = -1,
					selectedStep = -1;
					
					<#-- update general graph -->
					updateGeneralGraph( cdata.pub_recommendation, 0 );
				
					$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );	
					
					<#-- call for next step -->
					callRecommendationStep( 1 );
				}
			});
		}
		algorithmProfileDropDown.selectpicker( 'refresh' );
	}
	
	function getBB(selection) {
		selection.each(function(d){d.bbox = this.getBBox();})
	}
	
	var singleRequest = null;
	var uniquePidSingleNodeTreeGraph = $.PALM.utility.generateUniqueId();
	<#-- Function to show call and show single node tree -->
	function singleTreeGraph( sStep, item ) {
		var stepId = item.id;
		singleRequest = $.ajax({
			type: "GET",
			url : "<@spring.url '/user/single_tree_recommendation?query=' />" + generalAlgorithmID + "&stepNo=" + sStep + "&id=" + item.id,
			accepts: "application/json, text/javascript, */*; q=0.01",
			beforeStart: function ( e ) {
				$.PALM.popUpMessage.create( "Extracting node transparency", { uniqueId:uniquePidSingleNodeTreeGraph, popUpHeight:40, directlyRemove:true , polling:false});
		
				if ( singleRequest !== null )
					singleRequest.abort();
			},
			success: function( cdata ){				
							
				var data = cdata.single_tree_recommendation;
				var sTreeStepNodes = {};
				var sTreeStepEdges = [];
				var sTreeNodes = [];
				var f_node = null;
				
				var STEP = [14, 20, 16.3, 16, 16, 16.567];
				
				<#-- Constant values -->
				var tWidth = $( "#singleTreeTab" ).width();
				var tHeight = 300;
				var stepWidth = ( ( 17.4 / 100 ) * tWidth );
				var default_node_color = "#ccc";
				var color = d3.scale.category10();
				var fill = d3.scale.category10();
				var default_link_color = "#B3C4D2";
				var nominal_base_node_size = 80;
				var nominal_text_size = 15;
				var max_text_size = 24;
				var nominal_stroke = 0.5;
				var max_stroke = 4.5;
				var max_base_node_size = 36;
				var min_zoom = 0.1;
				var max_zoom = 3;
				var radius = 6;
				
				var text_center = false;
				var tocolor = "fill";
				var towhite = "stroke";
				var highlight_color = "#808080";
				var focus_node = null, highlight_node = null;
				var size = d3.scale.pow()
							.exponent(1)
							.domain([1,100])
							.range([8,24]);
				var colorSpec = d3.scale.linear().domain([0, 1]).range(["#84e184", "#1e7b1e"]); //['lime', 'green']); //d3.scale.linear().domain([0,10]).range(["red","green"]);
				colorSpec.nice();

				$( "#singleTreeTab" ).html("");
				//var tab = document.getElementById("singleTreeTab");
				var svg = d3.select( "#singleTreeTab" )
									  .append("div")
								      .classed("svg-container", true).style({"height":"inherit"}).style({"padding-bottom":"0%"})
									  .append("svg:svg")
									  .attr("width", width)
									  .style("height", "inherit")
									  .attr("preserveAspectRatio", "xMinYMin meet")
								      .classed("svg-content-responsive", true)
								      .style("top", 0)
								      .style("left", 0)
								      .style("position", 'absolute');
				//$("svg").css({top: 0, left: 0, position:'absolute'});
				
				svg.append("g")
						.classed("network", true);
				var graph = svg.selectAll("g.network")
						.attr("width", width)
						.style("height", "inherit");

				var toolTip = d3.tip()
							      .attr('class', 'd3-tip')
							      .offset([-10, 0])
				svg.call(toolTip);
				
							
				var zoom = d3.behavior.zoom()
				    .scaleExtent([min_zoom, max_zoom])
				    .on("zoom", function() {
									graph.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");									
								})
				//svg.call(zoom);
				
				if ( data !== null && data.count > 0 ) {		
										
					<#-- Adding the current step nodes -->
					var index = 0,
						oneD = 0, oneDPos = 1, oneDXPos = 0, 
						twoD = 0, twoDPos = 1, twoDXPos = 0, 
						threeD = 0, threeDPos = 1, threeDXPos = 0;
					var oneDs = 0, twoDs = 0, threeDs = 0;
					var intXInterval = 1, intYInterval = 1, 
						intXIndex = 0, intYIndex = 0,
						intXPos = 0, intYPos = 0;
					var totalInterests = 0;
					data.nodes.forEach(function(d){
						if ( d.stepNo == 1 ) {
							if ( d.group == 0 ) {
								oneDs++;
							}
							else if ( d.group == 1 ) {
								twoDs++;
							}
							else if ( d.group == 2 ) {
								threeDs++;
							}
						}
						else if ( d.stepNo == 2 ) {
							totalInterests++;
						}
					});
					
					console.log("size: ", totalInterests);
					if ( totalInterests < 25 && (25 - totalInterests) > 15 )
					var nodeSize = 25 - totalInterests;
					else if ( totalInterests < 50 && (50 - totalInterests) > 15 )
					nodeSize = 50 - totalInterests;
					else if ( totalInterests < 75 && (75 - totalInterests) > 15 )
					nodeSize = 75 - totalInterests;
					else if ( totalInterests < 100 && (100 - totalInterests) > 15 )
					nodeSize = 100 - totalInterests;
					else
					nodeSize = 15;

					var maxPub = Math.max.apply(Math,data.nodes.map(function(o){return (o.type == 3) ? o.group : -1;}));
	      			var maxAuth = Math.max.apply(Math,data.nodes.map(function(o){return (o.type == 1) ? o.group : -1;}));
	      			var maxInt = Math.max.apply(Math,data.nodes.map(function(o){return (o.type == 2) ? o.group : -1;}));
	      			var PubList = {};
	      			var AuthList = {};
	      			var IntList = {};
	      			
					data.nodes.forEach( function(e){
						var xStep = e.stepNo * (tWidth/5);
						
						stepWidth = ( ( STEP[e.stepNo] / 100 ) * tWidth );
						var orgId = e.id.split(":")[0],
							aditional = 0;
						var x = stepWidth/2,
							y = tHeight/2,
							fix = false;
						
						if ( e.stepNo == 0 ) {
							x = stepWidth/1.4;
							fix = true;
						}
						else if ( e.stepNo == sStep && orgId == stepId ){
							fix = true;
							x = stepWidth/1.1
						}
						else if ( e.stepNo == 5 ) {
							var addition = 0;
							if ( PubList[e.group] == null || PubList[e.group] == 'undefined' ) {
								//addition = stepWidth / 2;
								PubList[e.group] = 1.0;
							} else {
								addition = -stepWidth / 2 * PubList[e.group];
								aditional = PubList[e.group];
								PubList[e.group] = PubList[e.group] + 1.0;
								if ( PubList[e.group] >= 3 )
									return;
							}
																											
							fix = true;
							x = stepWidth/1.1 + addition;
							var tempY = e.group/maxPub;
							y = (tHeight+14) - (tempY*tHeight);
						}
						else if ( e.stepNo == 4 ) {
							var addition = 0;
							if ( AuthList[e.group] == null || AuthList[e.group] == 'undefined' ) {
								//addition = stepWidth / 2;
								AuthList[e.group] = 1.0;
							} else {
								addition = -stepWidth / 2 * AuthList[e.group];
								aditional = AuthList[e.group];
								AuthList[e.group] = AuthList[e.group] + 1.0;
								if ( AuthList[e.group] >= 3 )
									return;
							}
														
							fix = true;
							x = stepWidth/1.1 + addition;
							var tempY =  ( generalAlgorithmID == "interest" ? e.group/maxAuth : e.group/maxInt );
							y = (tHeight+14) - (tempY*tHeight);
							
						}
						else if ( e.stepNo == 3 ) {
							var addition = 0;
							if ( IntList[e.group] == null || IntList[e.group] == 'undefined' ) {
								//addition = stepWidth / 2;
								IntList[e.group] = 1.0;
							} else {
								addition = -stepWidth / 2 * IntList[e.group];
								aditional = IntList[e.group];
								IntList[e.group] = IntList[e.group] + 1.0;
								if ( IntList[e.group] >= 3 )
									return;
							}
							
							fix = true;
							x = stepWidth/1.1 + addition;
							var tempY = ( generalAlgorithmID == "interest" ? e.group/maxInt : e.group/maxAuth );
							y = (tHeight+14) - (tempY*tHeight);
						}
						else if ( e.stepNo == 2 ) {
							<#-- calculating Y position -->
							y = ( (tHeight) / 2 ) + ( intYPos * (nodeSize) );
							
							if ( y >= (tHeight-5) || y <= 5 ) {
								intYPos = 0; intYIndex = 0; intYInterval = 1;
								y = ( (tHeight) / 2 ) + ( intYPos * (nodeSize) ); 
								
								intXInterval = intXInterval * -1;
								intXIndex++;
								intXPos = ( intXPos + (intXIndex * intXInterval) );
							}
							
							intYInterval = intYInterval * -1;
							intYIndex++;
							intYPos = ( intYPos + (intYIndex * intYInterval) );
							
							x = ( 50 / 100 * stepWidth ) + ( intXPos * nodeSize );
							fix = true;
						}
						else if ( e.stepNo == 1 ) {
							if ( e.group == 0 ) {
								var maxCols = oneDs / 5;
								if ( oneDs < 10 )
									maxCols = 15;
								x = 30 / 100 * stepWidth - (oneDXPos * 15);
								y = ( tHeight / 2 ) + ( oneD * oneDPos * maxCols );
								oneD++;
								oneDPos = oneDPos * -1;
								if ( y >= (tHeight-5) || y <= 5 ) {
									y = ( tHeight / 2 );
									x = 30 / 100 * stepWidth - 15;
									oneD = 0; oneDPos = 1;
									oneDXPos++;
									oneDs--;
								}
								fix = true;
							}
							else if ( e.group == 1 ) {
								var maxCols = 6 / twoDs * 100 + 5;
								//if ( maxCols < 10 )
								//	maxCols = 10;
								x = 75 / 100 * stepWidth - (twoDXPos * 15);
								y = ( tHeight / 2 ) + ( twoD * twoDPos * maxCols );
								twoD++;
								twoDPos = twoDPos * -1;
								if ( y >= (tHeight-5) || y <= 5 ) {
									y = ( tHeight / 2 );
									x = 75 / 100 * stepWidth;
									twoD = 0; twoDPos = 1;
									twoDXPos++;
									//twoDs--;
								}
								fix = true;
							}
							else {
								var maxCols = threeDs / 2;
								if ( threeDs < 10 )
									maxCols = 15;
								x = stepWidth/1.1 - (threeDXPos * 15);
								y = ( tHeight / 2 ) + ( threeD * threeDPos * maxCols );
								threeD++;
								threeDPos = threeDPos * -1;
								if ( y >= (tHeight-5) || y <= 5 ) {
									y = ( tHeight / 2 );
									x = stepWidth/1.1;
									threeD = 0; threeDPos = 1;
									threeDXPos++;
									oneDs--;
								}
								fix = true;
							}
						}
						
						var sTreeN = {
							id: e.id,
							index: index++,
							group: e.group,
							type: d3.svg.symbolTypes[e.type],
							nodeType: e.type,
							size: (150/2),
							title: e.title,
							details: e.details,
							orgId: orgId,
							step: e.stepNo,
							wid: stepWidth,
							fixed: fix,
							x: x,
							y: y,
							cx: x,
							cy: y
						};
						//if (index < 1000)
						sTreeNodes.push(sTreeN);
						if ( sTreeStepNodes[e.stepNo] == null ) {
							var myNode = [];
							myNode.push(sTreeN);
							sTreeStepNodes[e.stepNo] = myNode;
						} else {
							var myNode = sTreeStepNodes[e.stepNo];
							myNode.push(sTreeN);
							sTreeStepNodes[e.stepNo] = myNode;
						}
					});
					
				    if ( data.links.length > 0 ) {		
				    	data.links.forEach(function(e) {
						
							var sourceNode, targetNode;
							for ( var index = 0; index < Object.keys(sTreeStepNodes).length; index++ ) {
					
								var item = Object.keys(sTreeStepNodes)[index];
						 		var tempSourceNode = sTreeNodes.filter(function(n) {
										return n.id === e.source;
									})[0];
						 			tempTargetNode = sTreeNodes.filter(function(n) {
										return n.id === e.target;
									})[0];
								
								if ( tempSourceNode !== null )
									sourceNode = tempSourceNode;
								if ( tempTargetNode !== null )
									targetNode = tempTargetNode;
							}
							
							if(sourceNode == null || targetNode == null) {
							}
							else {
								sTreeStepEdges.push({
									source: sourceNode,
									target: targetNode,
									weight: 5
								});
							}
						});
						
						//console.log("empty edges: ", sTreeNodes.filter(function(f){
						//	return typeof(f.source) == 'undefined' || typeof(f.target) == 'undefined';
						//}));
					}
		
					
					var link = graph.selectAll(".link");
					link = link.data( sTreeStepEdges );
	      			link.enter().append("line")
						.attr("class", "link").style( "stroke-width", nominal_stroke )
						.style("stroke", function(d) { 
							if ( d.group >= 0 ) return color(d.group);
							else return default_link_color; 
						});
					link.exit().remove();
					
				
					var x = 0
					var per = 14;	
					for ( var i = 1; i <= 6; i++ ) {	
						graph.append("g")
							.attr("id", "rec" + (i-1))
							.attr("transform", "translate(" + ( ( x / 100 ) * tWidth ) + "," + 0 + ")")
							.append("rect")
							.style("fill", ((i == sStep) ? "#aaaaaa" : "transparent" ))
							.style("opacity", 0)
							.attr("stroke", "black")
							.attr("width", (per + '%'))
							.attr("max-width", (per + '%'))
							.attr("height", tHeight);
						if ( i == 1 ) {
							x = x + 14;
							per = 20;
						}
						else if ( i == 2 ) {
							x = x + 20;
							per = 16.3;
						}
						else if ( i == 3 ) {
							x = x + 16.3;
							per = 16;
						}
						else if ( i == 4 ) {
							x = x + 16;
							per = 16;
						}
						else if ( i == 5 ) {
							x = x + 16;
							per = 16.567;
						}
						else {
							var x = x + 16.567;
							per = 16.567;
						}
					}
				
					toolTip.html(function(d) {
						return "<strong>" + (d.title) + " :  </strong> <span style='color:GhostWhite; text-transform: capitalize;'>" + (d.details) + "</span>";
					});
					
					<#-- Inserting nodes in each group element -->
					var graphSVGNodes = [];
					var graphSVGText = [];
					var moveHoriz = 5;
					var moveVert = 1;
					var force = d3.layout.force()
							.charge(-330)
	    					.linkDistance(40)
	    					.gravity(0.3)
							.size([tWidth,tHeight])
							.nodes(sTreeNodes)
							.links(sTreeStepEdges)
							.on("tick", function(e) {  	
								for ( var index = 0; index < graphSVGNodes.length; index++ ) {
									graphSVGNodes[index][0].forEach( function(g){
													
										var pX = parseFloat(graphSVGNodes[index][0].parentNode.attributes[1].value.replace("translate(","").replace(",0)",""));
														
										link[0]
										.forEach(function(el) {
											var d = d3.select(el).data()[0],
											line = d3.select(el);
				
											if (d.source.id == g.id) {
												var x = (parseFloat(g.getAttribute("cx")) + pX);
												var y = g.getAttribute("cy");
												line.attr('x1', x).attr('y1', y);
											} else if (d.target.id == g.id) {
												var x = (parseFloat(g.getAttribute("cx")) + pX);
												var y = g.getAttribute("cy");
												line.attr('x2', x).attr('y2', y);
											}
										});
									} );
								}
							});
					
					function started() {
				  var circle = d3.select(this).classed("dragging", true);
				
				  d3.event.on("drag", dragged).on("end", ended);
				
				  function dragged(d) {
				    circle.raise().attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
				  }
				
				  function ended() {
				    circle.classed("dragging", false);
				  }
				}
					var node_drag = d3.behavior.drag()
				        .on("dragstart", dragstart)
				        .on("drag", dragmove)
				        .on("dragend", dragend);
				
				    function dragstart(d, i) {
				        //force.stop() // stops the force auto positioning before you start dragging
				    }
				
				    function dragmove(d, i) {
				        d.px += d3.event.dx;
				        d.py += d3.event.dy;
				        d.x += d3.event.dx;
				        d.y += d3.event.dy; 
				        //tick(); // this is the key to make it work together with updating both px,py,x,y on d !
				    }
				
				    function dragend(d, i) {
				        d.fixed = true; // of course set the node to fixed so the force doesn't include the node in its auto positioning stuff
				        //tick();
				        //force.resume();
				    }	
						
					// Resolve collisions between nodes.
					function collide(alpha) {
					  var quadtree = d3.geom.quadtree(sTreeNodes);
					  return function(d) {
					    var r = d.size,
					        nx1 = d.x - r,
					        nx2 = d.x + r,
					        ny1 = d.y - r,
					        ny2 = d.y + r;
					    quadtree.visit(function(quad, x1, y1, x2, y2) {
					      if (quad.point && (quad.point !== d)) {
					        var x = d.x - quad.point.x,
					            y = d.y - quad.point.y,
					            l = Math.sqrt(x * x + y * y),
					            r = d.size + quad.point.radius;
					        if (l < r) {
					          l = (l - r) / l * alpha;
					          d.x -= x *= l;
					          d.y -= y *= l;
					          quad.point.x += x;
					          quad.point.y += y;
					        }
					      }
					      return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
					    });
					  };
					}
  								
					for ( var index = 0; index < Object.keys(sTreeStepNodes).length; index++ ) {
					
						var item = Object.keys(sTreeStepNodes)[index];
						
						var topPub = Math.max.apply(Math,sTreeStepNodes[item].map(function(o){return (o.nodeType == 3) ? o.group : -1;}));
	      				var topAuth = Math.max.apply(Math,sTreeStepNodes[item].map(function(o){return (o.nodeType == 1) ? o.group : -1;}));
	      				var topInt = Math.max.apply(Math,sTreeStepNodes[item].map(function(o){return (o.nodeType == 2) ? o.group : -1;}));
	      			
												
						var genralNodes = graph.select("#rec"+item).selectAll(".node");
						var pX = parseFloat(graph.select("#rec"+item)[0][0].attributes[1].value.replace("translate(","").replace(",0)",""));
						
						var nodeGroup = genralNodes.data(sTreeStepNodes[item]).enter()
							.append("g")
							.attr("class", "node")
					        .call(node_drag);
						var circle = nodeGroup
							.append("path")
							.attr("id", function(d){ return d.id; })
							.attr("step", function(d){ return d.step; })
							.attr("d", d3.svg.symbol()
							.size( function(d) { return d.size ; })
							.type(function(d) { 
								return d.type;
							}))
							.style("stroke-width", function(o){
								return (o.id == (stepId + ":" + sStep)) ? 3.0 : nominal_stroke;
							})
							.style("stroke", function(o){ return (o.id == (stepId + ":" + sStep)) ? highlight_color : default_link_color; })
							.attr("cx", function(d) { return d.x; })
							.attr("cy", function(d) { return d.y; })
							.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
							.style(tocolor, function(d) {
								if ( d.step == 3 || d.step == 4 || d.step == 5 ) {
									if ( d.nodeType == 1 )
										return colorSpec(d.group/topAuth);
									else if ( d.nodeType == 2 )
										return colorSpec(d.group/topInt);
									else if ( d.nodeType == 3 )
										return colorSpec(d.group/topPub);
								} else {
									if ( d.group == 0 )
										return "#1f77b4";
									else if ( d.group == 1 )
										return "#ff7f0e ";
									else if ( d.group == 2 )
										return "#2ca02c";
									else if ( d.group == 4 )
										return "#9467bd";
									else
										return color(d.group);
								}
							})
							.on('mouseover', function (d,i) {
								generalGraph.style("cursor","pointer");
								toolTip.show(d);
								this.parentNode.appendChild(this);
								//var selectedCircle = d3.select("#c" + i)
								//	selectedCircle.transition().duration(250)
							    //    	.attr("r", selectedCircle.attr("size") * 1.2);
							})
							.on('mouseout', function (d,i) {
								toolTip.hide(d)
								//var selectedCircle = d3.select("#c" + i)
								//	selectedCircle.transition()
								//	.attr("r", selectedCircle.attr("size") );
								
							})
							.on("click", function(e){
								<#-- Toggle selected node highlight -->
								if ( f_node !== null && f_node.id == e.id ) {
									exit_highlight();
									f_node = null;
								}
								else {
									f_node = e;
									//addPublicationDetails(e);
									set_highlight(e);
									getNodeDetails( e );
									switchDetailsTab( false );
								}
								
								<#-- Toggle single node tree 
								if (selectedItem == e.id) {
						            toggleSingleTreeTab(true);
							        selectedItem = null;
					            } else {
					            	toggleSingleTreeTab(false);
					            	selectedItem = e.id;
									singleTreeGraph( stepNo, e );
					            }-->
					        });
					    var nodeText = nodeGroup.append("g")
							.style("display", function(e){
								if ( e.step == 1 || e.step == 2 )
				            		return "none";
				            	else
				            		return "block";
							})
							.attr("cx", function(d){ return d.x; })
							.attr("cy", function(d){ return d.y; })
							.attr("transform", function(d) { return "translate(" + (d.x-7) + "," + (d.y+5) + ")"; });
					    var text = nodeText.append("text")
				            .style("text-anchor","end") 
				            .attr("startOffset","50%")
				            .attr("fixed", true)
				            .style("font", function(o){ return (o.id == (stepId + ":" + sStep)) ? "20px sans-serif" : ""; })
							.html(function(d) {
								//if(d.step == 0 || d.step == 3 || d.step == 4 || d.step == 5) { 
									var endString = d.details;
									if ( endString.includes( "</br>" ) )
										endString = endString.substring( 0, endString.indexOf( "</br>" ) );
									
									<#-- Checking if node is Publication from Top N -->
									var cuttof = 30;
									if ( d.step == 5 ){
										for ( var i = 0; i < Object.keys(PubList).length; i++ ) {
											var keyGroup = Object.keys(PubList)[i];
											if ( d.group == keyGroup && PubList[keyGroup] > 1 ) {
												cuttof = cuttof / PubList[keyGroup];
											}
										}
									}
									<#-- Checking if node is Author from Top N -->
									else if ( d.step == 4 ){
										for ( var i = 0; i < Object.keys(AuthList).length; i++ ) {
											var keyGroup = Object.keys(AuthList)[i];
											if ( d.group == keyGroup && AuthList[keyGroup] > 1 ) {
												cuttof = endString.length / AuthList[keyGroup];
											}
										}
									}
									<#-- Checking if node is Interest from Top N -->
									else if ( d.step == 3 ){
										for ( var i = 0; i < Object.keys(IntList).length; i++ ) {
											var keyGroup = Object.keys(IntList)[i];
											if ( d.group == keyGroup && IntList[keyGroup] > 1 ) {
												cuttof = cuttof / IntList[keyGroup];
											}
										}
									}
																		
									endString = (endString.length >= cuttof) ? endString.substring(0, cuttof) + "... " : (endString);
									return endString; 
								//}
								//else
								//	return "";
							 })
							.call(getBB);
						nodeText.insert("rect","text")
						    .attr("width", function(d){return d.bbox.width})
						    .attr("height", function(d){return d.bbox.height})
						    .style("fill", "white")
						    .attr("transform", "scale(-1,-1)");
						    
				    	graphSVGNodes.push(circle);
				    	graphSVGText.push(nodeText);
				    }
				   
				   	setTimeout( function() {
						var n = 2;
						force.start();
						for (var i = n; i > 0; --i) force.tick();
						force.stop();
					}, 0 );
								
					<#-- Function to highligh the selected node and link -->
    				function set_highlight(d)
					{
						$.each( graphSVGNodes, function( index, value ) {
							value.style(towhite, function(o) {
								return isConnected(d, o) || isConnected(o, d) ? highlight_color : color(d.group*5);
							})
							.style("opacity", function(o) {
								return isConnected(d, o) || isConnected(o, d) ? 1 : 0.25;
							});
						} );
						$.each( graphSVGText, function( index, value ) {
							value.style("font-weight", function(o) {
								return isConnected(d, o) ? "bold" : "normal";
							})
							.style("display", function(o) {
									return isConnected(d, o) || isConnected(o, d) ? "block" : "none";
								});
						} );
						link.style("stroke", function(o) {
								return o.source.index == d.index || o.target.index == d.index ? highlight_color : default_link_color;
							})
							.style( "stroke-width", function(o) {
								return o.source.index == d.index || o.target.index == d.index ? 1.0 : 0.0;
							})
							.sort( function( o, b ) {
								return o.source.index == d.index || o.target.index == d.index ? 1 : 0;
							} );
					}
					
					<#-- Function to exit the highlighted node and link -->
					function exit_highlight()
					{
						$.each( graphSVGNodes, function( index, value ) {
							value.style(towhite, "white")
								.style("opacity", 1);
						} );
						$.each( graphSVGText, function( index, value ) {
							value.style("font-weight", "normal")
							.style("display", function(d){
								if (d.step == 1 || d.step == 2) return "none";
								else	return "block";
							});
						} );
						link.style("stroke", function(o) {
								return default_link_color
							})
							.style("stroke-width", nominal_stroke)
							//.sort( 0 )
							;
					}
					
					<#-- Storing the connected nodes -->
					var linkedByIndex = {};
					$.each(sTreeStepEdges, function( index, d ) {
						linkedByIndex[d.source.id + "," + d.target.id] = true;
					});
					
					function isConnected(a, b) {
						return linkedByIndex[a.id + "," + b.id] || linkedByIndex[b.id + "," + a.id] || a.id == b.id;
					}
							
					function hasConnections(a) {
						for (var property in linkedByIndex) {
							s = property.split(",");
							if ((s[0] == a.id || s[1] == a.id) && linkedByIndex[property])
								return true;
						}
						return false;
					}
				}
				$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) );
			}
		});
	}
	
	var detailsReq = null;
	function getNodeDetails( selectedNode ) {
		var detailContainer = $( "#node_details" );
		detailContainer.html("");
		
		if ( selectedNode.nodeType == 0 || selectedNode.nodeType == 1 ) {
			<#-- Extract author infromation -->
			detailsReq = 
				$.ajax({
					type: "GET",
					url : "<@spring.url '/researcher/basicInformation?id=' />" + selectedNode.orgId,
					accepts: "application/json, text/javascript, */*; q=0.01",
					beforeStart: function ( e ) {
						detailContainer.append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
						if ( detailsReq !== null )
							detailsReq.abort();
					},
					error: function() {
						detailContainer.html("");
					},
					success: function( data ){
						detailContainer.html("");
						detailsReq = null;
						var researcherDiv = 
							$( '<div/>' )
								.addClass( 'author static' );
								
							var researcherNav =
							$( '<div/>' )
								.addClass( 'nav medium' );
								
							var researcherDetail =
							$( '<div/>' )
								.addClass( 'detail static' )
								.append(
									$( '<div/>' )
										.addClass( 'name capitalize' )
										.html( "<a target='_blank' href='<@spring.url '/researcher' />?id=" + data.author.id + "&name=" + data.author.name + "'>" + data.author.name + "</a>" )
								);
								
							researcherDiv
								.append(
									researcherNav
								).append(
									researcherDetail
								);
								
							if( !data.author.isAdded ){
								researcherDetail.addClass( "text-gray" );
							}
							
							<#-- status -->
							if( typeof data.author.status != 'undefined')
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'status' )
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-briefcase icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.status )
									)
								);
							
							<#-- affiliation -->
							if( typeof data.author.aff != 'undefined')
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation' )
									.css({ "clear" : "both"})
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-institution icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.aff )
									)
								);
								
							<#-- email -->
							if( typeof data.author.email != 'undefined' && data.author.email != "" )
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation' )
									.css({ "clear" : "both"})
									.attr({ "title": data.author.name + " email" })
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-envelope icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.email )
									)
								);
								
							<#-- homepage -->
							if( typeof data.author.homepage != 'undefined' && data.author.homepage != "" )
								researcherDetail.append(
									$( '<div/>' )
									.addClass( 'affiliation urlstyle' )
									.css({ "clear" : "both"})
									.attr({ "title": data.author.name + " homepage" })
									.append( 
										$( '<i/>' )
										.addClass( 'fa fa-globe icon font-xs' )
									).append( 
										$( '<span/>' )
										.addClass( 'info font-xs' )
										.html( data.author.homepage )
									).click( function( event ){ event.preventDefault();window.open( data.author.homepage, data.author.name + " homepage" ,'scrollbars=yes,width=650,height=500')})
								);
								
							if( typeof data.author.publicationsNumber != 'undefined'){
									var citedBy = 0;
									if( typeof data.author.citedBy !== "undefined" )
										citedBy = data.author.citedBy;
									researcherDetail.append(
										$( '<div/>' )
										.addClass( 'paper font-xs' )
										.css({ "clear" : "both"})
										.html( "<strong>Publications: " + data.author.publicationsNumber + " || Cited by: " + citedBy + "</strong>" )
									);
								}
								
							if( typeof data.author.photo != 'undefined'){
								researcherNav
									.append(
									$( '<div/>' )
										.addClass( 'photo medium' )
										.css({ 'font-size':'14px'})
										.append(
											$( '<img/>' )
												.attr({ 'src' : data.author.photo })
										)
									);
							} else {
								researcherNav
								.append(
									$( '<div/>' )
									.addClass( 'photo medium fa fa-user' )
								);
							}
						detailContainer
								.append( 
									researcherDiv
								);
					}
				});
		} 
		else if ( selectedNode.nodeType == 2 ) {
			<#-- Extract interest infromation 
			detailsReq = 
				$.ajax({
					type: "GET",
					url : "<@spring.url '/researcher/basicInformation?id=' />" + selectedNode.id,
					accepts: "application/json, text/javascript, */*; q=0.01",
					beforeStart: function ( e ) {
						if ( detailsReq !== null )
							detailsReq.abort();
					},
					success: function( details ){
						console.log("details", details);
					}
				});-->
		}
		else if ( selectedNode.nodeType == 3 ) {
			<#-- Extract publication infromation -->
			detailsReq = 
				$.ajax({
					type: "GET",
					url : "<@spring.url '/publication/detail?id=' />" + selectedNode.orgId,
					accepts: "application/json, text/javascript, */*; q=0.01",
					beforeStart: function ( e ) {
						detailContainer.append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
						if ( detailsReq !== null )
							detailsReq.abort();
					},
					error: function() {
						detailContainer.html("");
					},
					success: function( data ){
						detailContainer.html("");
						detailsReq = null;
						<#-- title -->
						var pubTitle = 
							$('<dl/>')
							.addClass( "palm_section" )
							.append(
								$('<dt/>')
								.addClass( "palm_label" )
								.html( "Title :" )
							).append(
								$('<dd/>')
								.addClass( "palm_content" )
								.html( "<a target='_blank' href='<@spring.url '/publication' />?id=" + data.publication.id + "&title=" + 
								data.publication.title +"'>" + data.publication.title + "</a>" )
							);
		
						<#-- authors -->
						var pubCoauthor = 
							$('<dl/>')
							.addClass( "palm_pub_coauthor_blck" );
		
						var pubCoauthorHeader =
							$('<dt/>')
							.addClass( "palm_label" )
							.html( "Authors :" );
		
						var pubCoauthorContainer = $( '<dd/>' )
													.addClass( "author-list" );
		
						$.each( data.publication.coauthor, function( index, authorItem ){
							var eachAuthor = $( '<span/>' );
							
							<#-- photo -->
							var eachAuthorImage = null;
							if( typeof authorItem.photo !== 'undefined' ){
								eachAuthorImage = $( '<img/>' )
									.addClass( "timeline-author-img" )
									.attr({ "width":"40px" , "src" : authorItem.photo , "alt" : authorItem.name });
							} else {
								eachAuthorImage = $( '<i/>' )
									.addClass( "fa fa-user bg-aqua" )
									.attr({ "title" : authorItem.name });
							}
							eachAuthor.append( eachAuthorImage );
		
							<#-- name -->
							var eachAuthorName = $( '<a/>' )
												.css({"padding" : "0 15px 0 5px"})
												.html( authorItem.name );
							
							eachAuthorName.attr({ "href" : "<@spring.url '/researcher' />?id=" + authorItem.id + "&name=" + authorItem.name})
											.attr({ "target" : "_blank" });
							
							eachAuthor.append( eachAuthorName );
							
							pubCoauthorContainer.append( eachAuthor );
						});
		
						pubCoauthor
							.append( pubCoauthorHeader )
							.append( pubCoauthorContainer );
		
						detailContainer
							.append( pubTitle )
							.append( pubCoauthor );
		
						<#-- abstract -->
						if( typeof data.publication.abstract != 'undefined'){
							var pubAbstract = 
								$('<dl/>')
								.addClass( "palm_section abstractSec" )
								.append(
									$('<dt/>')
									.addClass( "palm_label" )
									.html( "Abstract :" )
								).append(
									$('<dd/>')
									.addClass( "palm_content" )
									.html( data.publication.abstract )
								);
									
						detailContainer
							.append( pubAbstract );
						}
						
						<#-- keywords -->
						if( typeof data.publication.keyword != 'undefined'){
							var pubKeyword = 
								$('<dl/>')
								.addClass( "palm_section keywordSec" )
								.append(
									$('<dt/>')
									.addClass( "palm_label" )
									.html( "Keywords :" )
								).append(
									$('<dd/>')
									.addClass( "palm_content" )
									.html( data.publication.keyword )
								);
									
						detailContainer
							.append( pubKeyword );
						}
						
						<#-- references -->
						if( typeof data.publication.reference != 'undefined'){
							var pubReference = 
								$('<dl/>')
								.addClass( "palm_section" )
								.append(
									$('<dt/>')
									.addClass( "palm_label" )
									.html( "Reference :" )
								).append(
									$('<dd/>')
									.addClass( "palm_content" )
									.html( data.publication.reference )
								);
									
						detailContainer
							.append( pubReference );
						}
					}
				});
		}
	}
	
	<#-- change the legend selection -->
	function updateLegendSelected( selected ) {
		
		for ( var i = 0; i < 6; i++ )
			$( "#legendGraph" ).find( "#rec" + i ).find( "rect" ).css('fill', 'transparent');

		if ( selected !== 0 ) {
			$( "#legendGraph" ).find( "#rec" + (selected-1) ).find( "rect" ).css('fill', '#B5DFF6');
		}
		$( "#legendGraph" ).find( "#rec" + selected ).find( "rect" ).css('fill', '#B5DFF6');
	} 
	
	function createLegend() {

				var lWidth = width+30;
				
				var legendSVG = d3.select( "#legendGraph" )
		        	.style("height", 100)
					.append("div")
					.classed("svg-container", true).style({"height":"inherit"}).style({"padding-bottom":"0%"}).style({"width":"100%"})
					.append("svg:svg")
					.attr("width", lWidth)
					.style("height", 100)
					.style("top", 0)
					.style("left", 0)
					.style("position", "inherit")
					.attr("viewBox", "0 0 "+lWidth+" 100")
					.attr("preserveAspectRatio", "xMaxYMax meet")
					.classed("svg-content-responsive", true);

		        var legend = legendSVG
					.append("g")
					.classed("network", true)
					.attr("width", lWidth)
					.style("height", 100)
					.attr("transform", "translate(" + 10 + "," + 0 +") rotate(180) scale(-1, -1)");
				
				
				var legendtoolTip = d3.tip()
							      .attr('class', 'd3-tip')
							      .offset([-10, 0])
				legendSVG.call(legendtoolTip);
				
				var legendGraph = legend.selectAll("g.network");
				var legendStepWidth = 
				( 6 / 100 ) * lWidth;
				var x = 0
				var per = 13;	
				for ( var i = 1; i <= 6; i++ ) {	
					legend.append("g")
						.attr("id", "rec" + (i-1))
						.attr("transform", "translate(" + ( ( x / 100 ) * lWidth ) + "," + 0 + ")")
							.append("rect")
							.style("opacity", 0)
							.style("fill", "transparent")
							.attr("stroke", "black")
							.attr("width", (per + '%'))
							.attr("height", 100);
					if ( i == 1 ) {
						x = x + 13.55;
					}
					else {
						var x = x + 18;
					}
					per = 17.4;
				}
				
				var color = d3.scale.category10();
				var color_scale = d3.scale.linear().domain([0, 30]).range(["#84e184", "#1e7b1e"]);
				
				if ( generalAlgorithmID == "interest" )
				{
					var legendData = [{id:0, y:100/2, x:(legendStepWidth/1.5), type:d3.svg.symbolTypes[0], color:0, text:"Active Researcher"},
									{id:1, y:100/4, x:(legendStepWidth*3.3), type:d3.svg.symbolTypes[1], color:0, text:"1D CoAuthor"},
									{id:2, y:100/2, x:(legendStepWidth*3.3), type:d3.svg.symbolTypes[1], color:1, text:"2D CoAuthor"},
									{id:5, y:100/1.3, x:(legendStepWidth*3.3), type:d3.svg.symbolTypes[1], color:4, text:"3D CoAuthor"},
									{id:7, y:100/2, x:(legendStepWidth*6.5), type:d3.svg.symbolTypes[2], color:0, text:"Interest"},
									{id:9, y:100/2, x:(legendStepWidth*9.5), type:d3.svg.symbolTypes[2], color:10, text:"Interest"},
									{id:12, y:100/2, x:(legendStepWidth*11.5+20), type:d3.svg.symbolTypes[1], color:20, text:"Author"},
									{id:14, y:100/3.5, x:(legendStepWidth*14.0+10), type:d3.svg.symbolTypes[3], color:10, text:"Publication"},
									{id:15, y:100/2, x:(legendStepWidth*14.0+10), type:d3.svg.symbolTypes[2], color:10, text:"Interest"}];
					var legendLink = [{source:0, target:1},{source:1, target:2},{source:1, target:3},{source:2, target:5},{source:3, target:4}
					,{source:5, target:7},{source:5, target:6},{source:4, target:7},{source:6, target:8},{source:7, target:8},{source:6, target:7}
					,{source:8, target:10},{source:7, target:9},{source:9, target:13},{source:10, target:11},{source:10, target:12},{source:13, target:14}
					,{source:12, target:15},{source:11, target:16},{source:15, target:14},{source:15, target:17},{source:15, target:18},{source:16, target:18}];
				}
				else if ( generalAlgorithmID == "c3d" ) {
					var legendData = [{id:0, y:100/2, x:(legendStepWidth/1.5), type:d3.svg.symbolTypes[0], color:0, text:"Active Researcher"},
									{id:2, y:100/1.5, x:(legendStepWidth*3.5+25), type:d3.svg.symbolTypes[1], color:0, text:"1D CoAuthor"},
									{id:3, y:100/3.5, x:(legendStepWidth*3.5+25), type:d3.svg.symbolTypes[1], color:0, text:"1D CoAuthor"},
									{id:4, y:100/3, x:(legendStepWidth*6+20), type:d3.svg.symbolTypes[1], color:1, text:"2D CoAuthor"},
									{id:5, y:100/1.5, x:(legendStepWidth*6+20), type:d3.svg.symbolTypes[1], color:1, text:"2D CoAuthor"},
									{id:6, y:100/1.5, x:(legendStepWidth*7.5), type:d3.svg.symbolTypes[1], color:4, text:"3D CoAuthor"},
									{id:7, y:100/3, x:(legendStepWidth*7.5), type:d3.svg.symbolTypes[1], color:4, text:"3D CoAuthor"},
									{id:8, y:100/1.5, x:(legendStepWidth*9), type:d3.svg.symbolTypes[1], color:15, text:"Author"},
									{id:9, y:100/3, x:(legendStepWidth*9.5+20), type:d3.svg.symbolTypes[1], color:10, text:"Author"},
									{id:10, y:100/1.5, x:(legendStepWidth*9.5+20), type:d3.svg.symbolTypes[1], color:14, text:"Author"},
									{id:11, y:100/1.5, x:(legendStepWidth*12.0+20), type:d3.svg.symbolTypes[2], color:17, text:"Interest"},
									{id:12, y:100/2.5, x:(legendStepWidth*11.5+20), type:d3.svg.symbolTypes[2], color:20, text:"Interest"},
									{id:13, y:100/5, x:(legendStepWidth*12.5+20), type:d3.svg.symbolTypes[2], color:10, text:"Interest"},
									{id:14, y:100/5, x:(legendStepWidth*14.0+10), type:d3.svg.symbolTypes[3], color:10, text:"Publication"},
									{id:15, y:100/3, x:(legendStepWidth*15.0), type:d3.svg.symbolTypes[2], color:10, text:"Interest"},
									{id:16, y:100/1.5, x:(legendStepWidth*14.5), type:d3.svg.symbolTypes[2], color:14, text:"Interest"},
									{id:17, y:100/5, x:(legendStepWidth*16.0), type:d3.svg.symbolTypes[3], color:16, text:"Publication"},
									{id:18, y:100/1.5, x:(legendStepWidth*16.0), type:d3.svg.symbolTypes[3], color:10, text:"Publication"}];
					var legendLink = [{source:0, target:2},{source:0, target:3},{source:2, target:5},{source:3, target:4}
					,{source:5, target:7},{source:5, target:6},{source:4, target:7},{source:6, target:8},{source:7, target:8},{source:6, target:7}
					,{source:6, target:10},{source:7, target:9},{source:9, target:13},{source:10, target:11},{source:10, target:12},{source:13, target:14}
					,{source:12, target:15},{source:11, target:16},{source:15, target:14},{source:15, target:17},{source:15, target:18},{source:16, target:18}];
				} 
				else {
					var legendData = [{id:0, y:100/2, x:(legendStepWidth/1.5), type:d3.svg.symbolTypes[0], color:0, text:"Active Researcher"},
									{id:2, y:100/2, x:(legendStepWidth*3.5+25), type:d3.svg.symbolTypes[1], color:0, text:"1D CoAuthor"},
									{id:4, y:100/2, x:(legendStepWidth*6+35), type:d3.svg.symbolTypes[1], color:1, text:"2D CoAuthor"},
									{id:8, y:100/2, x:(legendStepWidth*9+15), type:d3.svg.symbolTypes[1], color:15, text:"Author"},
									{id:11, y:100/2, x:(legendStepWidth*12.0+20), type:d3.svg.symbolTypes[2], color:17, text:"Interest"},
									{id:14, y:100/2, x:(legendStepWidth*14.0+25), type:d3.svg.symbolTypes[3], color:10, text:"Publication"}];
					var legendLink = [{source:0, target:2},{source:0, target:3},{source:2, target:5},{source:3, target:4}
					,{source:5, target:7},{source:5, target:6},{source:4, target:7},{source:6, target:8},{source:7, target:8},{source:6, target:7}
					,{source:6, target:10},{source:7, target:9},{source:9, target:13},{source:10, target:11},{source:10, target:12},{source:13, target:14}
					,{source:12, target:15},{source:11, target:16},{source:15, target:14},{source:15, target:17},{source:15, target:18},{source:16, target:18}];
				}
				var c10 = d3.scale.category10();
				
				console.log("scale 10: ", c10(0), " - ", c10(1), " - ", c10(2), " - ", c10(3), " - ", c10(4), " - ", c10(5), " - ", c10(6), " - ", c10(7), " - ", c10(8)
				, " - ", c10(9), " - ", c10(10));
				<#--var link = legend.selectAll(".link");
					link = link.data( legendLink )
	      			link.enter().append("line")
						.attr("class", "link").style( "stroke-width", 2 ).style("stroke", "#BBBBBB")
						.attr('x1', function(d) { return legendData.filter( function(n){return n.id == d.source;} )[0].x; })
				        .attr('y1', function(d) { return legendData.filter( function(n){return n.id == d.source;} )[0].y; })
				        .attr('x2', function(d) { return legendData.filter( function(n){return n.id == d.target;} )[0].x; })
				        .attr('y2', function(d) { return legendData.filter( function(n){return n.id == d.target;} )[0].y; });-->
					
				var legendGroup = legendGraph.data(legendData).enter()
						.append("g")
						.attr("class", "node")
						.style('transform', function(d){return 'translate(' + d.x + 'px, ' + d.y + 'px)'});
				var legendNodes = legendGroup
						.append("path")
						.attr("id","circle" + i)
						.attr("d", d3.svg.symbol()
							.size( 150/2 )
							.type(function(d) { 
								return d.type;
							}))
						.style("fill", function(d) {
							if ( d.color > 5 )
								return color_scale(d.color);
							else{
								console.log("item: ", d.color, " = ", c10(d.color));
								return c10(d.color);
							}
						})
						.style("opacity", 0.65)
						.on('mouseover', function (d,i) {
							generalGraph.style("cursor","pointer");
							legendtoolTip.show(d);
							//this.parentNode.appendChild(this);
						})
						.on('mouseout', function (d,i) {
							legendtoolTip.hide(d)
						});
				var legendTGroup = legendGroup.append("g");
				
				var legendNodes = legendTGroup.append("text")
				            .attr("dx", 12)
				            .attr("dy","0.2em")
				            //.append("textPath")
				            //.attr("xlink:href","#yyy")
				            //.attr("dy","1.5em")
				            //.attr("text-anchor", "middle")
				            .style("opacity", 0.65)
							.html(function(d) { return d.text })
							.call(getBB);
				<#-- legendTGroup.insert("rect","text")
						    .attr("width", function(d){return d.bbox.width})
						    .attr("height", function(d){return d.bbox.height})
						    .style("fill", "white")
				            .attr("text-anchor", "middle");-->
							
				legendtoolTip.html(function(d) {
						console.log("items: ", d);
						if ( d.id == 0 ) {	
							return "<span style='color:GhostWhite; width:150px; display:inline-block;'>Active Researcher (:You) or high profiled researcher for given filter.</span>";
						}
						else if ( d.id == 1 ) {
							return "<span style='color:GhostWhite;'>Co-Authors found in active researcher's publications.</span>";
						}
						else if ( d.id < 5 ) {
							return "<span style='color:GhostWhite; width:250px; display:inline-block;'>Co-Authors found in 1D Co-Author's publications. These authors are not used in algorithm, as Active Researcher already know them.</span>";
						}
						else if ( d.id == 5 ) {
							return "<span style='color:GhostWhite;'>Co-Authors found in 2D Co-Author's publications.</span>";
						}
						else if ( d.id < 9 ) {
							return "<span style='color:GhostWhite;'>Top 5 interests of each author from 2D and 3D Co-Authors.</span>";
						}
						else if ( d.id < 11 || d.id == 15 || d.id == 16 ) {
							return "<span style='color:GhostWhite;'>Top 'N' interests with highest centrality from Interest Network.</span>";
						}
						else if ( d.id < 14 ) {
							return "<span style='color:GhostWhite;'>Top 'N' authors which contain Top 'N' interests.</span>";
						}
						else if ( d.id == 14 || d.id == 17 || d.id == 18 ) {
							return "<span style='color:GhostWhite;'>Top 'N' publications which contain both Top 'N' interests</br>and Top 'N' authors.</span>";
						}
						else {
							return "<span style='color:GhostWhite;'>" + (d.text) + "</span>";
						}
					});
				<#-- var force = d3.layout.force()
							.charge(-330)
    						.linkDistance(40)
    						.gravity(0.3)
							.size([width,100])
							.links(legendLink)
							.on("tick", function(e) {  	
								link.attr("x1", function(d) { return d.source.x; })
									.attr("y1", function(d) { return d.source.y; })
								    .attr("x2", function(d) { return d.target.x; })
								    .attr("y2", function(d) { return d.target.y; });
							}).start(); -->
	}
	
</script>