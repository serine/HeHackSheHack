shinyUI(fluidPage(
  titlePanel("Quality Control Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("chr_sel", label = "Enter a chromosome",value = "chr1"),
      numericInput("s_pos", label = "Enter a genomic location",value = 161487764),
      textInput("samp_sel", label = "Enter a sample",value = "sdat0")
#       uiOutput("pos_inputs")      
     
    ),
    mainPanel(
      plotOutput("gggplot", brush = "plot_brush"),
      textOutput("pseq"),
      textOutput("sample")
      
    )
  )
))