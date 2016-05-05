<nav class="navbar navbar-static-top">
  <div class="container-fluid">
	  <div class="navbar-header">
	    <#--Logo -->
		<a href="<@spring.url '/' />" class="navbar-brand title" style="padding:0;display:block;width:270px;">
			<img src="<@spring.url '/resources/images/logo_white_h35px.png' />" alt="palm-logo" style="height:35px;padding:4px 5px 0 0;float:left;">
			<span class="pull-left" style="font-size:26px;line-height:26px;height:20px;"><strong>PALM</strong></span>
			<span class="pull-left subtitle" style="padding:0"><strong>Personal Academic Learner Model</strong></span>
		</a>
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