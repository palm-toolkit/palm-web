<div id="boxbody${wUniqueName}" class="box-body no-padding">
	<div style="max-width:600px;margin:0 auto">
		<#--
		<img style="height:50px" class="site-logo" src="http://haiti.informatik.rwth-aachen.de/lufgi9/wp-content/uploads/2015/04/cropped-RZ_i9_RGB12.png" alt="i9 – Learning Technologies Research Group">
		-->
		<br>
		<h1 style="text-align:center"><strong>PALM </strong>Documentation</h1>
		<br>
		<p>
			Looking for more information about PALM-Project? <a href="javascript:void()" onclick="window.open( 'https://github.com/palm-toolkit/palm-project/wiki', 'wiki page' ,'scrollbars=yes,width=650,height=500')" title="PALM project wiki">See the <strong>GitHub Wiki</strong>. (Under Construction)</a>
		</p>
		<h3>
			PALM Toolkit Modules Documentation
		</h3>
		<p>
			PALM Toolkit is a multimodules Maven project and it is currently hosted on 
				<a style="display:inline-block" href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
                    <i class="fa fa-github"></i> GitHub
                </a>
		</p>
		<div style="width:100%">
			<table class="table">
                    <tbody><tr>
                      <th style="width:15%">Modules</th>
                      <th style="width:70%">Description</th>
                      <th>Links</th>
                    </tr>
                    
                     <tr>
                      <td><strong><i>palm-project</i></strong></td>
                      <td>
                       This module is parent module. All other modules inherit dependencies and build strategies from this module.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-project' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
					  </td>
                    </tr>
                    
                    <tr>
                      <td><strong><i>palm-model</i></strong></td>
                      <td>
                       This module contains data-model or database schema structure of the system, where JPA(Java Persistence API) entities and their relations are defined. This module is also contains properties for data indexing and analyzer.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-model' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-model/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
                   
					 <tr>
                      <td><strong><i>palm-persistence-api</i></strong></td>
                      <td>
						This module contains set of interfaces to access the data-model module, also known as Data Access Object (DAO) interfaces.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-persistence-api' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-persistence-api/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
                   
					<tr>
                      <td><strong><i>palm-persistence-relational</i></strong></td>
                      <td>
                       This module contains the implementation for DAO interfaces from <i>palm-persistence-api</i> module. For the implementation, the Hibernate Object-Relational Mapping (ORM) framework is chosen for the mapping between the object-oriented domain model and the relational database.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-persistence-relational' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-persistence-relational/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
                    
                    <tr>
                      <td><strong><i>palm-analytics</i></strong></td>
                      <td>
                       This module contains analytics tools, interfaces, and their implementations. It includes the following data mining and Natural Language Processing (NLP) libraries: Mallet, Hadoop, Mahout, OpenNLP. It contains implementation of C-Value, LDA, and some of NLP tools such as part-of-speech (POS) tags, named-entity recognition, noun phrase extractor, etc.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-analytics' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-analytics/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
                    
                    <tr>
                      <td><strong><i>palm-core</i></strong></td>
                      <td>
                       This module contains the controlles, services and business logic.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-core' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-core/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
                    
                    <tr>
                      <td><strong><i>palm-web</i></strong></td>
                      <td>
                       This module depends to other modules and it contains the web resources, the system configurations, and the view templates.
                      </td>
                      <td>
                      	<a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-github width80px" onclick="window.open( 'https://github.com/palm-toolkit/palm-web' , 'Github PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-github"></i> GitHub
		                </a>
		                <a href="javascript:void()" class="btn btn-block btn-xs btn-social btn-dropbox width80px" onclick="window.open( 'http://palm-toolkit.github.io/palm-web/apidocs/' , 'JavaDoc PALM' ,'scrollbars=yes,width=650,height=500')">
		                    <i class="fa fa-book"></i> JavaDoc
		                </a>
					  </td>
                    </tr>
            </table>
		</div>
  	</div>
</div>