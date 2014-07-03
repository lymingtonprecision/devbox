require File.join(File.dirname(__FILE__), '..', 'common_config.rb')

module Boxes; module Staging
  def self.configure
    lambda {|config|
      Boxes.configure.call config

      config.vm.hostname = 'staging.vm.lymingtonprecision.co.uk'
      config.vm.network "private_network", ip: "10.118.109.20"
    }
  end
end; end

