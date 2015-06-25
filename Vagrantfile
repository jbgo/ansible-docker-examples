# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Ubuntu 14.04 is capable of running docker without any kernel modifications
  config.vm.box = "ubuntu/trusty64"

  ssh_public_key = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))

  4.times do |n|
    config.vm.define "swarm#{n}" do |swarm|
      swarm.vm.network "private_network", ip: "192.168.33.10#{n}"
      swarm.vm.hostname = "swarm#{n}"

      # To make running ansible playbooks against vagrant hosts a smoother experience, we
      # run apt-get udpate and copy our public key to the host.
      swarm.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        echo "#{ssh_public_key}" >> /home/vagrant/.ssh/authorized_keys
      SHELL
    end
  end
end
