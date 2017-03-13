<@security.authorize access="isAuthenticated()">
	<#assign currentUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body">
	<div class="box-content">
		<div class="container-box filter-box activity-status-criteria row">
			<div class="filter basedOn col-lg-4 col-md-5 col-sm-8">
  				<span class="title font-small col-md-4  col-sm-4"> Based on : </span>
  				<div class="dropdown col-md-8 col-sm-8">
    				<button class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">Publications' Citations<span class="caret"></span> </button>
    				<ul class="dropdown-menu">
    					<li class="selected" data-value="cited"><a href="#">Publications' Citations</a></li>
      					<li><a href="#" data-value="venue">Publication's Venue Rank</a></li>  					
    				</ul>
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
                    	<input type="radio" id="top10" name="top" checked="checked" value="10" /> 10
               	 	</label> 
                	<label class="radio-inline">
                    	<input type="radio" id="q158" name="top" value="15" /> 15
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
		<#-- set target pub id -->
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>
		var height = 630;
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
				
		<#-- set widget unique options -->

		var options ={
			source : "<@spring.url '/publication/basicInformation' />",
			
			query: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var wUniqueName   = "${wUniqueName}"; 
				var url 		  = "<@spring.url ''/>";
				var userLoggedId  = <#if currentUser.author??>"${currentUser.author.id}"<#else>""</#if>; 

				var query  = "?id=" + data.publication.event.id;
				var confPublURL = "<@spring.url '/venue/publicationList' />" + query;
				
				var conferencePublications = $.get(confPublURL, function(response){
					console.log("response"); console.log(response);
					$.publRank.visualization.draw( url, userLoggedId, wUniqueName, response, height);
				})
				
				<#-- remove overlay -->
				$container.find(".overlay").remove();
				
			
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
			console.log("click");	
			
			$.bestPapers.filterBy.top( $(this).val() );
			
		});
			
	});<#-- end document ready -->
</script>