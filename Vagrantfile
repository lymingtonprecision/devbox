# -*- mode: ruby -*-
# vi: set ft=ruby :

Dir[File.join(File.dirname(__FILE__), 'boxes', '**', 'config.rb')].each {|bc|
  require bc
}

Vagrant::configure("2") do |config|
  Boxes.constants.each do |bn|
    bm = Boxes.const_get bn
    vm = bn.to_s.gsub(/([a-z])([A-Z])/, '\1-\2').downcase
    config.vm.define vm, &bm.configure if bm.respond_to? :configure
  end
end

