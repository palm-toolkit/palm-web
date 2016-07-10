 <@layout.global classStyle="layout-top-nav skin-blue-light">
 	 	
 	<@content.header>

		<#include "headerHome.ftl" />
		
 	</@content.header>
 	
 	<@content.contentWrapper>
			<div class="box-filter">
				<div class="box-filter-option" style="display:none"></div>
				<button class="btn btn-block btn-default box-filter-button btn-xs" onclick="$( this ).prev().slideToggle( 'slow' )">
					<i class="fa fa-filter pull-left"></i>
					<span>Filter</span>
				</button>
			</div>

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