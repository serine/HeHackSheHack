library(ggplot2)
library(rmongodb)


shinyServer(function(input, output) {
  
  #Fetch data from data base
#   get.data <- reactive({
#     data.imp <- mongo.find.all(mongo, "healthhack.test_qc")
#     return(data.imp)
#   })
  #Fetch data from database
  mongo <- reactive({
    mongo <- mongo.create(host = "127.0.0.1")
    return(mongo)
  })
  #Fetch patient IDs
  all_pat_id <- reactive({
    uid <- mongo.distinct(mongo(), "healthhack.test_qc" , "uid")
    return(uid)
  })
  
  
  #Render patient ID UI element
  output$patient_ui <- renderUI({
    selectizeInput("patient_id", label = "Patient ID", 
                   choices = as.list(pat_id()),
                   selected = NULL, multiple = FALSE, options = list(maxOptions = 5))
  })
  
  #Create the range from the base field
  base <- reactive({
    base<- mongo.distinct(mongo(), "healthhack.test_qc" , "base")
    base <- as.vector(base)
    for(i in 1:length(base)){
      base[i] <- unlist(strsplit(base[i], split = "-"))[[1]]
    }
    base <- as.numeric(base)
    base <- unique(base)
    base <- sort(base)
    return(base)
  })
  
  #Wrangle the QC data into a format that can be manipulated
  alldata <- reactive({
#     mongo <- mongo.create(host = "127.0.0.1")
    data <- mongo.find.all(mongo(), "healthhack.test_qc")
    df <- data.frame(matrix(
      unlist(sapply(data, "[", 2)), ncol = length(data))
    )
    colnames(df) <- all_pat_id()
    return(df)
  })
  
  #Pull the record of interest
  pat_data <- reactive({
    df <- subset(alldata(), select = input$patient_id, drop = FALSE)
  })

  data.info <- reactive({
    df <- data.frame(
      base <- base()
      rmean <- apply(alldata(), 1, mean),
      rsd <- apply(alldata(), 1, sd),
      )
  })
  
 
  
  output$gplot <- renderPlot({
    p <- ggplot((), aes(x = base)) +  geom_ribbon(aes(ymin=rmean - rsd, 
                                                      ymax= rmean + rsd)) + 
      geom_line(aes(y=rmean))
    p
    
#     if(is.null(input$plot_brush$ymin) == FALSE) {
#      p <- p +  xlim(input$plot_brush$xmin, input$plot_brush$xmax) + 
#        ylim(input$plot_brush$ymin, input$plot_brush$ymax)
#     }
#     p
  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })

})


#defunct code

#Processing dataframe
#   
#   patient.df <- reactive({
#     base <- imp.data$base
#     
#     for(i in 1:length(base)){
#       base[i] <- unlist(strsplit(base[i], split = "-"))[[1]]
#     }
#     base <- as.numeric(base)
#     imp.data$base <- base
#     return(imp.data)
#   })