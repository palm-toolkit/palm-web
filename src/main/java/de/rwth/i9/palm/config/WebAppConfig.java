package de.rwth.i9.palm.config;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.Executor;

import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.aop.interceptor.SimpleAsyncUncaughtExceptionHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.Scope;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

import de.rwth.i9.palm.analytics.api.PalmAnalyticsImpl;
import de.rwth.i9.palm.feature.researcher.ResearcherFeature;
import de.rwth.i9.palm.feature.researcher.ResearcherFeatureImpl;

//import de.rwth.i9.palm.analytics.api.PalmAnalyticsImpl;

@Configuration
@EnableWebMvc
@ComponentScan( { "de.rwth.i9.palm" } )
@PropertySource( "classpath:application.properties" )
@EnableAsync
@Lazy( true )
public class WebAppConfig extends WebMvcConfigurerAdapter implements AsyncConfigurer
{

	@Autowired
	private Environment env;

	/* freemarker */

	@Bean
	public FreeMarkerViewResolver setupFreeMarkerViewResolver()
	{
		FreeMarkerViewResolver freeMarkerViewResolver = new FreeMarkerViewResolver();
		freeMarkerViewResolver.setCache( false );
		freeMarkerViewResolver.setContentType( "text/html;charset=UTF-8" );
		freeMarkerViewResolver.setSuffix( ".ftl" );
		freeMarkerViewResolver.setExposeSessionAttributes( true );
		freeMarkerViewResolver.setExposeSpringMacroHelpers( true );
		freeMarkerViewResolver.setAllowSessionOverride( true );
		freeMarkerViewResolver.setRequestContextAttribute( "rc" );

		return freeMarkerViewResolver;
	}

	@Bean
	public FreeMarkerConfigurer setupFreeMarkerConfigurer()
	{
		FreeMarkerConfigurer freeMarkerConfigurer = new FreeMarkerConfigurer();
		freeMarkerConfigurer.setTemplateLoaderPaths( 
				"/WEB-INF/ftl/",
				"/WEB-INF/ftl/administration",
				"/WEB-INF/ftl/administration/conference",
				"/WEB-INF/ftl/administration/dataset",
				"/WEB-INF/ftl/administration/publication",
				"/WEB-INF/ftl/administration/researcher",
				"/WEB-INF/ftl/administration/statistic",
				"/WEB-INF/ftl/administration/system",
				"/WEB-INF/ftl/administration/user",
				"/WEB-INF/ftl/administration/widget",
				"/WEB-INF/ftl/conference",
				"/WEB-INF/ftl/conference/visualization",
				"/WEB-INF/ftl/publication",
				"/WEB-INF/ftl/publication/visualization",
				"/WEB-INF/ftl/researcher",
				"/WEB-INF/ftl/researcher/visualization",
				"/WEB-INF/ftl/dataset", 
				"/WEB-INF/ftl/sparqlview", 
				"/WEB-INF/ftl/dialog", 
				"/WEB-INF/ftl/analytics",
				"/WEB-INF/ftl/template",
				"/WEB-INF/ftl/template/form",
				"/WEB-INF/ftl/template/layout",
				"/WEB-INF/ftl/template/widget"
			);

		Properties prop = new Properties();
		prop.put( "default_encoding", "UTF-8" );
		prop.put( "auto_import", 
				"template/layout/layoutMacros.ftl as layout, " +
				"template/layout/contentMacros.ftl as content, " +
				"template/widget/widgetMacros.ftl as widget, " +
				"spring.ftl as spring, " +
				"template/layout/dialogLayoutMacros.ftl as dialoglayout" );

		freeMarkerConfigurer.setFreemarkerSettings( prop );

		Map<String, Object> freemakerVariables = new HashMap<String, Object>();
		freemakerVariables.put( "foo", "foo" );

		freeMarkerConfigurer.setFreemarkerVariables( freemakerVariables );
		return freeMarkerConfigurer;
	}

	// @Bean
	// <bean id="freemarkerConfiguration"
	// class="freemarker.template.Configuration" />

	/* resource */

	// Maps resources path to webapp/resources
	public void addResourceHandlers( ResourceHandlerRegistry registry )
	{
		registry.addResourceHandler( "/resources/**" ).addResourceLocations( "/resources/" );
	}

	// <mvc:default-servlet-handler/>
	@Override
	public void configureDefaultServletHandling( DefaultServletHandlerConfigurer configurer )
	{
		configurer.enable();
	}

	// Provides internationalization of messages
	@Bean
	public ResourceBundleMessageSource messageSource()
	{
		ResourceBundleMessageSource source = new ResourceBundleMessageSource();
		source.setBasename( "messages" );
		return source;
	}

	/* fileupload */

	// @Bean
	// public CommonsMultipartResolver commonsMultipartResolver()
	// {
	// CommonsMultipartResolver commonsMultipartResolver = new
	// CommonsMultipartResolver();
	// commonsMultipartResolver.setMaxUploadSize( 10000000 );
	// return commonsMultipartResolver;
	// }

	@Bean( name = "multipartResolver" )
	public CommonsMultipartResolver createMultipartResolver()
	{
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setDefaultEncoding( "utf-8" );
		return resolver;
	}


	/* palm analytics */
	@Bean
	@Scope( "singleton" )
	public PalmAnalyticsImpl configAnalyticsImpl()
	{
		return new PalmAnalyticsImpl();
	}
	
	/* palm researcher feature */
	@Bean
	@Scope( "singleton" )
	public ResearcherFeature researcherFeature()
	{
		return new ResearcherFeatureImpl();
	}

	/* Scheduling and ThreadPool */

	@Override
	public Executor getAsyncExecutor()
	{
		ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
		taskExecutor.setMaxPoolSize( 100 );
		taskExecutor.setCorePoolSize( 5 );
		taskExecutor.setQueueCapacity( 1000 );
		taskExecutor.setThreadNamePrefix( "PALMExecutor-" );
		taskExecutor.initialize();
		return taskExecutor;
	}

	@Override
	public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler()
	{
		return new SimpleAsyncUncaughtExceptionHandler();
	}
}
