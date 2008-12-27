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

  desc "Show the amount of free disk space."
  task :disk_space, :roles => :gateway do
    run "df -h /"
  end

  desc "Display amount of free and used memory in the system."
  task :free, :roles => :gateway do
    run "free -m"
  end
  
end