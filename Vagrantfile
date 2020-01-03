# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'ostruct'

config = YAML.load_file('config.yaml')

Vagrant.configure("2") do |vagrant|
  config['master']['count'].times do |i|
    create_node(vagrant, config, i, 'master')
  end

  config['worker']['count'].times do |i|
    create_node(vagrant, config, i, 'worker')
  end
end 

def create_node(vagrant, config, count, type='master')
  name =  "#{type}%02d" % (count+1)
  ipSplit = config["#{type}"]['specs']['eth1'].split('.')
  ip = "#{ipSplit[0]}.#{ipSplit[1]}.#{ipSplit[2]}.#{(ipSplit[3].to_i-1)+(count+1)}"

  vagrant.vm.define name do |node|
    node.vm.box = config["#{type}"]['specs']['box']
    node.vm.hostname = name
    node.vm.network :private_network, ip: ip
    node.vm.boot_timeout = 600
    node.vbguest.auto_update = false

    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", config["#{type}"]['specs']['mem']]
      v.customize ["modifyvm", :id, "--cpus",   config["#{type}"]['specs']['cpu']]
    end

    args = [
      type,
      ip,
      config['k3s']['version'],
      config['k3s']['clusterName'],
      config['k3s']['token'],
      config['k3s']['datastoreEndpoint'],
      config["#{type}"]['k3sParams'],
    ]
    node.vm.provision "shell", path: 'provision.sh', args: args
  end

end
