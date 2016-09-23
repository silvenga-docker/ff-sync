FROM httpd:2.4
MAINTAINER Mark Lopez <m@silvenga.com>

RUN \ 
    DEBIAN_FRONTEND=noninteractive apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y libapache2-mod-wsgi python-dev git-core python-virtualenv g++ make

RUN \
    git clone https://github.com/mozilla-services/syncserver &&\
    cd syncserver &&\
    make build

ADD host.conf /usr/local/apache2/host.conf

RUN \
    echo "Include /usr/local/apache2/host.conf" >> /usr/local/apache2/conf/httpd.conf &&\
    adduser --system sync-user --group &&\
    chown sync-user:sync-user /usr/local/apache2/syncserver -R &&\
    mkdir -p /var/log/apache2 /var/run/apache2/

EXPOSE 80