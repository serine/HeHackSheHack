library(shiny)

shinyUI(fluidPage(
  titlePanel("Quality Control Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("patient_ui"),
      downloadButton("dpdf", label = "Download pdf file")
      ),
    mainPanel(
      plotOutput("gplot", click = "plot_click", brush = "plot_brush")
      )
    )
))
