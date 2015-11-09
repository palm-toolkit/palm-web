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

		<#-- publication-date -->
		<div class="form-group">
			<label>Publication Date</label>
			<div class="input-group" style="width:120px">
				<div class="input-group-addon">
					<i class="fa fa-calendar"></i>
				</div>
	      		<input type="text" id="publication-date" name="publication-date" class="form-control" data-inputmask="'alias': 'mm/yyyy'" data-mask="">
			</div>
	    </div>

		<#-- Venue -->
		<div class="form-group">
          <label>Venue</label>
          <div style="width:100%">
	          <select id="venue-type" name="venue-type" class="form-control pull-left" style="width:120px">
	            <option value="conference">Conference</option>
	            <option value="journal">Journal</option>
	          </select>
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="venue" name="venue" class="form-control">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="volume-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Volume</label>
				<input type="text" id="volume" name="volume" class="form-control">
			</div>
			<div id="issue-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Issue</label>
				<input type="text" id="issue" name="issue" class="form-control">
			</div>
			<div id="pages-container" class="col-xs-3 minwidth150Px">
				<label>Pages</label>
				<input type="text" id="pages" name="pages" class="form-control">
			</div>
			<div class="col-xs-3 minwidth150Px">
				<label>Publisher</label>
				<input type="text" id="publisher" name="publisher" class="form-control">
			</div>
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
</div>

<script>
	$(function(){

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );

		<#-- activate input mask-->
		$( "[data-mask]" ).inputmask();

		$( "#submit" ).click( function(){
			$("#addPublication").submit();
		});
		
		$( "#venue-type" ).change( function(){
			var selectionValue = $(this).val();
			if( selectionValue == "conference" ){
				$( "#volume-container,#issue-container" ).hide();
			} else if( selectionValue == "journal" ){
				$( "#volume-container,#issue-container" ).show();
			}
		});
	});
</script>