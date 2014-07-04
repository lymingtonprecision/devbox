require File.join(File.dirname(__FILE__), '..', 'common_config.rb')

module Boxes; module Staging
  def self.dokku_keys
    dev_key_path = File.join(
      File.dirname(__FILE__), '..', 'dev', 'files', 'id_rsa.pub'
    )

    {
      vagrant: File.read(dev_key_path)
    }
  end

  def self.configure
    lambda {|config|
      Boxes.configure.call config

      config.vm.hostname = 'staging.vm.lymingtonprecision.co.uk'
      config.vm.network "private_network", ip: "10.118.109.20"
      config.hostmanager.aliases = %w(staging.vm staging)

      config.vm.provision "chef_solo" do |chef|
        Boxes.configure_chef.call chef

        chef.add_recipe 'redisio::install'
        chef.add_recipe 'redisio::enable'
        chef.add_recipe 'rabbitmq::default'
        chef.add_recipe 'dokku::bootstrap'

        chef.json = {
          docker: {
            package: {
              repo_url: 'https://get.docker.io/ubuntu'
            }
          },
          dokku: {
            git_revision: 'v0.2.3',
            ssh_keys: dokku_keys
          }
        }
      end
    }
  end
end; end

