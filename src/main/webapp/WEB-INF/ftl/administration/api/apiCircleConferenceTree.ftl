<form action="<@spring.url '/circle/academicEventTree' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get Conference/Journal Tree of a circle</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get circle ID from first API (Circle Search).</label>  
</div>

<#-- Circle Id -->
<div class="form-group">
  <label>id</label>  
  <input name="id" type="text" class="form-control input-md">
  <span class="help-block">Circle ID gathered from Circle Search API</span>  
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
