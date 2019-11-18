#!/bin/bash

# Author: Hoareau John
# Description: Install apache, mariadb and php as explain in the reference link
# Notes: Must be used as root
# References: https://forum.manjaro.org/t/install-apache-mariadb-php-lamp-2016/1243
# Title: manjaro_lamp.sh
# Usage: ./manjaro_lamp.sh



# Apache
pacman -S apache --noconfirm
sed -i '/LoadModule unique_id_module modules\/mod_unique_id.so/c\# LoadModule unique_id_module modules\/mod_unique_id.so' /etc/httpd/conf/httpd.conf
systemctl start httpd
systemctl status httpd


# Mariadb
pacman -S mysql --noconfirm
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
systemctl status mysqld
mysql_secure_installation


# PHP
pacman -S php php-apache --noconfirm
sed -i '/#LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/c\LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so' /etc/httpd/conf/httpd.conf
echo 'LoadModule php7_module modules/libphp7.so' | tee --append /etc/httpd/conf/httpd.conf > /dev/null
echo 'AddHandler php7-script php' | tee --append /etc/httpd/conf/httpd.conf > /dev/null
echo 'Include conf/extra/php7_module.conf' | tee --append /etc/httpd/conf/httpd.conf > /dev/null
systemctl restart httpd
systemctl status httpd


# PHPMYADMIN
pacman -S phpmyadmin
sed -i '/;extension=bz2/c\extension=bz2' /etc/php/php.ini
sed -i '/;extension=mysqli/c\extension=mysqli' /etc/php/php.ini
echo 'Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '  <Directory "/usr/share/webapps/phpMyAdmin">' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '    DirectoryIndex index.php' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '    AllowOverride All' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '    Options FollowSymlinks' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '    Require all granted' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo '  </Directory>' | tee --append /etc/httpd/conf/extra/phpmyadmin.conf > /dev/null
echo 'Include conf/extra/phpmyadmin.conf' | tee --append /etc/httpd/conf/httpd.conf > /dev/null
# sed -i `/$cfg['blowfish_secret'] = '';/c\$cfg['blowfish_secret'] = 'FuckingPa$$';" /etc/webapps/phpmyadmin/config.inc.php`
echo "Please run the line 49 manually"
systemctl restart httpd
systemctl status httpd
