<div id="boxbody${wUniqueName}" class="box-body no-padding">

   <div class="box-group" id="accordion3">
  
  	<#-- Search Venue -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion3" href="#collapse3One" class="collapsed" aria-expanded="false">
            Conference/Journal Search ( /venue/search? )
          </a>
        </h4>
      </div>
      <div id="collapse3One" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiConferenceSearch.ftl">
        </div>
      </div>
    </div>
    
    <#-- Venue Fetch Group -->
    <div class="panel box box-danger">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion3" href="#collapse3Two" class="collapsed" aria-expanded="false">
            Conference/Journal Years/Volumes ( /venue/fetchGroup? )
          </a>
        </h4>
      </div>
      
      <div id="collapse3Two" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiConferenceFetchGroup.ftl">
        </div>
      </div>
    </div>
    
    <#-- Venue Conference/Journal Information -->
    <div class="panel box box-success">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion3" href="#collapse3Three" class="collapsed" aria-expanded="false">
            Conference/Journal Information( /venue/basicinformation? )
          </a>
        </h4>
      </div>
      
      <div id="collapse3Three" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiConferenceBasicInformation.ftl">
        </div>
      </div>
    </div>
    
        <#-- Venue Publications -->
    <div class="panel box box-info">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion3" href="#collapse3Four" class="collapsed" aria-expanded="false">
            Publications on Conference/Journal on specific year/volume( /venue/publicationList? )
          </a>
        </h4>
      </div>
      
      <div id="collapse3Four" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiConferencePublication.ftl">
        </div>
      </div>
    </div>
    
        <#-- Venue Interest -->
    <div class="panel box  box-warning">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion3" href="#collapse3Five" class="collapsed" aria-expanded="false">
            Topics Composition on Conference/Journal on specific year/volume( /venue/interest? )
          </a>
        </h4>
      </div>
      
      <div id="collapse3Five" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiConferenceTopicComposition.ftl">
        </div>
      </div>
    </div>
    
  </div>

</div>