# locale settings
default['locale'] = 'en_US.UTF-8'
# timezone settings
default['timezone'] = 'Asia/Tokyo'
# ufw settings
default['ufw']['allows'] = ['http', 'https', '22']
# ssh settings
default['ssh']['port'] = '22'
# git settings
default['git']['user']['email'] = 'vagrant@phpdev'
default['git']['user']['name'] = 'vagrant'
# php settings
default['php']['memory_limit'] = '128M'
default['php']['display_errors'] = 'On'
default['php']['zend_extensions'] = ['/usr/lib/php5/20121212/xdebug.so']
default['php']['extensions'] = ['mongo.so', 'xhprof.so', 'gearman.so', 'zmq.so']
default['php']['date']['timezone'] = 'Asia/Tokyo'
# apache2 settings
default['apache2']['var/www']['allow_override'] = 'All'
# mysql settings
default['mysql']['root']['password'] = 'root'
# other settings
default['server'] = 'phpdev'
