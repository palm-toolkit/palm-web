<#assign security=JspTaglibs["http://www.springframework.org/security/tags"] />
<li<#if link?? && link == "researcher"> class="open"</#if>>
	<a href="<@spring.url '/researcher' />"><i class="fa fa-users"></i><strong> Researchers</strong></a>
</li>
<li<#if link?? && link == "publication"> class="open"</#if>>
	<a href="<@spring.url '/publication' />"><i class="fa fa-file-text-o"></i><strong> Publications</strong></a>
</li>
<li<#if link?? && link == "venue"> class="open"</#if>>
	<a href="<@spring.url '/venue' />"><i class="fa fa-globe"></i><strong> Conferences</strong></a>
</li>
<li<#if link?? && link == "circle"> class="open"</#if>>
	<a href="<@spring.url '/circle' />"><i class="fa fa-circle-o"></i><strong> Circles</strong></a>
</li>
<@security.authorize access="isAuthenticated()">
	<#if securityService.isAuthorizedForRole( 'Administrator' )>
		<li<#if link?? && link == "administration"> class="open"</#if>>
			<a href="<@spring.url '/admin' />"><i class="fa fa-lock"></i><strong> Admin</strong></a>
		</li>
	</#if>
</@security.authorize>