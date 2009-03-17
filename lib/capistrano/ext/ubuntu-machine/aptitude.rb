namespace :aptitude do
  desc <<-DESC
    Updates your software package list. This will not "upgrade" any of your \
    installed software.

    See "Update" section on \
    http://articles.slicehost.com/2007/11/6/ubuntu-gutsy-setup-page-2
  DESC
  task :update, :roles => :app do
    sudo "apt-get update"
  end

  desc "Alias for 'aptitude:safe_upgrade'"
  task :upgrade, :roles => :app do
    safe_upgrade
  end

  desc <<-DESC
    Upgrades your installed software packages.

    From the aptitude man pages:

      This command will upgrade as many packages as it can upgrade without \
      removing existing packages or installing new ones.

      It is sometimes necessary to remove or install one package in order to \
      upgrade another; this command is not able to upgrade packages in such \
      situations. Use the full-upgrade to upgrade those packages as well.

    See "Upgrade" section on \
    http://articles.slicehost.com/2007/11/6/ubuntu-gutsy-setup-page-2
  DESC
  task :safe_upgrade, :roles => :app do
    
    # to prevent interactive mode to block the install script
    sudo 'aptitude hold console-setup -y'
    
    # By default, OVH replace the original /etc/issue. The safe_upgrade will then ask \
    # if it must overwrite this file, since it has been modified by OVH. \
    # data =~ /^\*\*\*\sissue/ looks for the interactive prompt to enable you to answer
    sudo_and_watch_prompt("aptitude safe-upgrade -y", /^\*\*\*\sissue/)    
  end
  
  desc <<-DESC
    Upgrades your installed software packages.

    From the aptitude man pages:

      Like safe-upgrade, this command will attempt to upgrade packages, but it is \
      more aggressive about solving dependency problems: it will install and \
      remove packages until all dependencies are satisfied. Because of the nature \
      of this command, it is possible that it will do undesirable things, and so \
      you should be careful when using it.

    See "Upgrade" section on \
    http://articles.slicehost.com/2007/11/6/ubuntu-gutsy-setup-page-2
  DESC
  task :full_upgrade, :roles => :app do
    sudo "aptitude full-upgrade -y"
  end

  desc <<-DESC
    Installs a software package via aptitude. You will be prompted for the \
    package name after running this commmand.
  DESC
  task :install, :roles => :app do
    package = Capistrano::CLI.ui.ask("Which package should we install: ")
    sudo "apt-get install #{package}"
  end

  desc <<-DESC
    Uninstalls a software package via aptitude. You will be prompted for the \
    package name after running this commmand.
  DESC
  task :uninstall, :roles => :app do
    package = Capistrano::CLI.ui.ask("Which package should we uninstall: ")
    sudo "apt-get remove #{package}"
  end
  
  desc <<-DESC
    Updates software packages and creates "a solid base for the 'meat' of the \
    server". This task should be run only once when you are first setting up your \
    new slice.

    See "Update", "locales", "Upgrade" and "build essentials" sections on \
    http://articles.slicehost.com/2007/11/6/ubuntu-gutsy-setup-page-2
  DESC
  task :setup, :roles => :app do
    update
    sudo "locale-gen en_GB.UTF-8"
    sudo "/usr/sbin/update-locale LANG=en_GB.UTF-8"
    safe_upgrade
    full_upgrade
    sudo "apt-get install -y build-essential"
  end
end
