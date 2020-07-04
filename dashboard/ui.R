library(shiny)

shinyUI(fluidPage(
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
))
