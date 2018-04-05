Vagrant.configure("2") do |config|
  #config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]	
  config.vm.provision "shell", inline: "echo 'Creating MH environment'"
  config.ssh.insert_key = false 

  config.vm.define "jenkins" do |jenkins|
  	jenkins.vm.provider "virtualbox" do |v|
      v.name = "jenkins"
    end
  	jenkins.vm.network "forwarded_port", guest: 8080, host: 8880
    jenkins.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    jenkins.vm.box_version = "1.0.0"
    jenkins.vm.hostname = 'jenkins'
    jenkins.vm.network :private_network, ip: "192.168.20.2"
    jenkins.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "modules/jenkins/manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

  config.vm.define "springapp01" do |app|
    app.vm.provider "virtualbox" do |v|
      v.name = "springapp01"
    end
    #app.vm.network "forwarded_port", guest: 8080, host: 8888
    app.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    app.vm.box_version = "1.0.0"
    app.vm.hostname = 'springapp01'
    app.vm.network :private_network, ip: "192.168.20.5"
    app.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "modules/springapp/manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

    config.vm.define "springapp02" do |app|
    app.vm.provider "virtualbox" do |v|
      v.name = "springapp02"
    end
    #app.vm.network "forwarded_port", guest: 8080, host: 8889
    app.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    app.vm.box_version = "1.0.0"
    app.vm.hostname = 'springapp02'
    app.vm.network :private_network, ip: "192.168.20.6"
    app.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "modules/springapp/manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

  config.vm.define "nginx " do |nginx_config|
    nginx_config.vm.provider "virtualbox" do |v|
      v.name = "nginx"
    end
    nginx_config.vm.network "forwarded_port", guest: 8085, host: 8881
    nginx_config.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    nginx_config.vm.box_version = "1.0.0"
    nginx_config.vm.hostname = 'nginx'
    nginx_config.vm.network :private_network, ip: "192.168.20.20"
    nginx_config.vm.provision :shell do |shell|
      shell.inline = "puppet module install puppetlabs-stdlib --version 4.13.1 --force --modulepath '/vagrant/modules';
          puppet module install puppetlabs-concat --version 1.1.0 --force --modulepath '/vagrant/modules';
          sed -e '/validate_string($order)/ s/^#*/#/' -i /vagrant/modules/concat/manifests/fragment.pp;
          puppet module install puppetlabs-apt --version 4.5.1 --force --modulepath '/vagrant/modules';
          puppet module install puppet-nginx --version 0.11.0 --force --modulepath '/vagrant/modules'"
      end
    nginx_config.vm.provision "puppet" do |puppet|
      #puppet.manifests_path = "modules/haproxy/manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "nginx.pp"
      puppet.options = "--verbose --debug"
    end
  end
end
