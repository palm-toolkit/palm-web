<div id="boxbody${wId}" class="box-body">
	<form role="form" action="<@spring.url '/publication' />" method="post">
	</form>
</div>

<div class="box-footer">
</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wId}").slimscroll({
			height: "250px",
	        size: "3px"
	    });

		<#-- set widget unique options -->
		var options ={
			source : "<@spring.url '/publication/basicstatistic' />",
			queryString : "",
			id: "",
			onRefreshStart: function( widgetElem ){
						},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( "form:first" );

				<#--remove previous content -->
				if( typeof data.publication !== "undefined" )
					targetContainer.html( printKeyValue( data.publication ) );
				else
					targetContainer.html( $( '<dl/>' ).append( $( '<dt/>' ).html( "No statistical data available" ) ) );

				<#-- print publication detail -->
				function printKeyValue( jsObject ){
					var descriptionList = $( '<dl/>' );
					$.each( jsObject , function( k, v){
						if( k == "source" )
							return;
						descriptionList.append(
											$( '<dt/>' ).html( k )
										)
										.append(
											$( '<dd/>' ).html( v )
										);
					});
					return descriptionList;
				} 
					
			}
		};
		
		<#-- register the widget -->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
	    
	    
	});<#-- end document ready -->
</script>