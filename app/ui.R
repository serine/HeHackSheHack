shinyUI(fluidPage(
  titlePanel("Plot Coverage at Genome Positions"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("chr_sel", label = "Enter a chromosome",value = "chr1"),
#       numericInput("s_pos", label = "Enter a genomic location",value =  161480623),
      uiOutput("pos_inputs"),
      textInput("samp_sel", label = "Enter a sample",value = "sdat2"),
      sliderInput("xslide", label = "See from base range", min = 0, max= 10000, value = c(0,100))
              
     
    ),
    mainPanel(
      plotOutput("gggplot", brush = "plot_brush")
#       textOutput("pseq"),
#       textOutput("sample"),
#         textOutput("fm")
      
    )
  )
))