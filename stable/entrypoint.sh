#!/bin/sh

envstamp /app/sites/common_site_config.json
cp /app/sites/common_site_config.json /app/sites/localhost/site_config.json
chmod 440 /app/sites/common_site_config.json
chmod 440 /app/sites/localhost/site_config.json
bench --site localhost doctor > /dev/null 2>&1
exec supervisord -n -c /etc/supervisord/supervisord.conf
