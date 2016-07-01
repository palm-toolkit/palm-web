<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	  	<div id="tab_va_publications" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_timeline">
				<a href="#tab_timeline" data-toggle="tab" aria-expanded="true">
					Timeline
				</a>
			</li>
			<li id="header_publication_list">
				<a href="#tab_publication_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_publication_comparison"  class="active">
				<a href="#tab_publication_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_timeline" class="tab-pane">
			</div>
			<div id="tab_publication_list" class="tab-pane">
			</div>
			<div id="tab_publication_comparison" class="tab-pane" >
			</div>
        </div>
	</div>
</div>

<script>
	$( function(){

		var options ={
			source : "<@spring.url '/explore/publication' />"}
			
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
	});
</script>