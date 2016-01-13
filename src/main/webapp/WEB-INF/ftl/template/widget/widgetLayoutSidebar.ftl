<#if widgets?has_content>
	<#list widgets as w>
		
		<#if w.widgetGroup == "sidebar">
			<@widget.widget 
			wId="${w.id}"
			wTitle="${w.title}"
			wType="${w.widgetType}"
			wGroup="${w.widgetGroup}"
			wSource="${w.widgetSource}"
			wWidth="LARGE"
			wSourcePath="${w.sourcePath!''}"
			wInformation="${w.information}"
			wCloseEnabled="${w.closeEnabled?c}"
			wMinimizeEnabled="${w.minimizeEnabled?c}"
			wResizeEnabled="${w.resizeEnabled?c}"
			wMoveableEnabled="${w.moveableEnabled?c}"
			wColorEnabled="${w.colorEnabled?c}"
			wColor="${w.color}"
			wHeight="${w.widgetHeight!''}"
			/>
		</#if>
	</#list>
</#if>