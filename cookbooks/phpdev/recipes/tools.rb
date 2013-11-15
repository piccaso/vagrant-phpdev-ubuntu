#
# Cookbook Name:: phpdev
# Recipe:: tools
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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

execute 'rm composer.lock' do
  command 'rm /home/vagrant/phpredisadmin/composer.lock'
  not_if {File.exists?('/home/vagrant/phpredisadmin/vendor')}
end

composer_project '/home/vagrant/phpredisadmin' do
  action :install
end

link '/var/www/phpredisadmin' do
  to '/home/vagrant/phpredisadmin'
end
