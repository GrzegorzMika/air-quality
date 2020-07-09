library(shiny)
library(shinyTime)

source("utils.R")

ui <- fluidPage(
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
    updateTimeInput(session, "time_start", value = strptime("00:00:00", "%H:%M:%S"))
    updateTimeInput(session, "time_end", value = strptime("23:59:00", "%H:%M:%S"))
  })

  output$temperature <- renderPlot({
    autoInvalidate()
    start <- strptime(paste(input$date_start, strftime(input$time_start, "%H:%M:%S", usetz = FALSE)), "%Y-%m-%d %H:%M:%S", "GMT") - 60 * 60 * 2
    end <- strptime(paste(input$date_end, strftime(input$time_end, "%H:%M:%S", usetz = FALSE)), "%Y-%m-%d %H:%M:%S", "GMT") - 60 * 60 * 2
    plot_temperature(start, end, input$smoothing)
  })

  output$humidity <- renderPlot({
    autoInvalidate()
    start <- strptime(paste(input$date_start, strftime(input$time_start, "%H:%M:%S", usetz = FALSE)), "%Y-%m-%d %H:%M:%S", "GMT") - 60 * 60 * 2
    end <- strptime(paste(input$date_end, strftime(input$time_end, "%H:%M:%S", usetz = FALSE)), "%Y-%m-%d %H:%M:%S", "GMT") - 60 * 60 * 2
    plot_humidity(start, end, input$smoothing)
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
