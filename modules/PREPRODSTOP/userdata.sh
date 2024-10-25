#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2 awscli
sudo apt-get install prometheus-node-exporter -y
sudo apt-get install awscli -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo apt install php libapache2-mod-php -y
sudo apt install php-cli -y
sudo apt install php-cgi -y
sudo apt install php-pgsql -y
sudo aws s3 cp ${s3_url}index.php  /var/www/html/index.php
sudo mv  /var/www/html/index.html  /var/www/html/index_old.html
sudo chmod 644 /var/www/html/index.php
AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWS_INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
EC2_NAME=$(aws ec2 describe-tags --region $AWS_REGION --filters "Name=resource-id,Values=$AWS_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
sudo hostnamectl set-hostname `echo $EC2_NAME | tr "[:upper:]" "[:lower:]"`
# for Ubuntu 20.04 (Focal)
sudo sed -i "1 s|$| `echo $EC2_NAME | tr "[:upper:]" "[:lower:]"`|" "/etc/hosts"


# this is the log so it will start logging
sudo chmod 755 /home/ubuntu
sudo touch /home/ubuntu/nginx_specific.log
sudo chmod 777 /home/ubuntu/nginx_specific.log


# now the ssl

sudo apt-get install openssl -y
sudo mkdir -p /etc/apache2/ssl
HOSTNAME=$EC2_NAME
sudo openssl genrsa -out /etc/apache2/ssl/$HOSTNAME.key 2048
sudo openssl req -new -x509 -key /etc/apache2/ssl/$HOSTNAME.key -out /etc/apache2/ssl/$HOSTNAME.crt -days 3650 -subj "/C=US/ST=UK/L=London/O=RLDatix/OU=Cloud/CN=$HOSTNAME/emailAddress=ilija.dimitrov@rldatix.com"
sudo chmod 600 /etc/apache2/ssl/$HOSTNAME.*
sudo cat <<EOF > /etc/apache2/sites-available/$HOSTNAME-ssl.conf
<VirtualHost *:443>
    ServerAdmin admin@mycompany.com
    ServerName $HOSTNAME

    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/$HOSTNAME.crt
    SSLCertificateKeyFile /etc/apache2/ssl/$HOSTNAME.key

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog '\\$APACHE_LOG_DIR/error.log'
    CustomLog '\\$APACHE_LOG_DIR/access.log combined'
</VirtualHost>
EOF

sudo cat <<EOF > /etc/apache2/sites-available/$HOSTNAME.conf
<VirtualHost *:80>
    ServerAdmin admin@mycompany.com
    ServerName $HOSTNAME

    # Redirect all HTTP requests to HTTPS
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>
EOF

sudo a2enmod ssl
sudo a2ensite $HOSTNAME-ssl
sudo a2ensite $HOSTNAME
sudo systemctl restart apache2


sudo reboot
