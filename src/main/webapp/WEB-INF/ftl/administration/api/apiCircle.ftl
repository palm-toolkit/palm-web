<div id="boxbody${wUniqueName}" class="box-body no-padding">

    <div class="box-group" id="accordion4">
  
  	<#-- Search Circle -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4One" class="collapsed" aria-expanded="false">
            Circles Search ( /circle/search? )
          </a>
        </h4>
      </div>
      <div id="collapse4One" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCircleSearch.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Basic Information -->
    <div class="panel box box-danger">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Two" class="collapsed" aria-expanded="false">
            Circle Information ( /circle/basicInformation? )
          </a>
        </h4>
      </div>
      
      <div id="collapse4Two" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCircleBasicInformation.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Publication List -->
    <div class="panel box box-success">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Three" class="collapsed" aria-expanded="false">
            Publications in Circle( /circle/publication? )
          </a>
        </h4>
      </div>
      
      <div id="collapse4Three" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCirclePublication.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Co-Author -->
    <div class="panel box box-info">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Four" class="collapsed" aria-expanded="false">
            Researchers in Circle( /circle/researcherList? )
          </a>
        </h4>
      </div>
      
      <div id="collapse4Four" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCircleResearcher.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Co-Author -->
    <div class="panel box  box-warning">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Five" class="collapsed" aria-expanded="false">
            Circle Publication Top List ( /circle/publicationTopList? )
          </a>
        </h4>
      </div>
      
      <div id="collapse4Five" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCirclePublicationTop.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Conference Tree -->
    <div class="panel box">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Six" class="collapsed" aria-expanded="false">
            Circle Conferences Tree ( /circle/academicEventTree? )
          </a>
        </h4>
      </div>
      
      <div id="collapse4Six" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCircleConferenceTree.ftl">
        </div>
      </div>
    </div>
    
    <#-- Circle Interest -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion4" href="#collapse4Seven" class="collapsed" aria-expanded="false">
            Circles Topics Composition ( /circle/interest? )
          </a>
        </h4>
      </div>
      <div id="collapse4Seven" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiCircleInterest.ftl">
        </div>
      </div>
    </div>
    
  </div>

</div>