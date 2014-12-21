#!/bin/bash

cd /app/haikeuken
source /etc/profile.d/rvm.sh
bundle exec unicorn -D -p 8080
nginx
