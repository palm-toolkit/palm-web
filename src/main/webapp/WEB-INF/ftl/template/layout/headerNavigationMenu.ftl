<li<#if link == "conference"> class="open"</#if>>
	<a href="<@spring.url '/conference' />"><i class="fa fa-globe"></i><strong> Conferences</strong></a>
</li>
<li<#if link == "researcher"> class="open"</#if>>
	<a href="<@spring.url '/researcher' />"><i class="fa fa-users"></i><strong> Researchers</strong></a>
</li>
<li<#if link == "publication"> class="open"</#if>>
	<a href="<@spring.url '/publication' />"><i class="fa fa-file-text-o"></i><strong> Publications</strong></a>
</li>
<li<#if link == "administration"> class="open"</#if>>
	<a href="<@spring.url '/admin' />"><i class="fa fa-lock"></i><strong> Administration</strong></a>
</li>