# encoding: utf-8

#
# Cookbook Name:: default
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#
# ufw (firewall) config
#
execute 'ufw-enable' do
  command 'ufw default deny; printf y | ufw enable'
end

node['ufw']['allows'].each do |allow|
  execute 'ufw-allow-' + allow do
    command 'ufw allow ' + allow
  end
end

execute 'ufw-reload' do
  command "ufw reload"
end

#
# ssh config
#
service 'ssh' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template '/etc/ssh/sshd_config' do
  notifies :reload, 'service[ssh]'
end

#
# locale and timezone
#
execute 'locale' do
  command "locale-gen #{node['locale']}; update-locale LANGUAGE=#{node['locale']} LC_ALL=#{node['locale']} LANG=#{node['locale']}  2> /dev/null"
end

execute 'timezone' do
  command "echo '#{node['timezone']}' > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
end

#
# set .bashrc and hosts by templates, set hostname
#
template '/home/vagrant/.bashrc' do
  user 'vagrant'
  group 'vagrant'
end

template '/etc/hosts' do
end

execute 'hostname' do
  command "hostname #{node['server']}"
end

#
# install git
#
package 'git' do
  action :install
end

execute 'git-config-user-email' do
  user 'vagrant'
  group 'vagrant'
  command "git config --global user.email '#{node['git']['user']['email']}'"
end

execute 'git-config-user-name' do
  user 'vagrant'
  group 'vagrant'
  command "git config --global user.name '#{node['git']['user']['name']}'"
end

#
# install php and apache
#
apt_repository 'php5' do
  uri 'http://ppa.launchpad.net/ondrej/php5/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'E5267A6C'
end

%w{php5 php5-dev php5-curl php5-mcrypt php5-gd}.each do |p|
  package p do
    action :install
  end
end

service 'apache2' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute 'a2enmod' do
  command 'a2enmod rewrite' # apache will be restarted by template
end

template '/etc/php5/apache2/php.ini' do
  notifies :restart, 'service[apache2]'
end

template '/etc/php5/cli/php.ini' do
end

template '/etc/apache2/apache2.conf' do
  notifies :restart, 'service[apache2]'
end

#
# install composer
#
composer '/usr/local/bin' do
  action :install
end

#
# install mysql
#
# TODO: :immediately should not be used for avoid the following error in phpmyadmin
# #1146 - Table 'phpmyadmin.pma_recent' doesn't exist
#
package 'mysql-server' do
  action :install
  notifies :run, 'execute[mysql]'
  notifies :run, 'execute[mysqladmin]'
end

service 'mysql' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute 'mysqladmin' do
  action :nothing
  command 'mysqladmin password -u root ' + node['mysql']['root']['password']
end

package 'php5-mysqlnd' do
  action :install
end

template '/etc/mysql/my.cnf' do
  notifies :restart, 'service[mysql]'
end

#
# install mongodb
#
package 'mongodb' do
  action :install
end

service 'mongodb' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute 'pecl-mongo' do
  command 'pecl install mongo'
  creates '/usr/lib/php5/20121212/mongo.so'
end

#
# install td-agent
#
execute 'td-agent' do
  command 'curl -L http://toolbelt.treasure-data.com/sh/install-ubuntu-precise.sh | sh'
  creates '/etc/init.d/td-agent'
end

#
# install packages by npm
#
apt_repository 'nodejs' do
  uri 'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'C7917B12'
end

package 'nodejs' do
  action :install
end

%w{grunt-cli bower}.each do |p|
  execute p do
    command 'npm install -g ' + p
    not_if "npm -g ls 2> /dev/null | grep '^[├└]─[─┬] #{p}@'"
  end
end

#
# install packages by gem
#
%w{compass}.each do |p|
  gem_package p do
    action :install
  end
end

#
# install redis
#
package 'redis-server' do
  action :install
end

service 'redis-server' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
