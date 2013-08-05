# PHP Development on Vagrant

<table>
<tr>
<th>PHP</th>
<td>5.5</td>
</tr>
<tr>
<th>Apache</th>
<td>2.4</td>
</tr>
<tr>
<th>MySQL</th>
<td>5.5</td>
</tr>
<tr>
<th>phpMyAdmin</th>
<td>http://www.phpmyadmin.net/</td>
</tr>
<tr>
<th>jsduck</th>
<td>https://github.com/senchalabs/jsduck</td>
</tr>
<tr>
<th>phpdev-tools</th>
<td>https://github.com/mp-php/phpdev-tools</td>
</tr>
<tr>
<th>fuel-dbdocs</th>
<td>https://github.com/mp-php/fuel-dbdocs</td>
</tr>
</table>

## Usage

### Run

	$ git clone --recursive https://github.com/mp-php/vagrant-phpdev-ubuntu.git
	$ cd vagrant-phpdev-ubuntu/
	$ vagrant up # Please wait a few minutes

### Make workspace

#### On your machine

	$ mkdir share/my_first_workspace
	$ vim share/my_first_workspace/index.php

	<?php
	phpinfo();

	$ vagrant ssh

#### On vagrant

	$ sudo ln -s /share/my_first_workspace /var/www/my_first_workspace
	$ exit

access http://localhost:8080/my_first_workspace/

## Features

* phpMyAdmin http://localhost:8080/phpmyadmin/ (root/root)
* DBDocs http://localhost:8080/dbdocs/
* phpunit command
* apigen command
* php-cs-fixer command
* jsduck command

## License

Copyright 2013, Mamoru Otsuka. Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
