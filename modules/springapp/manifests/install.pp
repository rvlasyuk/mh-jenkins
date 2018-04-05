class springapp::install {

    # update
    exec { 'apt-get update':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => 'apt-get update',
    }

    # install openjdk
    package { 'openjdk-8-jdk':
        ensure  => latest,
        require => Exec['apt-get update'],
    }

    # create user
    user { 'spring':
      ensure => 'present',
    }

    # create group
    group { 'spring':
        ensure => 'present',
    }

    # create spring bin directory
    file { [ '/opt/spring/', '/opt/spring/bin' ]:
        ensure => 'directory',
        owner  => 'spring',
        group  => 'spring',
        mode   => '0755',
        require => [ User['spring'], Group['spring'] ],
    }

    # set service file
    file { 'springapp.service':
        path => '/etc/systemd/system/springapp.service',
        mode    => '0644',
        owner   => spring,
        group   => spring,
        ensure => file,
        source => '/vagrant/modules/springapp/files/springapp.service',
        require => File['/opt/spring/bin'],
    }
}
