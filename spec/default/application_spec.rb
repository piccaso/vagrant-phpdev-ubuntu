require 'spec_helper'

#
# set knife.rb by template
#

# do nothing.

#
# install phpmyadmin
#
describe package('phpmyadmin') do
  it { should be_installed }
end

describe file('/var/www/phpmyadmin') do
  it { should be_linked_to '/usr/share/phpmyadmin' }
end

#
# install xdebug
#
describe command('php -r "phpinfo();" | grep xdebug') do
  it { should return_exit_status 0 }
end

#
# install xhprof
#
describe command('php -r "phpinfo();" | grep xhprof') do
  it { should return_exit_status 0 }
end

describe file('/var/www/xhprof') do
  it { should be_linked_to '/usr/share/php/xhprof_html' }
end

#
# install gearman
#
%w{gearman libgearman-dev}.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe command('php -r "phpinfo();" | grep gearman') do
  it { should return_exit_status 0 }
end

#
# install php-zmq
#
%w{libzmq-dev re2c pkg-config}.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe command('php -r "phpinfo();" | grep zmq') do
  it { should return_exit_status 0 }
end

#
# install packages by gem
#
%w{heroku af}.each do |p|
  describe command('gem list | grep ' + p) do
    it { should return_exit_status 0 }
  end
end

#
# install phpdev-tools
#
describe file('/home/vagrant/phpdev-tools/.git') do
  it { should be_directory }
end

describe file('/home/vagrant/phpdev-tools/vendor') do
  it { should be_directory }
end

describe file('/usr/local/bin/apigen') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/apigen.php' }
end

describe file('/usr/local/bin/php-cs-fixer') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/php-cs-fixer' }
end

describe file('/usr/local/bin/phing') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phing' }
end

describe file('/usr/local/bin/phpunit') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phpunit' }
end

describe file('/usr/local/bin/phpcs') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phpcs' }
end

describe file('/usr/local/bin/phpmd') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phpmd' }
end

describe file('/usr/local/bin/phpcpd') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phpcpd' }
end

describe file('/usr/local/bin/phploc') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phploc' }
end

describe file('/usr/local/bin/pdepend') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/pdepend' }
end

describe file('/usr/local/bin/phpdcd') do
  it { should be_linked_to '/home/vagrant/phpdev-tools/vendor/bin/phpdcd' }
end

#
# install RockMongo
#
describe file('/home/vagrant/rockmongo/.git') do
  it { should be_directory }
end

describe file('/var/www/rockmongo') do
  it { should be_linked_to '/home/vagrant/rockmongo' }
end

#
# install phpRedisAdmin
#
describe file('/home/vagrant/phpredisadmin/.git') do
  it { should be_directory }
end

describe file('/home/vagrant/phpredisadmin/vendor') do
  it { should be_directory }
end

describe file('/var/www/phpredisadmin') do
  it { should be_linked_to '/home/vagrant/phpredisadmin' }
end
