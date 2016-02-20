<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody${wUniqueName}" class="box-body no-padding">

  <div class="box-group" id="accordion">
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" class="">
            Search Researchers
          </a>
        </h4>
      </div>
      <div id="collapseOne" class="panel-collapse collapse in" aria-expanded="true">
        <div class="box-body">
        	<#include "apiResearcherSearch.ftl">
        </div>
      </div>
    </div>
    <div class="panel box box-danger">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="collapsed" aria-expanded="false">
            Collapsible Group Danger
          </a>
        </h4>
      </div>
      <div id="collapseTwo" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
          Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
        </div>
      </div>
    </div>
    <div class="panel box box-success">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree" class="collapsed" aria-expanded="false">
            Collapsible Group Success
          </a>
        </h4>
      </div>
      <div id="collapseThree" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
          Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
        </div>
      </div>
    </div>
  </div>

</div>