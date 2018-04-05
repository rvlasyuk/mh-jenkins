class jenkins::jobs {
    
    # create artifacts directory
    file { [ '/vagrant/files/', '/vagrant/files/artifacts' ]:
        ensure => 'directory',
    }

	# copy jenkins-job-builder config
    file { 'jenkins_jobs.ini':
        path => '/tmp/jenkins_jobs.ini',
        mode    => '0644',
        owner   => root,
        group   => root,
        ensure => file,
        source => '/vagrant/modules/jenkins/files/jenkins_jobs.ini',
    }

    # copy jenkins-job-builder mh-build job config
    file { 'mh-build.yml':
        path => '/tmp/mh-build.yml',
        mode    => '0644',
        owner   => root,
        group   => root,
        ensure => file,
        source => '/vagrant/modules/jenkins/files/mh-build.yml',
    }

    # copy jenkins-job-builder mh-deploy job config
    file { 'mh-deploy.yml':
        path => '/tmp/mh-deploy.yml',
        mode    => '0644',
        owner   => root,
        group   => root,
        ensure => file,
        source => '/vagrant/modules/jenkins/files/mh-deploy.yml',
    }

    # configure job mh-build
    exec { 'jenkins setup job mh-build':
        path    => ['/usr/bin', '/usr/sbin', '/bin', '/usr/local/bin/'],
        command => 'sleep 60 && jenkins-jobs --conf /tmp/jenkins_jobs.ini update /tmp/mh-build.yml',
        require => [ File['jenkins_jobs.ini'], File['mh-build.yml'] ],
    }

    # configure job mh-deploy
    exec { 'jenkins setup job mh-deploy':
        path    => ['/usr/bin', '/usr/sbin', '/bin', '/usr/local/bin/'],
        command => 'jenkins-jobs --conf /tmp/jenkins_jobs.ini update /tmp/mh-deploy.yml',
        require => [ File['jenkins_jobs.ini'], File['mh-deploy.yml'] ],
    }
}
