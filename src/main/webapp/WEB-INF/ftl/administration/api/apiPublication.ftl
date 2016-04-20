<div id="boxbody${wUniqueName}" class="box-body no-padding">

 <div class="box-group" id="accordion2">
  
  	<#-- Search Publication -->
    <div class="panel box box-primary">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseOne2" class="collapsed" aria-expanded="false">
            Publications Search ( /publication/search? )
          </a>
        </h4>
      </div>
      <div id="collapseOne2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationSearch.ftl">
        </div>
      </div>
    </div>
    
     <#-- Publication Detail -->
    <div class="panel box box-danger">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo2" class="collapsed" aria-expanded="false">
            Publication Information ( /publication/basicInformation? )
          </a>
        </h4>
      </div>
      
      <div id="collapseTwo2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationBasicInformation.ftl">
        </div>
      </div>
    </div>
    
    <#-- Publication Details -->
    <div class="panel box box-success">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseThree2" class="collapsed" aria-expanded="false">
            Publication Details ( /publication/detail? )
          </a>
        </h4>
      </div>
      
      <div id="collapseThree2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationDetail.ftl">
        </div>
      </div>
    </div>
    
    <#-- Publication Topics -->
    <div class="panel box box-info">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseFour2" class="collapsed" aria-expanded="false">
            Publication Topics Composition( /publication/topic? )
          </a>
        </h4>
      </div>
      
      <div id="collapseFour2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationTopic.ftl">
        </div>
      </div>
    </div>
    
    <#-- Publication Bibtex -->
    <div class="panel box  box-warning">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseFive2" class="collapsed" aria-expanded="false">
            Publication BibTeX ( /publication/bibtex? )
          </a>
        </h4>
      </div>
      
      <div id="collapseFive2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationBibtex.ftl">
        </div>
      </div>
    </div>
    
     <#-- Publication PdfHtmlExtract -->
    <div class="panel box">
      <div class="box-header with-border">
        <h4 class="box-title">
          <a data-toggle="collapse" data-parent="#accordion2" href="#collapseSix2" class="collapsed" aria-expanded="false">
            Extract Publication Information from Resources ( /publication/pdfHtmlExtract? )
          </a>
        </h4>
      </div>
      
      <div id="collapseSix2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
        <div class="box-body">
        	<#include "apiPublicationHtmlPdfExtract.ftl">
        </div>
      </div>
    </div>
    
    </div>

</div>