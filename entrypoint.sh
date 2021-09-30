#!/bin/bash

echo "${CRON} sh /app/backup.sh >> /var/log/cron.log 2>&1" >> /etc/crontabs/root

printenv | grep -v "no_proxy" >> /etc/environment

crond & tail -f /var/log/cron.log
