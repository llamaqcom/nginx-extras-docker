#!/bin/bash

##
# Define user and group credentials used by worker processes
##

group=$(grep ":$PGID:" /etc/group | cut -d: -f1)

if [[ -z "$group" ]]; then
	group='nginx-extras-docker'
	echo "Adding group $group($PGID)"
	addgroup --system --gid $PGID $group
fi

user=$(getent passwd $PUID | cut -d: -f1)

if [[ -z "$user" ]]; then
	user='nginx-extras-docker'
	echo "Adding user $user($PUID)"
	adduser --system --disabled-login --gid $PGID --no-create-home --home /nonexistent --gecos "user for nginx worker processes" --shell /bin/false --uid $PUID $user
fi

echo "Credentials used by worker processes: user $user($PUID), group $group($PGID)"

##
# Configuration
##

if [[ ! -d /etc/nginx.orig ]]; then
	echo "Saving original nginx configuration"
	cp -r /etc/nginx /etc/nginx.orig
fi

if [ -z "$(ls -A /opt/config)" ]; then
	echo "VOLUME /opt/config is empty, pre-populating it with original nginx configuration"
	cp -r /etc/nginx.orig/. /opt/config
fi

echo "Applying configuration from /opt/config"
rm -rf /etc/nginx
cp -r /opt/config /etc/nginx

sed -i 's/^user\s.*$/user '"$user $group"';/g' /etc/nginx/nginx.conf

#nginx -V

##
# Run Nginx
##

echo "Running nginx"
nginx -g "daemon off;"
