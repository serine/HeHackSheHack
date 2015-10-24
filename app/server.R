library("ggplot2")
source("helper.R")
library(rmongodb)
library("shiny")
# source("http://www.bioconductor.org/biocLite.R")
# biocLite("BSgenome")
# biocLite("BSgenome.Hsapiens.UCSC.hg19") 
library('BSgenome.Hsapiens.UCSC.hg19')

shinyServer(function(input, output) {
  
#   output$pos_inputs <- renderUI({
#     selectizeInput("pos_ins", options = possible_inputs(input$chr_sel, input$samp_sel), 
#                    label = "Select a sample", choices = possible_inputs(input$chr_sel, input$samp_sel)[[1]])
#   })
  
  get_sample<- reactive({
    handle_mong0(input$chr_sel, input$s_pos,input$samp_sel)
  })
  
  output$sample <- renderPrint({
    get_sample()
  })
  
  gene_seq <-  reactive({
    get_genomic_seq(input$chr_sel, input$s_pos,get_sample())
    
  })
  
  output$pseq <- renderPrint({
    gene_seq ()
  })
  
  make_plot <- reactive({
    make_gplot (gene_seq (), get_sample())
  })
  
  output$gggplot <- renderPlot({
    make_plot()
  })
  
})