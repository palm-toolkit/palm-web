<div id="boxbody${wUniqueName}" class="box-body" style="overflow:hidden">
	<form role="form" action="<@spring.url '/circle' />" method="post">
	</form>
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		<#--
		$("#boxbody${wUniqueName} form").slimscroll({
			height: "250px",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });
		-->
		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/circle/basicInformation' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				targetContainer.html( "" );

				if( typeof data.circle !== "undefined" ){
					<#-- Circle title -->
					targetContainer.append(
										$( '<dt/>' ).html( "Circle:" )
									)
									.append(
										$( '<dd/>' ).html( data.circle.name )
									);
					<#-- Circle creator -->
					targetContainer.append(
										$( '<dt/>' ).html( "Creator:" )
									)
									.append(
										$( '<dd/>' ).html( data.circle.creator.name + " on " + $.PALM.utility.parseDateType1( data.circle.dateCreated ) )
									);
					<#-- Circle number of researcher -->
					targetContainer.append(
										$( '<dt/>' ).html( "Number of Researchers:" )
									)
									.append(
										$( '<dd/>' ).html( data.circle.numberAuthors )
									);
					<#-- Circle number of publication -->
					targetContainer.append(
										$( '<dt/>' ).html( "Number of Publications:" )
									)
									.append(
										$( '<dd/>' ).html( data.circle.numberPublications )
									);
					if( typeof data.circle.description != "undefined" )				
						targetContainer.append(
										$( '<dt/>' ).html( "Description:" )
									)
									.append(
										$( '<dd/>' ).html( data.circle.description )
									);
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
	    
	    
	});<#-- end document ready -->
</script>