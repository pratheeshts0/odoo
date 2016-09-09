from ubuntu:14.04
maintainer prathes
run apt-get -y update && apt-get -y upgrade

run apt-get install -y 	subversion git bzr bzrtools postgresql postgresql-server-dev-9.3 \
		    	python-pip python-all-dev python-dev python-setuptools \
		    	libxml2-dev libxslt1-dev libevent-dev libsasl2-dev \
		    	libldap2-dev pkg-config libtiff5-dev \
		    	libjpeg8-dev libjpeg-dev zlib1g-dev \
		   	libfreetype6-dev liblcms2-dev liblcms2-utils \
		    	libwebp-dev tcl8.6-dev tk8.6-dev python-tk libyaml-dev fontconfig wget ssh ssmtp


run adduser --system --home=/opt/odoo --group odoo
run mkdir /var/log/odoo
workdir /opt/odoo
run git clone https://www.github.com/odoo/odoo --depth 1 --branch 9.0 --single-branch .
run pip install -r /opt/odoo/doc/requirements.txt
run pip install -r /opt/odoo/requirements.txt
run wget -qO- https://deb.nodesource.com/setup | sudo bash -
run  apt-get -y install nodejs
run npm install -g less less-plugin-clean-css
run wget http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
run dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
run cp /usr/local/bin/wkhtmltopdf /usr/bin
run cp /usr/local/bin/wkhtmltoimage /usr/bin
run cp /opt/odoo/debian/openerp-server.conf /etc/odoo-server.conf
workdir /etc
run sed -i "s|; admin_passwd = admin|admin_passwd = admin|g" odoo-server.conf
run sed -i "s|db_host = False|db_host = 192.168.1.235|g" odoo-server.conf
run sed -i "s|db_port = False|db_port = 5432|g" odoo-server.conf
run sed -i "s|db_user = odoo|db_user = odoo|g" odoo-server.conf
run sed -i "s|db_password = False|db_password = odoo|g" odoo-server.conf
run sed -i "s|addons_path = /usr/lib/python2.7/dist-packages/openerp/addons|#addons_path = /usr/lib/python2.7/dist-packages/openerp/addons|g" odoo-server.conf 

workdir /opt/odoo
run git clone https://github.com/pratheeshts0/odoo.git
workdir /opt/odoo/odoo
run cp odoo-server /etc/init.d/
run rm /etc/ssmtp/ssmtp.conf
run cp /opt/odoo/odoo/ssmtp.conf /etc/ssmtp/ssmtp.conf


run chmod 755 /etc/init.d/odoo-server
run chown root: /etc/init.d/odoo-server
run chown -R odoo: /opt/odoo/
run chown odoo:root /var/log/odoo
run chown odoo: /etc/odoo-server.conf
run chmod 640 /etc/odoo-server.conf
run update-rc.d odoo-server defaults
expose 8069
entrypoint /etc/init.d/odoo-server start && bash
