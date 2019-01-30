#!/bin/bash
### If the container was started with the env IS_CRON=1 make it only run the cron daemon
if [ 1 -eq ${IS_CRON:-0} ]
then

  crontab -u www-data crontab.file

  /usr/sbin/cron -f

else 

  /usr/sbin/php-fpm7.2 -F

fi

