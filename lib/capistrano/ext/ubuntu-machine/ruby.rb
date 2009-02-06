require 'net/http'

namespace :ruby do
  desc "Install Ruby 1.8"
  task :install, :roles => :app do
    sudo "aptitude install -y ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8"
    sudo "aptitude install -y libmysql-ruby1.8"

    sudo "ln -s /usr/bin/ruby1.8 /usr/bin/ruby"
    sudo "ln -s /usr/bin/ri1.8 /usr/bin/ri"
    sudo "ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc"
    sudo "ln -s /usr/bin/irb1.8 /usr/bin/irb"
  end
  

  set :ruby_enterprise_url do
    Net::HTTP.get('www.rubyenterpriseedition.com', '/download.html').scan(/http:.*\.tar\.gz/).first
  end

  set :ruby_enterprise_version do
    "#{ruby_enterprise_url[/(ruby-enterprise.*)(.tar.gz)/, 1]}"
  end

  desc "Install Ruby Enterpise Edition"
  task :install_enterprise, :roles => :app do
    sudo "apt-get install libssl-dev -y"
    sudo "apt-get install libreadline5-dev -y"
    
    run "test ! -d /opt/#{ruby_enterprise_version}"
    # run "curl -LO http://rubyforge.org/frs/download.php/50087/#{ruby_enterprise_version}.tar.gz"
    run "curl -LO #{ruby_enterprise_url}"
    run "tar xzvf #{ruby_enterprise_version}.tar.gz"
    run "rm #{ruby_enterprise_version}.tar.gz"
    sudo "./#{ruby_enterprise_version}/installer --auto /opt/#{ruby_enterprise_version}"
    sudo "rm -rf #{ruby_enterprise_version}/"
    
    # create a "permanent" link to the current REE install
    sudo "ln -s /opt/#{ruby_enterprise_version} /opt/ruby-enterprise" 
    
    # add REE bin to the path
    run "cat /etc/environment > ~/environment.tmp"
    run 'echo PATH="/opt/ruby-enterprise/bin:$PATH" >> ~/environment.tmp'
    sudo 'mv ~/environment.tmp /etc/environment'
  end
  
  desc "Install Phusion Passenger"
  task :install_passenger, :roles => :app do
    # because  passenger-install-apache2-module do not find the rake installed by REE
    sudo "gem install rake"

    sudo "apt-get install apache2-mpm-prefork -y"
    sudo "aptitude install libapr1-dev -y"
    sudo "apt-get install apache2-prefork-dev -y"

    sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/gem install passenger"
    
    run "echo -en '\n\n\n\n\n' | sudo /opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-apache2-module"
    
    put render("passenger.load", binding), "/home/#{user}/passenger.load"
    put render("passenger.conf", binding), "/home/#{user}/passenger.conf"

    sudo "mv /home/#{user}/passenger.load /etc/apache2/mods-available/"
    sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"

    sudo "a2enmod passenger"
    apache.force_reload
  end 
   
end
