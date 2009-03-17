unless Capistrano::Configuration.respond_to?(:instance)
  abort "Requires Capistrano 2"
end

# Dir["#{File.dirname(__FILE__)}/ubuntu-machine/*.rb"].each { |lib| 
#   Capistrano::Configuration.instance.load {load(lib)}   
# }

Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/apache.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/aptitude.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/gems.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/git.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/helpers.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/iptables.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/machine.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/mysql.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/php.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/postfix.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/ruby.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/ssh.rb")}
Capistrano::Configuration.instance.load {load("#{File.dirname(__FILE__)}/ubuntu-machine/utils.rb")}