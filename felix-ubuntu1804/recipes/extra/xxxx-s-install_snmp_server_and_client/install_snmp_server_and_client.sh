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

#
# Documentation on snmp daemon:
#   - Installation on Debian: <https://wiki.debian.org/SNMP>
#   - net-snmp documentation: <http://www.net-snmp.org/wiki/index.php/Main_Page>

#
# Extensions for net-snmp:
#   - <https://kb.op5.com/display/HOWTOs/Configure+a+Linux+server+for+SNMP+monitoring>
#   - <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sect-system_monitoring_tools-net-snmp-extending>
#   - <https://geekpeek.net/extend-snmp-run-bash-scripts-via-snmp/>
#   - <http://net-snmp.sourceforge.net/wiki/index.php/FAQ:Agent_07>
#   - <https://www.comparitech.com/net-admin/snmp/>
#   - <https://docstore.mik.ua/orelly/networking_2ndEd/snmp/ch04_02.htm>
#   - <http://www.net-snmp.org/docs/mibs/ucdavis.html>

#
# Documentation on Zabbix:
#   - <https://www.zabbix.com/documentation/3.4/manual/appendix/install/db_scripts#mysql>
#

install_snmp_deamon(){
	echo "Installing snmp deamon ..."
	
	apt install -y snmp snmp-mibs-downloader snmpd
	
	# Allow full access from localhost: uncomment the line "rocommunity public localhost"
	
	# Allow access from local network UDP:161 in /etc/snmp/snmpd.conf
	
	# Comment out the line "mibs :" in /etc/snmp/snmp.conf
	
	# Test if the MIBs are working properly
	snmpwalk -v1 -cpublic localhost
	snmpwalk -v1 -cpublic localhost system
	
	# Test snmpget command
	snmpget -v1 -c public localhost .1.3.6.1.4.1.2021.4.6.0
	
	echo
}

install_zabbix(){
	echo "Installing snmp client Zabbix ..."
	
	apt-get -y install apache2
	
	# ServerTokens only in the server HTTP response header 
	add_or_update_line_based_on_prefix "ServerTokens " "ServerTokens Prod" "/etc/apache2/conf-enabled/security.conf"
	
	# Set ServerName and ServerAdmin in /etc/apache2/apache2.conf
	
	# Install PHP
	apt-get -y install php php-pear php-cgi php-common libapache2-mod-php php-mbstring php-net-socket php-gd php-xml-util php-mysql php-gettext php-bcmath
	a2enconf php7.2-cgi
	
	# Set time zone for PHP
	TIME_ZONE=$(cat /etc/timezone)
	add_or_update_line_based_on_prefix ";date.timezone =" "date.timezone =${TIME_ZONE}" "/etc/php/7.2/apache2/php.ini"
	systemctl restart apache2
	
	# Install Zabbix server
	wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb
	dpkg -i ./zabbix-release_3.4-1+bionic_all.deb
	apt-get update
	apt-get -y install zabbix-agent zabbix-server-mysql php-mysql zabbix-frontend-php
	
	# Create database and set rights for user zabbix
	# mysql -uroot -p
	# create database zabbix character set utf8 collate utf8_bin;
	# grant all privileges on zabbix.* to zabbix@localhost identified by ${PASSWORD};
	# flush privileges;
	
	# Import Zabbix database
	cd /usr/share/doc/zabbix-server-mysql
	gunzip create.sql.gz
	mysql -u zabbix -p zabbix < ./create.sql
	
	# Load http://localhost/zabbix in the browser
	# Default login "Admin" and default password "zabbix"
	
	echo
}

install_snmp_deamon 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_zabbix 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
