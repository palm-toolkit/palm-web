<form action="<@spring.url '/publication/detail' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get publication details</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get publication ID from first API (Publication Search).</label>  
</div>

<#-- Publication ID-->
<div class="form-group">
	<label>id</label>  
	<input name="id" type="text" class="form-control">
	<span class="help-block">Publication ID gathered from Publication Search API</span>  
</div>

<div class="form-group">
  <label>section</label>  
  <input name="section" type="test" class="form-control input-md">
  <span class="help-block">blank input or title, title-abstract, title-coauthor-abstract-keyword</span>  
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
