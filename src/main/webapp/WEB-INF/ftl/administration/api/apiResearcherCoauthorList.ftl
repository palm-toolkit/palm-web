<form action="<@spring.url '/researcher/coAuthorList' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get list of co-authors of a researcher</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get researcher ID from first API (Researcher Search). Use only ID from researcher which is added to PALM (isAdded:true)</label>  
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>id</label>  
  <input name="id" type="text" class="form-control input-md">
  <span class="help-block">Researcher ID gathered from Researcher Search API</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>startPage</label>  
	<input name="startPage" type="text" class="form-control" value="0">
	<span class="help-block">set the starting point of retrieved records</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>maxresult</label>  
	<input name="maxresult" type="text" class="form-control" value="10">
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
