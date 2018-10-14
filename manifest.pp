include git
include java

tomcat::install { '/opt/tomcat8':
  source_url => 'http://www.trieuvan.com/apache/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz'
}

tomcat::instance { 'tomcat8-pwm':
  catalina_home => '/opt/tomcat8',
  catalina_base => '/opt/tomcat8/pwm',
}

tomcat::war { 'pwm.war':
  catalina_base => '/opt/tomcat8/pwm',
  war_source    => 'https://www.pwm-project.org/artifacts/pwm/2018-10-11T16_39_11Z/pwm-1.8.0-SNAPSHOT.war'
}

augeas {'web.xml':
	incl    => '/opt/tomcat8/pwm/webapps/pwm/WEB-INF/web.xml',
	context => '/files/opt/tomcat8/pwm/webapps/pwm/WEB-INF/web.xml/web-app',
	lens    => 'Xml.lns',
	changes => 'set context-param[1]/param-value/#text /opt/tomcat8/pwm/webapps/pwm/WEB-INF',
}

class { '::mysql::server':
     root_password           => '',
     remove_default_accounts => true,
     package_name            => 'mariadb-server',
     package_ensure          => 'installed',
     service_name            => 'mariadb',
}

mysql::db { 'pwm':
     user     => 'pwm',
     password => '', # Can't do a password hash here :(
}

class { 'mysql::bindings':
     java_enable => true,
}

file { '/opt/tomcat8/pwm/lib/mysql-connector-java.jar':
     ensure  => link,
     target  => '/usr/share/java/mysql-connector-java.jar',
     require => Class['mysql::bindings']
}