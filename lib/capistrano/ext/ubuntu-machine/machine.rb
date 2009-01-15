namespace :machine do

  desc "Change the root password, create a new user and allow him to sudo and to SSH"
  task :initial_setup do
    set :user_to_create , user
    set :user, 'root'
    
    
    run "passwd", :pty => true do |ch, stream, data|
      if data =~ /Enter new UNIX password/ || data=~ /Retype new UNIX password:/
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      end
    end
    
    run "adduser #{user_to_create}", :pty => true do |ch, stream, data|
      if data =~ /Enter new UNIX password/ || data=~ /Retype new UNIX password:/ || data=~/\[\]\:/ || data=~/\[y\/N\]/i
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      end
    end
    
    run "echo '#{user_to_create} ALL=(ALL)ALL' >> /etc/sudoers"
    run "echo 'AllowUsers #{user_to_create}' >> /etc/ssh/sshd_config"
    run "/etc/init.d/ssh reload"
  end
  
  task :configure do
    ssh.setup
    iptables.configure
    aptitude.setup
  end
  
  task :install_dev_tools do
    mysql.install
    apache.install
    ruby.install
    gems.install_rubygems
    ruby.install_enterprise
    ruby.install_passenger
    git.install
    php.install
  end
  
  desc = "Ask for a user and change his password"
  task :change_password do
    user_to_update = Capistrano::CLI.ui.ask("Name of the user whose you want to update the password : ")
    
    sudo "passwd #{user_to_update}", :pty => true do |ch, stream, data|
      if data =~ /Enter new UNIX password/ || data=~ /Retype new UNIX password:/
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      end
    end
  end
end
