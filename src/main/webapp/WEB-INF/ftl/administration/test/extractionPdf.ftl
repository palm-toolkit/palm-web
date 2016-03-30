<div id="boxbody${wUniqueName}" class="box-body">

	<div class="col-md-6">
		<div class="box box-default box-solid">
			<div class="box-header">
				<h3 class="box-title">Extract publication from PDF - Morphological Approach</h3>
				<div class="box-tools pull-right">
	            	<button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
	            	<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
	           </div>
			</div>
			
			<div class="box-body">
				
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
	    
			</div>
		</div>
	</div>
	
	 <br/>

	 <form role="form" id="addPublication" action="<@spring.url '/publication/add' />" method="post" style="clear:both">
		
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication">
	    </div>
	    
	    <div id="similar-publication-container" class="form-group" style="display:none">
	    	<div class="callout callout-warning">
	            <h4>Similar publication is found on PALM database!</h4>
	            <div class="content-list info-box">
	            </div>
	        </div>
	    </div>

		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <textarea name="author" id="author" class="form-control" rows="3" placeholder="Author"></textarea>
	    </div>
	    
		<#-- abstract -->
		<div class="form-group">
	      <label>Abstract</label>
	      <textarea name="abstractText" id="abstractText" class="form-control" rows="3" placeholder="Abstract"></textarea>
	    </div>

		<#-- keyword -->
		<div class="form-group">
	      <label>Keywords</label>
	      <textarea name="keywords" id="keywords" class="form-control" rows="3" placeholder="Keywords"></textarea>
	    </div>
	    
		<#-- Content -->
		<div class="form-group">
	      <label>Content</label>
	      <textarea name="contentText" id="contentText" class="form-control" rows="3" placeholder="Content"></textarea>
	    </div>
	    
	    <#-- keyword -->
		<div class="form-group">
	      <label>References</label>
	      <textarea name="referenceText" id="referenceText" class="form-control" rows="3" placeholder="References"></textarea>
	    </div>
	</form>
</div>

<div class="box-footer">
</div>

<script>
	$(function(){
	
		 $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			alwaysVisible: true
		  });

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );
		
	   
	});

</script>