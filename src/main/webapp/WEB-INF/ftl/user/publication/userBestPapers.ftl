<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter basedOn col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Based on : </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle selected" data-value="cited" type="button" data-toggle="dropdown">Publications' Citations </button>  				
  				</div>
			</div>
			<div class="filter orderedBy col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Ordered by: </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Publications' Citations <span class="caret"></span> </button>
    				<ul class="dropdown-menu">
      					<li class="selected" data-value="cited"><a href="#">Publications' Citations</a></li>
      					<li data-value="year"><a href="#" >Year of publication</a></li>
    				</ul>
  				</div>
			</div>
			<div class="filter top col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Top : </span>
  				 <div class="btn-group" data-toggle="">
                	<label class="radio-inline">
                    	<input type="radio" id="top5" name="top" value="5" /> 5
                	</label> 
                	<label class="radio-inline active">
                    	<input type="radio" id="top10" name="top" value="10" /> 10
               	 	</label> 
                	<label class="radio-inline">
                    	<input type="radio" id="q158" name="top" value="15"  checked="checked"  /> 15
                	</label> 
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
		<#-- add slimscroll to widget body -->
		<#-- $("#boxbody${wUniqueName} .box-content").slimscroll({
			height: height + "px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50,
   			railVisible: true,
    		alwaysVisible: true
	    }); -->

		<#-- add overlay -->
		var $container = $( "#widget-${wUniqueName}" );
		$container.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				
		var currentUser = <#if currentUser.author??>"${currentUser.author.id}"<#else>""</#if>;
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/researcher/publicationTopList' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				if( data.status != "ok"){
						$.PALM.callout.generate( $container , "warning", "Empty Publications !", "Sorry, you don't have any publication, please try to add one" );
						return false;
				}
				
				$.PALM.visualizations.record ( {
					data 	: data, 
					widgetUniqueName : "${wUniqueName}", 
					width	: 960,
					height	: 630,
					url 	: "<@spring.url ''/>",
					user	: currentUser	
				});
								
				user_best_papers();
				
				<#-- remove overlay -->
				$container.find(".overlay").remove();
	
				function user_best_papers(){
					var $mainContainer = $("#widget-" + "${wUniqueName}" + " .visualization-main");
					$mainContainer.html( "" );
					
					var vars = $.bestPapers.variables;				
					
					vars.margin = {top: 20, right: 20, bottom: 40, left: 40};
					vars.width 	= $mainContainer.width() - vars.margin.left - vars.margin.right;
					vars.height = $.PALM.visualizations.height;
					
					vars.criterion = $("#widget-${wUniqueName} .basedOn .selected").data("value");
					vars.widget = d3.select("#widget-${wUniqueName}");
					
					$.PALM.visualizations.data = $.bestPapers.processData();
					vars.dataBackUp = $.extend(true, {}, $.PALM.visualizations.data);
					
					$.bestPapers.visualise.chart.draw();
				};	
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
		
		<#-- order publications -->
		$("#widget-${wUniqueName}" + " .orderedBy .dropdown-menu li").on("click", function(){
			if ( !$(this).hasClass("selected") ){
				$(this).parent().children("li").removeClass("selected");
				$(this).addClass("selected");
				$(this).parents(".dropdown").children("button").html( $(this).text() + " <span class='caret'></span>" );
				$.bestPapers.orderBy( $(this).data("value") );
			}
		});
		
		<#-- filter publications -->
		$("#widget-${wUniqueName}" + " .top input[name=top]").on("click", function(){
			$.bestPapers.filterBy.top( $(this).val() );	
		});
			
	});<#-- end document ready -->
</script>