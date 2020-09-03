library(shiny)
library(shinydashboard)
library(shinyTime)

source("utils.R")

shinyServer(function(input, output, session) {
  observe({
    autoInvalidate()
  })

  observe({
    uiInvalidate()
    updateDateInput(session, "date_start", value = Sys.Date())
    updateDateInput(session, "date_end", value = Sys.Date())
    updateSliderInput(session, "smoothing", value = SMOOTHING, min = 1, max = 240)
    updateTimeInput(session, "time_start", value = strptime("00:00:00", "%H:%M:%S"))
    updateTimeInput(session, "time_end", value = strptime("23:59:00", "%H:%M:%S"))
  })

  observe({
    input$reset_input
    source("utils.R")
    updateDateInput(session, "date_start", value = Sys.Date())
    updateDateInput(session, "date_end", value = Sys.Date())
    updateSliderInput(session, "smoothing", value = SMOOTHING, min = 1, max = 240)
    updateTimeInput(session, "time_start", value = strptime("00:00:00", "%H:%M:%S"))
    updateTimeInput(session, "time_end", value = strptime("23:59:00", "%H:%M:%S"))
  })

  output$notificationsMenu <- renderMenu({
    dropdownMenu(
      type = "notifications",
      .list = generate_notifications()
    )
  })

  observe({
    notificationsInvalidate()
    get_new_warning()
  })

  output$temperature <- renderPlot({
    autoInvalidate()
    input$reset_input
    start <- paste(input$date_start, strftime(input$time_start, "%H:%M:%S", usetz = TRUE))
    end <- paste(input$date_end, strftime(input$time_end, "%H:%M:%S", usetz = TRUE))
    plot_temperature(start, end, input$smoothing)
  })

  output$humidity <- renderPlot({
    autoInvalidate()
    input$reset_input
    start <- paste(input$date_start, strftime(input$time_start, "%H:%M:%S", usetz = TRUE))
    end <- paste(input$date_end, strftime(input$time_end, "%H:%M:%S", usetz = TRUE))
    plot_humidity(start, end, input$smoothing)
  })

  output$current_time <- renderText({
    autoInvalidate()
    input$reset_input
    get_current_time()
  })

  output$current_temperature <- renderText({
    autoInvalidate()
    input$reset_input
    get_current_temperature()
  })

  output$current_humidity <- renderText({
    autoInvalidate()
    input$reset_input
    get_current_humidity()
  })
})
