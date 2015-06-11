package de.rwth.i9.palm.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.Scope;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.LazyConnectionDataSourceProxy;
import org.springframework.orm.hibernate4.HibernateTransactionManager;
import org.springframework.orm.hibernate4.LocalSessionFactoryBean;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import de.rwth.i9.palm.model.Algorithm;
import de.rwth.i9.palm.model.Author;
import de.rwth.i9.palm.model.AuthorAlias;
import de.rwth.i9.palm.model.Conference;
import de.rwth.i9.palm.model.ConferenceGroup;
import de.rwth.i9.palm.model.Dataset;
import de.rwth.i9.palm.model.Function;
import de.rwth.i9.palm.model.Institution;
import de.rwth.i9.palm.model.Location;
import de.rwth.i9.palm.model.Publication;
import de.rwth.i9.palm.model.PublicationHistory;
import de.rwth.i9.palm.model.PublicationSource;
import de.rwth.i9.palm.model.Reference;
import de.rwth.i9.palm.model.Role;
import de.rwth.i9.palm.model.RunTime;
import de.rwth.i9.palm.model.Source;
import de.rwth.i9.palm.model.Subject;
import de.rwth.i9.palm.model.Topic;
import de.rwth.i9.palm.model.User;
import de.rwth.i9.palm.model.UserWidget;
import de.rwth.i9.palm.model.Widget;
import de.rwth.i9.palm.persistence.relational.PersistenceStrategyImpl;

@Configuration
@EnableTransactionManagement
@ComponentScan( "de.rwth.i9" )
@PropertySource( value = "classpath:database.dev.properties" )
@Lazy( true )
public class DatabaseConfig
{
	private static final String PROPERTY_NAME_DATABASE_DRIVER = "db.driver";
	private static final String PROPERTY_NAME_DATABASE_PASSWORD = "db.password";
	private static final String PROPERTY_NAME_DATABASE_URL = "db.url";
	private static final String PROPERTY_NAME_DATABASE_USERNAME = "db.username";

	private static final String PROPERTY_NAME_HIBERNATE_DIALECT = "hibernate.dialect";
	private static final String PROPERTY_NAME_HIBERNATE_SHOW_SQL = "hibernate.show_sql";
	private static final String PROPERTY_NAME_HIBERNATE_FORMAT_SQL = "hibernate.format_sql";
	private static final String PROPERTY_NAME_HIBERNATE_HBM2DDL_AUTO = "hibernate.hbm2ddl.auto";
	//private static final String PROPERTY_NAME_HIBERNATE_CONNECTION_AUTOCOMMIT = "hibernate.connection.autocommit";

	private static final String PROPERTY_NAME_ENTITYMANAGER_PACKAGES_TO_SCAN = "entitymanager.packages.to.scan";
	private static final String PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_DIRECTORY_PROVIDER = "hibernate.search.default.directory_provider";
	private static final String PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_INDEXBASE = "hibernate.search.default.indexBase";
	private static final String PROPERTY_NAME_HIBERNATE_SEARCH_LUCENE_VERSION = "hibernate.search.lucene_version";

	@Autowired
	private Environment env;

	@Bean( destroyMethod = "close" )
	public DataSource dataSource()
	{
		BasicDataSource dataSource = new BasicDataSource();

		dataSource.setDriverClassName( env.getRequiredProperty( PROPERTY_NAME_DATABASE_DRIVER ) );
		dataSource.setUrl( env.getRequiredProperty( PROPERTY_NAME_DATABASE_URL ) );
		dataSource.setUsername( env.getRequiredProperty( PROPERTY_NAME_DATABASE_USERNAME ) );
		dataSource.setPassword( env.getRequiredProperty( PROPERTY_NAME_DATABASE_PASSWORD ) );
		dataSource.setValidationQuery( "select 1" );

		return dataSource;
	}

	@Bean
	public LazyConnectionDataSourceProxy lazyConnectionDataSourceProxy()
	{
		LazyConnectionDataSourceProxy lazyConnectionDataSourceProxy = new LazyConnectionDataSourceProxy();
		lazyConnectionDataSourceProxy.setTargetDataSource( this.dataSource() );
		return lazyConnectionDataSourceProxy;
	}

	private Properties hibProperties()
	{
		Properties properties = new Properties();
		properties.put( PROPERTY_NAME_HIBERNATE_DIALECT, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_DIALECT ) );
		properties.put( PROPERTY_NAME_HIBERNATE_SHOW_SQL, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_SHOW_SQL ) );
		properties.put( PROPERTY_NAME_HIBERNATE_FORMAT_SQL, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_FORMAT_SQL ) );
		properties.put( PROPERTY_NAME_HIBERNATE_HBM2DDL_AUTO, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_HBM2DDL_AUTO ) );
		// properties.put(PROPERTY_NAME_HIBERNATE_CONNECTION_AUTOCOMMIT,
		// env.getRequiredProperty(PROPERTY_NAME_HIBERNATE_CONNECTION_AUTOCOMMIT));

		properties.put( PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_DIRECTORY_PROVIDER, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_DIRECTORY_PROVIDER ) );
		properties.put( PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_INDEXBASE, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_SEARCH_DEFAULT_INDEXBASE ) );
		properties.put( PROPERTY_NAME_HIBERNATE_SEARCH_LUCENE_VERSION, env.getRequiredProperty( PROPERTY_NAME_HIBERNATE_SEARCH_LUCENE_VERSION ) );
		return properties;
	}

	@Bean
	public HibernateTransactionManager transactionManager()
	{
		HibernateTransactionManager transactionManager = new HibernateTransactionManager();
		transactionManager.setSessionFactory( sessionFactory().getObject() );
		return transactionManager;
	}

	@Bean
	public LocalSessionFactoryBean sessionFactory()
	{
		LocalSessionFactoryBean sessionFactoryBean = new LocalSessionFactoryBean();
		sessionFactoryBean.setDataSource( this.lazyConnectionDataSourceProxy() );
		sessionFactoryBean.setPackagesToScan( env.getRequiredProperty( PROPERTY_NAME_ENTITYMANAGER_PACKAGES_TO_SCAN ) );
		sessionFactoryBean.setHibernateProperties( hibProperties() );
		sessionFactoryBean.setAnnotatedClasses( new Class<?>[] { 
				/* model class here */
				Algorithm.class,
				Author.class,
				AuthorAlias.class,
				Conference.class,
				ConferenceGroup.class,
				Dataset.class,
				Function.class,
				Institution.class,
				Location.class,
				Publication.class,
				PublicationHistory.class,
				PublicationSource.class,
				Reference.class,
				Role.class,
				RunTime.class, 
 				Source.class,
 				Subject.class,
				Topic.class,
				User.class,
				UserWidget.class,
				Widget.class
		} );
		return sessionFactoryBean;
	}

	@Bean
	@Scope( "singleton" )
	public PersistenceStrategyImpl configPersistenceStrategyImpl()
	{
		PersistenceStrategyImpl persistenceStrategyImpl = new PersistenceStrategyImpl();
		persistenceStrategyImpl.setSessionFactory( sessionFactory().getObject() );
		return persistenceStrategyImpl;
	}

	@Bean
	public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer()
	{
		return new PropertySourcesPlaceholderConfigurer();
	}
}