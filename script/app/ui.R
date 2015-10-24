shinyUI(fluidPage(
  titlePanel("Quality Control Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("patient_ui")
      ),
    mainPanel(
      plotOutput("gplot")
      )
    )
))
