library(shiny)
library(shinydashboard)
library(shinyTime)

source("utils.R")

shinyServer(function(input, output, session) {
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
})
