<form action="<@spring.url '/publication/pdfExtract' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Extract publication information from PDF</label> 
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>url</label>  
  <input name="url" type="text" class="form-control input-md">
  <span class="help-block">The Pdf Url</span>  
</div>

<#-- Button -->
<div class="form-group">
    <button onclick="$.PALM.api.submit( $(this) ); return false;" class="btn btn-primary">Execute</button>
</div>

<br/>

<#-- query -->
<div class="form-group">
	<label>API Query</label>
	<textarea class="form-control queryAPI" rows="2" readonly>
	</textarea>
</div>

<div class="form-group">
	<label>API Results</label>
	<pre class="textarea">
	</pre>
</div>
</form>
