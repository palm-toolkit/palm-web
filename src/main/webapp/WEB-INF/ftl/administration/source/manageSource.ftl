<div class="box-body">
	  <form role="form" id="manageSource" action="<@spring.url '/admin/source' />" method="post">
	    <#-- text input widget title -->
		<#list sourceListWrapper.sources as source>
			<#if source_index gt 0>
				<hr>
			</#if>
	  		<div class="form-group">
	  			<#-- label -->
	      		<label>${source.name}</label>
				<#-- options -->
				<div class="btn-group pull-right">
					<#if source.active>
                  		<input type="button" class="btn btn-sm btn-success" value="Active"/>
                  		<input type="hidden" name="sources[${source_index}].active" value="on" />
              		<#else>
              			<input type="button" class="btn btn-sm btn-danger" value="Not Active"/>
                  		<input type="hidden" name="sources[${source_index}].active" value="off" />
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
                <textarea class="form-control" name="sources[${source_index}].description" id="sources[${source_index}].description" rows="2" placeholder="Enter source description/hint/info..."><#if source.description??>${source.description}</#if></textarea>
				<#-- properties -->
				
				<strong>Properties:</strong>
				<button type="button" class="btn btn-primary btn-xs pull-right" onclick="addPropertiesRow( $('#table_source_${source_index}'), ${source_index} ); return false;"> + Add Properties</button>
				<table id="table_source_${source_index}" class="table table-condensed">
                    <tbody>
	                    <tr>
	                      <th style="width:5%" title="validity">#</th>
	                      <th style="width:25%">Identifier 1</th>
	                      <th style="width:25%">Identifier 2</th>
	                      <th style="width:45%">Value</th>
	                    </tr>
	                    <#if source.sourceProperties??>
		                    <#list source.sourceProperties as sourceProperty>
		                    	<tr>
		                    		<td>
		                    			<#if sourceProperty.valid>
			                    			<input type="checkbox" onclick="setSourcePropertyValidity( this );" checked>
			                    			<input name="sources[${source_index}].sourceProperties[${sourceProperty_index}].valid" type="hidden" value="on">
			                    		<#else>
			                    			<input type="checkbox" onclick="setSourcePropertyValidity( this );">
			                    			<input name="sources[${source_index}].sourceProperties[${sourceProperty_index}].valid" type="hidden" value="off">
		                    			</#if>
	                    			</td>
	                    			<td>
	                    				<input name="sources[${source_index}].sourceProperties[${sourceProperty_index}].mainIdentifier" type="text" class="form-control" value="<#if sourceProperty.mainIdentifier??>${sourceProperty.mainIdentifier}</#if>">
	                				</td>
	                				<td>
	            						<input name="sources[${source_index}].sourceProperties[${sourceProperty_index}].secondaryIdentifier" type="text" class="form-control" value="<#if sourceProperty.secondaryIdentifier??>${sourceProperty.secondaryIdentifier}</#if>">
	        						</td>
	        						<td>
	        							<textarea name="sources[${source_index}].sourceProperties[${sourceProperty_index}].value9" rows="1" class="form-control"><#if sourceProperty.value??>${sourceProperty.value}</#if></textarea>
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
  	<button type="submit" class="btn btn-primary" onclick="postFormViaAjax( $( 'form#manageSource' ) )">Save Changes</button>
</div><#-- /.box-footer -->

<script>
	<#-- change source button -->
	function changeDropdownButton( selectedElement ){
		var buttonGroupElement = $( selectedElement ).parent().parent().parent();
		var mainButton = buttonGroupElement.find( "input[type='button']" );
		mainButton.removeClass();
		mainButton.addClass( $( selectedElement ).attr( "data-class" ) ).val( $( selectedElement ).text() );
		buttonGroupElement.find( "input[type='hidden']" ).val( $( selectedElement ).attr( "data-value" ) );
	}
	<#-- add a row attribute -->
	function addPropertiesRow( sourceTable , sourceIndex){
		var rowIndex = sourceTable.find( 'tr' ).length - 1;
		console.log( rowIndex );
		sourceTable
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
						setSourcePropertyValidity( this )
					})
				)
				.append(
					$( '<input/>' )
					.attr({
						'name':'sources[' + sourceIndex + '].sourceProperties[' + rowIndex + '].valid',
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
						'name':'sources[' + sourceIndex + '].sourceProperties[' + rowIndex + '].mainIdentifier',
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
						'name':'sources[' + sourceIndex + '].sourceProperties[' + rowIndex + '].secondaryIdentifier',
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
						'name':'sources[' + sourceIndex + '].sourceProperties[' + rowIndex + '].value',
						'rows' : '1'
					})
					.addClass( 'form-control' )
				)
			)
		);
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