
# Following tutorial there [[https://linuxize.com/post/how-to-install-and-configure-nagios-on-debian-9/]]

# Installing dependencies
sudo apt update && sudo apt upgrade

# Should be libapache2-mod-php7.0 on ubuntu 18.04
sudo apt install autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.0 libgd-dev


sudo apt install libmcrypt-dev libssl-dev bc gawk dc build-essential libnet-snmp-perl gettext

# Download and unpack Nagios
cd /usr/src/
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz
sudo tar zxf nagios-*.tar.gz

# Build
cd nagioscore-nagios-*/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

# Creating Nagios user and group
sudo make install-groups-users
sudo usermod -a -G nagios www-data

# Install
sudo make install

# Creating external command directory
sudo make install-commandmode

# Install Nagios configuration files
sudo make install-config

# Install Apache configuration files
sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi

# Creating systemd unit file
sudo make install-daemoninit

# Creating user account and restart apache
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo systemctl restart apache2

# Configuring firewall
sudo ufw allow Apache

# Installing Nagios plugins
cd /usr/src/
sudo wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
sudo tar zxf nagios-plugins.tar.gz
cd nagios-plugins-release-2.2.1
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install

# Starting Nagios
sudo systemctl start nagios
sudo systemctl status nagios

# Access the web interface [[http(s)://your_domain_or_ip_address/nagios]]
