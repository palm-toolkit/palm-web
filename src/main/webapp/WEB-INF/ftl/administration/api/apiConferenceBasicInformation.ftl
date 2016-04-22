<form action="<@spring.url '/venue//basicinformation' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get Conference/Journal information</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get Conference/Journal ID from first API (Conference/Journal Search). Use only ID from Conference/Journal which is added to PALM (isAdded:true)</label>  
</div>

<#-- Conference/Journal ID-->
<div class="form-group">
	<label>id</label>  
	<input name="id" type="text" class="form-control">
	<span class="help-block">Conference/Journal ID gathered from Conference/Journal Search API</span>  
</div>

<div class="form-group">
	<label>type</label>
	<select name="type" class="form-control">
		<option value="event">event</option>
		<option value="eventGroup">eventGroup</option>
	</select>
	<span class="help-block">Event means conference/journal on specific year or volume, EventGroup means the entire Conference/Journal</span>  
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
