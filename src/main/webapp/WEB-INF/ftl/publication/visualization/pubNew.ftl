<div id="boxbody<#--${wId}-->" class="box-body">

		<table style="width:100%">
	        <tr style="background:transparent">
	            <td style="width:70%;padding:0">
	            	<span style="margin-top:5px;">Upload your publication (PDF format) : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/publication/upload' />" multiple />
				</td>
	            <td style="padding:0">
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>

	 <form role="form" id="addPublication" action="<@spring.url '/publication/add' />" method="post">
		
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication">
	    </div>

		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <textarea id="author" class="form-control" rows="3" placeholder="Author"></textarea>
	    </div>

		<#-- abstract -->
		<div class="form-group">
	      <label>Abstract</label>
	      <textarea name="abstractText" id="abstractText" class="form-control" rows="3" placeholder="Abstract"></textarea>
	    </div>

		<#-- keyword -->
		<div class="form-group">
	      <label>Keywords</label>
	      <textarea id="keywords" class="form-control" rows="3" placeholder="Keywords"></textarea>
	    </div>

		<#-- content -->
		<div class="form-group">
	      <label>Content</label>
	      <textarea name="contentText" id="contentText" class="form-control" rows="3" placeholder="Publication body/content"></textarea>
	    </div>

		<#-- references -->
		<div class="form-group">
	      <label>References</label>
	      <textarea name="referenceText" id="referenceText" class="form-control" rows="3" placeholder="References"></textarea>
	    </div>

		<#-- conference/journal -->
<#--		<div class="form-group">
	      <label>Venue</label>
	      <input type="text" id="venue" name="venue" class="form-control" placeholder="Venue">
	    </div>
-->
	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Submit</button>
	<button id="submit" class="btn btn-primary">Cancel</button>
</div>

<script>
	$(function(){

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );

		$("#submit").click( function(){
			$("#addPublication").submit();
		});
	});
</script>