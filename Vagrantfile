VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  
  config.vm.provider :virtualbox do |vb|
    #memory
    vb.customize ["modifyvm", :id, "--memory", "5120"]
  end
  config.vm.hostname = "cassandra-devenv-host.dev"
  config.vm.box = "ubuntu/trusty64"

  # cassandra ports
  config.vm.network "forwarded_port", guest: 7199, host: 7199
  config.vm.network "forwarded_port", guest: 7000, host: 7000
  config.vm.network "forwarded_port", guest: 7001, host: 7001
  config.vm.network "forwarded_port", guest: 9160, host: 9160
  config.vm.network "forwarded_port", guest: 9042, host: 9042
  # opscenter web console access port
  config.vm.network "forwarded_port", guest: 8888, host: 8888
  # monitoring ports for opscenter communication
  config.vm.network "forwarded_port", guest: 61620, host: 61620
  config.vm.network "forwarded_port", guest: 61621, host: 61621


  config.vm.provision :shell, inline: <<-SCRIPT
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install -y python2.7
    sudo apt-get install -y python-pip
    sudo pip install -q cqlsh
  SCRIPT

  config.vm.provision "docker",
    images: ["crosbymichael/skydns","crosbymichael/skydock"]

  # cleanup previous data
  config.vm.provision :shell, path: "devenv-cleanup.sh"

  # default provisioning of the cassandra node not added yet (registry usage should be defined)
  config.vm.provision :shell, run: "always", path: "devenv-cassandra-startup.sh"
  
  # latest schema creation
  config.vm.provision :shell, inline: <<-SCRIPT
    sleep 30
    cd /vagrant
    sh ./devenv-create-schema.sh
  SCRIPT
end
