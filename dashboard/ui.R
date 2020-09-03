library(shiny)
library(shinydashboard)
library(shinyTime)

source("utils.R")

header <- dashboardHeader(title = "Air Quality", dropdownMenuOutput("notificationsMenu"))

sidebar <- dashboardSidebar(disable = TRUE)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "header.css"),
    tags$style("#current_temperature{color: black;
                                     font-size: 20px;
                                     font-style: italic;
                                     font-weight: bold;
                                     }"),
    tags$style("#current_humidity{color: black;
                                     font-size: 20px;
                                     font-style: italic;
                                     font-weight: bold;
                                     }"),
    tags$style("#current_time{color: black;
                                     font-size: 20px;
                                     font-style: italic;
                                     font-weight: bold;
                                     }")
  ),
  sidebarLayout(
    sidebarPanel(
      dateInput("date_start", "Start date:", value = Sys.Date(), weekstart = 1),
      timeInput("time_start", "Start time:", value = strptime("00:00:00", "%H:%M:%S"), seconds = FALSE),
      dateInput("date_end", "End date:", value = Sys.Date(), weekstart = 1),
      timeInput("time_end", "End time:", value = strptime("23:59:00", "%H:%M:%S"), seconds = FALSE),
      sliderInput("smoothing", "Smoothing window (in minutes):", value = SMOOTHING, min = 1, max = 240),
      actionButton("reset_input", "Reset")
    ),
    mainPanel(
      fluidRow(
        box(
          title = tags$p("Current conditions", style = "font-size: 32px; font-family: Times New Roman; font-weight: bold;"),
          solidHeader = TRUE, collapsible = TRUE, width = NULL, collapsed = FALSE,
          splitLayout(cellWidths = c("15%", "15%", "20%"), textOutput("current_temperature"), textOutput("current_humidity"), textOutput("current_time"))
        ),
        box(
          collapsible = TRUE, width = NULL, collapsed = FALSE,
          splitLayout(cellWidths = c("50%", "50%"), plotOutput("temperature"), plotOutput("humidity"))
        )
      )
    )
  )
)

ui <- dashboardPage(header = header, sidebar = sidebar, body = body, skin = "green")
