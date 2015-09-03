<section class="sidebar" style="height: auto;">
  <ul class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>ADMINISTRATION</strong></li>
    
    <#-- Widgets menu -->
    <li class="treeview" data-link="widget">
      <a href="#">
        <i class="fa fa-th"></i>
        <span>Widgets</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="overview"><a href="<@spring.url '/admin/widget/overview' />"><i class="fa fa-caret-right"></i>Overview</a></li>
        <li data-link="add"><a href="<@spring.url '/admin/widget/add' />"><i class="fa fa-caret-right"></i>Add New Widget</a></li>
        <li data-link="edit"><a href="<@spring.url '/admin/widget/edit' />"><i class="fa fa-caret-right"></i>Edit Widget</a></li>
        <li data-link="conference"><a href="<@spring.url '/admin/widget/conference' />"><i class="fa fa-caret-right"></i>Conference Widget</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/widget/publication' />"><i class="fa fa-caret-right"></i>Publication Widget</a></li>
        <li data-link="researcher"><a href="<@spring.url '/admin/widget/researcher' />"><i class="fa fa-caret-right"></i>Researcher Widget</a></li>
        <li data-link="administration"><a href="<@spring.url '/admin/widget/administration' />"><i class="fa fa-caret-right"></i>Administration Widget</a></li>
      </ul>
    </li>

	<#-- SOurces menu -->
    <li class="treeview" data-link="source">
      <a href="<@spring.url '/admin/source' />">
        <i class="fa fa-book"></i>
        <span>Sources</span>
      </a>
    </li>
    
    <#-- Users menu -->
    <li class="treeview">
      <a href="#">
        <i class="fa fa-user"></i>
        <span>Users</span>
        <i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li><a href="pages/layout/top-nav.html"><i class="fa fa-caret-right"></i> Overview</a></li>
        <li><a href="pages/layout/boxed.html"><i class="fa fa-caret-right"></i> Edit</a></li>
      </ul>
    </li>
    
  </ul>
</section>