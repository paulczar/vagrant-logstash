Description
===========

Rebuilding my Logstash sandbox utilizing the [puppet-sandbox](https://github.com/paulczar/puppet-sandbox) project which I forked to add my own yum repo and fpm package building server.

The idea is to keep this super simple and light and pull puppet modules as git submodules to fulfill my needs for installing and configuring packages.

The following machines are available right now...   

* _puppet.example.com_  - the Puppet master server
* _client1.example.com_ - the first Puppet client machine
* _client2.example.com_ - the second Puppet client machine
* _fpm.example.com_     - package building machine


When fpm is fired up it will build a bunch of RPM packages (if they don't exist already) to be added to the puppet servers yum repo for local consumption.   This means it can be started and then destroyed as soon as its up.


Nodes
=====

nodes.pp currently sets up a basic single server elasticsearch VM on client1.   There's a bunch of config vars passed to the elasticsearch puppet module to enable this.    The elasticsearch puppet module is grabbed from [here](https://github.com/electrical/puppet-elasticsearch).

have also added basic puppet config to client2.    


Requirements
============

To use this, you must have the following items installed and working:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant 1.1+](http://vagrantup.com/)

This has been designed for and tested with Vagrant base boxes running:

* CentOS 6.3


...although it may work just fine with other distributions/versions.

Usage
=====

Make sure you have a compatible Vagrant base box (if you don't have one
already, it will download a 64-bit Ubuntu 12.04 box for you), and then you
should be good to clone this repo and go:

    $ vagrant box list
    centos63
    $ git clone git://github.com/paulczar/vagrant-logstash.git
    $ cd vagrant-logstash/
    $ git submodule init
    $ git submodule update


If you want a CentOS base box to work from, I highly recommend the boxes
published by Jan Vansteenkiste: http://packages.vstone.eu/vagrant-boxes/
if using other CentOS boxes watch out for iptables being turned on by default.

Initial Startup
---------------

Build the needed RPMs with the FPM server

    $ vagrant up fpm
    $ vagrant destroy fpm

To bring up the Puppet server and the elasticsearch node environment, issue the following command:

    $ vagrant up puppet elasticsearch

The following tasks will be handled automatically:

1. The Puppet server daemon will be installed and enabled on the master
   machine.
2. The Puppet client agent will be installed and enabled on all three machines.
3. A host-only network will be set up with all machines knowing how to
   communicate with each other.
4. All client certificate requests will be automatically signed by the master
   server.
5. The master server will utilize the `nodes.pp` file and `modules/` directory
   that exist **outside of the VMs** (in your puppet-sandbox Git working
   directory) by utilizing VirtualBox's shared folder feature.
6. Elasticsearch and Kibana will be installed according to the rules set in the nodes.pp
   _Kibana module is a bit wacky ...  may need to run `puppet agent -t` a few times on it._

Most of this is handled using Vagrant's provisioning capabilities and is
controlled by the manifests under the `provision/` directory. 

If you wish to change the domain name of the VMs (it defaults to
_example.com_), edit the "domain" variable at the top of `Vagrantfile` and
reload the machines:

    $ vim Vagrantfile
    $ vagrant reload

If you edit the Vagrantfile to add/remove hosts running ./make_hosts.sh will parse the nodes.pp file and create a new template for /etc/hosts with all the hostnames.   run `vagrant provision` to catch any changes on already running vms.



Check Your Handiwork
--------------------

    $ vagrant ssh elasticsearch
    $ curl elasticsearch:9200
    $ curl elasticsearch:5601


Package Repositories
--------------------

A local YUM repo `sandbox` is configured on the puppet server.     Copy RPM files into `/vagrant/packages/rpm` and then run `vagrant provision puppet` to refresh the repo.    Currently only supports RPM/YUM but will add APT support some time soon.

Building Packages
-----------------

FPM is installed on the fpm host.   This is an excellent tool for building OS packages where writing specfiles gets painful.    FPM allows you to create RPM or APT packages from source,  or from a directory with all the apps installed.    Check the example redis or elasticsearch scripts on the FPM system under /tmp/ for examples of building packages using FPM.    Saving the resultant RPM to `/vagrant/packages/rpm` and run `vagrant provision puppet` will make it immediately available to client1,client2 for installation. 

Example Package Building and Usage
----------------------------------

    $ vagrant up puppet fpm client1
    $ vagrant ssh fpm
    [vagrant@fpm ~]$ sudo /tmp/redis-rpm.sh
    ...
    ...
    [vagrant@fpm ~]$ exit
    $ vagrant provision puppet
    $ vagrant ssh client1
    [vagrant@client1 ~]$ sudo yum clean all
    [vagrant@client1 ~]$ sudo yum -y install redis
    [vagrant@client1 ~]$ sudo service redis-server start
    [vagrant@client1 ~]$ redis-cli ping
    PONG
    [vagrant@client1 ~]$


Further reading
---------------

[dealing with git submodules](http://git-scm.com/book/en/Git-Tools-Submodules)


License
=======

Vagrant-Logstash is provided under the terms of [The MIT
License](http://www.opensource.org/licenses/MIT).

Copyright &copy; 2013, [Paul Czarkowski](mailto:paul@paulcz.net).


Puppet Sandbox is provided under the terms of [The MIT
License](http://www.opensource.org/licenses/MIT).

Copyright &copy; 2012, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
