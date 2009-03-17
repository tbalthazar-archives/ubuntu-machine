namespace :iptables do
  desc <<-DESC
    Harden iptables configuration. Only allows ssh, http, and https connections and packets from SAN.

    See "iptables" section on \
    http://articles.slicehost.com/2008/4/25/ubuntu-hardy-setup-page-1
  DESC
  task :configure, :roles => :gateway do
    sudo "apt-get install iptables -y"
    put render("iptables", binding), "iptables.up.rules"
    sudo "mv iptables.up.rules /etc/iptables.up.rules"
    
    sudo "iptables-restore < /etc/iptables.up.rules"
    
    # ensure that the iptables rules are applied when we reboot the server
    run "cat /etc/network/interfaces > ~/tmp_interfaces"
    run "echo 'pre-up iptables-restore < /etc/iptables.up.rules' >> ~/tmp_interfaces"
    sudo "mv ~/tmp_interfaces /etc/network/interfaces"
  end
end
