<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="widget-publications-${wUniqueName}">
	<div id="publications-box-${wUniqueName}" class="box">
		<div class="box-header"> 
			<div class="box-title-container">
          		<h3 class="box-title">Publications <span class="author_name"></span> </h3>
        	</div>
        	<div class="box-tools pull-right">
          		<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
         	 </div>
		</div>
		<div class="box-content">
		<div class="box-footer"> </div>
		</div>
	</div>	
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#publications-box-${wUniqueName} .box-content ").slimscroll({
			height : "95%",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: false
    		
	    });

		$("#publications-box-${wUniqueName} .box-content").css({"max-height": "600px", "height":"100%"});
	
		<#-- set widget unique options -->
		var options ={};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-publications-box-${wUniqueName}",
			"element": $( "#widget-publications-box-${wUniqueName}" ),
			"options": options
		});
	});<#-- end document ready -->
</script>