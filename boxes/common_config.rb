module Boxes
  def self.configure
    lambda {|config|
      config.vm.box = 'phusion/ubuntu-14.04-amd64'

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id,
                      "--natdnshostresolver1", "on",
                      "--ostype", "Ubuntu_64",
                      "--groups", "/Vagrant"]
      end

      if Vagrant.has_plugin? 'vagrant-librarian-chef'
        config.librarian_chef.cheffile_dir = File.join(
          File.dirname(__FILE__), '..'
        )
      end

      if Vagrant.has_plugin? 'vagrant-hostmanager'
        config.hostmanager.enabled = true
        config.hostmanager.include_offline = true
      end
    }
  end

  def self.configure_chef
    lambda {|chef| }
  end
end

