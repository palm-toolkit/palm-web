 <@layout.global>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox"> 
				<h1>Data Upload</h1>
				<!-- the tabs -->
				<div id="datasetTabContainer" class="tabContainer">
					<ul style="height: 40px;">	
						<li><a class="tabElement" href="#dataset-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> None</a></li>
						<li><a class="tabElement" href="#dataset-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> None</a></li>
						<li><a class="tabElement" href="#dataset-tab3" style="text-decoration:none;padding: 10px 15px;"><span>3.</span> None</a></li>
					</ul>
				
					<div id="dataset-tab1" style="padding:0 !important; border:none; float:left; width:100%">
						<#include "dataset-tab1.ftl" />
					</div>
					<div id="dataset-tab2" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "dataset-tab2.ftl" />
					</div>
					<div id="dataset-tab3" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "dataset-tab3.ftl" />
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
		$( "#datasetTabContainer" ).tabs({ 
			active: 0
     	});
    });
</script>