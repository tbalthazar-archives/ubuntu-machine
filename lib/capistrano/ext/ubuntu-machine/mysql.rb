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
    sudo_and_watch_prompt("mysqldump -u root -p #{database} > #{database}.sql", /Enter\spassword/)
    download "#{database}.sql", "#{default_local_files_path}/database.sql"
    run "rm #{database}.sql"
  end

  desc "Create a new MySQL database, a new MySQL user, and load a local MySQL dump file"
  task :create_database, :roles => :db do
    db_root_password = Capistrano::CLI.ui.ask("MySQL root password : ")
    db_name = Capistrano::CLI.ui.ask("Which database should we create: ")
    db_username = Capistrano::CLI.ui.ask("Which database username should we create: ")
    db_user_password = Capistrano::CLI.ui.ask("Choose a password for the new database username: ")
    file_to_upload = Capistrano::CLI.ui.ask("Do you want to import a database file? (y/n) : ")
    if file_to_upload == "y"
      file = Capistrano::CLI.ui.ask("Which database file should we import (it must be located in #{default_local_files_path}): ")
      upload "#{default_local_files_path}/#{file}", "#{file}"
    end
    create_db_tmp_file = "create_#{db_name}.sql"
    put render("new_db", binding), create_db_tmp_file
    run "mysql -u root -p#{db_root_password} < #{create_db_tmp_file}"
    if file_to_upload == "y"
      run "mysql -u root -p#{db_root_password} #{db_name} < #{file}"
      run "rm #{file}"
    end
    run "rm #{create_db_tmp_file}"
  end

  desc "Install MySQL"
  task :install, :roles => :db do
    db_root_password = Capistrano::CLI.ui.ask("Choose a MySQL root password : ")

    # set a default dummy password for the root user so the installer do not ask interactively for a password
    put render("my.cnf", binding), ".my.cnf"
    sudo "mv .my.cnf /root"
    
    sudo "aptitude install -y mysql-server mysql-client libmysqlclient15-dev"
    run "mysqladmin -u root password #{db_root_password}"
    
    # remove the dummy password
    sudo "rm /root/.my.cnf"
  end
  
  desc "Ask for a MySQL user and change his password"
  task :change_password, :roles => :db do
    user_to_update = Capistrano::CLI.ui.ask("Name of the MySQL user whose you want to update the password : ")
    old_password = Capistrano::CLI.ui.ask("Old password for #{user_to_update} : ")
    new_password = Capistrano::CLI.ui.ask("New password for #{user_to_update} : ")
    
    run "mysqladmin -u #{user_to_update} -p#{old_password} password \"#{new_password}\""
  end
end
