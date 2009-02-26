Gem::Specification.new do |s|
  s.name     = "ubuntu-machine"
  s.version  = "0.4.4"
  s.date     = "2009-02-26"
  s.summary  = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.email    = "thomas@suitmymind.com"
  s.homepage = "http://suitmymind.github.com/ubuntu-machine"
  s.description = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.has_rdoc = false
  s.authors  = ["Thomas Balthazar"]
  # s.files    = Dir["README", "MIT-LICENSE", "lib/capistrano/ext/**/*"]
  s.files    = ["README", "MIT-LICENSE", "lib/capistrano/ext/ubuntu-machine.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/apache.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/aptitude.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/gems.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/git.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/helpers.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/iptables.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/machine.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/mysql.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/php.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/ruby.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/ssh.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/utils.rb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/apache2.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/iptables.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/my.cnf.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/new_db.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/passenger.conf.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/passenger.load.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/sshd_config.erb", "lib/capistrano/ext/ubuntu-machine/templateslib/capistrano/ext/ubuntu-machine/templates/vhost.erb"]
  
  s.add_dependency("capistrano", ["> 2.5.2"])
end
