<@security.authorize access="isAuthenticated()">
<#assign userName = securityService.getUser().getName() >
<#if securityService.getUser().getAuthor()?? >
	<#assign author = securityService.getUser().getAuthor()>
	<#assign userName = author.getName()>
	<#if author.getPhotoUrl()??>
		<#assign photo = author.getPhotoUrl()>
	</#if>
	<#if author.getAcademicStatus()??>
		<#assign academicStatus = author.getAcademicStatus()>
	</#if>
	<#if author.getAffiliation()??>
		<#assign institution = author.getAffiliation()>
	</#if>
</#if>
<#assign lastName = userName >
<#list userName?split(" ") as sValue>
  <#assign lastName = sValue >
</#list>
<#---->
<#--if link?? && link == "user"> class="open"</#if-->
	<li class="dropdown user user-menu">
		<a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown" style="overflow:hidden;">
			<#if photo??>
	        	<img src="${photo}" class="user-image" alt="User Image"/>
	        <#else>
	        	<i class="fa fa-user"></i>
	        </#if>
			<strong style="max-width:80px;display:inline-block;white-space:nowrap;padding-top:3px;">${lastName}</strong>
		</a>
		<ul class="dropdown-menu">
	      <li class="user-header">
	      	<#if photo??>
	      		<img src="${photo}" class="img-circle" alt="User Image" />
	        <#else>
	        	<i class="fa fa-user" style="color:#fff;font-size:70px;"></i>
	        </#if>
	        <p>
	          ${userName}
			  <#if academicStatus??>
			  	<small>${academicStatus}</small>
			  </#if>
			  <#if institution??>
			  	<small>${institution}</small>
			  </#if>
	        </p>
	      </li>
	      <!-- Menu Body -->
	      <li class="user-body">
	        <div class="col-xs-12 text-center">
	          <a href="user" class="btn btn-default btn-flat" style="width:100%;height:100%"><i class="fa fa-tachometer" style="margin-right:5px"></i><span style="font-weight:600;font-size:16px">My Dashboard</span></a>
	        </div>
	        <#if link?? && ( link == "researcher" || link == "publication" || link == "venue" || link == "circle" )>
	        	<#assign linkLabel = link>
	        	<#if link == "venue">
	        		<#assign linkLabel = "Conference">
	        	</#if>
		        <div class="pull-left col-xs-12 text-center">
		          <a href="javascript:void(0)" id="manage-widget" class="btn btn-default btn-flat" style="width:100%;height:100%;margin-top:8px" 
		          data-url="<@spring.url '/widget' />/${link}" data-title="Manage ${linkLabel?capitalize} Widgets"><i class="fa fa-th" style="margin-right:5px"></i><span style="font-weight:600;font-size:16px">${linkLabel?capitalize} Widgets</span></a>
		        </div>
		        
<script>
$(function(){
	$( "#manage-widget" ).click( function( event ){
		event.preventDefault();
		$.PALM.popUpIframe.create( $(this).data("url") , { "popUpWidth":"90%", "popUpHeight":"80%"}, $(this).data("title") );
	});
});
</script>
	        </#if>
	      </li>
	      <!-- Menu Footer-->
	      <li class="user-footer">
	        <div class="pull-right">
	          <a href="logout" class="btn btn-default btn-flat"><span>Sign out</span><i class="fa fa-sign-out" style="margin-left:5px"></i></a>
	        </div>
	      </li>
	    </ul>
	</li>
</@security.authorize>

<@security.authorize access="isAnonymous()">
	<li>	
		<a href="javascript:void(0)" id="signin_button" title="Sign In" onclick="$.PALM.popUpAjaxModal.load( 'login?form=true' )">
		<i class="fa fa-sign-in"></i>
		<strong>Sign in</strong>
	</a>
	</li>
</@security.authorize>

<@security.authorize access="isAuthenticated()">
	<#if securityService.isAuthorizedForRole( 'ADMIN' )>
		<li<#if link?? && link == "administration"> class="open"</#if>>
			<a href="<@spring.url '/admin' />" title="Administration">
				<i class="fa fa fa-gears"></i>
			</a>
		</li>
	</#if>
</@security.authorize>