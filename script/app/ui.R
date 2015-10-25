library(shiny)

shinyUI(fluidPage(
  titlePanel("Quality Control Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("patient_ui")
      ),
    mainPanel(
      plotOutput("gplot", click = "plot_click", brush = "plot_brush"),
      textOutput("info"),
      tableOutput("table")
      )
    )
))
