 <@layout.global classStyle="layout-top-nav skin-blue-light">
 	 	
 	<@content.header>

		<#include "headerHome.ftl" />
		
 	</@content.header>
 	
 	<@content.contentWrapper>
 	
          <section class="content">
			<div class ="row">
 				<#include "widgetLayoutMainContent.ftl" />
			</div>
		</section>
 	</@content.contentWrapper>

	<@content.footerWrapper>
		<#include "footer.ftl" />
	</@content.footerWrapper>
 	
</@layout.global>