require File.join(File.dirname(__FILE__), '..', 'common_config.rb')

module Boxes; module Dev
  def self.configure
    lambda {|config|
      Boxes.configure.call config

      config.vm.hostname = 'dev.vm.lymingtonprecision.co.uk'
      config.vm.network "private_network", ip: "10.118.109.10"
      config.hostmanager.aliases = %w(dev.vm dev)

      config.vm.synced_folder "m:\\projects", "/projects",
        mount_options: ["dmode=775,fmode=664"]

      # Install some baseline package dependencies
      config.vm.provision :shell, inline: <<-SCRIPT
        apt-get install software-properties-common python-software-properties
        add-apt-repository -y ppa:rquillo/ansible
        apt-get update
        apt-get -y install ansible git libssl-dev openjdk-7-jdk
        mv /etc/ansible/hosts /etc/ansible/hosts.example
        echo 'localhost ansible_connection=local' > /etc/ansible/hosts
      SCRIPT

      # Configure the Ruby environment
      # NOTE: consider replacing custom ohmygems with the one from the official
      # repository: https://github.com/seattlerb/ohmygems
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
        rbenv install 2.1.2 &&
        rbenv install 1.9.3-p547 &&
        rbenv global 2.1.2

        wget -O ~/bin/ohmygems https://gist.githubusercontent.com/ah45/7dad9968dd2b1240b01d/raw/31cb8429bf0a2811e43456ddb4f0e21d51a6279f/ohmygems.sh
        wget -O - https://gist.githubusercontent.com/ah45/7dad9968dd2b1240b01d/raw/73d6095ad83324bf0c08e0a528dcbcfbf8b91f6f/.profile >> ~/.bashrc
      SCRIPT

      # Configure the Clojure environment
      config.vm.provision :shell, privileged: false, inline: <<-SCRIPT
        mkdir -p ~/bin
        wget -O ~/bin/lein https://raw.github.com/technomancy/leiningen/stable/bin/lein
        chmod u+x ~/bin/lein
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        ~/bin/lein version

      SCRIPT
      # TODO: setup ~/.lein/profiles.clj with lein-try and midje

      # Add an Oracle database Docker for IFS
      #config.vm.provision :docker do |d|
      #  image = 'wnameless/oracle-xe-11g'
      #  d.pull_images image
      #  d.run image, args: "-p 1521:1521 -p 15212:22 -v '/vagrant:/mnt/vagrant'"
      #end
    }
  end
end; end

=begin
TODO:

* .dotfiles
* a docker instance that houses an IFS database suitable for testing
* [shoreman][shoreman] or [foreman][foreman]

[shoreman]: https://github.com/hecticjeff/shoreman
[foreman]: http://ddollar.github.io/foreman/
=end

