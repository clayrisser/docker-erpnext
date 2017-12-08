FROM alpine:3.7

ENV BENCH_BRANCH=master \
    ERPNEXT_BRANCH=master \
    TAG=stable \
    ENVSTAMP_VERSION=0.1.0

LABEL image=jamrizzi/erpnext:$TAG \
      maintainer="Jam Risser <jam@jamrizzi.com>" \
      base=alpine:3.7

WORKDIR /app

RUN mkdir -p /tmp && cd /tmp && \
    apk add --no-cache \
        tini \
        py-pip \
        python-dev \
        mariadb-client \
        mariadb-dev \
        zlib-dev \
        jpeg-dev \
        nginx \
        libffi-dev \
        postgresql-dev \
        libxslt-dev \
        xvfb \
        ttf-freefont \
        supervisor \
        fontconfig \
        dbus \
        nodejs && \
    apk add --no-cache --virtual build-deps \
        linux-headers \
        build-base \
        curl \
        git

RUN curl -L -o /usr/local/bin/envstamp https://github.com/jamrizzi/envstamp/releases/download/v$ENVSTAMP_VERSION/envstamp && \
    chmod +x /usr/local/bin/envstamp && \
    git clone https://github.com/frappe/bench && \
    pip install -e bench --no-cache-dir && \
    addgroup -S frappe && \
    adduser -D -G frappe frappe && \
    chown frappe:frappe /app && \
    echo 'frappe ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers

COPY /$TAG/supervisord.conf /etc/supervisord/supervisord.conf

USER frappe

RUN mkdir -p apps logs sites/localhost config && \
    bench setup env && \
    bench setup socketio && \
    bench get-app frappe https://github.com/frappe/frappe --branch $BENCH_BRANCH && \
    cd apps/frappe && npm install && cd ../.. && \
    bench get-app erpnext https://github.com/frappe/erpnext --branch $ERPNEXT_BRANCH && \
    mv node_modules package-lock.json sites

COPY --chown=frappe /$TAG/site_config.json /app/sites/common_site_config.json
COPY /$TAG/nginx.conf /etc/nginx/conf.d/default.conf
COPY /$TAG/entrypoint.sh /scripts/nginx.sh
COPY /$TAG/entrypoint.sh /scripts/entrypoint.sh

USER root

RUN apk del build-deps && \
    rm -rf /tmp

ENV ADMIN_PASSWORD=frappe \
    DB_HOST=db \
    DB_NAME=erpnext \
    DB_PASSWORD=hellodocker \
    DB_USER=root \
    MAIL_LOGIN= \
    MAIL_PASSWORD= \
    MAIL_PORT= \
    MAIL_SERVER= \
    REDIS_CACHE_URL=redis-cache \
    REDIS_QUEUE_URL=redis-queue \
    REDIS_SOCKETIO_URL=redis-socketio \
    ROOT_PASSWORD=root \
    USE_SSL=false \
    DEVELOPER_MODE=false

ENTRYPOINT ["/sbin/tini", "--", "sh", "/scripts/entrypoint.sh"]
