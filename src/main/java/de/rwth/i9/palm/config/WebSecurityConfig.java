package de.rwth.i9.palm.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.web.context.request.RequestContextListener;

import de.rwth.i9.palm.security.LogoutSuccessHandler;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter
{
	
	@Autowired
	private DataSource dataSource;
	
	@Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .jdbcAuthentication()
            	.dataSource( dataSource )
            	.usersByUsernameQuery( getUserQuery() )
            	.authoritiesByUsernameQuery( getAuthoritiesQuery() );
        //.inMemoryAuthentication()
        //.withUser("user").password("password").roles("USER");
    }
	
	private String getUserQuery() {
		return "SELECT username, password, enabled "
                + "FROM user "
                + "WHERE username = ?";
    }

    private String getAuthoritiesQuery() {
        return "SELECT u.username, r.name AS authority "
                + "FROM user u, role r "
                + "WHERE u.role_id = r.id "
                + "AND username = ?";
    }
	
	@Override
    protected void configure(HttpSecurity http) throws Exception {
        http
    		.csrf()
    			.disable()
            .authorizeRequests()
            	.antMatchers( 
            			"/", 
            			"/home", 
            			"/login", 
            			"/logout", 
            			"/log/**", 
            			"/register", 
            			"/conference/**", 
            			"/researcher/**", 
            			"/publication/**", 
            			"/sparqlview/**",
            			"/admin/**" 
            			)
                	.permitAll()
                .anyRequest()
                	.authenticated()
            .and()
        	.formLogin()
        		.usernameParameter("j_username") // form-login@username-parameter
                .passwordParameter("j_password") // form-login@password-parameter
				.loginPage( "/login" ) // form-login@login-page
				.defaultSuccessUrl( "/" )// form-login@default-target-url /form-login@always-use-default-target
				.failureUrl( "/login?auth=fail" )
				.permitAll()
				// .successHandler( loginSuccessHandler() )
            .and()
        	.logout()
        		.logoutUrl( "/logout" )
        		.invalidateHttpSession( true );
		// .logoutSuccessHandler( logoutSuccessHandler() );
    }

	@Override
	public void configure( WebSecurity web ) throws Exception
	{
		web.ignoring().antMatchers( "/resources/**" );
	}
	
	@Bean
	public AuthenticationSuccessHandler loginSuccessHandler(){
		return new de.rwth.i9.palm.security.LoginSuccessHandler( "/home" );
	}
	
	@Bean
	public LogoutSuccessHandler logoutSuccessHandler(){
		return new LogoutSuccessHandler( "/home" );
	}

	/**
	 * session will be created if not exists
	 * 
	 * @return
	 */
	@Bean
	public RequestContextListener requestContextListener()
	{
		return new RequestContextListener();
	}
}
