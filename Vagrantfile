# -*- mode: ruby -*-
# vi: set ft=ruby :

# install docker 1.9 on Fedora 23
# The number of labvms to provision
$num_labvm = (ENV['NUM_LABVMS'] || 2).to_i

# ip configuration
$labvm_ip_base = ENV['LABVM_IP_BASE'] || "192.168.101.2"
$labvm_ips = $num_labvm.times.collect { |n| $labvm_ip_base + "#{n+3}" }
#$num_labvm.times do |n|
#  print $labvm_ips[n]
#end

Vagrant.configure(2) do |config|
  config.vm.box = "cloudnative/fedora23"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box_url = "https://download.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-Vagrant-23-20151030.x86_64.vagrant-virtualbox.box"
  config.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
  config.ssh.insert_key = false
  # config.vm.provision "shell", keep_color: true, path: "fedora23.sh"  # "https://raw.githubusercontent.com/smartbitnl/Cloud-Native/master/fedora23.sh"
#  config.ssh.password = "vagrant"
  $num_labvm.times do |n|
    config.vm.define "labvm-#{n+1}" do |labvm|

      labvm_index = n+1
      labvm_ip = $labvm_ips[n]
      labvm.vm.network "private_network", ip: "#{labvm_ip}"
      labvm.vm.hostname = "lab-vm-#{labvm_index}"
      config.vm.provision "shell", keep_color: true, path:"fedora23.sh", args: "#{labvm_ip}"
    end
  end
end
