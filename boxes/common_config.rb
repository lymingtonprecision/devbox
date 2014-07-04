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
      chef.add_recipe 'resolver::default'

      chef.json = {
        resolver: {
          search: 'vm.lymingtonprecision.co.uk lymingtonprecision.co.uk',
          nameservers: %w(10.118.109.10 192.168.108.1 192.168.108.2)
        }
      }
    }
  end
end

