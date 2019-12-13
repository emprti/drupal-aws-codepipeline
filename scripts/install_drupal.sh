#!/bin/bash

composer create-project drupal-composer/drupal-project:8.x-dev /var/www --no-interaction

#drush site-install standard --yes \
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
chmod -R 750 /var/www
# chmod -R 770 /var/www/drupal/sites/default/files

