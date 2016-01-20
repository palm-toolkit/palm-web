<div class="box-body">
	<form role="form" id="manageUserWidget" action="<@spring.url '/widget' />" method="post">
		<div class="palm-table">
			<div class="table-header">
				<span style="width:20px;">#</span>
				<span style="width:30%">&nbsp;Widget</span>
				<span style="width:20%">&nbsp;Width</span>
				<span style="width:20%">&nbsp;Height</span>
				<span>Status</span>
			</div>
		  	<ul id="widget-list-container" class="list-unstyled table-body" style="width:100%">
	            <#if userWidgetsWrapper.userWidgets?has_content>
	                <#list userWidgetsWrapper.userWidgets as userWidget>
	                	<#assign isHeightAvailable = false>
	                	<#if userWidget.widget.widgetHeight?? && userWidget.widget.widgetHeight != "">
	                		<#assign isHeightAvailable = true>
	                	</#if>
			           <li class="table-row">
			           		<input type="hidden" class="wposition" name="userWidgets[${userWidget_index}].widget.pos" value="${userWidget_index}">

			           		<span class="widget-handle" style="width:20px;">
			            		<div class="btn btn-box-tool" style="padding-left:0">
					          		<i class="fa fa-ellipsis-v"></i>
					          		<i class="fa fa-ellipsis-v"></i>
					      		</div>
				            </span>
				            <span class="title" style="width:30%">
				            	${userWidget.widget.title}
							</span>
							<span style="width:20%">
								<div class="btn-group">
								  <input type="hidden" name="userWidgets[${userWidget_index}].widget.width" value="${userWidget.widget.widgetWidth}" >
			                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
			                        ${userWidget.widget.widgetWidth?capitalize}<span class="caret"></span>
			                      </button>
			                      <ul class="dropdown-menu" role="menu">
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Small</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Medium</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Large</a></li>
			                      </ul>
			                    </div>
							</span>
							<span style="width:20%">
				            	<div class="btn-group">
				            	  <#if !isHeightAvailable>
				                      <button type="button" class="btn btn-sm btn-default min-w-75 btn-flat disabled">Fixed</button>
			                      <#else>
			                      	  <input type="hidden" name="userWidgets[${userWidget_index}].widget.height" value="${userWidget.widget.widgetHeight}" >
				                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
				                        ${userWidget.widget.widgetHeight} <span class="caret"></span>
				                      </button>
				                      <ul class="dropdown-menu" role="menu">
				                      	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">300px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">450px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">600px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">800px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">1000px</a></li>
				                      </ul>
			                      </#if>
			                    </div>
							</span>
							<span>
				            	<div class="btn-group" data-toggle="buttons">
				            		<#if userWidget.widgetStatus == "ACTIVE">
			                          	<label class="btn btn-sm btn-default active"><input type="radio" name="userWidgets[${userWidget_index}].widget.status" value="active" checked>On</label>
	          							<label class="btn btn-sm btn-default"><input type="radio" name="userWidgets[${userWidget_index}].widget.status" value="nonactive">Off</label>
          							<#else>
          								<label class="btn btn-sm btn-default"><input type="radio" name="userWidgets[${userWidget_index}].widget.status" value="active">On</label>
          								<label class="btn btn-sm btn-default active"><input type="radio" name="userWidgets[${userWidget_index}].widget.status" value="nonactive" checked>Off</label>
          							</#if>
		                        </div>
							</span>
			           </li>
	                </#list>
	            </#if>

				<#if notInstalledWidgetsWrapper.widgets?has_content>
					<#list notInstalledWidgetsWrapper.widgets as notInstalledWidget>
						<#assign isHeightAvailable = false>
	                	<#if notInstalledWidget.widgetHeight?? && notInstalledWidget.widgetHeight != "">
	                		<#assign isHeightAvailable = true>
	                	</#if>
			           <li class="table-row">
			           		<input type="hidden" class="wposition" name="widgets[${notInstalledWidget_index}].pos" value="${notInstalledWidget_index}">
				      		<span class="widget-handle" style="width:20px;">
			            		<div class="btn btn-box-tool" style="padding-left:0">
					          		<i class="fa fa-ellipsis-v"></i>
					          		<i class="fa fa-ellipsis-v"></i>
					      		</div>
				            </span>
				            <span class="title" style="width:30%">
				            	${notInstalledWidget.title}
							</span>
							<span style="width:20%">
								<div class="btn-group">
								  <input type="hidden" name="widgets[${notInstalledWidget_index}].width" value="${notInstalledWidget.widgetWidth}" >
			                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
			                        ${notInstalledWidget.widgetWidth?capitalize} <span class="caret"></span>
			                      </button>
			                      <ul class="dropdown-menu" role="menu">
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Small</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Medium</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Large</a></li>
			                      </ul>
			                    </div>
							</span>
							<span style="width:20%">
				            	<div class="btn-group">
			                      <#if !isHeightAvailable>
				                      <button type="button" class="btn btn-sm btn-default min-w-75 btn-flat disabled">Fixed</button>
			                      <#else>
			                      	  <input type="hidden" name="userWidgets[${notInstalledWidget_index}].widget.height" value="${notInstalledWidget.widgetHeight}" >
				                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
				                        ${notInstalledWidget.widgetHeight} <span class="caret"></span>
				                      </button>
				                      <ul class="dropdown-menu" role="menu">
				                      	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">300px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">450px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">600px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">800px</a></li>
			                        	<li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">1000px</a></li>
				                      </ul>
			                      </#if>
			                    </div>
							</span>
							<span>
				            	<div class="btn-group" data-toggle="buttons">
		                          <label class="btn btn-sm btn-default"><input type="radio" name="widgets[${notInstalledWidget_index}].status" value="active">On</label>
          						  <label class="btn btn-sm btn-default active"><input type="radio" name="widgets[${notInstalledWidget_index}].status" value="nonactive" checked>Off</label>
		                        </div>
							</span>
			           </li>
	                </#list>
				</#if>
			</ul>
		</div>
	</form>
</div>
<div class="box-footer">
  	<button id="submit" type="submit" class="btn btn-primary">Save Changes</button>
</div>

<script>
$(function(){
	<#-- make position sortable -->
	 var sortableWidgetContainer = $( "#widget-list-container" ).sortable({
	   connectWith: "#widget-list-container",
	   handle: ".widget-handle",
	   cursor: "move",
	   placeholder: "widget-placeholder",
	   start: function(e, ui ){
           ui.placeholder.height(ui.helper.outerHeight() - 60);
           ui.placeholder.width(ui.helper.outerWidth() - 30);
       }
	  });
	  
	  <#-- submit via ajax -->
		
		$( "#submit" ).click( function( e ){
			e.preventDefault();
			<#-- set the position of the list -->
			$.each( $( "#widget-list-container" ).children(), function( index, item ){
				$( item ).find( "input.wposition:first" ).val( index + 1 );
			});
			<#-- put researcher & publication on circle into hidden input -->
			$.post( $("#manageUserWidget").attr( "action" ), $("#manageUserWidget").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload parent page -->
					parent.location.reload();
				}
			});
		});
});
	<#-- change source button -->
	function changeDropdownButton( selectedElement ){
		var buttonGroupElement = $( selectedElement ).parent().parent().parent();
		var mainButton = $( buttonGroupElement ).find( "button:first" );
		mainButton.html( $( selectedElement ).text() + '<span class="caret">' );
		buttonGroupElement.find( "input[type='hidden']" ).val( $( selectedElement ).text() );
	}
	
	<#-- toggle checkbox validity value -->
	function setSourcePropertyValidity( checkBoxElem ){
		var propertyValidity = $( checkBoxElem ).next( "input[type='hidden']" );
		if( $( checkBoxElem ).is( ":checked" ))
			propertyValidity.val( "on" );
		else
			propertyValidity.val( "off" );
	}
</script>