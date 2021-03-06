library(rmongodb)
query <- mongo.bson.from.list(list('city' = 'COLORADO CITY'))
mongo <- mongo.create()
mongo.get.databases(mongo)
mongo.get.database.collections(mongo, db)
db <- "healthhack"

res <- mongo.distinct(mongo, "healthhack.test_qc" , "uid")

test2 <- mongo.find.all(mongo, "healthhack.test_qc", list('uid' = "sdat89"))

pops1 <- mongo.find.all(mongo, "healthhack.test_qc", 
                        query = list('uid' = "sdat89", "quality" = list('$gte' = 32)))

test_qc <- mongo.find.all(mongo, "healthhack.test_qc")
test

df.b <- data.frame(matrix(unlist(test_qc), nrow=length(test_qc), byrow=T), 
                 stringsAsFactors = F)
View(df.b)

df <- data.frame(matrix(
  unlist(sapply(test_qc, "[", 2)), ncol = length(test_qc))
  )
uid <- mongo.distinct(mongo, "healthhack.test_qc" , "uid")
base<- mongo.distinct(mongo, "healthhack.test_qc" , "base")
base <- as.vector(base)
colnames(df) <- uid

for(i in 1:length(base)){
  base[i] <- unlist(strsplit(base[i], split = "-"))[[1]]
}
base <- as.numeric(base)
base <- unique(base)
base <- sort(base)
rownames(df) <- base

rsd <- apply(df, 1, sd)
rvar <- apply(df, 1, var)
rmean <- apply(df, 1, mean)


info.df <- data.frame(
  base,
  rmean,
  rsd
  )

c_rec <- "sdat89"
rec_data <- subset(df, select = c_rec)
rec_data <- data.frame(base, rec_data)
colnames(rec_data) <- c("base", "pat") 

b <- ggplot(info.df, aes(x= base)) + geom_ribbon(aes(ymin=rmean - rsd, 
                                                     ymax= rmean + rsd))
b + geom_line(data = rec_data, aes(x = base, y= pat), colour = "red")



p <- ggplot(alldata(), aes(x = base)) +  geom_ribbon(aes(ymin=rmean - rsd, 
                                                         ymax= rmean + rsd)) + 
  geom_line(aes(y=rmean))
p + geom_line(data = pat_dat, aes(y=input$patient_id), colour = "red")


View(rsd
  sapply(test_qc, "[", 4)





cdf <- sapply(test_qc, "[", c(1,2))
View(cdf)
