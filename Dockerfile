FROM --platform=linux/amd64 adambodysseus/rockershinyverseplus:v0.1

RUN sed -i -e 's/\blisten 3838\b/listen 80/g' /etc/shiny-server/shiny-server.conf