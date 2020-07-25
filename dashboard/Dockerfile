FROM rocker/shiny

RUN apt-get update && \
    apt-get install mariadb-server -y && \
    apt-get install libv8-dev -y

RUN R -e 'install.packages(c("shiny", "shinyTime",  "shinydashboard", "scales", "ggplot2", "jsonlite", "RMariaDB"))'

ENV TZ=Europe/Warsaw

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . .

EXPOSE 3838

CMD R -e 'shiny::runApp(".", port = 3838, host = "0.0.0.0")'