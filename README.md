# Jenkins and microservices

The environment needs to have a jenkins installed with a job that pulls, builds and dists (manually) https://github.com/GoogleCloudPlatform/getting-started-java/tree/master/helloworld-springboot SpringBoot HelloWorld example.
The environment needs to have a single URL that will load balance between at least 2 instances of the code (the solution  must  support changing the number of instances, either in runtime or in ‘up’ of the vagrant)


## Provisioning
You should have [Vagrant] installed.
    

To start provisioning run command from the root of this repo:

    vagrant up

There are 4 VM's should be up and running:

- `jenkins`
- `spingapp01`
- `spingapp02`
- `nginx`

## Jenkins jobs

After completing open in your browser [Jenkins] `http://localhost:8880` and run [Build Job] [mh-build].
As a result you should get the new artifact `helloworld-springboot-latest.jar` in the shared directory `./files/artifacts`

Then run  `Deploy Job` [mh-deploy]. This job will deploy `helloworld-springboot-latest.jar` on 2 application servers `spingapp01` and `spingapp02`.

## Openning web url

Open in your browser [URL] `http://localhost:8881` and you can see `Hello World!`.

## Changing nodes nubmer

Unfortunately nodes autotedecting is absent in this version of code. So if you want to change the number of nodes:

- Add or remove configuration for VM with name `springapp0N`. Each node should have a uniq IP address
- Add or remove member's IP in nginx upstream config in file

### manifests/nginx.pp

    nginx::resource::upstream { 'spring':
      members => [
        '192.168.20.5:8080',
        '192.168.20.6:8080',
      ],
    }

- Add or remove a record in jenkins deploy job file with node's IP

### modules/jenkins/files/mh-deploy.yml

    stage('deploy') {
        sshagent (credentials: ['6b76a131-6ec5-4ae5-b7d4-4b3b1b6acfa7']) {
            sh "ssh -o StrictHostKeyChecking=no -l vagrant 192.168.20.5 sudo /opt/puppetlabs/bin/puppet apply --modulepath=/vagrant/modules /vagrant/manifests/springapp_deploy.pp"
            sh "ssh -o StrictHostKeyChecking=no -l vagrant 192.168.20.6 sudo /opt/puppetlabs/bin/puppet apply --modulepath=/vagrant/modules /vagrant/manifests/springapp_deploy.pp"
        }
    }

- Run provisioning again with a parameter

    vagrant up --provision


## Delete infrastructure

For infrastructure deleting use command:

    vagrant destroy

**Note**: You should delete puppet modules and artifacts manualy.

## Dependencies
 * Vagrant 2.0.3


[Vagrant]: https://www.vagrantup.com/downloads.html
[mh-build]: http://localhost:8880/job/mh-build/
[mh-deploy]: http://localhost:8880/job/mh-deploy/
[URL]: http://localhost:8881
[Jenkins]: http://localhost:8880
