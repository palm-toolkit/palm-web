<#-- the webpage header -->
<#macro header>
	<header class="main-header"> 
		<#nested />
	</header>
</#macro>

<#-- Left side column. contains the logo and sidebar -->
<#macro leftSidebar>
	<aside class="main-sidebar">
		<#nested />
	</aside>
</#macro>

<#-- Content Wrapper. Contains page content -->
<#macro contentWrapper>
    <div class="content-wrapper">
		<#nested />
	</div>
</#macro>

<#-- FooterWrapper. Contains footer -->
<#macro footerWrapper>
    <div class="footer-wrapper">
		<#nested />
	</div>
</#macro>