FROM nginx:alpine3.18

LABEL Maintainer="billcoding <bill07wang@gmail.com>"
LABEL Maintainer="rwsoftware <billcoding@rwsoftware.cn>"
LABEL Description="The NSQ Admin front web with Nginx"

ENV AUTH_BASIC_REALM="NSQ Admin Auth" \
NSQ_ADMIN_USER=nsqadmin \
NSQ_ADMIN_PASSWD=nsqadmin \
NSQ_PASSWD_FILE=/opt/nsqadmin/passwd \  
NSQ_PROXY_ADDR=http://0.0.0.0:4171

RUN mkdir -p /etc/nginx/templates

COPY nsqadmin-static.tar.gz /tmp
COPY default.conf.template /etc/nginx/templates

RUN mkdir -p /opt/nsqadmin/static \
&& tar xvf /tmp/nsqadmin-static.tar.gz -C /opt/nsqadmin/static \
&& apk add apache2-utils \
&& cat /docker-entrypoint.sh > /docker-entrypoint-tmp.sh \
&& echo "#!/bin/sh" > /docker-entrypoint.sh \
&& echo "htpasswd -bmn \$NSQ_ADMIN_USER \$NSQ_ADMIN_PASSWD > \$NSQ_PASSWD_FILE" >> /docker-entrypoint.sh \
&& cat /docker-entrypoint-tmp.sh >> /docker-entrypoint.sh \
&& rm -rf /docker-entrypoint-tmp.sh /tmp/nsqadmin-static.tar.gz

EXPOSE 80