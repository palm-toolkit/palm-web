 <@layout.global>
 	 	
 	<@content.header>

		<#include "headerPageVA.ftl" />
		
 	</@content.header>
 	
 	<@content.leftSidebar>
		<#include "widgetLayoutSidebar.ftl" />
 	</@content.leftSidebar>
 	
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