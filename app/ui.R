shinyUI(fluidPage(
  titlePanel("Quality Control Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("chr_sel", label = "Enter a chromosome",value = "chr1"),
      numericInput("s_pos", label = "Enter a genomic location",value = 161487764),
      textInput("samp_sel", label = "Enter a sample",value = "sdat0"),
      sliderInput("xslide", label = "See from base range", min = 0, max= 1000, value = c(0,100))
#       uiOutput("pos_inputs")      
     
    ),
    mainPanel(
      plotOutput("gggplot", brush = "plot_brush"),
      textOutput("pseq"),
      textOutput("sample")
      
    )
  )
))