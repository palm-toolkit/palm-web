<#-- Logo -->
<a href="<@spring.url '/' />" class="logo"><strong>PALM</strong></a>
<#-- Header Navbar: style can be found in header.less -->
<nav class="navbar navbar-static-top" role="navigation">
  <#-- Sidebar toggle button-->
  <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
    <span class="sr-only">Toggle navigation</span>
  </a>
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