<#macro widget wId="" wUniqueName="" wTitle="" wType="" wGroup="" wSource="BLANK" wWidth="SMALL" wParams...>
	<#-- security -->
	<#assign security=JspTaglibs["http://www.springframework.org/security/tags"] />
	<#-- local variables -->
	<#-- widget container class -->
	<#local wClassContainer = "">
	<#local wClassStyle = "">
	<#local headerVisible = true>
	
	<#-- widget box class -->
	<#local wClassBox = "box">
	
	<#-- widget width -->
	<#if wWidth == "LARGE">
		<#local wClassContainer = "col-md-12">
	<#elseif wWidth == "MEDIUM">
		<#local wClassContainer = "col-md-8">
	<#else>
		<#local wClassContainer = "col-md-4">
	</#if>
	
	<#-- widget color -->
	<#if wParams["wColor"]??>
		<#if wParams["wColor"] == "GREEN">
			<#local wClassBox = wClassBox + " box-success">
		<#elseif wParams["wColor"] == "YELLOW">
			<#local wClassBox = wClassBox + " box-warning">
		<#elseif wParams["wColor"] == "RED">
			<#local wClassBox = wClassBox + " box-danger">
		<#elseif wParams["wColor"] == "BLUE">
			<#local wClassBox = wClassBox + " box-info">
		<#elseif wParams["wColor"] == "SOLID">
			<#local wClassBox = wClassBox + " box-solid">
		</#if>
	
	</#if>
	
	<#if wGroup="sidebar">
		<#local wClassContainer = wClassContainer + " padding0">
		<#local wClassBox = wClassBox + " border0" >
	</#if>

	<#if wParams["wHeaderVisible"]?? && wParams["wHeaderVisible"] == "false">
		<#local headerVisible = false>
	</#if>

	<#if wParams["wHeight"]?? && wParams["wHeight"] != "">
		<#local wClassStyle = "height:" + wParams["wHeight"]>
		<#if wParams["wHeaderVisible"]?? && wParams["wHeaderVisible"] == "false">
			<#local wClassStyle = wClassStyle + " background-color:#fff">
		</#if>
	</#if>

	<#-- The widget -->
	<div id="widget-${wUniqueName}" class="${wClassContainer}">
      <div class="${wClassBox}" <#if !headerVisible>style="border:none;margin:0"</#if>>
		
	<#if headerVisible>
        <div class="box-header with-border">
        
          <#-- widget handle moveable button -->
          <#if wParams["wMoveableEnabled"] == "true">
      		<div class="btn btn-box-tool box-move-handle" data-widget="move">
          		<i class="fa fa-ellipsis-v"></i>
          		<i class="fa fa-ellipsis-v"></i>
      		</div>
      	  </#if>
      	  
          <div class="box-title-container">
          	<h3 class="box-title">${wTitle}</h3>
          </div>
          <div class="box-tools pull-right">
          	
          	<#-- widget other option dropdown -->
			<#--
          	<#if wParams["wResizeEnabled"]== "true" || wParams["wColorEnabled"] == "true">
	          	<div class="btn-group">
	              <button class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown"><i class="fa fa-wrench"></i></button>
	              <ul class="dropdown-menu" role="menu">
	                <li><a href="#">Action</a></li>
	                <li><a href="#">Another action</a></li>
	                <li><a href="#">Something else here</a></li>
	                <li class="divider"></li>
	                <li><a href="#">Separated link</a></li>
	              </ul>
	            </div>
	        </#if>
	         -->

          	<#-- widget help button -->
          	<#if wParams["wInformation"]?? && wParams["wInformation"] != "">
            	<button class="btn btn-box-tool" data-toggle="tooltip" data-placement="bottom" data-html="true" data-original-title="${wParams["wInformation"]}"><i class="fa fa-info"></i></button>
            </#if>
          	
          	<#-- widget minimize button -->
          	<#if wParams["wMinimizeEnabled"] == "true">
            	<button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
            </#if>
            
            <#-- widget close button -->
            <#if wParams["wCloseEnabled"] == "true">
            	<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
        	</#if>
          </div>
        </div><#-- /.box-header -->
    </#if>

        <#if wSource == "INCLUDE">
    		<#include wParams["wSourcePath"] />
		<#else>
			<div class="box-body" style="${wClassStyle}">
	            <#-- ajax content goes here -->
	            <#-- if external source, load from iframe -->
	            <#if wSource == "EXTERNAL">
	            	<iframe class="externalContent" alt="external source" width="1" height="1" scrolling="yes" frameborder="no" marginheight="0" marginwidth="0" border="0" src="${wParams["wSourcePath"]}"></iframe>
	            </#if>
	        </div><#-- ./box-body -->
	        <div class="box-footer">
	          	<#-- ajax footer goes here -->
            </div><#-- /.box-footer -->
			
    	</#if>
      </div><#-- /.box -->
    </div><#-- /.container -->
	
</#macro>