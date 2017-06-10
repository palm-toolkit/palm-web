<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter basedOn col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Based on : </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Publications' Citations</button>    				
  				</div>
			</div>
			<div class="filter orderedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Ordered by: </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Publications' Citations </button>
  				</div>
			</div>
		</div>
		<div class="container-box visualization-box row">
			<div class="visualization-main col-md-8  col-sm-8"></div>
			<div class="visualization-details col-md-4  col-sm-4">
				<#--<div class="list-publications" style="display:none"></div> -->
				<div class="basicinfo"></div>
			</div>
		</div>
	</div>
</div>

<#--
<div class="box-footer">
</div>
-->
<script>
	$( function(){
		<#-- set target pub id -->
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>
		<#-- add slimscroll to widget body -->
		<#-- $("#boxbody${wUniqueName} .box-content").slimscroll({
			height: height + "px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    }); -->

		<#-- add scroll for papers' list -->
		<#-- $("#boxbody${wUniqueName} .visualization-details .list-publications").slimscroll({
			height: height/2 + "px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    }); -->
		<#-- add overlay -->
		var $container = $( "#widget-${wUniqueName}" );
		$container.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				
		<#-- set widget unique options -->

		var options ={
			source : "<@spring.url '/publication/basicInformationAndTopics' />",
			queryString:"",
			query: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var url 		  = "<@spring.url ''/>";
				var userLoggedId  = <#if currentUser??>"${currentUser.author.id}"<#else>""</#if>; 
				var mainContainer = $( widgetElem ).find( "#boxbody${wUniqueName}" ).find(".visualization-main");
				
				mainContainer.html("");
				
				if (  data.basicinfo.publication.event != null && data.basicinfo.publication.event.id != null ){
					var query  = "?id=" + data.basicinfo.publication.event.id + "&maxresult=" + 15;
					var confPublURL = "<@spring.url '/venue/publicationTopList' />" + query;
					
					$.PALM.visualizations.record ( {
						data 	: data, 
						widgetUniqueName : "${wUniqueName}", 
						width	: 800,
						height	: 450,
						url		: "<@spring.url '' />",
						user	: userLoggedId,
					});
				
					publication_status_in_conference();
					
					
				}else
					$.PALM.callout.generate( mainContainer , "warning", "Empty Publications!", "Currently no venue found on PALM database for this publication." );

				<#-- remove overlay -->
				$container.find(".overlay").remove();
				
				function publication_status_in_conference(){
					var vars = $.publRank.variables;
					vars.widget = d3.select("#widget-${wUniqueName}");
					
					vars.mainContainer    = $("#widget-${wUniqueName}" + " .visualization-main");
					vars.detailsContainer = $("#widget-${wUniqueName}" + " .visualization-details");
					
					vars.publication	  = {basicinfo : $.PALM.visualizations.data.basicinfo, topics : $.PALM.visualizations.data.topics};
					
					vars.thisWidget 	  = $.PALM.boxWidget.getByUniqueName( "${wUniqueName}" );	
					vars.width  	  	  = vars.mainContainer.width() - vars.margin.left - vars.margin.right;
					vars.width			  = vars.width > $.PALM.visualizations.width ? $.PALM.visualizations.width : vars.width; 
					vars.height 	      = $.PALM.visualizations.height;
					
					$.publRank.visualization.draw();
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
		
		<#-- user.author.id exist, triger ajax call -->
		<#--<#if currentUser.author??>
			$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		<#else>
			$("#boxbody${wUniqueName} .box-content").html( "No publication found. Please link yourself to a researcher on PALM" );
		</#if>
		
		<#-- order publications -->
		$("#widget-${wUniqueName}" + " .orderedBy .dropdown-menu li").on("click", function(){
			if ( !$(this).hasClass("selected") ){
				$(this).parent().children("li").removeClass("selected");
				$(this).addClass("selected");
				$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
				$.bestPapers.orderBy( $(this).data("value") );
			}
		});
		
		<#-- filter publications 
		<#-- $("#widget-${wUniqueName}" + " .top input[name=top]").on("click", function(){			
			$.bestPapers.filterBy.top( $(this).val() );	
		});-->
			
	});<#-- end document ready -->
</script>