FROM rocker/shiny

RUN R -e 'install.packages(c("shiny", "dplyr", "dbplyr", "ggplot2", "RMariaDB"))'

RUN apt-get update && \
    apt-get install mariadb-server -y

COPY app.R /app.R

COPY utils.R /utils.R

EXPOSE 3838

CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'