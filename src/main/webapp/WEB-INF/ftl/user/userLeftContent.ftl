<section class="sidebar" style="height: auto;">
  <ul class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>USER DASHBORD</strong></li>

	<#-- Profile menu -->
    <li class="treeview" data-link="profile">
      <a href="<@spring.url '/user/profile' />">
        <i class="fa fa-user"></i>
        <span>Profile</span>
      </a>
    </li>

	<#-- Publication menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/user/publication' />">
        <i class="fa fa-file-text-o"></i>
        <span>Publications</span>
      </a>
    </li>
    
    <#-- Conference menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/user/event' />">
        <i class="fa fa-file-text-o"></i>
        <span>Conferences</span>
      </a>
    </li>
    
  </ul>
</section>