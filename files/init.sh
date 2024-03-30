#!/bin/sh

SERVER=/sync/server
DATA=/sync/data
: ${SECRET:=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)}

echo "Listening for host ${URL}."

echo "\
[server:main]
use = egg:gunicorn
host = 0.0.0.0
port = 5000
workers = 1
timeout = 30
errorlog = -
loglevel = warning
forwarded_allow_ips = *

[app:main]
use = egg:syncserver

[syncserver]
public_url = ${URL}
secret = ${SECRET}
force_wsgi_environ = false
sqluri = sqlite:///${DATA}/syncserver.db

" > $SERVER/syncserver.ini

cd ${SERVER}
make serve
