FROM python:2.7-alpine

ARG SYNC_VERSION=c2f17a7bae6306e94e761ec1de18fb669d643f62
ENV URL=http://localhost:5000
ENV UID=791 GID=791

RUN set -xe \
    && addgroup -g $GID -S app \
    && adduser -S -D -u $UID -G app app \
    && apk add --no-cache -U bash dumb-init gcc libstdc++ libffi-dev make mysql-dev musl-dev ncurses-dev openssl-dev g++ \
    && pip install --upgrade pip \
    && pip install virtualenv \
    && mkdir /sync \
    && cd /sync \
    && wget https://github.com/mozilla-services/syncserver/archive/$SYNC_VERSION.tar.gz \
    && tar -xzf $SYNC_VERSION.tar.gz \
    && rm -f $SYNC_VERSION.tar.gz \
    && mv syncserver-$SYNC_VERSION server \
    && cd /sync/server \
    && make build \
    && chown -R "${UID}:${GID}" /sync/server \
    && apk del g++ \
    && mkdir -p /sync/data

COPY files/init.sh /init.sh

VOLUME [ "/sync/data" ]

EXPOSE 5000
USER app

CMD ["/usr/bin/dumb-init", "/bin/sh", "/init.sh"]
