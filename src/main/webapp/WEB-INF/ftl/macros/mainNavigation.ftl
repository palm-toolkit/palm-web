<ul id="menu">

	<li>
    	<a href="<@spring.url '/signin' />"<#if link?? & link == 'signin'> class="current"</#if> title="Signi">
	    	Sign in
    	</a>
	</li>
	
	<li>
    	<a href="<@spring.url '/about' />"<#if link?? & link == 'about'> class="current"</#if> title="about system and its documentation">
    		About
		</a>
	</li>
	
	<li>
    	<a href="#" id="topic-search" class="search-button"  title="search based on topic">
	    	Topic
    	</a>
	</li>
	    
    <li>
    	<a href="#" id="tfidf-search" class="search-button" title="search based on tf idf rank">
	    	Tf-Idf rank
    	</a>
	</li>
	
	<li>
		<a href="#" id="fulltext-search" class="search-button" title="full text search">
			Full Text
		</a>
	</li>
	
	<li>
    	<a id="snorql-button" href="#" title="explore linked data">
	    	Snorql
    	</a>
	</li>

    <li>
    	<a href="<@spring.url '/analyze' />"<#if link?? & link == 'analyze'> class="current"</#if> title="analyze a publication">
    		Analyze
		</a>
	</li>

	<li>
  		<a href="#" id="input-dialog" <#if link?? & link == 'input'> class="current"</#if> title="insert new publication">
    		Input
		</a>
	</li>
</ul>