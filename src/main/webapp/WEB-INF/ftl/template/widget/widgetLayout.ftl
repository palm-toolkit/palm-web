<#if widgets?has_content>
	<#list widgets as w>
		
		<@widget.widget 
		wId="${w.id}"
		wTitle="${w.title}"
		wType="${w.widgetType}"
		wGroup="${w.widgetGroup}"
		wSource="${w.widgetSource}"
		wWidth="${w.widgetWidth}"
		wSourcePath="${w.sourcePath!''}"
		wInformation="${w.information}"
		wCloseEnabled="${w.closeEnabled?c}"
		wMinimizeEnabled="${w.minimizeEnabled?c}"
		wResizeEnabled="${w.resizeEnabled?c}"
		wMoveableEnabled="${w.moveableEnabled?c}"
		wColorEnabled="${w.colorEnabled?c}"
		wColor="${w.color}"
		/>
			
		<script>
			<#-- Activate current box widget -->
	    	$.PALM.boxWidget.activateSpecific( $( "#widget-${w.id}" ));
		</script>
	</#list>
</#if>

<#--
<script>
	// Activate box widget
  	if ($.PALM.options.enableBoxWidget) {
    	$.PALM.boxWidget.activate();
  	}
</script>
-->