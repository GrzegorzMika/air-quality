library(shiny)
library(RMariaDB)
library(dplyr)
library(dbplyr)
library(ggplot2)

source("utils.R")

ui <- fluidPage(
  titlePanel("Air Quality"),

  sidebarLayout(
    sidebarPanel(
      dateInput("date_start", "Start date:", value = "2020-06-29", weekstart = 1),
      dateInput("date_end", "End date:", value = "2020-06-30", weekstart = 1),
      textOutput("current_temperature"),
      textOutput("current_humidity")
    ),

    mainPanel(
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"), plotOutput("temperature"), plotOutput("humidity"))
      )
    )
  )
)

server <- function(input, output) {
  autoInvalidate <- reactiveTimer(1000*60*5)
  
  output$temperature <- renderPlot({
    plot_temperature(input$date_start, as.Date(input$date_end) + 1)
  })

  output$humidity <- renderPlot({
    plot_humidity(input$date_start, as.Date(input$date_end) + 1)
  })
  
  output$current_temperature <- renderText({
    autoInvalidate()
    get_current_temperature()
  })
  
  output$current_humidity <- renderText({
    autoInvalidate()
    get_current_humidity()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
