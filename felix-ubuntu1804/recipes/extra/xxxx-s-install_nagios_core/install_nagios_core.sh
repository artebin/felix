#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_nagios_core(){
	printf "Installing Nagios Core ...\n"
	
	# See <https://linuxize.com/post/how-to-install-and-configure-nagios-on-debian-9>
	
	# Installing dependencies
	apt-get update
	DEPENDENCIES=( 	"autoconf"
			"gcc"
			"libc6"
			"make"
			"wget"
			"unzip"
			"apache2"
			"php"
			"libapache2-mod-php7.2"
			"libgd-dev"
			"libmcrypt-dev"
			"libssl-dev"
			"bc"
			"gawk"
			"dc"
			"build-essential"
			"libnet-snmp-perl"
			"gettext" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Download and unpack Nagios
	cd /usr/src/
	wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz
	tar zxf nagios-*.tar.gz
	
	# Build
	cd nagioscore-nagios-*/
	./configure --with-httpd-conf=/etc/apache2/sites-enabled
	make all
	
	# Creating Nagios user and group
	make install-groups-users
	usermod -a -G nagios www-data
	
	# Install
	make install
	
	# Creating external command directory
	make install-commandmode
	
	# Install Nagios configuration files
	make install-config
	
	# Install Apache configuration files
	make install-webconf
	a2enmod rewrite
	a2enmod cgi
	
	# Creating systemd unit file
	make install-daemoninit
	
	# Creating user account and restart apache
	htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
	systemctl restart apache2
	
	# Configuring firewall
	ufw allow Apache
	
	# Installing Nagios plugins
	cd /usr/src/
	wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
	tar zxf nagios-plugins.tar.gz
	cd nagios-plugins-release-2.2.1
	./tools/setup
	./configure
	make
	make install
	
	# Starting Nagios
	systemctl start nagios
	systemctl status nagios
	
	printf "\n"
}

install_nagios_core 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
