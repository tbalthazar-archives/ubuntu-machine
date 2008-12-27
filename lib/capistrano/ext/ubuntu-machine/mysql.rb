#TODO : change root password

namespace :mysql do
  desc "Restarts MySQL database server"
  task :restart, :roles => :db do
    sudo "/etc/init.d/mysql restart"
  end

  desc "Starts MySQL database server"
  task :start, :roles => :db do
    sudo "/etc/init.d/mysql start"
  end

  desc "Stops MySQL database server"
  task :stop, :roles => :db do
    sudo "/etc/init.d/mysql stop"
  end

  desc "Export MySQL database"
  task :export, :roles => :db do
    database = Capistrano::CLI.ui.ask("Which database should we export: ")
    # sudo "mysqldump -u root -p #{database} > #{database}.sql", :pty => true
    sudo "mysqldump -u root -p #{database} > #{database}.sql", :pty => true do |ch, stream, data|
      if data =~ /Enter\spassword/
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt("mysql password: ") + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
       end
     end
    download "#{database}.sql", "#{default_local_files_path}/database.sql"
    run "rm #{database}.sql"
  end

  desc "Create a new MySQL database, a new MySQL user, and load a local MySQL dump file"
  task :create_database, :roles => :db do
    db_root_password = Capistrano::CLI.ui.ask("MySQL root password : ")
    db_name = Capistrano::CLI.ui.ask("Which database should we create: ")
    db_username = Capistrano::CLI.ui.ask("Which database username should we create: ")
    db_user_password = Capistrano::CLI.ui.ask("Choose a password for the new database username: ")
    file = Capistrano::CLI.ui.ask("Which database file should we import (it must be located in #{default_local_files_path}): ")
    upload "#{default_local_files_path}/#{file}", "#{file}"

    create_db_tmp_file = "create_#{db_name}.sql"
    put render("new_db", binding), create_db_tmp_file
    run "mysql -u root -p#{db_root_password} < #{create_db_tmp_file}"
        
    # sudo "mysqladmin -u root -p create #{database}", :pty => true do |ch, stream, data|
    #   if data =~ /Enter\spassword/
    #     # prompt, and then send the response to the remote process
    #     ch.send_data(Capistrano::CLI.password_prompt("mysql password: ") + "\n")
    #   else
    #     # use the default handler for all other text
    #     Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    #    end
    # end
    
    run "mysql -u root -p#{db_root_password} #{db_name} < #{file}"
    # sudo "mysql -u root -p #{db_name} < #{file}", :pty => true do |ch, stream, data|
    #   if data =~ /Enter\spassword/
    #     # prompt, and then send the response to the remote process
    #     ch.send_data(Capistrano::CLI.password_prompt("mysql password: ") + "\n")
    #   else
    #     # use the default handler for all other text
    #     Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    #    end
    # end
    
    run "rm #{file} #{create_db_tmp_file}"
  end

  desc "Install MySQL"
  task :install, :roles => :db do
    db_root_password = Capistrano::CLI.ui.ask("Choose a MySQL root password : ")
    sudo "aptitude install -y mysql-server mysql-client libmysqlclient15-dev"
    sudo "aptitude install -y libmysql-ruby1.8"
    run "mysqladmin -u root password #{db_root_password}"
  end
end
