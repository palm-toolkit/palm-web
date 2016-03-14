<form action="<@spring.url '/researcher/basicInformation' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get researcher basic information and number of publications per year</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get researcher ID from first API (Researcher Search). Use only ID from researcher which is added to PALM (isAdded:true)</label>  
</div>

<#-- Researcher ID-->
<div class="form-group">
	<label>id</label>  
	<input name="id" type="text" class="form-control">
	<span class="help-block">Researcher ID gathered from Researcher Search API</span>  
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
