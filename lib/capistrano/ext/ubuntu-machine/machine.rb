namespace :machine do
  task :configure do
    ssh.setup
    iptables.configure
    aptitude.setup
  end
  
  task :install_dev_tools do
    mysql.install
    apache.install
    ruby.install
    ruby.install_enterprise
    ruby.install_passenger
    git.install
  end
end
