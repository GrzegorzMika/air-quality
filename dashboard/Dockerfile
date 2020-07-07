FROM rocker/shiny

RUN apt-get update && \
    apt-get install mariadb-server -y && \
    apt-get install libv8-dev -y

RUN R -e 'install.packages(c("shiny", "dplyr", "dbplyr", "ggplot2", "purrr", "RMariaDB"))'

COPY app.R /app.R

COPY utils.R /utils.R

EXPOSE 3838

CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'