<div id="boxbody${wUniqueName}" class="box-body no-padding">
	<h1>Researcher APIs</h1>
  <div class="box-group" id="accordion">
  
  	<#-- Search Researcher -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" class="collapsed" aria-expanded="false">
            Researchers Search ( /researcher/search? )
          </a>
        </h4>
      </div>
      <div id="collapseOne" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherSearch.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Detail -->
    <div class="panel box box-danger">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="collapsed" aria-expanded="false">
            Researcher Information ( /researcher/basicInformation? )
          </a>
        </h4>
      </div>
      
      <div id="collapseTwo" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherBasicInformation.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Publication List -->
    <div class="panel box box-success">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree" class="collapsed" aria-expanded="false">
            Researcher Publications ( /researcher/publicationList? )
          </a>
        </h4>
      </div>
      
      <div id="collapseThree" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherPublication.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Co-Author -->
    <div class="panel box box-info">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour" class="collapsed" aria-expanded="false">
            Researcher Top Cited Publications( /researcher/publicationTopList? )
          </a>
        </h4>
      </div>
      
      <div id="collapseFour" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherPublicationTop.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Co-Author -->
    <div class="panel box  box-warning">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseFive" class="collapsed" aria-expanded="false">
            Researcher Co-Authors ( /researcher/coAuthorList? )
          </a>
        </h4>
      </div>
      
      <div id="collapseFive" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherCoauthorList.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Conference Tree -->
    <div class="panel box">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseSix" class="collapsed" aria-expanded="false">
            Researcher Conferences Tree ( /researcher/academicEventTree? )
          </a>
        </h4>
      </div>
      
      <div id="collapseSix" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherConferenceTree.ftl">
        </div>
      </div>
    </div>
    
    <#-- Researcher Interest -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseSeven" class="collapsed" aria-expanded="false">
            Researchers Interest ( /researcher/interest? )
          </a>
        </h4>
      </div>
      <div id="collapseSeven" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "../administration/api/apiResearcherInterest.ftl">
        </div>
      </div>
    </div>
    
  </div>
  
  <h1>Publication APIs</h1>

</div>