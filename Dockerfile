FROM alpine:3.6

# Based on https://github.com/nrobinaubertin/dockerfiles/blob/master/firefox_syncserver/Dockerfile

ARG SYNC_VERSION=1.6.0
ENV URL=http://localhost:5000
ENV UID=791 GID=791

RUN set -xe \
    && addgroup -g $GID -S app \
    && adduser -S -D -u $UID -G app app \
    && apk add --no-cache -U python su-exec make libstdc++ \
    && apk add --no-cache --virtual .build-deps py-pip py-virtualenv g++ gcc python-dev openssl \
    && mkdir /sync \
    && cd /sync \
    && wget https://github.com/mozilla-services/syncserver/archive/$SYNC_VERSION.tar.gz \
    && tar -xzf $SYNC_VERSION.tar.gz \
    && rm -f $SYNC_VERSION.tar.gz \
    && mv syncserver-$SYNC_VERSION server \
    && cd /sync/server \
    && make build \
    && chown -R "${UID}:${GID}" /sync/server \
    && apk del .build-deps \
    && mkdir -p /sync/data

COPY files/init.sh /init.sh

VOLUME [ "/sync/data" ]

EXPOSE 5000
USER app

CMD ["/bin/sh", "/init.sh"]