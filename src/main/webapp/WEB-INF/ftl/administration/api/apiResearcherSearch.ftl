<form action="<@spring.url '/researcher/search' />" method="post" role="form">

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. Mohamed Amine Chatti</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>queryType</label>
	<select name="queryType" class="form-control">
		<option value="name">name</option>
		<option value="affiliation">affiliation</option>
	</select>
</div>

<#-- Text input-->
<div class="form-group">
	<label>startPage</label>  
	<input name="startPage" type="text" class="form-control" value="0">
	<span class="help-block">set the starting of records</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>maxResult</label>  
	<input name="maxResult" type="text" class="form-control" value="20">
	<span class="help-block">number of maximum returned results</span>  
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
	<div class="radio">
		<label class="col-md-4">
			<input type="radio" name="fulltextSearch" value="on" checked="">
			Yes
		</label>
		<label>
			<input type="radio" name="fulltextSearch" value="off">
			No
		</label>
	</div>
</div>

<#-- Button -->
<div class="form-group">
  <div class="col-md-4">
    <button onclick="$.PALM.api.submit( $(this) ); return false;" class="btn btn-primary">Execute</button>
  </div>
</div>

<#-- query -->
<div class="form-group">
	<label>API Query</label>
	<textarea class="form-control queryAPI" rows="3" readonly>
	</textarea>
</div>

<#-- result -->
<pre class="textarea">
</pre>

</form>
