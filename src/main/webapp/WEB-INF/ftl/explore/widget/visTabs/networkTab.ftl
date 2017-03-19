<#-- NETWORK TAB -->
function tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, reload)
{
	var tabContainer = $( widgetElem ).find( "#tab_Network" );
	var canvasDiv = $('<div/>').attr({'id': 'canvas'});
	tabContent.html("");
	tabContent.append(canvasDiv);
	s = new sigma(),
	cam = s.addCamera();
	
	<#-- Initialize two distinct renderers, each with its own settings -->
	s.addRenderer(
	{
		container: document.getElementById('canvas'),
		type: 'canvas',
		camera: cam,
		settings: {
			labelColor: 'node',
			enableEdgeHovering: 'true',
			edgeHoverColor: 'edge',
			edgeHoverExtremities: 'true',
			doubleClickZoomingRatio: 1.7,
			labelThreshold: 4,
			zoomMax: 50,
			defaultLabelSize: 13,
			edgeColor:"default",
		}
	});
	s.settings(
	{
        	enableEdgeHovering: 'true',
        	autoRescale:  ['nodeSize'],
        	maxNodeSize: 5,
	})
		
    var edgeSizes = [];
	if(reload!="true")
	{
		$.getJSON( url , function( data ) 
		{
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );
		
			<#-- gephi network -->
			sigma.parsers.gexf( "<@spring.url '/resources/gexf/'/>" + data.map.graphFile ,s,function() 
			{
				s.refresh();
				
				if(s.graph.nodes().length==0 && s.graph.edges().length==0)
				{
					tabContent.html("")
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No authors satisfy the specified criteria!" );
					return false;
				}
				
				if(data.oldVis=="false")
				{
					graphFile=data.map.graphFile;
	
					<#-- Zoom out - single frame -->
					if(s.graph.nodes().length < 20)
					{
						s.camera.goTo({
						  x: 15,
						  y: 0,
						  ratio: 0.2
						});
					}
					if(s.graph.nodes().length > 200)
					{
						s.camera.goTo({
						  x: 0,
						  y: 0,
						  ratio: 1.5
						});
					}
				
					s.renderers[0].bind("render", function (e) 
					{
						cameraX = e.target.camera.x;
						cameraY = e.target.camera.y;
						cameraRatio = e.target.camera.ratio;
					});
				
					
					s.graph.nodes().forEach(function(n) 
					{
				        n.originalColor = n.color;
				    });
				    s.graph.edges().forEach(function(e) 
				    {
				        e.originalColor = e.color;
				        edgeSizes.push(e.size)
				    });
				      
					s.bind('clickNode rightClickNode', function(e)
					{
						var nodeId = e.data.node.id,
	        			toKeep = s.graph.neighbors(nodeId);
				        toKeep[nodeId] = e.data.node;
				        s.graph.nodes().forEach(function(n) 
				        {
				          if (toKeep[n.id])
				            n.color = n.originalColor;
				          else
				            n.color = '#c9c0c2';
				        });
				
				        s.graph.edges().forEach(function(e) 
				        {
				          if (toKeep[e.source] && toKeep[e.target])
				            e.color = e.originalColor;
				          else
				            e.color = '#c9c0c2';
				        });
				
				        s.refresh();
					})
					
					s.bind('clickStage', function(e)
					{
						hidehoverdiv('divhold');
				        s.graph.nodes().forEach(function(n) 
				        {
				            n.color = n.originalColor;
				        });
				        s.graph.edges().forEach(function(e) 
				        {
				            e.color = e.originalColor;
				        });
				        s.refresh();
					})
					
					s.bind('clickNode', function(e)
					{
						if(e.data.captor.ctrlKey == false)
						{ 
							if(e.data.node.attributes.isadded==false)
							{
								var text = e.data.node.label;
								showhoverdiv(e,'divhold', text.toUpperCase() + " is currently not added to PALM");
							}
							else
								showmenudiv(e,'menu');
						}	
					})
					
					s.bind('overEdge',function(e)
					{
						showhoverdiv(e,'divhold', "co-authored " + Math.round(e.data.edge.weight / 0.1) + " time(s)");
					})
					s.bind('outEdge',function(e)
					{
						hidehoverdiv('divhold');
					})
					
					
					s.bind('clickEdge', function(e)
					{
	  					hidehoverdiv('divhold');
						hidehoverdiv('divtoshow');
						hidemenudiv('menu');
						if(e.data.edge.attributes.sourceauthorisadded && e.data.edge.attributes.targetauthorisadded)
							showmenudiv(e,'menu');
						else if(e.data.edge.attributes.sourceauthorisadded && !e.data.edge.attributes.targetauthorisadded)
							showhoverdiv(e,'divhold', e.data.edge.target.toUpperCase() + " is currently not added to PALM");
						else if(!e.data.edge.attributes.sourceauthorisadded && e.data.edge.attributes.targetauthorisadded)
							showhoverdiv(e,'divhold', e.data.edge.source.toUpperCase() + " is currently not added to PALM");		
						else
							showhoverdiv(e,'divhold', "Both "+ e.data.edge.source.toUpperCase() + " and " + e.data.edge.target.toUpperCase() + " are currently not added to PALM");
					})
					
					s.bind('clickStage',function(e)
					{
						hidemenudiv('menu');
						hidehoverdiv('divhold');
					})
				}
			}); 
			
			s.refresh();
			url="";
			
		})
		.fail(function() 
		{
	 		$.PALM.popUpMessage.remove( uniquePid );
		});
	}
	else
	{
		<#-- gephi network -->
		sigma.parsers.gexf( "<@spring.url '/resources/gexf/'/>" + graphFile ,s,function() 
		{
			s.refresh();
			s.refresh();
			
			<#-- Zoom out - single frame -->
			s.camera.goTo({
			  x: cameraX,
			  y: cameraY,
			  ratio: cameraRatio
			});
			
			s.renderers[0].bind("render", function (e) 
			{
				cameraX = e.target.camera.x;
				cameraY = e.target.camera.y;
				cameraRatio = e.target.camera.ratio;
			});
				
			if(s.graph.nodes().length==0 && s.graph.edges().length==0)
			{
				tabContent.html("")
				$.PALM.callout.generate( tabContent , "warning", "No data found!!", "No authors satisfy the specified criteria!" );
				return false;
			}
				
			s.graph.nodes().forEach(function(n) 
			{
		        n.originalColor = n.color;
		    });
		    s.graph.edges().forEach(function(e) 
		    {
		        e.originalColor = e.color;
		        edgeSizes.push(e.size)
		    });
	      
			s.bind('clickNode rightClickNode', function(e)
			{
				var nodeId = e.data.node.id,
				toKeep = s.graph.neighbors(nodeId);
		        toKeep[nodeId] = e.data.node;
		
		        s.graph.nodes().forEach(function(n) 
		        {
		          if (toKeep[n.id])
		            n.color = n.originalColor;
		          else
		            n.color = '#c9c0c2';
		        });
		
		        s.graph.edges().forEach(function(e) 
		        {
		          if (toKeep[e.source] && toKeep[e.target])
		            e.color = e.originalColor;
		          else
		            e.color = '#c9c0c2';
		        });
		
		        s.refresh();
			})
			
			s.bind('clickStage', function(e)
			{
				hidehoverdiv('divhold');
		        s.graph.nodes().forEach(function(n) 
		        {
		            n.color = n.originalColor;
		        });
		        s.graph.edges().forEach(function(e) 
		        {
		            e.color = e.originalColor;
		        });
		        s.refresh();
			})
			
			s.bind('clickNode', function(e)
			{
				if(e.data.captor.ctrlKey == false)
				{ 
					if(e.data.node.attributes.isadded==false)
					{
						var text = e.data.node.label;
						showhoverdiv(e,'divhold', text.toUpperCase() + " is currently not added to PALM");
					}
					else
						showmenudiv(e,'menu');
				}
			})
			
			s.bind('overEdge',function(e)
			{
				if(!(edgeSizes.every( (val, i, arr) => val == arr[0] )))
				showhoverdiv(e,'divhold', "co-authored " + Math.round(e.data.edge.weight / 0.1) + " time(s)");
			})
			s.bind('outEdge',function(e)
			{
				hidehoverdiv('divhold');
			})
			
			
			s.bind('clickEdge', function(e)
			{
				hidehoverdiv('divhold');
				hidehoverdiv('divtoshow');
				hidemenudiv('menu');
				if(e.data.edge.attributes.sourceauthorisadded && e.data.edge.attributes.targetauthorisadded)
					showmenudiv(e,'menu');
				else if(e.data.edge.attributes.sourceauthorisadded && !e.data.edge.attributes.targetauthorisadded)
					showhoverdiv(e,'divhold', e.data.edge.target.toUpperCase() + " is currently not added to PALM");
				else if(!e.data.edge.attributes.sourceauthorisadded && e.data.edge.attributes.targetauthorisadded)
					showhoverdiv(e,'divhold', e.data.edge.source.toUpperCase() + " is currently not added to PALM");		
				else
					showhoverdiv(e,'divhold', "Both "+ e.data.edge.source.toUpperCase() + " and " + e.data.edge.target.toUpperCase() + " are currently not added to PALM");
			})
				
			s.bind('clickStage',function(e)
			{
				hidemenudiv('menu');
				hidehoverdiv('divhold');
			})
		}); 
		s.refresh();
		url="";
	}
}
	
<#-- neighbour highlight in gephi network -->
sigma.classes.graph.addMethod('neighbors', function(nodeId) 
{
	var k,
    neighbors = {},
    index = this.allNeighborsIndex[nodeId] || {};

    for (k in index)
      neighbors[k] = this.nodesIndex[k];

	return neighbors;
  });