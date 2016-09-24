#!/bin/bash

if [ ! -f /var/log/messages ]; then
    echo "Creating default syncserver.ini."
    cp /usr/local/apache2/syncserver/syncserver.ini.orig /sync/syncserver.ini
fi

echo "Updating links."
ln -s /sync/syncserver.ini /usr/local/apache2/syncserver/syncserver.ini
mkdir -p /sync/logs
ln -s /sync/logs /var/log/apache2

echo "Updating permissions."
chown sync-user:sync-user /usr/local/apache2/syncserver -R
chown sync-user:sync-user /sync -R

echo "Running Server."
httpd-foreground