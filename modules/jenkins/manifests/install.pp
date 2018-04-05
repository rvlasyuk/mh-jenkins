class jenkins::install {

    # get jenkins repo key
    exec { 'install_jenkins_key':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => 'wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - ',
    }
    
    # apt update
    exec { 'apt-get update':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => 'apt-get update',
        require => File['/etc/apt/sources.list.d/jenkins.list'],
    }
    
    # set jenkins apt repo
    file { '/etc/apt/sources.list.d/jenkins.list':
        content => "deb http://pkg.jenkins-ci.org/debian binary/\n",
        mode    => '0644',
        owner   => root,
        group   => root,
        require => Exec['install_jenkins_key'],
    }
    
    # install common packages
    $common = [ 'openjdk-8-jdk', 'git', 'maven', 'python-pip' ]
    package { $common:
        ensure  => latest,
        require => Exec['apt-get update'],
    }
    
    # install jenkins package
    package { 'jenkins':
        ensure  => latest,
        require => Exec['apt-get update'],
    }
    
    # install package for job building
    exec { 'install jenkins-job-builder':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => 'pip install jenkins-job-builder',
    }

   # jenkins disable startup config
    exec { 'jenkins disable startup config':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "sed -i 's/^JAVA_ARGS=\"\\(.*\\)\"/JAVA_ARGS=\"\\1 -Djenkins.install.runSetupWizard=false\"/g' /etc/default/jenkins",
    }

    # create .ssh directory
    file { '/var/lib/jenkins/.ssh':
        ensure => 'directory',
        owner  => 'jenkins',
        group  => 'jenkins',
        mode   => '0755',
        require => Package['jenkins'],
    }

    # copy id_rsa
    file { 'id_rsa':
        path => '/var/lib/jenkins/.ssh/id_rsa',
        mode    => '0400',
        owner   => jenkins,
        group   => jenkins,
        ensure => file,
        source => '/vagrant/modules/jenkins/files/id_rsa',
        require => File['/var/lib/jenkins/.ssh']
    }

    # jenkins restart service
    exec { 'jenkins restart service':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "service jenkins restart",
    }

}



