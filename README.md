# php72
Dockerfile for DockerHub: geohost/php72
Container based on Ubuntu 18.04 with php7.2-fpm or cron
If the container was started with the env IS_CRON=1 make it only run the cron daemon
or with env IS_SUPERVISOR=1 will start the supervisord.
