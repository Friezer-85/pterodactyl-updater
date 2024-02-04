#!/bin/bash

######################################################################################
#                                                                                    #
# Project 'pterodactyl-updater'                                                    #
#                                                                                    #
# This script is not associated with the official Pterodactyl Project.               #
# https://github.com/Friezer-85/pterodactyl-updater                     #
#                                                                                    #
######################################################################################

cd /var/www/pterodactyl
php artisan down
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
chmod -R 755 storage/* bootstrap/cache
composer install --no-dev --optimize-autoloader
php artisan view:clear
php artisan config:clear
php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan queue:restart
php artisan up
echo "Update of Pterodactyl Panel terminated successfully, processing with Wings update"
systemctl stop wings
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
chmod u+x /usr/local/bin/wings
systemctl restart wings
echo "Update of Wings successfully, thanks for using this script !"
