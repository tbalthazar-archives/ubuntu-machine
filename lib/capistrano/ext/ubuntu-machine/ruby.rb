#TODO : add /opt/ruby-enterprise to /etc/environment
namespace :ruby do
  desc "Install Ruby 1.8"
  task :install, :roles => :app do
    sudo "aptitude install -y ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8"

    sudo "ln -s /usr/bin/ruby1.8 /usr/bin/ruby"
    sudo "ln -s /usr/bin/ri1.8 /usr/bin/ri"
    sudo "ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc"
    sudo "ln -s /usr/bin/irb1.8 /usr/bin/irb"
  end

  desc "Install Ruby Enterpise Edition"
  task :install_enterprise, :roles => :app do
    sudo "apt-get install libssl-dev -y"
    
    run "test ! -d /opt/#{ruby_enterprise_version}"
    run "wget -q http://files.rubyforge.mmmultiworks.com/emm-ruby/#{ruby_enterprise_version}.tar.gz"
    run "tar xzvf #{ruby_enterprise_version}.tar.gz"
    run "rm #{ruby_enterprise_version}.tar.gz"
    sudo "./#{ruby_enterprise_version}/installer --auto /opt/#{ruby_enterprise_version}"
    sudo "rm -rf #{ruby_enterprise_version}/"
    
    # create a "permanent" link to the current REE install
    sudo "ln -s /opt/#{ruby_enterprise_version} /opt/ruby-enterprise" 

    # create this alias so the passenger-install-apache2-module script will find the rake command
    # sudo "ln -s /opt/ruby-enterprise/bin/rake /usr/bin/rake"
    
    # put render("passenger_ree.conf", binding), "/home/#{user}/passenger.conf"
    # sudo "a2dismod passenger"
    # sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"
    # sudo "a2enmod passenger"
    # apache.force_reload
  end
  
  desc "Install Phusion Passenger"
  task :useless_install_passenger, :roles => :app do
    # because  passenger-install-apache2-module do not find the rake installed by REE
    sudo "gem install rake"
    
    sudo "apt-get install apache2-mpm-prefork -y"
    sudo "aptitude install libapr1-dev -y"
    sudo "apt-get install apache2-prefork-dev -y"

    sudo "/usr/bin/gem install passenger"
    run "echo -en '\n\n\n\n\n' | sudo passenger-install-apache2-module"

    put render("passenger.load", binding), "/home/#{user}/passenger.load"
    put render("passenger.conf", binding), "/home/#{user}/passenger.conf"

    sudo "mv /home/#{user}/passenger.load /etc/apache2/mods-available/"
    sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"

    sudo "a2enmod passenger"
    apache.force_reload
  end
  
  desc "Install Phusion Passenger"
  task :install_passenger, :roles => :app do
    sudo "apt-get install apache2-mpm-prefork -y"
    sudo "aptitude install libapr1-dev -y"
    sudo "apt-get install apache2-prefork-dev -y"

    # suggested by Hongli Lai
    # sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/gem install rake"
    
    sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/gem install passenger"


    # run 'export PATH="$PATH:/opt/' + ruby_enterprise_version + '/bin"'
    # sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-apache2-module", :pty => true do |ch, stream, data|
    #   if data =~ /Press\sEnter\sto\scontinue/ || data =~ /Press\sENTER\sto\scontinue/
    #     # prompt, and then send the response to the remote process
    #     ch.send_data(Capistrano::CLI.password_prompt("Press Enter to continue: ") + "\n")
    #   else
    #     # use the default handler for all other text
    #     Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    #    end
    # end
    
    run "echo -en '\n\n\n\n\n' | sudo /opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-apache2-module"
    
    
    # sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-apache2-module" #, :pty => true

    put render("passenger.load", binding), "/home/#{user}/passenger.load"
    put render("passenger.conf", binding), "/home/#{user}/passenger.conf"

    sudo "mv /home/#{user}/passenger.load /etc/apache2/mods-available/"
    sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"

    sudo "a2enmod passenger"
    apache.force_reload
  end
  
  task :tmp_passenger, :roles => :app do
    # run "PATH=/opt/#{ruby_enterprise_version}/bin"
    # run "export PATH"
    #run 'export PATH="$PATH:/opt/' + ruby_enterprise_version + '/bin"'
    #ENV["PATH"] = "foo"
    run "echo 'the path is : ' $PATH"

    sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-apache2-module", :pty => true do |ch, stream, data|
      if data =~ /Press\sEnter\sto\scontinue/
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt("Answer: ") + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
       end
    end
  end
  
end
