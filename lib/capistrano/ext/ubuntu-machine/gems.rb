namespace :gems do
  desc "List gems on remote server"
  task :list, :roles => :app do
    stream "gem list"
  end

  desc "Update gems on remote server"
  task :update, :roles => :app do
    sudo "gem update"
  end
  
  desc "Update gem system on remote server"
  task :update_system, :roles => :app do
    sudo "gem update --system"
  end

  desc "Install a gem on the remote server"
  task :install, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we install: ")
    sudo "gem install #{name}"
  end

  desc "Uninstall a gem on the remote server"
  task :uninstall, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we uninstall: ")
    sudo "gem uninstall #{name}"
  end
end
