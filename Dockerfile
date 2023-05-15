FROM --platform=linux/amd64 rocker/shiny-verse:latest

FROM rocker/shiny-verse:latest

RUN sudo apt update

RUN sudo apt install apache2 \
  iproute2 \
  vim
  
COPY ./apache.crt /etc/ssl/certs/apache.crt

#RUN openssl genrsa -out /etc/ssl/private/apache.key 2048
#RUN openssl req -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt
# Need to enter domain name as common name

# install apache services
RUN a2enmod ssl proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html

# find an replace
RUN sed -i -e '/s</VirtualHost>/       SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache.crt
        SSLCertificateKeyFile /etc/ssl/private/apache.key
        ProxyPreserveHost On
        ProxyPass / http://0.0.0.0:3838/
        ProxyPassReverse / http://0.0.0.0:3838/
        ServerName localhost
</VirtualHost>' etc/apache2/sites-enabled/000-default.conf

RUN service apache2 restart


#RUN sed -i -e 's/\blisten 3838\b/listen 8080/g' /etc/shiny-server/shiny-server.conf

COPY app.R /srv/shiny-server/app/app.R


