 <@layout.global classStyle="layout-top-nav skin-blue-light">

 	<@content.contentWrapper>
 	
 	 <!-- Main content -->
        <section class="content">

          <div class="error-page">
            <h2 class="headline text-yellow"> 404</h2>
            <div class="error-content">
              <h3><i class="fa fa-warning text-yellow"></i> Oops! Page not found.</h3>
              <p>
              	<#if errorMessage??>
              		${errorMessage!''}
              	<#else>
                We could not find the page you were looking for.
                Meanwhile, you may <a href='/'>return to PALM home</a>.
                </#if>
              </p>
            </div><!-- /.error-content -->
          </div><!-- /.error-page -->
        </section><!-- /.content -->
          		
 	</@content.contentWrapper>
 	
</@layout.global>