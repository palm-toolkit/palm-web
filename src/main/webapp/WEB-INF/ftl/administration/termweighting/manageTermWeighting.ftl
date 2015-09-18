<div class="box-body">
	  <form role="form" id="manageInterestProfile" action="<@spring.url '/admin/interestProfile' />" method="post">
	    <#-- text input widget title -->
		<#list interestProfileListWrapper.interestProfiles as interestProfile>
			<#if interestProfile_index gt 0>
				<hr>
			</#if>
	  		<div class="form-group">
	  			<#-- label -->
	      		<label>${interestProfile.name}</label>
				<#-- options -->
				<div class="btn-group pull-right">
					<#if interestProfile.active>
                  		<input type="button" class="btn btn-sm btn-success" value="Active"/>
                  		<input type="hidden" name="interestProfiles[${interestProfile_index}].active" value="on" />
              		<#else>
              			<input type="button" class="btn btn-sm btn-danger" value="Not Active"/>
                  		<input type="hidden" name="interestProfiles[${interestProfile_index}].active" value="off" />
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
                <textarea class="form-control" name="interestProfiles[${interestProfile_index}].description" id="interestProfiles[${interestProfile_index}].description" rows="2" placeholder="Enter interestProfile description/hint/info..."><#if interestProfile.description??>${interestProfile.description}</#if></textarea>
				<#-- properties -->
				
				<strong>Properties:</strong>
				<button type="button" class="btn btn-primary btn-xs pull-right" onclick="addPropertiesRow( $('#table_interestProfile_${interestProfile_index}'), ${interestProfile_index} ); return false;"> + Add Properties</button>
				<table id="table_interestProfile_${interestProfile_index}" class="table table-condensed">
                    <tbody>
	                    <tr>
	                      <th style="width:5%" title="validity">#</th>
	                      <th style="width:25%">Identifier 1</th>
	                      <th style="width:25%">Identifier 2</th>
	                      <th style="width:45%">Value</th>
	                    </tr>
	                    <#if interestProfile.interestProfileProperties??>
		                    <#list interestProfile.interestProfileProperties as interestProfileProperty>
		                    	<tr>
		                    		<td>
		                    			<#if interestProfileProperty.valid>
			                    			<input type="checkbox" onclick="setInterestProfilePropertyValidity( this );" checked>
			                    			<input name="interestProfiles[${interestProfile_index}].interestProfileProperties[${interestProfileProperty_index}].valid" type="hidden" value="on">
			                    		<#else>
			                    			<input type="checkbox" onclick="setInterestProfilePropertyValidity( this );">
			                    			<input name="interestProfiles[${interestProfile_index}].interestProfileProperties[${interestProfileProperty_index}].valid" type="hidden" value="off">
		                    			</#if>
	                    			</td>
	                    			<td>
	                    				<input name="interestProfiles[${interestProfile_index}].interestProfileProperties[${interestProfileProperty_index}].mainIdentifier" type="text" class="form-control" value="<#if interestProfileProperty.mainIdentifier??>${interestProfileProperty.mainIdentifier}</#if>">
	                				</td>
	                				<td>
	            						<input name="interestProfiles[${interestProfile_index}].interestProfileProperties[${interestProfileProperty_index}].secondaryIdentifier" type="text" class="form-control" value="<#if interestProfileProperty.secondaryIdentifier??>${interestProfileProperty.secondaryIdentifier}</#if>">
	        						</td>
	        						<td>
	        							<textarea name="interestProfiles[${interestProfile_index}].interestProfileProperties[${interestProfileProperty_index}].value" rows="1" class="form-control"><#if interestProfileProperty.value??>${interestProfileProperty.value}</#if></textarea>
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
  	<button type="submit" class="btn btn-primary" onclick="$.PALM.postForm.viaAjaxAndReload( $( 'form#manageInterestProfile' ), 'Saving changes on Manage InterestProfile and refresh page...' )">Save Changes</button>
</div><#-- /.box-footer -->

<script>
	<#-- change interestProfile button -->
	function changeDropdownButton( selectedElement ){
		var buttonGroupElement = $( selectedElement ).parent().parent().parent();
		var mainButton = buttonGroupElement.find( "input[type='button']" );
		mainButton.removeClass();
		mainButton.addClass( $( selectedElement ).attr( "data-class" ) ).val( $( selectedElement ).text() );
		buttonGroupElement.find( "input[type='hidden']" ).val( $( selectedElement ).attr( "data-value" ) );
	}
	<#-- add a row attribute -->
	function addPropertiesRow( interestProfileTable , interestProfileIndex){
		var rowIndex = interestProfileTable.find( 'tr' ).length - 1;
		console.log( rowIndex );
		interestProfileTable
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
						setInterestProfilePropertyValidity( this )
					})
				)
				.append(
					$( '<input/>' )
					.attr({
						'name':'interestProfiles[' + interestProfileIndex + '].interestProfileProperties[' + rowIndex + '].valid',
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
						'name':'interestProfiles[' + interestProfileIndex + '].interestProfileProperties[' + rowIndex + '].mainIdentifier',
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
						'name':'interestProfiles[' + interestProfileIndex + '].interestProfileProperties[' + rowIndex + '].secondaryIdentifier',
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
						'name':'interestProfiles[' + interestProfileIndex + '].interestProfileProperties[' + rowIndex + '].value',
						'rows' : '1'
					})
					.addClass( 'form-control' )
				)
			)
		);
	}
	
	<#-- toggle checkbox validity value -->
	function setInterestProfilePropertyValidity( checkBoxElem ){
		var propertyValidity = $( checkBoxElem ).next( "input[type='hidden']" );
		if( $( checkBoxElem ).is( ":checked" ))
			propertyValidity.val( "on" );
		else
			propertyValidity.val( "off" );
	}
</script>