package de.rwth.i9.palm.config;

import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

@Order(1)
public class Initializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	
	@Override
	@Profile( value = "dev" )
	protected Class<?>[] getRootConfigClasses() {
	return new Class[] {DatabaseConfig.class };
	}
	
	@Override
	protected Class<?>[] getServletConfigClasses() {
	return new Class<?>[] { WebAppConfig.class };
	}
	
	@Override
	protected String[] getServletMappings() {
	return new String[] { "/" };
	}

}