library(ggplot2)
library(rmongodb)


shinyServer(function(input, output) {
  
  #Fetch data from data base
#   get.data <- reactive({
#     data.imp <- mongo.find.all(mongo, "healthhack.test_qc")
#     return(data.imp)
#   })
  
  mongo <- reactive({
    mongo <- mongo.create(host = "127.0.0.1")
    return(mongo)
  })
  
  alldata <- reactive({
#     mongo <- mongo.create(host = "127.0.0.1")
    data <- mongo.find.all(mongo(), "healthhack.test_qc")
    df <- data.frame(matrix(
      unlist(sapply(data, "[", 2)), ncol = length(data))
    )
    return(df)
  })
  
  pat_id <- reactive({
    uid <- mongo.distinct(mongo(), "healthhack.test_qc" , "uid")
    uid <- as.character(uid)
    return(uid)
  })

  #Patient ID UI element
  output$patient_ui <- renderUI({
    selectizeInput("patient_id", label = "Patient ID", 
                   choices =pat_id(),
                   selected = NULL, multiple = FALSE, options = list(maxOptions = 5))
  })
  
  #Processing dataframe
  
  patient.df <- reactive({
    base <- imp.data$base
    
    for(i in 1:length(base)){
      base[i] <- unlist(strsplit(base[i], split = "-"))[[1]]
    }
    base <- as.numeric(base)
    imp.data$base <- base
    return(imp.data)
  })
  
  output$gplot <- renderPlot({
    p <- ggplot(df(), aes(x = base, y = qual)) + geom_point() +
      geom_point(data = patient.df, aes(x = ___, y = ____), colour = "red")
    
    
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
