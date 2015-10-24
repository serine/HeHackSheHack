handle_mong0 <- function(chr, pos,samp){  
  mongo <- mongo.create(host = "146.118.98.44")
  mongo.get.databases(mongo)
  db <-  "healthhack"
#   pops1 <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                             list('uid' = samp, 'chr' = chr, 'startpos' = list('$gte' = pos),
#                                  'startpos' = list('$lte' = pos+150)))
  pops1 <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
                            list('uid' = samp, 'chr' = chr, 'startpos'= pos))

                                 
  return(pops1)
  
}

get_genomic_seq <- function(chr, pos, sample){  
  len <- length(sample[[1]]$coverage)
  seq <- getSeq(Hsapiens,chr,pos,pos+len-1)
  c_seq <-  as.character(seq)
  return(c_seq)
}

make_gplot <- function (seq, samp){
  coverage <- samp[[1]]$coverage
  nums <- seq(1, length(coverage))
  sequence <- strsplit(seq, "")
  print(str(coverage))
  to_plot <- data.frame(sequence, coverage, nums, stringsAsFactors = F)
  
  colnames(to_plot) <- c("sequence", "coverage", "numbers")
  print(head(to_plot))
  to_plot<<-to_plot
  plt <- ggplot(data = to_plot, aes(x = numbers, y = coverage))+geom_point()
  return(print(plt))
  
}

# possible_inputs <- function(samp, chr){
#   mongo <- mongo.create(host = "146.118.98.44")
#   mongo.get.databases(mongo)
#   db <-  "healthhack"
#   
#   all_uids <- mongo.find.all(mongo, "healthhack.testcoverage", query = 
#                             list('uid' = samp, 'chr' = chr))  
#   
# }
#"/run/user/1000/gvfs/sftp:host=146.118.98.44,user=andrew/mnt/home/andrew/ShinyApps/app"