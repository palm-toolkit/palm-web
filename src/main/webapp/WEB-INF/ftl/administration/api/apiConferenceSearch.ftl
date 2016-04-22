<form action="<@spring.url '/venue/search' />" method="post" role="form">

<div class="form-group">
  <label class="info-label">Searching Conferences/Journals either on PALM database or on Adacemic Networks</label> 
</div>

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. Educational Data Mining, blank input will list all Conferences/Journals</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
  <label>abbr</label>  
  <input name="abbr" type="text" class="form-control input-md width80px">
  <span class="help-block">the abbreviation e.g. EDM</span>  
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
  <label>type</label>  
  <input name="type" type="text" class="form-control input-md">
  <span class="help-block">venue type either blank, conference, journal, journal-conference</span>  
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>source</label>
	<select id="source" name="source" class="form-control">
		<option value="internal">internal</option>
		<option value="all">all</option>
	</select>
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
