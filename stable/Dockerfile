FROM alpine:3.7

ARG bench_branch=master
ARG erpnext_branch=master
ARG envstamp_version=0.1.0

LABEL image=jamrizzi/erpnext:stable \
      maintainer="Jam Risser <jam@jamrizzi.com> (https://jam.jamrizzi.com)" \
      base=alpine:3.7

RUN apk add --no-cache \
      fontconfig \
      jpeg-dev \
      libffi-dev \
      libxslt-dev \
      mariadb-client \
      mariadb-dev \
      nginx \
      nodejs \
      postgresql-dev \
      py-pip \
      python-dev \
      supervisor \
      ttf-freefont \
      xvfb \
      zlib-dev \
      dbus
RUN apk add --no-cache --virtual build-deps \
      build-base \
      curl \
      git \
      linux-headers

RUN cd /tmp && \
    curl -L -o /usr/local/bin/envstamp https://github.com/jamrizzi/envstamp/releases/download/v${envstamp_version}/envstamp && \
    chmod +x /usr/local/bin/envstamp && \
    git clone https://github.com/frappe/bench && \
    pip install -e bench --no-cache-dir && \
    addgroup -S frappe && \
    adduser -D -G frappe frappe && \
    echo 'frappe ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers

WORKDIR /opt/erpnext

COPY stable /tmp

RUN mkdir -p apps logs sites/localhost config && \
    chown -R frappe:frappe /opt/erpnext

USER frappe

RUN bench setup env && \
    bench setup socketio && \
    bench get-app frappe https://github.com/frappe/frappe --branch ${bench_branch} && \
    bench get-app erpnext https://github.com/frappe/erpnext --branch ${erpnext_branch} && \
    envstamp /tmp/site_config.json && \
    mv /tmp/site_config.json /app/sites/common_site_config.json && \
    chown -R frappe:frappe /app

RUN mv /tmp/entrypoint.sh /usr/local/sbin/entrypoint.sh && \
    mv /tmp/supervisord.conf /etc/supervisord.conf && \
    mv /tmp/nginx.conf /etc/nginx/conf.d/default.conf && \
    apk del build-deps && \
    rm -rf /tmp/* /tmp/.* &>/dev/null || true

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

ENTRYPOINT ["/bin/sh", "/usr/local/sbin/entrypoint.sh"]
