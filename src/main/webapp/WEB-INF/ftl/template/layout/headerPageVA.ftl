<#-- Logo -->
<#--<a href="<@spring.url '/' />" class="logo">
<strong>PALM</strong>
</a>
-->
 <#--Logo -->
<a href="<@spring.url '/' />" class="logo" style="padding:0;display:block;">
	<div style="width:300px;margin:0 auto;display:block;">
		<img src="<@spring.url '/resources/images/logo_white_h35px.png' />" alt="palm-logo" style="height:35px;padding:4px 5px 0 0;float:left;">
		<span class="pull-left" style="font-size:26px;line-height:26px;height:20px;"><strong>PALM</strong></span>
		<span class="pull-left subtitle" style="padding:0;font-size:14px;margin:0;line-height:20px;"><strong>Personal Academic Learner Model</strong></span>
	</div>
</a>
<#-- Header Navbar: style can be found in header.less -->
<nav class="navbar navbar-static-top" role="navigation">
  <#-- Sidebar toggle button-->
  <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
    <span class="sr-only">Toggle navigation</span>
  </a>
  
  	<div class="navbar-header" style="width:20%;text-align:right">
	    <a class="btn btn-info btn-sm"  id="va-help" role="button" data-url="<@spring.url '/menu/va-help' />" title="Visual Analytics in PALM" style="margin-top:4px"><i class="fa fa-info-circle"></i>  Help</a>
	  </div>
  
  <#-- Navbar Right Menu -->
  <div class="navbar-custom-menu">
    <ul class="nav navbar-nav">
    
      <#--Navigation menu -->
      <#include "headerNavigationMenu.ftl" />

      <#-- Notifications: style can be found in dropdown.less -->
      <#include "headerNotification.ftl" />
      
      <#-- User Account: style can be found in dropdown.less -->
      <#include "headerUserAccount.ftl" />
      
    </ul>
  </div>
</nav>

<script>
$(function(){
	$( "#va-help" ).click( function( event ){
		console.log("clicked!!")
		$.PALM.popUpIframe.create( $(this).data("url") , {popUpHeight:"480px"}, $(this).attr("title") );
		event.preventDefault();
	});
});

</script>