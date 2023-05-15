FROM --platform=linux/amd64 rocker/shiny-verse:latest

RUN sudo apt update

RUN sudo apt install -y apache2 iproute2 vim
  
# create the cert
#RUN openssl genrsa -out /etc/ssl/private/apache.key 2048
#RUN openssl req -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt
# Need to enter domain name as common name

COPY ./apache.crt /etc/ssl/certs/apache.crt
COPY ./apache.key /etc/ssl/private/apache.key

# install apache services
RUN a2enmod ssl proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html

RUN sed -e "s/</VirtualHost>//g" -i etc/apache2/sites-enabled/000-default.conf
RUN echo "        SSLEngine on" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        SSLCertificateFile /etc/ssl/certs/apache.crt" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        SSLCertificateKeyFile /etc/ssl/private/apache.key" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        ProxyPreserveHost On" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        ProxyPass / http://0.0.0.0:3838/" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        ProxyPassReverse / http://0.0.0.0:3838/" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "        ServerName localhost" >> etc/apache2/sites-enabled/000-default.conf
RUN echo "</VirtualHost>" >> etc/apache2/sites-enabled/000-default.conf

RUN echo "Mutex posixsem" >> /etc/apache2/apache2.conf

RUN service apache2 restart

#RUN sed -i -e 's/\blisten 3838\b/listen 8080/g' /etc/shiny-server/shiny-server.conf
COPY app.R /srv/shiny-server/app/app.R


