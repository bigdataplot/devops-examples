#!/bin/bash
#supervisord

j2 /apps/supervisord-monitor/supervisord.php.j2 > /apps/supervisord-monitor/application/config/supervisor.php
j2 /apps/supervisord-monitor/welcome.php.j2 > /apps/supervisord-monitor/application/views/welcome.php

cd /apps/supervisord-monitor/public_html
php -S 0.0.0.0:80
