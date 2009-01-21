namespace :utils do
  
  desc "Reboot the system."
  task :reboot, :roles => :gateway do
    sure = Capistrano::CLI.ui.ask("Are you sure you want to reboot now? (y/n) : ")
    sudo "reboot" if sure=="y"
  end
  
  desc "Force a reboot of the system."
  task :force_reboot, :roles => :gateway do
    sudo "reboot"
  end
  
  desc "Show the amount of free disk space."
  task :disk_space, :roles => :gateway do
    run "df -h /"
  end

  desc "Display amount of free and used memory in the system."
  task :free, :roles => :gateway do
    run "free -m"
  end

  desc "Display passenger status information."
  task :passenger_status, :roles => :gateway do
    sudo "/opt/ruby-enterprise/bin/passenger-status"
  end

  desc "Display passenger memory usage information."
  task :passenger_memory, :roles => :gateway do
    sudo "/opt/ruby-enterprise/bin/passenger-memory-stats"
  end  

  desc "Activate Phusion Passenger Enterprise Edition."
  task :passenger_enterprise, :roles => :gateway do
    # sudo "passenger-make-enterprisey"
    sudo '/opt/ruby-enterprise/bin/passenger-make-enterprisey', :pty => true do |ch, stream, data|
      if data =~ /Key\:/ || data =~ /again\:/
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      end
    end
  end
  
end