<form action="<@spring.url '/publication/search' />" method="post" role="form">

<div class="form-group">
  <label class="info-label">Searching publications on PALM database, all inputs are optional</label> 
</div>

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. publication title, blank input will list all publications</span>  
</div>

<#-- Query name -->
<div class="form-group">
  <label>publicationType</label>  
  <input name="publicationType" type="publicationType" class="form-control input-md">
  <span class="help-block">blank input or conference, conference-journal</span>  
</div>

<div class="form-group">
  <label>authorId</label>  
  <input name="authorId" type="text" class="form-control input-md">
</div>

<div class="form-group">
  <label>eventId</label>  
  <input name="eventId" type="text" class="form-control input-md">
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

<#-- Text input-->
<div class="form-group">
	<label>year</label>  
	<input name="year" type="text" class="form-control">
	<span class="help-block">publication's year published</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>orderBy</label>
	<select name="orderBy" class="form-control">
		<option value="date">date</option>
		<option value="citation">number of citation</option>
	</select>
	<span class="help-block">if you choose search with fulltextSearch, the results will be ordered based on relevancy</span>  
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>fulltextSearch</label>
	<div class="radio" style="padding:2px 0">
		<label class="col-md-4">
			<input type="radio" name="fulltextSearch" value="yes">
			Yes
		</label>
		<label>
			<input type="radio" name="fulltextSearch" value="no" checked="">
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
