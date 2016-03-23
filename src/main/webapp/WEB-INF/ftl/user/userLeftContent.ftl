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
        <i class="fa fa-circle-o"></i>
        <span>My Circles</span>
      </a>
    </li>
    
    <#-- Bookmark author menu -->
    <li class="treeview" data-link="bookmarkauthor">
      <a href="<@spring.url '/user/book/author' />">
        <i class="fa fa-file-text-o"></i>
        <span>Followed Researchers</span>
      </a>
    </li>
    
    <#-- Bookmark publication menu -->
    <li class="treeview" data-link="bookmarkpublication">
      <a href="<@spring.url '/user/book/publication' />">
        <i class="fa fa fa-user"></i>
        <span>Booked Publications</span>
      </a>
    </li>
    
    <#-- Bookmark eventGroup menu -->
    <li class="treeview" data-link="bookmarkeventgroup">
      <a href="<@spring.url '/user/book/conference' />">
        <i class="fa fa-globe"></i>
        <span>Booked Conferences</span>
      </a>
    </li>
    
    <#-- Bookmark circle menu -->
    <li class="treeview" data-link="bookmarkcircle">
      <a href="<@spring.url '/user/book/circle' />">
        <i class="fa fa-circle-o"></i>
        <span>Booked Circles</span>
      </a>
    </li>
  </ul>
</section>