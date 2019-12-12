#!/bin/bash
if ! [ -x "$(command -v httpd)" ]; then yum install -y httpd >&2; fi # install apache if not already installed
if ! [ -x "$(command -v git)" ]; then yum install -y git >&2; fi # install git if not already installed
if ! [ -x "$(command -v mysql)" ]; then yum install -y mysql56 >&2; fi # install mysql if not already installed
if ! [ -x "$(command -v php7)" ]; then yum install -y php73 php73-cli php73-common php73-pdo php73-mysqlnd php73-xml php73-gd libssh2 php73-pecl-ssh2 php73-mbstring php73-fpm php73-opcache php73-pecl-memcached >&2; fi # install php and dependencies if not already installed
