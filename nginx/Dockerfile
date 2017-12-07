FROM nginx:1.13.7

ENV TAG=stable

LABEL image=jamrizzi/erpnext:$TAG \
      maintainer="Jam Risser <jam@jamrizzi.com>" \
      base=alpine:3.5

COPY /$TAG/nginx.conf /etc/nginx/conf.d/default.conf
