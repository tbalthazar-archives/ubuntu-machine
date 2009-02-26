unless Capistrano::Configuration.respond_to?(:instance)
  abort "Requires Capistrano 2"
end

# Dir["#{File.dirname(__FILE__)}/ubuntu-machine/*.rb"].each { |lib| 
#   Capistrano::Configuration.instance.load {load(lib)}   
# }

Capistrano::Configuration.instance.load {load("apache.rb")}
Capistrano::Configuration.instance.load {load("aptitude.rb")}
Capistrano::Configuration.instance.load {load("gems.rb")}
Capistrano::Configuration.instance.load {load("git.rb")}
Capistrano::Configuration.instance.load {load("helpers.rb")}
Capistrano::Configuration.instance.load {load("iptables.rb")}
Capistrano::Configuration.instance.load {load("machine.rb")}
Capistrano::Configuration.instance.load {load("mysql.rb")}
Capistrano::Configuration.instance.load {load("php.rb")}
Capistrano::Configuration.instance.load {load("ruby.rb")}
Capistrano::Configuration.instance.load {load("ssh.rb")}
Capistrano::Configuration.instance.load {load("utils.rb")}