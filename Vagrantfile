# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "yaml2bash"

  config.vm.box = "ailispaw/barge"

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision :docker do |docker|
    docker.build_image "/vagrant/docker", args: "-t yaml2bash"
  end
end
