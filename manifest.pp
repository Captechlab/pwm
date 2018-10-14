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
  war_source    => `https://www.pwm-project.org/artifacts/pwm/2018-10-11T16_39_11Z/pwm-1.8.0-SNAPSHOT.war`
}

augeas {'web.xml':
	incl    => '/opt/tomcat8/pwm/webapps/pwm/WEB-INF/web.xml',
	context => '/files/opt/tomcat8/pwm/webapps/pwm/WEB-INF/web.xml/web-app',
	lens    => 'Xml.lns',
	changes => 'set context-param[1]/param-value/#text /opt/tomcat8/pwm/webapps/pwm/WEB-INF',
}