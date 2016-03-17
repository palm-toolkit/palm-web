<div class="box-body" style="min-width:535px">
	<form role="form" id="manageWidget" action="<@spring.url '/admin/widget/manage' />" method="post">
		<div class="palm-table">
			<div class="table-header">
				<span style="width:20px;">#</span>
				<span style="width:30%" title="Click on widget name to edit">&nbsp;Widget</span>
				<span style="width:15%">&nbsp;Width</span>
				<span style="width:15%">&nbsp;Height</span>
				<span>Status</span>
			</div>
		  	<ul id="widget-list-container" class="list-unstyled table-body" style="width:100%">
				<#if widgetsWrapper.widgets?has_content>
					<#list widgetsWrapper.widgets as eachWidget>
						<#assign isHeightAvailable = false>
	                	<#if eachWidget.widgetHeight?? && eachWidget.widgetHeight != "">
	                		<#assign isHeightAvailable = true>
	                	</#if>
			           <li class="table-row">
			           		<#if eachWidget.moveableEnabled>
			           		<input type="hidden" class="wposition" name="widgets[${eachWidget_index}].pos" value="${eachWidget_index}">
				      		<span class="widget-handle" style="width:20px;">
			            		<div class="btn btn-box-tool" style="padding-left:0">
					          		<i class="fa fa-ellipsis-v"></i>
					          		<i class="fa fa-ellipsis-v"></i>
					      		</div>
				            </span>
				            <#else>
				            <span style="width:20px;">&nbsp;</span>
				            </#if>
				            
				            <span class="title wtitle no_selection" style="width:30%" title="Edit '${eachWidget.title}' Widget" data-url="<@spring.url '/admin/widget/edit' />?id=${eachWidget.id}">
				            	${eachWidget.title}
							</span>
							<span style="width:15%">
								<div class="btn-group">
								  <input type="hidden" name="widgets[${eachWidget_index}].width" value="${eachWidget.widgetWidth}" >
			                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
			                        ${eachWidget.widgetWidth?capitalize} <span class="caret"></span>
			                      </button>
			                      <ul class="dropdown-menu" role="menu">
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Small</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Medium</a></li>
			                        <li><a href="javascript:void(0)" onclick="changeDropdownButton( this )">Large</a></li>
			                      </ul>
			                    </div>
							</span>
							<span style="width:15%">
				            	<div class="btn-group">
			                      <#if !isHeightAvailable>
				                      <button type="button" class="btn btn-sm btn-default min-w-75 btn-flat disabled">Fixed</button>
			                      <#else>
			                      	  <input type="hidden" name="widgets[${eachWidget_index}].height" value="${eachWidget.widgetHeight}" >
				                      <button type="button" class="btn btn-sm btn-default min-w-75 dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
				                        ${eachWidget.widgetHeight} <span class="caret"></span>
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
				            	 <#if !(widgetType == 'administration' || widgetType == 'user')>
		                          <label class="btn btn-sm btn-default<#if eachWidget.widgetStatus == 'DEFAULT'> active</#if>">
		                          		<input type="radio" name="widgets[${eachWidget_index}].status" value="default" <#if eachWidget.widgetStatus == 'DEFAULT'> checked</#if>>Default
		                          </label>
		                         </#if>
          						  <label class="btn btn-sm btn-default<#if eachWidget.widgetStatus == 'ACTIVE'> active</#if>">
          						  		<input type="radio" name="widgets[${eachWidget_index}].status" value="active" <#if eachWidget.widgetStatus == 'ACTIVE'> checked</#if>>Active
          						  </label>
          						  <label class="btn btn-sm btn-default<#if eachWidget.widgetStatus == 'NONACTIVE'> active</#if>">
          						  		<input type="radio" name="widgets[${eachWidget_index}].status" value="nonactive" <#if eachWidget.widgetStatus == 'NONACTIVE'> checked</#if>>Non Active
          						  </label>
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
	<#-- change box title -->
	$( '#widget-${wUniqueName}' ).find( ".box-title" ).html("Manage ${widgetType?capitalize} Widgets");
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
	  
	  
	  <#-- open popup edit widget on doubleclick -->
	  $( ".wtitle" )
	  	.css({"cursor":"pointer"})
	  	.click( function(){
	  		$.PALM.popUpIframe.create( $(this).data("url") , { "popUpHeight":"88%", "popUpWidth" : "94%", "popUpMargin": "2% auto"}, $(this).attr("title") );
	  	});
	  
	  <#-- submit via ajax -->
		$( "#submit" ).click( function( e ){
			e.preventDefault();
			<#-- set the position of the list -->
			$.each( $( "#widget-list-container" ).children(), function( index, item ){
				$( item ).find( "input.wposition:first" ).val( index + 1 );
			});
			<#-- put researcher & publication on circle into hidden input -->
			$.post( $("#manageWidget").attr( "action" ), $("#manageWidget").serialize(), function( data ){
				<#-- todo if error -->

				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload parent page -->
					location.reload();
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