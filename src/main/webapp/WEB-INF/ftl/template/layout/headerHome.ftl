<nav class="navbar navbar-static-top">
  <div class="container-fluid">
	  <div class="navbar-header">
	    <#--Logo -->
		<a href="<@spring.url '/' />" class="navbar-brand title"><strong>PALM</strong></a>
		<span class="navbar-brand subtitle"><strong>Personal Academic Learner Model</strong></span>
	    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
	      <i class="fa fa-bars"></i>
	    </button>
	  </div>
	
	  <#--Collect the nav links, forms, and other content for toggling -->
	  <div class="collapse navbar-collapse" id="navbar-collapse">
	
	    <ul class="nav navbar-nav navbar-right">
	      <#--Navigation menu -->
	      <#include "headerNavigationMenu.ftl" />
	      
	      <#--Notifications: style can be found in dropdown.less -->
	      <#--<#include "headerNotification.ftl" />-->
	      
	      <#--User Account: style can be found in dropdown.less -->
	      <#include "headerUserAccount.ftl" />
	    </ul>
	  </div><#--/.navbar-collapse -->
  </div><#--/.container-fluid -->
</nav>