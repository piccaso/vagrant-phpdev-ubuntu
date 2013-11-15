# PHP Development on Vagrant

## Features

* PHP 5.4 http://php.net/
* Apache 2.2 http://www.apache.org/
* MySQL 5.5 http://www.mysql.com/
* phpMyAdmin http://www.phpmyadmin.net/ http://192.168.33.10/phpmyadmin/ (root/root)
* Xdebug http://xdebug.org/
* MongoDB http://www.mongodb.org/
* RockMongo http://rockmongo.com/ http://192.168.33.10/rockmongo/ (admin/admin)
* Redis http://redis.io/
* phpRedisAdmin https://github.com/ErikDubbelboer/phpRedisAdmin http://192.168.33.10/phpredisadmin/
* ZeroMQ http://zeromq.org/
* node.js http://nodejs.org/
* Grunt http://gruntjs.com/
* Bower http://bower.io/
* Fluentd(td-agent) http://fluentd.org/
* Compass http://compass-style.org/
* ApiGen http://apigen.org/
* PHP-CS-Fixer http://cs.sensiolabs.org/
* Phing http://www.phing.info/
* PHPUnit http://phpunit.de/manual/
* PHP_CodeSniffer https://github.com/squizlabs/PHP_CodeSniffer
* phpmd https://github.com/manuelpichler/phpmd
* phpcpd https://github.com/sebastianbergmann/phpcpd
* phploc https://github.com/sebastianbergmann/phploc
* pdepend https://github.com/pdepend/pdepend
* phpdcd https://github.com/sebastianbergmann/phpdcd

## Usage

### Run

	$ git clone --recursive https://github.com/mp-php/vagrant-phpdev-ubuntu.git
	$ cd vagrant-phpdev-ubuntu/
	$ vagrant up # this could take a while...

### Make Project

#### On your machine

	$ mkdir share/my_first_project
	$ vim share/my_first_project/index.php

##### share/my_first_project/index.php

	<?php
	phpinfo();

##### Log in with vagrant ssh

	$ vagrant ssh

#### On vagrant

	$ sudo ln -s /share/my_first_project /var/www/my_first_project

access http://192.168.33.10/my_first_project/

## Customize

	$ cp cookbooks/phpdev/recipes/custom.rb.default cookbooks/phpdev/recipes/custom.rb

edit cookbooks/phpdev/recipes/custom.rb

## License

Copyright 2013, Mamoru Otsuka. Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
