library(shiny)
library(RMariaDB)
library(dplyr)
library(dbplyr)
library(ggplot2)

source("utils.R")

ui <- fluidPage(
  theme = "bootstrap.css",
  titlePanel("Air Quality"),

  sidebarLayout(
    sidebarPanel(
      dateInput("date_start", "Start date:", value = Sys.Date(), weekstart = 1),
      dateInput("date_end", "End date:", value = Sys.Date(), weekstart = 1),
      sliderInput("smoothing", "Smoothing window in min:", value = 15, min = 1, max = 240),
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
)

server <- function(input, output, session) {
  autoInvalidate <- reactiveTimer(1000 * 60 * 1)
  uiInvalidate <- reactiveTimer(1000 * 60 * 60 * 1)

  observe({
    autoInvalidate()
  })

  observe({
    uiInvalidate()
    updateDateInput(session, "date_start", value = Sys.Date())
    updateDateInput(session, "date_end", value = Sys.Date())
    updateSliderInput(session, "smoothing", value = 15, min = 1, max = 240)
  })

  output$temperature <- renderPlot({
    autoInvalidate()
    plot_temperature(input$date_start, as.Date(input$date_end) + 1, input$smoothing)
  })

  output$humidity <- renderPlot({
    autoInvalidate()
    plot_humidity(input$date_start, as.Date(input$date_end) + 1, input$smoothing)
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
