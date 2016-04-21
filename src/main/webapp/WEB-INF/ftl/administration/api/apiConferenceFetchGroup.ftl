<form action="<@spring.url '/venue/fetchGroup' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get conference/ journal year and volume list</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get conference/journal ID from first API (Conference/Journal Search). Use only ID from conference/journal which is added to PALM (isAdded:true)</label>  
</div>

<#-- Conference/Journal ID-->
<div class="form-group">
	<label>id</label>  
	<input name="id" type="text" class="form-control">
	<span class="help-block">Conference/Journal ID gathered from Conference/Journal Search API</span>  
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
