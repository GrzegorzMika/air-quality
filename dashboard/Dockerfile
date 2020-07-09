FROM rocker/shiny

RUN apt-get update && \
    apt-get install mariadb-server -y && \
    apt-get install libv8-dev -y

RUN R -e 'install.packages(c("shiny", "shinyTime", "ggplot2", "purrr", "RMariaDB"))'

COPY . .

EXPOSE 3839

CMD R -e 'shiny::runApp(".", port = 3839, host = "0.0.0.0")'