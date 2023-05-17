FROM --platform=linux/amd64 rocker/shiny-verse:latest
RUN apt -y update
#RUN apt -y upgrade
RUN apt install -y nginx iproute2 vim 
COPY ./apache.crt /etc/ssl/certs/apache.crt
COPY ./apache.key /etc/ssl/private/apache.key
COPY app.R /srv/shiny-server/app/app.R
COPY ./nginx.conf /etc/nginx/sites-available/default
RUN service nginx start