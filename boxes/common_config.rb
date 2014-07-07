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
    }
  end

  def self.configure_chef
    lambda {|chef|
      chef.add_recipe 'resolvconf::default'

      chef.json = {
        resolvconf: {
          search: %w(vm.lymingtonprecision.co.uk lymingtonprecision.co.uk),
          nameserver: %w(10.118.109.10 10.0.2.3)
        }
      }
    }
  end
end

