#
# Cookbook Name:: phpdev
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
  command "ufw default deny; printf y | ufw enable"
end

node['ufw']['allows'].each do |port|
  execute 'ufw-allow-' + port do
    command 'ufw allow ' + port
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
# apt-get update
#
execute 'apt-get' do
  command 'apt-get update'
end

#
# install git
#
package 'git' do
  action :install
end

execute 'git-config-user-email' do
  command "sudo -u vagrant -H git config --global user.email \"#{node['git']['user']['email']}\""
end

execute 'git-config-user-name' do
  command "sudo -u vagrant -H git config --global user.name \"#{node['git']['user']['name']}\""
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

%w{php5 php5-dev php5-curl php5-mcrypt}.each do |p|
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
# install mysql
#
package 'mysql-server' do
  action :install
  notifies :run, 'execute[mysqladmin]', :immediately
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
  not_if {File.exists?('/usr/lib/php5/20121212/mongo.so')}
end

#
# install td-agent
#
execute 'td-agent' do
  command 'curl -L http://toolbelt.treasure-data.com/sh/install-ubuntu-precise.sh | sh'
  not_if {File.exists?('/etc/init.d/td-agent')}
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
# for development
#

#
# set knife.rb by template
#
directory '/home/vagrant/.chef' do
  user 'vagrant'
  group 'vagrant'
end

template '/home/vagrant/.chef/knife.rb' do
  user 'vagrant'
  group 'vagrant'
end

#
# install phpmyadmin
#
package 'phpmyadmin' do
  action :install
end

link '/var/www/phpmyadmin' do
  to '/usr/share/phpmyadmin'
end

execute 'mysql' do
  command "mysql -u root -p#{node['mysql']['root']['password']} -e \"GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '#{node['mysql']['root']['password']}' WITH GRANT OPTION\""
end

#
# install xdebug
#
execute 'pecl-xdebug' do
  command 'pecl install xdebug'
  not_if {File.exists?('/usr/lib/php5/20121212/xdebug.so')}
end

#
# install xhprof
#
execute 'pecl-xhprof' do
  command 'pecl install xhprof-0.9.4'
  not_if {File.exists?('/usr/lib/php5/20121212/xhprof.so')}
end

link '/var/www/xhprof' do
  to '/usr/share/php/xhprof_html'
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

#
# install gearman
#
%w{gearman libgearman-dev}.each do |p|
  package p do
    action :install
  end
end

execute 'pecl-gearman' do
  command 'pecl install gearman-1.0.3'
  not_if {File.exists?('/usr/lib/php5/20121212/gearman.so')}
end

#
# install php-zmq
#
%w{libzmq-dev re2c pkg-config}.each do |p|
  package p do
    action :install
  end
end

execute 'php-zmq' do
  command <<-CMD
    git clone git://github.com/mkoppanen/php-zmq.git
    cd php-zmq/
    phpize
    ./configure
    make
    make install
    cd ../
    rm -r php-zmq
  CMD
  not_if {File.exists?('/usr/lib/php5/20121212/zmq.so')}
end

#
# install packages by gem
#
%w{heroku af}.each do |p|
  gem_package p do
    action :install
  end
end

#
# run custom recipe
#
begin
  include_recipe 'phpdev::custom'
rescue Exception => error
  # avoid Chef::Exceptions::RecipeNotFound
end
