<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter col-md-4 col-sm-6">
  				<span class="title font-small col-md-3  col-sm-3"> Based on : </span>
  				<div class="dropdown col-md-9 col-sm-9">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of publications <span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li><a href="#">Resercher's H-index</a></li>
      					<li><a href="#">Publications' Citations</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter col-md-4 col-sm-6">
  				<span class="title font-small col-md-3  col-sm-3"> Ordered by: </span>
  				<div class="dropdown col-md-9 col-sm-9">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Number of publications <span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li><a href="#">Resercher's H-index</a></li>
      					<li><a href="#">Publications' Citations</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter col-md-4 col-sm-6">
  				<span class="title font-small col-md-3  col-sm-3"> Top : </span>
  				<div id="slider" class="col-md-9 col-sm-9">  				
    				<div class="body col-md-8 col-sm-8"></div>
    				<div class="min"></div>
    				<div class="max"></div>
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-12  col-sm-12"></div>
		</div>
	</div>
</div>

<#--
<div class="box-footer">
</div>
-->
<script>
	$( function(){
		var height = 630;
		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} .box-content").slimscroll({
			height: height + "px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    });

		<#-- add overlay -->
		var $container = $( "#widget-${wUniqueName}" );
		$container.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/user/publicationList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var wUniqueName   = "${wUniqueName}"; 
				var url 		  = "<@spring.url ''/>";
				var processedData = $.bestPapers.init( url, wUniqueName, data, height);
				
				<#-- remove overlay -->
				$container.find(".overlay").remove();
				
				if ( processedData != false )
					 $.bestPapers.visualise( data );
				else
					return false;
			}
		};
		
		<#if currentUser.author??>
			options.queryString = "?id=${currentUser.author.id}";
		</#if>
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#-- user.author.id exist, triger ajax call -->
		<#if currentUser.author??>
			$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		<#else>
			$("#boxbody${wUniqueName} .box-content").html( "No publication found. Please link yourself to a researcher on PALM" );
		</#if>

	});<#-- end document ready -->
</script>