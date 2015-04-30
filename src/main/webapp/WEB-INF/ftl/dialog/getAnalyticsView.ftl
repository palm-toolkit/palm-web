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
	  	
	  	
	  	<#-- testing -->
	  	<textarea id="input_text" name="input_text" style="height:180px;width:95%"></textarea>
	  	<br/>
	  	<input type="button" id="procceed_btn" value="analyze" />
	  	
	  	<#-- text result -->
	  	<div id="results"></div>
	</form>
<script>
	$(function() {
    	<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , "#text_area" );
    	
    	$( "#procceed_btn" ).click( function(){
    		analyzeContent();
    	});
	});	
	
	function analyzeContent(){
		$.post( "<@spring.url '/analytics/run' />", { "content" : $( "#input_text" ).val() })
		.done( function( html){
			$( "#results" ).html( html );
		});
	}
	
</script>  	
	</@content.dialogmain>
</@dialoglayout.global>