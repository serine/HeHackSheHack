library(ggplot2)
imp.data <- read.table("test_qc.txt", header = TRUE, sep = "",
                       stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  
  #Patient ID UI element
  output$patient_ui <- renderUI({
    selectizeInput("patient_id", label = "Patient ID", 
                   choices =colnames(imp.data),
                   selected = NULL, multiple = FALSE, options = list(maxOptions = 5))
  })
  
  #Processing dataframe
  
  df <- reactive({
    base <- imp.data$base
    
    for(i in 1:length(base)){
      base[i] <- unlist(strsplit(base[i], split = "-"))[[1]]
    }
    base <- as.numeric(base)
    imp.data$base <- base
    return(imp.data)
  })
  
  output$gplot <- renderPlot({
    p <- ggplot(df(), aes(x = base, y = qual)) + geom_point() 
    
    if(is.null(input$plot_brush$ymin) == FALSE) {
     p <- p +  xlim(input$plot_brush$xmin, input$plot_brush$xmax) + 
       ylim(input$plot_brush$ymin, input$plot_brush$ymax)
    }
    p
  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
})
