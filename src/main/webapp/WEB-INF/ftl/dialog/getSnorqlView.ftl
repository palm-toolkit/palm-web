 <html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Visual Analytics of Conference Network</title>
		<meta name="keywords" content="Visual Analytics of Conference Network" />
		<meta name="description" content="Visual Analytics of Conference Network" />
	<!-- internal missy css definition -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/snorql.css' />" />
	
	<script>
		var baseUrl = "<@spring.url '' />";
	</script>
	
	<!-- external -->
	<!-- simplifies javascript programming -->
	<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>
	
	<!-- sparql -->
	<script src="<@spring.url '/resources/scripts/sparql.js' />"></script>
	<script src="<@spring.url '/resources/scripts/namespaces.js' />"></script>
	<script src="<@spring.url '/resources/scripts/snorql.js' />"></script>
	<script>
		$( function() // begin document ready
		{
	    	snorql.loadQueries("#queries");
	      	snorql.start();
	    });
	</script>

	<body>
		<div id="snorql">
			<div id="snorql-header">
				<div id="snorql-title">
					<h1>Explore: http://lak.linkededucation.org/</h1>
				</div>
				<div id="top-menu">
				  <ul id="snorql-menu">
				    <li><a class="graph-link" href="?browse=classes">Classes</a></li>
				    <li><a class="graph-link" href="?browse=properties">Properties</a></li>
				  </ul>
				</div>
			</div>
			
			<div id="snorql-body">
			  <div class="snorql-section">
				  <label class="snorql-label">Saved queries :</label>
			      <select id="queries"></select>
		      </div>
		      <div class="snorql-section">
			  	 <label class="snorql-label">Sparql Query :</label>
				  <pre id="prefixestext"></pre>
				  <form id="queryform" action="#" method="get">
					  <div>
					    <input type="hidden" name="query" value="" id="query" />
					    <input type="hidden" name="output" value="json" id="jsonoutput" disabled="disabled" />
					    <input type="hidden" name="stylesheet" value="" id="stylesheet" disabled="disabled" />
					    <input type="hidden" name="graph" value="" id="graph-uri" disabled="disabled" />
					  </div>
				  </form>
		      	  <textarea name="query" id="querytext"></textarea>
		       <div>
			    <label class="snorql-label">Results: </label>
			    <div id="time"></div>
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
			</div>    
			
			<div class="section">
			  <div id="result"><span></span></div>
			</div>
			<#--
			<iframe id="iframeResult" style="width:100%;min-height:500px;" alt="external source" width="1" height="1" scrolling="yes" frameborder="no" marginheight="0" marginwidth="0" border="0" src=""></iframe>
			-->
		</div>
		
		<script>
			var urlarray = [];
			var urlarrayIndex = 0;
				
			function insertData(){
				$("#result").find( "td" ).find("a:first").each( function(){
					urlarray.push( $( this ).attr( "href" ));
				});
				// using ajax loop the entire url
				loadIframe();
			}
			
			function openLinks(){
				if( urlarrayIndex < urlarray.length ){
					console.log( urlarray[urlarrayIndex] );
					$.get( urlarray[urlarrayIndex] , function ( data ){
						console.log( data );
						urlarrayIndex++;
						setTimeout(function(){ openLinks() },2000);
					});
				}
			}
			
			function loadIframe() {
				if( urlarrayIndex < urlarray.length ){
					console.log( urlarray[urlarrayIndex] );
					//$('#iframeResult').attr('src', "http://localhost:8081/" + urlarray[urlarrayIndex]);  
					window.open("http://localhost:8081/" + urlarray[urlarrayIndex], '_blank');
					urlarrayIndex++;
					
					setTimeout(function(){ loadIframe() },700);
				}
			}
			
		</script>
	</body>
</html>