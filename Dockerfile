FROM --platform=linux/amd64 rocker/shiny-verse:latest

RUN sed -i -e 's/\blisten 3838\b/listen 8080/g' /etc/shiny-server/shiny-server.conf

COPY app.R /srv/shiny-server/app/app.R


