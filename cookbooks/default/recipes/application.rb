#
# Cookbook Name:: default
# Recipe:: application
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
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
  action :nothing
  command "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '#{node['mysql']['root']['password']}' WITH GRANT OPTION\""
end

#
# install xdebug
#
execute 'pecl-xdebug' do
  command 'pecl install xdebug'
  creates '/usr/lib/php5/20121212/xdebug.so'
end

#
# install xhprof
#
execute 'pecl-xhprof' do
  command 'pecl install xhprof-0.9.4'
  creates '/usr/lib/php5/20121212/xhprof.so'
end

link '/var/www/xhprof' do
  to '/usr/share/php/xhprof_html'
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
  creates '/usr/lib/php5/20121212/gearman.so'
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
  creates '/usr/lib/php5/20121212/zmq.so'
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
# install phpdev-tools
#
git '/home/vagrant/phpdev-tools' do
  action :checkout
  user 'vagrant'
  group 'vagrant'
  repository 'https://github.com/mp-php/phpdev-tools.git'
  reference 'master'
end

composer_project '/home/vagrant/phpdev-tools' do
  user 'vagrant'
  group 'vagrant'
  action :install
end

link '/usr/local/bin/apigen' do
  to '/home/vagrant/phpdev-tools/vendor/bin/apigen.php'
end

link '/usr/local/bin/php-cs-fixer' do
  to '/home/vagrant/phpdev-tools/vendor/bin/php-cs-fixer'
end

link '/usr/local/bin/phing' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phing'
end

link '/usr/local/bin/phpunit' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phpunit'
end

link '/usr/local/bin/phpcs' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phpcs'
end

link '/usr/local/bin/phpmd' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phpmd'
end

link '/usr/local/bin/phpcpd' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phpcpd'
end

link '/usr/local/bin/phploc' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phploc'
end

link '/usr/local/bin/pdepend' do
  to '/home/vagrant/phpdev-tools/vendor/bin/pdepend'
end

link '/usr/local/bin/phpdcd' do
  to '/home/vagrant/phpdev-tools/vendor/bin/phpdcd'
end

#
# install RockMongo
#
git '/home/vagrant/rockmongo' do
  action :checkout
  user 'vagrant'
  group 'vagrant'
  repository 'https://github.com/iwind/rockmongo.git'
  reference 'master'
end

link '/var/www/rockmongo' do
  to '/home/vagrant/rockmongo'
end

#
# install phpRedisAdmin
#
git '/home/vagrant/phpredisadmin' do
  action :checkout
  user 'vagrant'
  group 'vagrant'
  repository 'https://github.com/ErikDubbelboer/phpRedisAdmin.git'
  reference 'master'
end

composer_project '/home/vagrant/phpredisadmin' do
  user 'vagrant'
  group 'vagrant'
  action :install
end

link '/var/www/phpredisadmin' do
  to '/home/vagrant/phpredisadmin'
end

#
# run custom recipe
#
begin
  include_recipe 'default::custom'
rescue Exception => error
  # avoid Chef::Exceptions::RecipeNotFound
end
