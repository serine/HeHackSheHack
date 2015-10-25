library(rmongodb)
mongo <- mongo.create(host = "146.118.98.44")
mongo.get.databases(mongo)
db <-  "healthhack"
mongo.get.database.collections(mongo, db)
library("ggplot2")
# source("helper.R")
library("shiny")
# source("http://www.bioconductor.org/biocLite.R")
# biocLite("BSgenome")
# biocLite("BSgenome.Hsapiens.UCSC.hg19") 
library('BSgenome.Hsapiens.UCSC.hg19')
shinyServer(function(input, output) {
  
  mongoo <- reactive ({
    mongo <- mongo.create(host = "146.118.98.44")
    return(mongo)
  })
  
  get_sample<- reactive({   
    mongo <- mongoo()
    mongo.get.databases(mongo)
    db <-  "healthhack"
    mongo.get.database.collections(mongo, db)
    
    pops1 <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
                              list('uid' = input$samp_sel, 'chr' = input$chr_sel, 'startpos'= as.numeric(input$pos_ins)),
                            fields=
                              list('coverage' = '1L', '_id'= '0l'))                                 
    return(pops1)
  })
  
  output$sample <- renderPrint({
    get_sample()
  })
  
  output$fm <- renderPrint({
    str(mean_frame())
  })
  
  gene_seq <-  reactive({
    get_genomic_seq(input$chr_sel, as.numeric(input$pos_ins),get_sample())
    
  })
  
  output$pseq <- renderPrint({
    gene_seq ()
  })
  
  
  mean_frame <- reactive({
    
    mongo <- mongoo()
    mongo.get.databases(mongo)
    db <-  "healthhack"
    mongo.get.database.collections(mongo, db)
    
    pops1 <- mongo.find.all(mongo, "healthhack.subsetcoverage", query = 
                              list('chr' = input$chr_sel, 'startpos' =as.numeric(input$pos_ins)  ),
                            fields=
                              list('coverage' = '1L', '_id'= '0l'))    
    return(pops1)
    
  })
  
  make_plot <- reactive({
    make_gplot (gene_seq (), get_sample(), input$xslide,
                mean_frame())
    
#     means_data(input$chr_sel,input$samp_sel
  })
  
  output$gggplot <- renderPlot({
    make_plot()
  })
    
    output$pos_inputs <- renderUI({
      mongo <- mongoo()
        mongo.get.databases(mongo)
        db <-  "healthhack"
        mongo.get.database.collections(mongo, db)
        all_pos <- mongo.find.all(mongoo(), "healthhack.testcoverage", query = 
                                    list('chr' = input$chr_sel, 'uid' = input$samp_sel), fields=
                                    list('startpos' = '1L', '_id'= '0l')) 
      
        new_pos <- unlist(all_pos , recursive = F)
        print(str(new_pos))
        snewps <-  new_pos[sapply(new_pos, is.numeric)]
        end <- as.numeric(snewps)

      selectInput("pos_ins",selectize = F,
                     label = "Select a genomic location", choices = end[1:20])
    })

  
})


handle_mong0 <- function(chr, pos,samp){  
  mongo <- mongoo()
  mongo.get.databases(mongo)
  db <-  "healthhack"
  mongo.get.database.collections(mongo, db)

  pops1 <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
                            list('uid' = samp, 'chr' = chr, 'startpos'= pos),
                          fields=
                            list('coverage' = '1L', '_id'= '0l'))                                 
  return(pops1)
  
}

get_genomic_seq <- function(chr, pos, sample){  
  len <- length(sample[[1]]$coverage)
  seq <- getSeq(Hsapiens,chr,pos,pos+len-1)
  c_seq <-  as.character(seq)
  return(c_seq)
}

make_gplot <- function (seq, samp, slider, meanss){
  meanss <- meanss
  new_pos2 <- unlist(meanss , recursive = F)
  snewps2 <-  new_pos2[sapply(new_pos2, is.numeric)]
  df <- data.frame(snewps2)
  mean_track <- rowMeans(df)
  sdevs <- apply(df, 1, sd)
  
  coverage <- samp[[1]]$coverage
  nums <- seq(1, length(coverage))
  sequence <- strsplit(seq, "")
  to_plot <- data.frame(sequence, coverage, nums,mean_track,sdevs, stringsAsFactors = F)
  colnames(to_plot) <- c("sequence", "coverage", "numbers", "means", "sdevs")
  to_plot <- to_plot[
    to_plot$numbers >= slider[1] &
      to_plot$numbers <= slider[2],]
  print(head(to_plot))
  plt <- ggplot(data = to_plot, aes(x = numbers, y = coverage, color="Sample Coverage"), size =1.3)+
    geom_ribbon(aes(numbers, ymin= means - (sdevs * 1),ymax = means + (sdevs * 1), color="mean +- 1 sdev"), alpha = 0.4)+
    geom_line(size = 1.3)+
    scale_x_discrete(labels=to_plot$sequence)+
    geom_line(aes(numbers, means, color="Mean Coverage"), size =1.3)+  
    scale_color_manual(values=c("Sample Coverage"="red", "mean +- 1 sdev"="grey",
                                "Mean Coverage"=  "green"))
    xlab("Hg19")
  return(print(plt))
  
}

# possible_inputs <- function(samp, chr){
#   
#   all_pos <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                               list('uid' = samp, 'chr' = chr), fields=
#                               list('startpos' = '1L', '_id'= '0l')) 
#   new_pos <- unlist(all_pos , recursive = F)
#   print(str(new_pos))
#   snewps <-  new_pos[sapply(new_pos, is.numeric)]
#   return (as.numeric(snewps))
#   #   print(str(all_pos))
#   #   return(as.numeric(unlist(all_pos)))
#   
# }

# get_mean_data <- function(samp,chr){
#   all_pos <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                               list('uid' = samp, 'chr' = chr), fields=
#                               list('coverage' = '1L', '_id'= '0l')) 
# }
# 
# all_pos <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                             list('uid' = "sdat62", 'chr' = "chr1"), fields=
#                             list('startpos' = '1L', '_id'= '0l')) 

# means_data <- function(chr, pos, mongo){  
#   
#   mongo.get.databases(mongo)
#   db <-  "healthhack"
#   mongo.get.database.collections(mongo, db)
#   pops2 <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                             list('chr' = "chr1", 'startpos'= list('$gte' = 161480623),
#                                  'startpos'= list('$lte' = 161480623+10000)),
#                           fields=
#                             list('coverage' = '1L', '_id'= '0l')) 
#   print(str(pops2))
#   return(pops2)
#   
# }

#"/run/user/1000/gvfs/sftp:host=146.118.98.44,user=andrew/mnt/home/andrew/ShinyApps/app"