<div class="box-body">
	  <form role="form" id="manageExtractionService" action="<@spring.url '/admin/extractionService' />" method="post">
	    <#-- text input widget title -->
		<#list extractionServiceListWrapper.extractionServices as extractionService>
			<#if extractionService_index gt 0>
				<hr>
			</#if>
	  		<div class="form-group">
	  			<#-- label -->
	      		<label>${extractionService.extractionServiceType}</label>
				<#-- options -->
				<div class="btn-group pull-right">
					<#if extractionService.active>
                  		<input type="button" class="btn btn-sm btn-success" value="Active"/>
                  		<input type="hidden" name="extractionServices[${extractionService_index}].active" value="on" />
              		<#else>
              			<input type="button" class="btn btn-sm btn-danger" value="Not Active"/>
                  		<input type="hidden" name="extractionServices[${extractionService_index}].active" value="off" />
              		</#if>
                  <button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                    <span class="caret"></span>
                  </button>
                  <ul class="dropdown-menu" role="menu">
                    <li><a href="javascript:void(0)" data-class="btn btn-sm btn-success" data-value="on" onclick="changeDropdownButton( this )">Active</a></li>
                    <li><a href="javascript:void(0)" data-class="btn btn-sm btn-danger" data-value="off" onclick="changeDropdownButton( this )">Not Active</a></li>
                  </ul>
                </div>
                <#-- description -->
                <textarea class="form-control" name="extractionServices[${extractionService_index}].description" id="extractionServices[${extractionService_index}].description" rows="2" placeholder="Enter extractionService description/hint/info..."><#if extractionService.description??>${extractionService.description}</#if></textarea>
				<#-- properties -->
				
				<strong>Properties:</strong>
				<button type="button" class="btn btn-primary btn-xs pull-right" onclick="addPropertiesRow( $('#table_extractionService_${extractionService_index}'), ${extractionService_index} ); return false;"> + Add Properties</button>
				<table id="table_extractionService_${extractionService_index}" class="table table-condensed">
                    <tbody>
	                    <tr>
	                      <th style="width:5%" title="validity">#</th>
	                      <th style="width:25%">Identifier 1</th>
	                      <th style="width:25%">Identifier 2</th>
	                      <th style="width:45%">Value</th>
	                    </tr>
	                    <#if extractionService.extractionServiceProperties??>
		                    <#list extractionService.extractionServiceProperties as extractionServiceProperty>
		                    	<tr>
		                    		<td>
		                    			<#if extractionServiceProperty.valid>
			                    			<input type="checkbox" onclick="setExtractionServicePropertyValidity( this );" checked>
			                    			<input name="extractionServices[${extractionService_index}].extractionServiceProperties[${extractionServiceProperty_index}].valid" type="hidden" value="on">
			                    		<#else>
			                    			<input type="checkbox" onclick="setExtractionServicePropertyValidity( this );">
			                    			<input name="extractionServices[${extractionService_index}].extractionServiceProperties[${extractionServiceProperty_index}].valid" type="hidden" value="off">
		                    			</#if>
	                    			</td>
	                    			<td>
	                    				<input name="extractionServices[${extractionService_index}].extractionServiceProperties[${extractionServiceProperty_index}].mainIdentifier" type="text" class="form-control" value="<#if extractionServiceProperty.mainIdentifier??>${extractionServiceProperty.mainIdentifier}</#if>">
	                				</td>
	                				<td>
	            						<input name="extractionServices[${extractionService_index}].extractionServiceProperties[${extractionServiceProperty_index}].secondaryIdentifier" type="text" class="form-control" value="<#if extractionServiceProperty.secondaryIdentifier??>${extractionServiceProperty.secondaryIdentifier}</#if>">
	        						</td>
	        						<td>
	        							<textarea name="extractionServices[${extractionService_index}].extractionServiceProperties[${extractionServiceProperty_index}].value" rows="1" class="form-control"><#if extractionServiceProperty.value??>${extractionServiceProperty.value}</#if></textarea>
	    							</td>
								</tr>
		                    </#list>
	                    </#if>          
	                  </tbody>
                  </table>
				
	    	</div>
			
	  	</#list>
	
	  </form>
  
</div><#-- ./box-body -->
<div class="box-footer">
  	<button type="submit" class="btn btn-primary" onclick="$.PALM.postForm.viaAjaxAndReload( $( 'form#manageExtractionService' ), 'Saving changes on Manage ExtractionService and refresh page...' )">Save Changes</button>
</div><#-- /.box-footer -->

<script>
	<#-- change extractionService button -->
	function changeDropdownButton( selectedElement ){
		var buttonGroupElement = $( selectedElement ).parent().parent().parent();
		var mainButton = buttonGroupElement.find( "input[type='button']" );
		mainButton.removeClass();
		mainButton.addClass( $( selectedElement ).attr( "data-class" ) ).val( $( selectedElement ).text() );
		buttonGroupElement.find( "input[type='hidden']" ).val( $( selectedElement ).attr( "data-value" ) );
	}
	<#-- add a row attribute -->
	function addPropertiesRow( extractionServiceTable , extractionServiceIndex){
		var rowIndex = extractionServiceTable.find( 'tr' ).length - 1;
		console.log( rowIndex );
		extractionServiceTable
		.find( "tbody" )
		.append(
			$( '<tr/>' )
			.append(
				$( '<td/>' )
				.append(
					$( '<input/>' )
					.attr({
						'type':'checkbox'
					})
					.prop({
						'checked': true
					})
					.on( "click", function(){
						setExtractionServicePropertyValidity( this )
					})
				)
				.append(
					$( '<input/>' )
					.attr({
						'name':'extractionServices[' + extractionServiceIndex + '].extractionServiceProperties[' + rowIndex + '].valid',
						'type':'hidden',
						'value': 'on'
					})
				)
			)
			.append(
				$( '<td/>' )
				.append(
					$( '<input/>' )
					.attr({
						'name':'extractionServices[' + extractionServiceIndex + '].extractionServiceProperties[' + rowIndex + '].mainIdentifier',
						'type':'text'
					})
					.addClass( 'form-control' )
				)
			)
			.append(
				$( '<td/>' )
				.append(
					$( '<input/>' )
					.attr({
						'name':'extractionServices[' + extractionServiceIndex + '].extractionServiceProperties[' + rowIndex + '].secondaryIdentifier',
						'type':'text'
					})
					.addClass( 'form-control' )
				)
			)
			.append(
				$( '<td/>' )
				.append(
					$( '<textarea/>' )
					.attr({
						'name':'extractionServices[' + extractionServiceIndex + '].extractionServiceProperties[' + rowIndex + '].value',
						'rows' : '1'
					})
					.addClass( 'form-control' )
				)
			)
		);
	}
	
	<#-- toggle checkbox validity value -->
	function setExtractionServicePropertyValidity( checkBoxElem ){
		var propertyValidity = $( checkBoxElem ).next( "input[type='hidden']" );
		if( $( checkBoxElem ).is( ":checked" ))
			propertyValidity.val( "on" );
		else
			propertyValidity.val( "off" );
	}
</script>