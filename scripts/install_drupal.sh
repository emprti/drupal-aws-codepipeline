#!/bin/bash

# mkdir /var/www/drupal

composer global require drush/drush:8.*
/root/.composer/vendor/bin/drush dl -y drupal-8 --drupal-project-rename drupal
mv /root/drupal /var/www/drupal

#/root/.composer/vendor/bin/drush site-install standard --yes \
#--site-name='We Think Twice Dev Site' \
#--site-mail=emp@rti.org \
#--account-name=admin \
#--account-pass=fee9phah \
#--db-url=mysql://drupal:quee3cae@dev-drupalstack-1q2kbcf3rjin9-rds-auroradbcluster-18rsaezn9ipeq.cluster-cptbllp3w4ar.us-east-1.rds.amazonaws.com/sradevdrupaldb \
#--db-prefix=drupal_

rm -f /etc/httpd/conf.d/autoindex.conf /etc/httpd/conf.d/notrace.conf /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf

cat <<EOF > /etc/httpd/conf.d/drupal.conf
<VirtualHost *:80>
    ServerAdmin emp@rti.org
    ServerName  projectsrti.org
    ServerAlias www.projectsrti.org
    DocumentRoot /var/www/drupal
    <Directory /var/www/drupal>
        Options -Indexes -MultiViews +FollowSymLinks
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    RewriteEngine On
    RewriteCond %{HTTP:X-Forwarded-Proto} =http
    RewriteRule .* https://%{HTTP:Host}%{REQUEST_URI} [L,R=permanent]
    LogLevel warn
    ErrorLog /var/log/httpd/drupal-error.log
    CustomLog /var/log/httpd/drupal-access.log combined
</VirtualHost>
ServerSignature Off
ServerTokens Prod
EOF

chown -R apache:apache /var/www/

