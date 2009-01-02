Gem::Specification.new do |s|
  s.name     = "ubuntu-machine"
  s.version  = "0.0.2.1"
  s.date     = "2009-01-02"
  s.summary  = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.email    = "thomas@suitmymind.com"
  s.homepage = "http://suitmymind.github.com/ubuntu-machine"
  s.description = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.has_rdoc = false
  s.authors  = ["Thomas Balthazar"]
  s.files    = Dir["README", "MIT-LICENSE", "lib/capistrano/ext/**/*"]
  
  s.add_dependency("capistrano", ["> 2.5.2"])
end
