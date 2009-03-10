namespace :git do
  desc "Install git"
  task :install, :roles => :app do
    sudo "sudo apt-get build-dep git-core -y"
    run "wget http://kernel.org/pub/software/scm/git/#{git_version}.tar.gz"
    run "tar xvzf #{git_version}.tar.gz"
    run "cd #{git_version}"
    run "cd #{git_version} && ./configure"
    run "cd #{git_version} && make"
    run "cd #{git_version} && sudo make install"
    run "rm #{git_version}.tar.gz"
    run "rm -Rf #{git_version}"
  end

end
