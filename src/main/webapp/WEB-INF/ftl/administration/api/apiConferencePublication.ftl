<form action="<@spring.url '/venue/publicationList' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get publications from a Conference/Journal on specific year or volume</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get Conference/Journal (based on year or volume) ID from first API (Conference/Journal Search). Use only ID from Conference / Journal which is added to PALM (isAdded:true)</label>  
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>id</label>  
  <input name="id" type="text" class="form-control input-md">
  <span class="help-block">Researcher ID gathered from Researcher Search API</span>  
</div>

<#-- Query -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. knowledge management</span>  
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
