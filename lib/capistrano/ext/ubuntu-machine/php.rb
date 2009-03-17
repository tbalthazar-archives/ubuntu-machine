namespace :php do
  desc "Install PHP 5"
  task :install, :roles => :app do    
    sudo "apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-imagick php5-mcrypt php5-memcache php5-mhash php5-mysql php5-pspell php5-snmp php5-sqlite php5-xmlrpc php5-xsl -y"
    sudo "/etc/init.d/apache2 reload"
  end

end
