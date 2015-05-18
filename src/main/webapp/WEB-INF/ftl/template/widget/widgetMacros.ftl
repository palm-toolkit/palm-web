<#macro widget wSize="SMALL" wTitle="" wId="" wParams...>
	
	<#-- container -->
	<#if wSize == "LARGE">
		<div id="${wId}" class="col-md-12<#if wParams["wClassContainer"]??> ${wParams["wClassContainer"]}</#if>">
	<#elseif  wSize == "MEDIUM">
		<div id="${wId}" class="col-md-8<#if wParams["wClassContainer"]??> ${wParams["wClassContainer"]}</#if>">
	<#else>
		<div id="${wId}" class="col-md-6<#if wParams["wClassContainer"]??> ${wParams["wClassContainer"]}</#if>">
	</#if>
	      <div class="box<#if wParams["wClassBox"]??> ${wParams["wClassBox"]}</#if>">
	        <div id="${wId}_header" class="box-header with-border">
	          <h3 class="box-title">${wTitle}</h3>
	          <div class="box-tools pull-right">
	          	<#-- widget help button -->
	          	
	          	<#-- widget minimize button -->
	            <button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
	            <#-- widget miximize button -->
	            
	            <#-- widget -->
	            <#--
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
	            -->
	            <button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
	          </div>
	        </div><#-- /.box-header -->
	        <div id="${wId}_body" class="box-body">
	        	<#-- if there is included content body -->
	        	<#if wParams["wContentBody"]??>
	        		<#include wParams["wContentBody"] />
	        	</#if>
	            <#-- ajax content goes here -->
	        </div><#-- ./box-body -->
	        <div id="${wId}_footer" class="box-footer">
	          <div class="row">
	            
	          </div><#-- /.row -->
	        </div><#-- /.box-footer -->
	      </div><#-- /.box -->
	    </div><#-- /.container -->
	
</#macro>