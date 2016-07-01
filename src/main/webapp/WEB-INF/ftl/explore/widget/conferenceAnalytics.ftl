<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_conferences" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_locations" class="active">
				<a href="#tab_locations" data-toggle="tab" aria-expanded="true">
					Locations
				</a>
			</li>
			<li id="header_conference_list">
				<a href="#tab_conference_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_conference_comparison">
				<a href="#tab_conference_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_locations" class="tab-pane" active>
			</div>
			<div id="tab_conference_list" class="tab-pane">
			</div>
			<div id="tab_conference_comparison" class="tab-pane" >
			</div>
        </div>
	</div>
	</div>

<script>
	$( function(){

		var options ={
			source : "<@spring.url '/explore/conference' />"}
			
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