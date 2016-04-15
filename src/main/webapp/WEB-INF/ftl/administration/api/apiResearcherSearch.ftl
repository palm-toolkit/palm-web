<form action="<@spring.url '/researcher/search' />" method="post" role="form">

<div class="form-group">
  <label class="info-label">Searching researchers either on PALM database or on Adacemic Networks</label> 
</div>

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. Mohamed Amine Chatti, blank input will list all researchers</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>queryType</label>
	<select name="queryType" class="form-control">
		<option value="name">name</option>
		<option value="affiliation" disabled>affiliation</option>
	</select>
</div>

<#-- Text input-->
<div class="form-group">
	<label>startPage</label>  
	<input name="startPage" type="text" class="form-control" value="0">
	<span class="help-block">set the starting point of retrieved records</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>maxResult</label>  
	<input name="maxResult" type="text" class="form-control" value="20">
	<span class="help-block">number of maximum retrieved records</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>source</label>
	<select id="source" name="source" class="form-control">
		<option value="internal">internal</option>
		<option value="all">all</option>
	</select>
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>fulltextSearch</label>
	<div class="radio" style="padding:2px 0">
		<label class="col-md-4">
			<input type="radio" name="fulltextSearch" value="yes" checked="">
			Yes
		</label>
		<label>
			<input type="radio" name="fulltextSearch" value="no">
			No
		</label>
	</div>
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>addedAuthor</label>
	<div class="radio" style="padding:2px 0">
		<label class="col-md-4">
			<input type="radio" name="addedAuthor" value="yes" checked="">
			Yes
		</label>
		<label>
			<input type="radio" name="fulltextSearch" value="no">
			No
		</label>
	</div>
	<span class="help-block">Researchers which are directly added to PALM</span>
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
