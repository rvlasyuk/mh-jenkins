class jenkins::plugins {

    # download jenkins cli
    exec { 'get jenkins-cli':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "sleep 60 && wget -q -O /tmp/jenkins-cli.jar - http://localhost:8080/jnlpJars/jenkins-cli.jar",
        returns => [0, 4],
        require => Exec['jenkins restart service'],
    }

#    # copy jenkins-job-builder config
#    file { 'credentials.xml':
#        path => '/tmp/credentials.xml',
#        mode    => '0644',
#        owner   => root,
#        group   => root,
#        ensure => file,
#        source => '/vagrant/modules/jenkins/files/credentials.xml',
#    }

    # add jenkins credentials
    exec { 'add jenkins credentials':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => 'curl -X POST \'http://jenkins:8080/credentials/store/system/domain/_/createCredentials\' --data-urlencode \'json={"": "0", "credentials": { "scope": "GLOBAL", "id": "6b76a131-6ec5-4ae5-b7d4-4b3b1b6acfa7", "username": "vagrant", "password": "", "privateKeySource": { "stapler-class": "com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey$UsersPrivateKeySource",}, "description": "",  "stapler-class": "com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey" }}\'',
    }

    # jenkins install plugins
    exec { 'install_github_plugin':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ install-plugin GitHub -deploy",
        require => Exec['get jenkins-cli'],
    }

    exec { 'install_sshagent_plugin':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ install-plugin ssh-agent -deploy",
        require => Exec['get jenkins-cli'],
    }

    exec { 'install_pipeline_plugin':
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ install-plugin workflow-aggregator -deploy -restart",
        require => Exec['get jenkins-cli'],
    }

}



