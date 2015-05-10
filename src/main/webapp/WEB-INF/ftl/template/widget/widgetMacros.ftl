<#macro widget wSize="SMALL" wTitle="" wId="" wParams...>

	<#-- List of local variables -->
	<#local wCond = "normal">
	<#local wColor = "normal">
	<#if wParams["wCond"]?? >
		<#local wCond = wParams["wCond"] >
	</#if>
	
	<#if wSize == "LARGE">
		<div id="${wId}" class="col-md-12">
	<#elseif  wSize == "MEDIUM">
		<div id="${wId}" class="col-md-8">
	<#else>
		<div id="${wId}" class="col-md-6">
	</#if>
	      <div class="box">
	        <div id="${wId}_header" class="box-header with-border">
	          <h3 class="box-title">${wTitle}</h3>
	          <div class="box-tools pull-right">
	            <button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
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
	        </div><!-- /.box-header -->
	        <div id="${wId}_body" class="box-body">
	            <#-- ajax content goes here -->
	        </div><!-- ./box-body -->
	        <div id="${wId}_footer" class="box-footer">
	          <div class="row">
	            
	          </div><!-- /.row -->
	        </div><!-- /.box-footer -->
	      </div><!-- /.box -->
	    </div>

</#macro>