<div class="box-body">
	  <form role="form" id="manageConfig" action="<@spring.url '/admin/config' />" method="post">
	    <#-- text input widget title -->
		<#assign prevGroupName = "">
		<#list config.configProperties as configProperty>
			<#if prevGroupName != configProperty.groupName>
				<#assign prevGroupName = configProperty.groupName>
				<label class="pull-left" style="clear:both;margin:15px 0 10px 0">${prevGroupName}</label>
			</#if>
			
	  		<div class="form-group" style="clear:both;margin:0 0 5px 15px">
	  			<#-- label -->
	      		<span class="pull-left" style="width:60%;padding-right:15px;">${configProperty.statement}</span>
	      		<span class="pull-left">
				<#if configProperty.fieldType == "radio">
					<#list configProperty.fieldOptions?split(",") as fieldOption>
						<#if configProperty.value == fieldOption>
							<input type="radio" name="configProperties[${configProperty_index}].value" id="configProperties${configProperty_index}value${fieldOption_index}" value="${fieldOption}" checked>
							<label for="configProperties${configProperty_index}value${fieldOption_index}" style="margin-right:20px">${fieldOption}</label>
						<#else>
							<input type="radio" name="configProperties[${configProperty_index}].value" id="configProperties${configProperty_index}value${fieldOption_index}" value="${fieldOption}">
							<label for="configProperties${configProperty_index}value${fieldOption_index}" style="margin-right:20px">${fieldOption}</label>
						</#if>
					</#list>
				<#elseif configProperty.fieldType == "text">
					<input type="text" name="configProperties[${configProperty_index}].value" value="${configProperty.value}">
				</#if>
				</span>
	    	</div>
			
	  	</#list>
	
	  </form>
  
</div><#-- ./box-body -->
<div class="box-footer">
  	<button type="submit" class="btn btn-primary" onclick="$.PALM.postForm.viaAjaxAndReload( $( 'form#manageConfig' ), 'Saving changes on ${header?capitalize} Configuration and refresh page...' ,'<@spring.url '/admin' />?page=publication')">Save Changes</button>
  	<button type="submit" class="btn btn-primary pull-right" onclick="$( 'form#manageConfig' ).append( '<input type=\'hidden\' name=\'resetDafault\' value=\'reset\'>' );$.PALM.postForm.viaAjaxAndReload( $( 'form#manageConfig' ), 'Saving changes on ${header?capitalize} Set configuration to default and refresh page...' ,'<@spring.url '/admin' />?page=publication')">Reset Default</button>
</div><#-- /.box-footer -->

<script>
	<#-- change source button -->
	$( function(){
		$( "#manageConfig" ).parent().prev().find( "h3" ).html( "${header?capitalize} Configuration")
	});
</script>