<@dialoglayout.global>
	<@content.dialogmain>
	<form id="form-palm-analytics" action="<@spring.url '/analytics' />" style="padding-left: 25px" class="MISSY_round_right"  enctype="multipart/form-data" >	
	
	<table>
	        <tr style="background:transparent">
	            <td style="width:70%;padding:0">
	            	<span style="margin-top:5px;">By File Upload : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/analytics/upload' />" multiple />
				</td>
	            <td style="padding:0">
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	
		<#-- text result -->
	  	<div id="text_area"></div>
	</form>
<script>
	$(function() {
    	<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , "#text_area" );
	});	
	
</script>  	
	</@content.dialogmain>
</@dialoglayout.global>