<form action="<@spring.url '/circle/search' />" method="post" role="form">

<div class="form-group">
  <label class="info-label">Searching circles on PALM database, all inputs are optional</label> 
</div>

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. circle name, blank input will list all circles</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>page</label>  
	<input name="page" type="text" class="form-control" value="0">
	<span class="help-block">set the starting point of retrieved records</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>maxresult</label>  
	<input name="maxresult" type="text" class="form-control" value="20">
	<span class="help-block">number of maximum retrieved records</span>  
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
