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
      dateInput("date_end", "End date:", value = "2020-06-29", weekstart = 1)
    ),

    mainPanel(
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"), plotOutput("temperature"), plotOutput("humidity"))
      )
    )
  )
)

server <- function(input, output) {
  output$temperature <- renderPlot({
    plot_temperature(input$date_start, input$date_end)
  })

  output$humidity <- renderPlot({
    plot_humidity(input$date_start, input$date_end)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
