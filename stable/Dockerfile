FROM alpine:3.7

ENV BENCH_BRANCH=master \
    TAG=stable \
    DOCKERIZE_VERSION=v0.2.0

LABEL image=jamrizzi/erpnext:$TAG \
      maintainer="Jam Risser <jam@jamrizzi.com>" \
      base=alpine:3.7

WORKDIR /app

RUN mkdir -p /tmp && cd /tmp &&
    apk add --no-cache \
        tini \
        py-pip \
        python-dev && \
    apk add --no-cache --virtual build-deps \
        git && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -xzvf -C /usr/local/bin dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    git clone https://github.com/frappe/bench bench-repo && \
    pip install -e bench --no-cache-dir && \
    mkdir -p frappe-bench && cd frappe-bench

RUN mkdir -p apps logs sites/localhost config && \
    bench setup env && \
    bench setup socketio && \
    bench get-app frappe https://github.com/frappe/frappe --branch $BENCH_BRANCH && \
    bench get-app erpnext https://github.com/frappe/erpnext --branch $ERPNEXT_BRANCH && \
    apk del build-deps && \
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

ENTRYPOINT ["/sbin/tini", "--", "python", "/app/entrypoint.py"]
