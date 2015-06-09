 <@layout.global>

	<script>
		$( function() // begin document ready
		{
			<#-- change the size of main content -->
			$( "#col3" ).css( "margin", "0 0 0 15px");
			
			//$("#queries").elastic();
	    	snorql.loadQueries("#queries");
	      	snorql.start();
	    });
	</script>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox"> 
				<h1>SPARQL</h1>
				<h2 id="title">Snorql: </h1>
				
				<!-- copied content -->
				<div class="section" style="float: right; width: 8em">
			      <h2>Browse:</h2>
			      <ul>
			        <li><a class="graph-link" href="?browse=superclasses">Super Classes</a></li>
			        <li><a class="graph-link" href="?browse=classes">Classes</a></li>
			        <li><a class="graph-link" href="?browse=properties">Properties</a></li>
			        <li id="browse-named-graphs-link"><a href="?browse=graphs">Named Graphs</a></li>
			      </ul>
			    </div>
			
			    <div id="default-graph-section" class="section" style="margin-right: 12em">
			      <h2 style="display: inline">GRAPH:</h2>
			      <p style="display: inline">
			        Default graph.
			        <a href="?browse=graphs">List named graphs</a>
			      </p>
			    </div>
			
			    <div id="named-graph-section" class="section" style="margin-right: 12em">
			      <h2 style="display: inline">GRAPH:</h2>
			      <p style="display: inline">
			        <span id="selected-named-graph">Named graph goes here</span>.
			        <a href="javascript:snorql.switchToDefaultGraph()">Switch back to default graph</a>
			      </p>
			    </div>
			    
			    <div class="section" style="margin-right: 12em">
			      <h2 style="display: inline">Select an example</h2>
			      <p>
			        <select id="queries" style="font-size: 110%; padding: 5px; border: 1px solid #ddd;width:90%"></select>
			      </p>
			      <p id="filters">
			      filter by: 
			      </p>
			    </div>    
			
			    <div class="section" style="margin-right: 12em">
			      <h2>SPARQL:</h2>
			      <pre id="prefixestext"></pre>
			      <form id="queryform" action="#" method="get"><div>
			        <input type="hidden" name="query" value="" id="query" />
			        <input type="hidden" name="output" value="json" id="jsonoutput" disabled="disabled" />
			        <input type="hidden" name="stylesheet" value="" id="stylesheet" disabled="disabled" />
			        <input type="hidden" name="graph" value="" id="graph-uri" disabled="disabled" />
			      </div></form>
			      <div>
			        <textarea name="query" id="querytext"></textarea>
			        Results: <div id="time"></div>
			        <select id="selectoutput" onchange="snorql.updateOutputMode()">
			          <option selected="selected" value="browse">Browse</option>
			          <option value="json">as JSON</option>
			          <option value="xml">as XML</option>
			          <option value="xslt">as XML+XSLT</option>
			        </select>
			        <span id="xsltcontainer"><span id="xsltinput">
			          XSLT stylesheet URL:
			          <input id="xsltstylesheet" type="text" value="snorql/xml-to-html.xsl" size="30" />
			        </span></span>
			        <input type="button" value="Go!" onclick="snorql.submitQuery()" />
			        <input type="button" value="Reset" onclick="snorql.resetQuery()" />
			        <input type="button" value="Insert" onclick="insertData()" />
			      </div>
			    </div>
			
			    <div class="section">
			      <div id="result"><span></span></div>
			    </div>
				<!-- end copied content -->
				
			</div>
 		</div>
		<!-- IE clearing - important! -->
		<div id="ie_clearing">&nbsp;</div>
		
		<script>
			function insertData(){
				$( "#queryresults > td" ).find( "a.first" ).each( function(){
					console.log( $( this ).attr( "href" ));
				});
			}
		</script>
 	</@content.main>
 	
</@layout.global>