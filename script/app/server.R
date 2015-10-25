library(shiny)
library(ggplot2)
library(rmongodb)


shinyServer(function(input, output) {
  #Define mongo
  mongo <- reactive({
    mongo <- mongo.create(host = "146.118.98.44")
    return(mongo)
  })
  
  #Fetch patient IDs with a mongo query. This will then be passed to the 
  #selectize input which will be rendered in server instead of the UI.
  #
  all_pat_id <- reactive({
    uid <- mongo.distinct(mongo(), "healthhack.test_qc" , "uid")
    return(uid)
  })
  
  #Render patient ID UI element. This input will be used later to change which
  #patient record is being displayed. It will pull the specific record out of the 
  #reactive object which will contain all other records.
  output$patient_ui <- renderUI({
    selectizeInput("patient_id", label = "Patient ID", 
                   choices = as.list(all_pat_id()),
                   selected = as.list(all_pat_id())[1], 
                   multiple = FALSE, options = list(maxOptions = 5))
  })
  
  #Fetch the bases with a mongo query. This should be the same/similar for each record 
  #(some records has a final entry of 100 and others have 100-101). The base field
  #will form the xaxis. 
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
  
  #Wrangle the QC data into a format that can be manipulated. Pull all entries from the
  #database. This will be in an array class. This will be converted into a dataframe
  #with each column corresponding to a patient (use the all_pat_id object), and
  #the rows correspond to the base.
  
  alldata <- reactive({
    data <- mongo.find.all(mongo(), "healthhack.test_qc")
    df <- data.frame(matrix(
      unlist(sapply(data, "[", 2)), ncol = length(data))
    )
    colnames(df) <- all_pat_id()
    return(df)
  })
  
  #Generate a df containing the summary statistics from the QC information dataframe.
  #This is what will be plotted as a geom_ribbon layer. The base column provides the 
  #information for the x-axis. The mean and standard deviationn is 
  #calculated across each row.
  data.info <- reactive({
    base <- base()
    data <- alldata()
    QC <- apply(data, 1, mean)
    rsd <- apply(data, 1, sd)
    df <- data.frame(
      base,
      QC,
      rsd
    )
    #     colnames(df)[2] <- "QC"
    return(df)
  })
  
  #Pull the record of interest and create a dataframe. Base column - for the xaxis, 
  #Y-axis will be the QC information for the specific. Wait for the app to find
  #the input ID first (removes error messages from trying to change colnames)
  pat_data <- reactive({
    if(is.null(input$patient_id) == FALSE) {
      base <- base()
      QC <- subset(alldata(), select = input$patient_id)
      df <- data.frame(
        base,
        QC
      )
      names <- c("base", "QC")
      colnames(df) <- names
      
      
      return(df)
    }
  })
  
  
  
  output$gplot <- renderPlot({
    p <- ggplot(data.info(), aes(x = base)) +  geom_ribbon(aes(ymin= QC - rsd, 
                                                               ymax= QC + rsd),
                                                           colour ="#C2C2C2") 
    
    p <- p + geom_line(data = pat_data(), aes(x= base, y= QC), size = 2,
                       colour = "#333333") + theme(panel.background = "#FFFFFF")
    
    if(is.null(input$plot_brush$ymin) == FALSE) {
      p <- p +  xlim(input$plot_brush$xmin, input$plot_brush$xmax) + 
        ylim(input$plot_brush$ymin, input$plot_brush$ymax)
    }
    p
  })
  
  
})
