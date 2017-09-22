FROM httpd:2.4
MAINTAINER Mark Lopez <m@silvenga.com>

RUN \ 
    DEBIAN_FRONTEND=noninteractive apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y libapache2-mod-wsgi python-dev git-core python-virtualenv g++ make

RUN \
    git clone https://github.com/mozilla-services/syncserver &&\
    cd syncserver &&\
    make build

RUN \
    DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove git-core g++ make

COPY files/setup.sh /setup.sh
RUN \
    mkdir -p /sync &&\
    mv /usr/local/apache2/syncserver/syncserver.ini /usr/local/apache2/syncserver/syncserver.ini.bak &&\
    chmod +x /setup.sh
    
COPY files/syncserver.ini /usr/local/apache2/syncserver/syncserver.ini.orig
COPY files/host.conf /usr/local/apache2/host.conf
RUN \
    mkdir -p /var/run/apache2 &&\
    echo "Include /usr/local/apache2/host.conf" >> /usr/local/apache2/conf/httpd.conf &&\
    adduser --system sync-user --group
    
EXPOSE 80

ENTRYPOINT ["/setup.sh"]