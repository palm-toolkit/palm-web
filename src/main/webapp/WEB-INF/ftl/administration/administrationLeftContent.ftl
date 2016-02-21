<section class="sidebar">
  <ul id="left-menu-sidebar" class="sidebar-menu">
  	<#-- Menu header -->
    <li class="header"><strong>ADMINISTRATION</strong></li>
    
    <#-- Data Collection menu -->
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
        <li data-link="html"><a href="<@spring.url '/admin/config/html' />"><i class="fa fa-file-text-o"></i>HTML extraction</a></li>
        <li data-link="pdf"><a href="<@spring.url '/admin/config/pdf' />"><i class="fa fa-file-pdf-o"></i>PDF extraction</a></li>
      </ul>
    </li>
    
    <#-- Data Management -->
    <li class="treeview" data-link="data">
      <a href="#">
        <i class="fa fa-database"></i>
        <span>Data Management</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="researcher"><a href="<@spring.url '/admin/data/researcher' />"><i class="fa fa-users"></i>Researcher Data</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/data/publication' />"><i class="fa fa-file-text-o"></i>Publication Data</a></li>
        <li data-link="event"><a href="<@spring.url '/admin/data/conference' />"><i class="fa fa-globe"></i>Conferences Data</a></li>
        <li data-link="circle"><a href="<@spring.url '/admin/data/circle' />"><i class="fa fa-circle-o"></i>Circle Data</a></li>
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
        <li data-link="add"><a href="<@spring.url '/admin/widget/add' />"><i class="fa fa-caret-right"></i>Add New Widget</a></li>
        <li data-link="all"><a href="<@spring.url '/admin/widget/all' />"><i class="fa fa-caret-right"></i>All Widgets</a></li>
        <li data-link="researcher"><a href="<@spring.url '/admin/widget/researcher' />"><i class="fa fa-caret-right"></i>Researcher Widgets</a></li>
        <li data-link="conference"><a href="<@spring.url '/admin/widget/conference' />"><i class="fa fa-caret-right"></i>Conference Widgets</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/widget/publication' />"><i class="fa fa-caret-right"></i>Publication Widgets</a></li>
        <li data-link="circle"><a href="<@spring.url '/admin/widget/circle' />"><i class="fa fa-caret-right"></i>Circle Widgets</a></li>
        <li data-link="administration"><a href="<@spring.url '/admin/widget/administration' />"><i class="fa fa-caret-right"></i>Administration Widgets</a></li>
        <li data-link="user"><a href="<@spring.url '/admin/widget/user' />"><i class="fa fa-caret-right"></i>User Widget</a></li>
      </ul>
    </li>

	<#-- Sources menu -->
    <li class="treeview" data-link="source">
      <a href="<@spring.url '/admin/source' />">
        <i class="fa fa-cloud-download"></i>
        <span>Sources</span>
      </a>
    </li>

	<#-- Term Extraction menu -->
    <li class="treeview" data-link="termextraction">
      <a href="<@spring.url '/admin/termextraction' />">
        <i class="fa fa-tint"></i>
        <span>Terms Extraction</span>
      </a>
    </li>

	<#-- Term Weighting menu -->
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
    
    <#-- Developer corner -->
    <li class="treeview" data-link="developer">
      <a href="#">
        <i class="fa fa-code"></i>
        <span>Developer</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="architecture"><a href="<@spring.url '/admin/developer/architecture' />"><i class="fa fa-building-o"></i>Architecture Overview</a></li>
        <li data-link="technologies"><a href="<@spring.url '/admin/developer/technologies' />"><i class="fa fa-asterisk"></i>Technologies</a></li>
        <li data-link="documentation"><a href="<@spring.url '/admin/developer/documentation' />"><i class="fa fa-file-o"></i>Documentation</a></li>
        <li data-link="credit"><a href="<@spring.url '/admin/developer/creadit' />"><i class="fa fa-users"></i>Credit</a></li>
      </ul>
    </li>
    
    <#-- API -->
    <li class="treeview" data-link="api">
      <a href="#">
        <i class="fa fa-exchange"></i>
        <span>API</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="researcher"><a href="<@spring.url '/admin/api/researcher' />"><i class="fa fa-users"></i>Researcher API</a></li>
        <li data-link="publication"><a href="<@spring.url '/admin/api/publication' />"><i class="fa fa-file-text-o"></i>Publication API</a></li>
        <li data-link="event"><a href="<@spring.url '/admin/api/conference' />"><i class="fa fa-globe"></i>Conferences API</a></li>
        <li data-link="circle"><a href="<@spring.url '/admin/api/circle' />"><i class="fa fa-circle-o"></i>Circle API</a></li>
      </ul>
    </li>
    
    <#-- API -->
    <li class="treeview" data-link="extract">
      <a href="#">
        <i class="fa fa-cubes"></i>
        <span>PDF & HTML Extraction Test</span>
		<i class="fa fa-angle-left pull-right"></i>
      </a>
      <ul class="treeview-menu">
        <li data-link="pdf"><a href="<@spring.url '/admin/extract/pdf' />"><i class="fa fa-file-pdf-o"></i>PDF Extraction</a></li>
        <li data-link="html"><a href="<@spring.url '/admin/extract/html' />"><i class="fa fa-file-text-o"></i>Webpage Extraction</a></li>
      </ul>
    </li>
    
  </ul>
</section>

<script>
	$( function(){
		<#-- add slim scroll -->
	      $("#left-menu-sidebar").slimscroll({
				height: "100%",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		  <#--
		   $(".content-wrapper>.content").slimscroll({
				height: "100%",
		        size: "8px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			railVisible: true,
    			alwaysVisible: true
		  });
		  -->
	});
</script>