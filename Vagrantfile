# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'


# if you change hosts here,  run ./make_hosts.sh to recreate the hosts template.
puppet_nodes = [
  {:hostname => 'fpm',     :ip => '172.16.32.9',  :box => 'centos63'},
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'centos63', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'elasticsearch',  :ip => '172.16.32.11', :box => 'centos63', :ram => 1024},
  {:hostname => 'elasticsearch2', :ip => '172.16.32.13', :box => 'centos63', :ram => 1024},
  {:hostname => 'logstash',       :ip => '172.16.32.12', :box => 'centos63', :ram => 512},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = 'http://files.vagrantup.com/' + node_config.vm.box + '.box'
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
  end
end
