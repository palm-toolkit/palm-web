 <@layout.global>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox"> 
				<h1>visualization</h1>
				<!-- the tabs -->
				<div id="visualizationTabContainer" class="tabContainer">
					<ul style="height: 40px;">	
						<li><a class="tabElement" href="#visualization-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Force Directed Graph</a></li>
						<li><a class="tabElement" href="#visualization-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> None</a></li>
						<li><a class="tabElement" href="#visualization-tab3" style="text-decoration:none;padding: 10px 15px;"><span>3.</span> None</a></li>
						<li><a class="tabElement" href="#visualization-tab4" style="text-decoration:none;padding: 10px 15px;"><span>4.</span> None</a></li>
					</ul>
				
					<div id="visualization-tab1" style="padding:0 !important; border:none; float:left; width:100%">
						<#include "visualization-tab1.ftl" />
					</div>
					<div id="visualization-tab2" style="padding:0 !important;border:none;float:left; width:100%">
						<#include "visualization-tab2.ftl" />
					</div>
					<div id="visualization-tab3" style="padding:0 !important;border:none;float:left; width:100%">
						<#include "visualization-tab3.ftl" />
					</div>
					<div id="visualization-tab4" style="padding:0 !important;border:none;float:left; width:100%">
						<#include "visualization-tab4.ftl" />
					</div>
				</div>
			</div>
 		</div>
		<!-- IE clearing - important! -->
		<div id="ie_clearing">&nbsp;</div>
 	</@content.main>
 	
</@layout.global>

<script>
	$( function() // begin document ready
	{
		<#-- change the size of main content -->
		$( "#col3" ).css( "margin", "0 0 0 15px");
	
		<#-- jQery tab for main content 'define study, define spss file, import -->
		$( "#visualizationTabContainer" ).tabs({ 
			active: 0
     	});
    });
</script>