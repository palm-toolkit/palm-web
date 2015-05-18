<section class="sidebar" style="height: auto;">
  <ul class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>ADMINISTRATION</strong></li>
    
    <#-- Widgets menu -->
    <li class="active treeview">
      <a href="#">
        <i class="fa fa-th"></i>
        <span>Widgets</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li class="active"><a href="index.html"><i class="fa fa-caret-right"></i>Overview</a></li>
        <li><a href="<@spring.url '/admin/widget/add' />"><i class="fa fa-caret-right"></i>Add New Widget</a></li>
        <li><a href="index2.html"><i class="fa fa-caret-right"></i>Edit Widget</a></li>
        <li><a href="index2.html"><i class="fa fa-caret-right"></i>Conference Widget</a></li>
        <li><a href="index2.html"><i class="fa fa-caret-right"></i>Publication Widget</a></li>
        <li><a href="index2.html"><i class="fa fa-caret-right"></i>Researcher Widget</a></li>
        <li><a href="index2.html"><i class="fa fa-caret-right"></i>Administration Widget</a></li>
      </ul>
    </li>
    
    <#-- Users menu -->
    <li class="treeview">
      <a href="#">
        <i class="fa fa-user"></i>
        <span>Users</span>
        <i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li><a href="pages/layout/top-nav.html"><i class="fa fa-circle-o"></i> Top Navigation</a></li>
        <li><a href="pages/layout/boxed.html"><i class="fa fa-circle-o"></i> Boxed</a></li>
        <li><a href="pages/layout/fixed.html"><i class="fa fa-circle-o"></i> Fixed</a></li>
        <li><a href="pages/layout/collapsed-sidebar.html"><i class="fa fa-circle-o"></i> Collapsed Sidebar</a></li>
      </ul>
    </li>
    
  </ul>
</section>     