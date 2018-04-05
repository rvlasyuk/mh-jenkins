class springapp::deploy {
    
#    service { 'springapp stopped':
#        name => 'springapp'
#        ensure => 'stopped',
#        require => File['springapp.service'],
#    }

    # get application artifact
    file { 'get_spring_artifact':
        path => '/opt/spring/bin/helloworld-springboot-latest.jar',
        mode    => '0644',
        owner   => spring,
        group   => spring,
        ensure => file,
        source => '/vagrant/files/artifacts/helloworld-springboot-latest.jar',
        #require => File['/opt/spring/bin'],
    }

    service { 'springapp' :
        ensure  => 'running',
        #require => [ File['springapp.service' ], Package['openjdk-8-jdk'] ],
    }
}
