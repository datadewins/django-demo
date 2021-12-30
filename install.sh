#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
		apache2 \
		git \
		jq \
		libapache2-mod-wsgi-py3 \
		python3 \
		python3-pip \
		tmux
sudo pip3 install django

# install apache and module
sudo systemctl enable apache2
sudo systemctl stop apache2
sudo a2enmod wsgi

# configure service and host
# get the application code
git clone https://github.com/datadewins/django-demo.git
sudo cp -r django-demo/dynamic /var/www/html
sudo chown www-data /var/www/html/dynamic -R

# setup host definition
echo '
WSGIScriptAlias / /var/www/html/dynamic/dynamic/wsgi.py
WSGIPythonPath /var/www/html/dynamic/
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html
	<Directory /var/www/html/dynamic/>
	   <Files wsgi.py>
	      Order deny,allow
	      Allow from all
	   </Files>
	</Directory>
</VirtualHost>
' | sudo tee /etc/apache2/sites-enabled/000-default.conf

# validate and start apache
sudo apache2ctl configtest
sudo systemctl start apache2
