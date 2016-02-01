<section class="sidebar" style="height: auto;">
  <ul class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>USER DASHBORD</strong></li>

	<#-- Profile menu -->
    <li class="treeview" data-link="profile">
      <a href="<@spring.url '/user/profile' />">
        <i class="fa fa-user"></i>
        <span>My Profile</span>
      </a>
    </li>

	<#-- Publications menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/user/publication' />">
        <i class="fa fa-file-text-o"></i>
        <span>My Publications</span>
      </a>
    </li>
    
    <#-- Conferences menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/user/event' />">
        <i class="fa fa-globe"></i>
        <span>My Conferences</span>
      </a>
    </li>
    
    <#-- Circles menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/user/circle' />">
        <i class="fa fa fa-circle-o"></i>
        <span>My Circles</span>
      </a>
    </li>
    
  </ul>
</section>