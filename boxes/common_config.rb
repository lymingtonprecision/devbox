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
    }
  end
end

