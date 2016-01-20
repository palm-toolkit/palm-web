<#if widgets?has_content>
	<#list widgets as w>
		
		<@widget.widget 
		wId="${w.id}"
		wUniqueName="${w.uniqueName}"
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
		wHeaderVisible="${w.headerVisible?c}"
		wHeight="${w.widgetHeight!''}"
		/>
		
	</#list>
</#if>