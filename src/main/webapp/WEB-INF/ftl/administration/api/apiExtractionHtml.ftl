<form action="<@spring.url '/publication/htmlExtract' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Extract publication information from webpage / digital library</label> 
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>url</label>  
  <input name="url" type="text" class="form-control input-md">
  <span class="help-block">The Webpage Url</span>  
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
