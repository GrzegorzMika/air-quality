library(shiny)
library(shinyTime)

source("utils.R")

shinyUI(fluidPage(
    theme = "bootstrap.css",
    titlePanel("Air Quality"),
    
    sidebarLayout(
        sidebarPanel(
            dateInput("date_start", "Start date:", value = Sys.Date(), weekstart = 1),
            timeInput("time_start", "Start time:", value = strptime("00:00:00", "%H:%M:%S"), seconds = FALSE),
            dateInput("date_end", "End date:", value = Sys.Date(), weekstart = 1),
            timeInput("time_end", "End time:", value = strptime("23:59:00", "%H:%M:%S"), seconds = FALSE),
            sliderInput("smoothing", "Smoothing window in minutes:", value = 15, min = 1, max = 240),
            textOutput("current_temperature"),
            textOutput("current_humidity"),
            
            tags$head(tags$style("#current_temperature{color: black;
                                 font-size: 20px;
                                 font-style: italic;
                                 font-weight: bold;
                                 }")),
            
            tags$head(tags$style("#current_humidity{color: black;
                                 font-size: 20px;
                                 font-style: italic;
                                 font-weight: bold;
                                 }"))
        ),
        mainPanel(
            fluidRow(
                splitLayout(cellWidths = c("50%", "50%"), plotOutput("temperature"), plotOutput("humidity"))
            )
        )
    )
))
