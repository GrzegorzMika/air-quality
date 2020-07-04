library(shiny)

source("utils.R")

shinyServer(function(input, output) {
  output$temperature <- renderPlot({
    plot_temperature(input$date_start, input$date_end)
  })

  output$humidity <- renderPlot({
    plot_humidity(input$date_start, input$date_end)
  })
})
