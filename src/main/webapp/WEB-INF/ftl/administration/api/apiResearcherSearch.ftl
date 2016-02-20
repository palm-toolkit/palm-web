<form role="form">

<#-- Query name -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" placeholder="e.g. Mohamed Amine Chatti" class="form-control input-md">
  <span class="help-block">e.g. researcher name</span>  
</div>

<!-- Select Basic -->
<div class="form-group col-xs-4">
  <label>queryType</label>
    <select name="queryType" class="form-control col-xs-4">
      <option value="name">name</option>
      <option value="affiliation">affiliation</option>
    </select>
</div>

<!-- Text input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="textinput">startPage</label>  
  <div class="col-md-1">
  <input id="textinput" name="textinput" type="text" placeholder="placeholder" class="form-control input-md">
  <span class="help-block">for paging</span>  
  </div>
</div>

<!-- Text input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="textinput">maxResult</label>  
  <div class="col-md-1">
  <input id="textinput" name="textinput" type="text" placeholder="placeholder" class="form-control input-md">
  <span class="help-block">number of maximum returned results</span>  
  </div>
</div>

<!-- Select Basic -->
<div class="form-group">
  <label class="col-md-4 control-label" for="selectbasic">source</label>
  <div class="col-md-4">
    <select id="selectbasic" name="selectbasic" class="form-control">
      <option value="1">internal</option>
      <option value="2">all</option>
    </select>
  </div>
</div>

<!-- Multiple Radios (inline) -->
<div class="form-group">
  <label class="col-md-4 control-label" for="radios">addedAuthor</label>
  <div class="col-md-4"> 
    <label class="radio-inline" for="radios-0">
      <input type="radio" name="radios" id="radios-0" value="1" checked="checked">
      yes
    </label> 
    <label class="radio-inline" for="radios-1">
      <input type="radio" name="radios" id="radios-1" value="2">
      no
    </label>
  </div>
</div>

<!-- Multiple Radios (inline) -->
<div class="form-group">
  <label class="col-md-4 control-label" for="radios">fulltextSearch</label>
  <div class="col-md-4"> 
    <label class="radio-inline" for="radios-0">
      <input type="radio" name="radios" id="radios-0" value="1" checked="checked">
      yes
    </label> 
    <label class="radio-inline" for="radios-1">
      <input type="radio" name="radios" id="radios-1" value="2">
      no
    </label>
  </div>
</div>

<!-- Multiple Radios (inline) -->
<div class="form-group">
  <label class="col-md-4 control-label" for="radios">persist</label>
  <div class="col-md-4"> 
    <label class="radio-inline" for="radios-0">
      <input type="radio" name="radios" id="radios-0" value="1" checked="checked">
      yes
    </label> 
    <label class="radio-inline" for="radios-1">
      <input type="radio" name="radios" id="radios-1" value="2">
      no
    </label>
  </div>
</div>

<!-- Button -->
<div class="form-group">
  <label class="col-md-4 control-label" for="singlebutton"></label>
  <div class="col-md-4">
    <button id="singlebutton" name="singlebutton" class="btn btn-primary">Execute</button>
  </div>
</div>

</form>
