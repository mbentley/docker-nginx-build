#!/bin/bash

set -e
set -x

WORKDIR="/data/nginx"

if [ ! -d /data ]
then
  mkdir /data
fi
cd /data

if [ ! -d nginx ]
then
  hg clone http://hg.nginx.org/nginx/
  cd nginx
else
  cd nginx
  hg pull --rev default
  make clean || true
fi

if [ ! -d nginx-dav-ext-module ]
then
  git clone --depth 1 https://github.com/arut/nginx-dav-ext-module.git
fi

if [ ! -d ngx_http_auth_pam_module-1.5.1 ]
then
  wget "https://github.com/stogh/ngx_http_auth_pam_module/archive/v1.5.1.tar.gz" -O ngx_http_auth_pam_module-1.5.1.tar.gz
  tar zxf ngx_http_auth_pam_module-1.5.1.tar.gz
  rm ngx_http_auth_pam_module-1.5.1.tar.gz
fi

./auto/configure \
  --sbin-path=/usr/local/sbin \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --http-log-path=/var/log/nginx/access.log \
  --with-http_dav_module \
  --add-module=${WORKDIR}/nginx-dav-ext-module \
  --http-client-body-temp-path=/var/lib/nginx/body \
  --with-http_ssl_module \
  --with-http_realip_module \
  --http-proxy-temp-path=/var/lib/nginx/proxy \
  --with-http_stub_status_module \
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
  --with-http_auth_request_module \
  --add-module=${WORKDIR}/ngx_http_auth_pam_module-1.4 \
  --with-http_v2_module \
  --user=www-data \
  --group=www-data

make

./objs/nginx -v
