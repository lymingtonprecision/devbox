# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV["BOX_NAME"] || "saucy"
BOX_URI = ENV["BOX_URI"] || "https://cloud-images.ubuntu.com/vagrant/#{BOX_NAME}/current/#{BOX_NAME}-server-cloudimg-amd64-vagrant-disk1.box"

Vagrant::configure("2") do |config|
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
  end

  config.vm.synced_folder "../../", "/projects"

  # Install some baseline package dependencies
  config.vm.provision :shell, inline: <<-SCRIPT
    apt-get update
    apt-get -y install git libssl-dev openjdk-7-jdk
  SCRIPT

  # Configure the Ruby environment
  config.vm.provision :shell, privileged: false, inline: <<-SCRIPT
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    eval "$(rbenv init -)"

    mkdir -p ~/.rbenv/plugins
    cd ~/.rbenv/plugins
    git clone https://github.com/sstephenson/ruby-build.git
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git
    git clone https://github.com/chriseppstein/rbenv-each.git

    cd ~/
    echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
    echo 'update: --no-rdoc --no-ri' >> ~/.gemrc
    rbenv install 2.1.1 &&
    rbenv install 1.9.3-p484 &&
    rbenv global 2.1.1 &&
    rbenv each gem install bundler
  SCRIPT

  # Configure the Clojure environment
  config.vm.provision :shell, privileged: false, inline: <<-SCRIPT
    mkdir -p ~/bin
    wget -O ~/bin/lein https://raw.github.com/technomancy/leiningen/stable/bin/lein
    chmod u+x ~/bin/lein
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    ~/bin/lein version
  SCRIPT

  # Add an Oracle database Docker
  config.vm.provision :docker do |d|
    image = 'wnameless/oracle-xe-11g'
    d.pull_images image
    d.run image, args: '-p 1521:1521 -p 15212:22'
  end

  config.vm.network :forwarded_port, guest: 1521, host: 15210
end

=begin
TODO:

* ohmygems
* .dotfiles
* a docker instance that houses an IFS database suitable for testing
* [shoreman][shoreman] or [foreman][foreman]

[shoreman]: https://github.com/hecticjeff/shoreman
[foreman]: http://ddollar.github.io/foreman/
=end

