namespace :apache do
  desc "Install Apache"
  task :install, :roles => :web do
    sudo "apt-get install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y"
    
    run "cat /etc/apache2/apache2.conf > ~/apache2.conf.tmp"
    put render("apache2", binding), "apache2.append.conf.tmp"
    run "cat apache2.append.conf.tmp >> ~/apache2.conf.tmp"
    sudo "mv ~/apache2.conf.tmp /etc/apache2/apache2.conf"
    run "rm apache2.append.conf.tmp"
    restart
  end
  
  desc "Restarts Apache webserver"
  task :restart, :roles => :web do
    sudo "/etc/init.d/apache2 restart"
  end

  desc "Starts Apache webserver"
  task :start, :roles => :web do
    sudo "/etc/init.d/apache2 start"
  end

  desc "Stops Apache webserver"
  task :stop, :roles => :web do
    sudo "/etc/init.d/apache2 stop"
  end

  desc "Reload Apache webserver"
  task :reload, :roles => :web do
    sudo "/etc/init.d/apache2 reload"
  end

  desc "Force reload Apache webserver"
  task :force_reload, :roles => :web do
    sudo "/etc/init.d/apache2 force-reload"
  end

  desc "List enabled Apache sites"
  task :enabled_sites, :roles => :web do
    run "ls /etc/apache2/sites-enabled"
  end

  desc "List available Apache sites"
  task :available_sites, :roles => :web do
    run "ls /etc/apache2/sites-available"
  end

  desc "List enabled Apache modules"
  task :enabled_modules, :roles => :web do
    run "ls /etc/apache2/mods-enabled"
  end

  desc "List available Apache modules"
  task :available_modules, :roles => :web do
    run "ls /etc/apache2/mods-available"
  end

  desc "Disable Apache site"
  task :disable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we disable: ")
    sudo "sudo a2dissite #{site}"
    reload
  end

  desc "Enable Apache site"
  task :enable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we enable: ")
    sudo "sudo a2ensite #{site}"
    reload
  end

  desc "Disable Apache module"
  task :disable_module, :roles => :web do
    mod = Capistrano::CLI.ui.ask("Which module should we disable: ")
    sudo "sudo a2dismod #{mod}"
    force_reload
  end

  desc "Enable Apache module"
  task :enable_module, :roles => :web do
    mod = Capistrano::CLI.ui.ask("Which module should we enable: ")
    sudo "sudo a2enmod #{mod}"
    force_reload
  end

  desc "Create a new website"
  task :create_website, :roles => :web do
    server_admin    = Capistrano::CLI.ui.ask("Server admin (#{default_server_admin}) if blank : ")
    server_admin    = default_server_admin if server_admin.empty?
    server_name     = Capistrano::CLI.ui.ask("Server name : ")
    server_alias    = Capistrano::CLI.ui.ask("Server alias : ")
    directory_index = Capistrano::CLI.ui.ask("Directory index (#{default_directory_index}) if blank : ")
    directory_index = default_directory_index if directory_index.empty?

    # Website skeleton
    %w{backup cap cgi-bin logs private public tmp}.each { |d|
      run "mkdir -p /home/#{user}/websites/#{server_name}/#{d}"
    }
    
    put render("vhost", binding), server_name
    sudo "mv #{server_name} /etc/apache2/sites-available/#{server_name}"
    sudo "sudo a2ensite #{server_name}"
    reload
  end
  
  desc "Delete a website (! delete all file and folders)"
  task :delete_website, :roles => :web do
    server_name = Capistrano::CLI.ui.ask("Server name you want to delete : ")
    sure = Capistrano::CLI.ui.ask("Are you sure you want to delete #{server_name} and all its files? (y/n) : ")
    if sure=="y"
      sudo "sudo a2dissite #{server_name}"
      sudo "rm /etc/apache2/sites-available/#{server_name}"
      sudo "rm -Rf /home/#{user}/websites/#{server_name}"
      reload
    end
  end  
end
