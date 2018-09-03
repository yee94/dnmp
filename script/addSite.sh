#!/bin/bash

work_path=$(dirname $0)

read -p "Enter your domain [www.example.com]: " DOMAIN

if [ ! $DOMAIN ]; then
    echo 'Please input your domain !';
    exit;
fi

file_path=$work_path/../conf/conf.d/$DOMAIN.conf

echo "writing Nginx config at ${file_path}";

echo "server {
          listen       80;
          server_name  ${DOMAIN};
          root   /var/www/html/${DOMAIN};
          index  index.php index.html index.htm;
          #charset koi8-r;

          access_log /dev/null;
          #access_log  /var/log/dnmp/nginx.site1.access.log  main;
          error_log  /var/log/dnmp/nginx.${DOMAIN}.error.log  warn;

          #error_page  404              /404.html;

          # redirect server error pages to the static page /50x.html
          #
          error_page   500 502 503 504  /50x.html;
          location = /50x.html {
              root   /usr/share/nginx/html;
          }

          # proxy the PHP scripts to Apache listening on 127.0.0.1:80
          #
          #location ~ \.php$ {
          #    proxy_pass   http://127.0.0.1;
          #}

          # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
          #
          location ~ \.php$ {
              fastcgi_pass   php:9000;
              fastcgi_index  index.php;
              include        fastcgi_params;
              fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
          }

          # deny access to .htaccess files, if Apache's document root
          # concurs with nginx's one
          #
          #location ~ /\.ht {
          #    deny  all;
          #}
      }

" >> $file_path

php_www_path=$work_path/../www/$DOMAIN

echo "make dir at ${php_www_path}"

mkdir $php_www_path

echo "<?php
echo 'site ${DOMAIN}<br />';
phpinfo();
" >> $php_www_path/index.php

echo "Done!"
