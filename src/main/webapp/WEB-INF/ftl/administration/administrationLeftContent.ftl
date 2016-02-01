<section class="sidebar" style="height: auto;">
  <ul class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>ADMINISTRATION</strong></li>
    
    <#-- Widgets menu -->
    <li class="treeview" data-link="config">
      <a href="#">
        <i class="fa fa-tasks"></i>
        <span>Data Collections</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="researcher"><a href="<@spring.url '/admin/config/researcher' />"><i class="fa fa-users"></i>Researcher Collections</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/config/publication' />"><i class="fa fa-file-text-o"></i>Publication Collections</a></li>
        <li data-link="event"><a href="<@spring.url '/admin/config/conference' />"><i class="fa fa-globe"></i>Conferences Collections</a></li>
        <li data-link="html"><a href="<@spring.url '/admin/config/html' />"><i class="fa fa-code"></i>HTML extraction</a></li>
        <li data-link="pdf"><a href="<@spring.url '/admin/config/pdf' />"><i class="fa fa-file-pdf-o"></i>PDF extraction</a></li>
      </ul>
    </li>
    
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
        <li data-link="venue"><a href="<@spring.url '/admin/widget/venue' />"><i class="fa fa-caret-right"></i>Conference Widget</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/widget/publication' />"><i class="fa fa-caret-right"></i>Publication Widget</a></li>
        <li data-link="researcher"><a href="<@spring.url '/admin/widget/researcher' />"><i class="fa fa-caret-right"></i>Researcher Widget</a></li>
        <li data-link="administration"><a href="<@spring.url '/admin/widget/administration' />"><i class="fa fa-caret-right"></i>Administration Widget</a></li>
      </ul>
    </li>

	<#-- Sources menu -->
    <li class="treeview" data-link="source">
      <a href="<@spring.url '/admin/source' />">
        <i class="fa fa-cloud-download"></i>
        <span>Sources</span>
      </a>
    </li>

	<#-- Sources menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/admin/termextraction' />">
        <i class="fa fa-tint"></i>
        <span>Terms Extraction</span>
      </a>
    </li>

	<#-- Sources menu -->
    <li class="treeview" data-link="termweighting">
      <a href="<@spring.url '/admin/termweighting' />">
        <i class="fa fa-balance-scale"></i>
        <span>Terms Weighting</span>
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