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
	      </li>
	      <!-- Menu Footer-->
	      <li class="user-footer">
	        <div class="pull-left">
	          <a href="javascript:void(0)" class="btn btn-default btn-flat"><i class="fa fa-th" style="margin-right:5px"></i><span>Widgets</span></a>
	        </div>
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
  
  
  <#-- if already login -->
  <#--
  <li class="dropdown user user-menu">
    <a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
      <img src="dist/img/user2-160x160.jpg" class="user-image" alt="User Image"/>
      <span class="hidden-xs">Alexander Pierce</span>
    </a>
    <ul class="dropdown-menu">
      <li class="user-header">
        <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image" />
        <p>
          Alexander Pierce - Web Developer
          <small>Member since Nov. 2012</small>
        </p>
      </li>
      <!-- Menu Body -->
      <#--
      <li class="user-body">
        <div class="col-xs-4 text-center">
          <a href="javascript:void(0)">Followers</a>
        </div>
        <div class="col-xs-4 text-center">
          <a href="javascript:void(0)">Sales</a>
        </div>
        <div class="col-xs-4 text-center">
          <a href="javascript:void(0)">Friends</a>
        </div>
      </li>
      -->
      <!-- Menu Footer-->
      <#--
      <li class="user-footer">
        <div class="pull-left">
          <a href="javascript:void(0)" class="btn btn-default btn-flat">Profile</a>
        </div>
        <div class="pull-right">
          <a href="javascript:void(0)" class="btn btn-default btn-flat">Sign out</a>
        </div>
      </li>
    </ul>
  </li>
  -->