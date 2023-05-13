FROM --platform=linux/amd64 adambodysseus/rockershinyverseplus:v0.1

RUN sed -i -e 's/\blisten 3838\b/listen 8080/g' /etc/shiny-server/shiny-server.conf

COPY app.R /srv/shiny-server/app/app.R

EXPOSE 8080

CMD Rscript -e shiny::runApp('/srv/shiny-server/app', port = 8080, host = '0.0.0.0')

