<nav class="navbar navbar-static-top">
  <div class="container-fluid">
	  <div class="navbar-header">
	    <!-- Logo -->
		<a href="#" class="navbar-brand"><strong>PALM</strong></a>
	    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
	      <i class="fa fa-bars"></i>
	    </button>
	  </div>
	
	  <!-- Collect the nav links, forms, and other content for toggling -->
	  <div class="collapse navbar-collapse" id="navbar-collapse">
	
	    <ul class="nav navbar-nav navbar-right">
	      <!-- Notifications: style can be found in dropdown.less -->
	      <#include "headerNotification.ftl" />
	      
	      <!-- User Account: style can be found in dropdown.less -->
	      <#include "headerUserAccount.ftl" />
	    </ul>
	  </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>

<#--
<div id="site_title_bar_wrapper">
	<div id="site_title_bar"> 
	
		<div id="site_title">
            <h1><a href="#">PALM</a></h1>
        </div>
        
        <#include "mainNavigation.ftl" />
        
        <div id="search_box" class="invisible">
            <input type="text" value="" name="q" size="10" id="searchfield" title="searchfield" />
            <div id="searchbutton">Search</div>
       </div>
        
        <div id="site_sub_title">
        	<h3>Personal Academic Learner Model</h3>
        </div>
       
	</div>
       
</div> 
-->