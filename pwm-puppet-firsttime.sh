#!/bin/bash -e
yum -y install wget git-core vim open-vm-tools
wget -O /tmp/puppet6-release-el-7.noarch.rpm https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm
rpm -i /tmp/puppetlabs-release-el-7.noarch.rpm
yum -y update
yum -y install puppet
puppet module install puppetlabs-stdlib --version 4.24.0
puppet module install puppet-letsencrypt --version 2.2.0
puppet module install puppetlabs-mysql
puppet module install puppetlabs-java
puppet module install puppetlabs-git
puppet module install puppetlabs-concat
puppet module install puppetlabs-tomcat --ignore-dependencies

# Clone the 'puppet' repo
cd /etc
mv puppet/ puppet-bak
git clone http://your_git_server_ip/username/puppet.git /etc/puppet

# Run Puppet initially to set up the auto-deploy mechanism
puppet apply /etc/puppet/manifests/site.pp