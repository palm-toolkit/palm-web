<#if widgets?has_content>
	<#list widgets as w>
	
		<#if w.widgetType == "ADMINISTRATION">
			<@widget.widget 
			wSize="${w.widgetWidth}" 
			wTitle="${w.title}" 
			wId="${w.title}" 
			wClassContainer="padding0" 
			wClassBox="border0" 
			wContentBody="${w.sourcePath}"
			/>
		</#if>
	</#list>
</#if>

<script>
	<#-- Activate box widget -->
  	if ($.PALM.options.enableBoxWidget) {
    	$.PALM.boxWidget.activate();
  	}
</script>