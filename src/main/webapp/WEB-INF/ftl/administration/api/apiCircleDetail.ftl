<form action="<@spring.url '/circle/detail' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get Circle Details</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get circle ID from first API (Circle Search).</label>  
</div>

<#-- Circle ID-->
<div class="form-group">
	<label>id</label>  
	<input name="id" type="text" class="form-control">
	<span class="help-block">Circle ID gathered from Circle Search API</span>  
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>retrieveAuthor</label>
	<div class="radio" style="padding:2px 0">
		<label class="col-md-4">
			<input type="radio" name="retrieveAuthor" value="yes" checked="">
			Yes
		</label>
		<label>
			<input type="radio" name="retrieveAuthor" value="no">
			No
		</label>
	</div>
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>retrievePubication</label>
	<div class="radio" style="padding:2px 0">
		<label class="col-md-4">
			<input type="radio" name="retrievePubication" value="yes" checked="">
			Yes
		</label>
		<label>
			<input type="radio" name="retrievePubication" value="no">
			No
		</label>
	</div>
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
