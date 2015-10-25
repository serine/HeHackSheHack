library(rmongodb)
query <- mongo.bson.from.list(list('city' = 'COLORADO CITY'))
mongo <- mongo.create()
mongo.get.databases(mongo)
mongo.get.database.collections(mongo, db)
db <- "healthhack"
res <- mongo.distinct(mongo, "healthhack.test_qc" , "uid")
test2 <- mongo.find.all(mongo, "healthhack.test_qc", list('uid' = "sdat89"))
pops1 <- mongo.find.all(mongo, "healthhack.test_qc", query = list('uid' = "sdat89", "quality" = list('$gte' = 32)))
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

sapply(test_qc, "[", 4)
cdf <- sapply(test_qc, "[", c(1,2))
View(cdf)


imp.data <- read.table("test_qc.txt", header = TRUE, sep = "", stringsAsFactors = FALSE)
View(imp.data)
class(imp.data$base)
library(ggplot2)
len <- imp.data$base
for(i in 1:length(len)){
  len[i] <- unlist(strsplit(imp.data$base[i], split = "-"))[[1]]
}
df <- imp.data
len <- as.numeric(len)
df$base <- len
len[,1]
names <- as.character(final$gene)
for(i in 1:length(names)){
  names[i] <- unlist(strsplit(names[i], "-peak"))[[1]]
}
ggplot(df, aes(x = base, y = qual)) + geom_point()
View(df)
install.packages("viridis") # dependency
install.packages("devtools")
devtools::install_github("ropensci/plotly")
library(plotly)
library(shiny)
help("mongo.create")
mongo <- mongo.create()
mongo
## [1] 0
## attr(,"mongo")
## <pointer: 0x58df750>
## attr(,"class")
## [1] "mongo"
## attr(,"host")
## [1] "127.0.0.1"
## attr(,"name")
## [1] ""
## attr(,"username")
## [1] ""
## attr(,"password")
## [1] ""
## attr(,"db")
## [1] "admin"
## attr(,"timeout")
## [1] 0
mongo <- mongo.create()
if(mongo.is.connected(mongo) == TRUE) {
  mongo.get.databases(mongo)
}
print(mongo.get.databases(mongo))
print(mongo.get.database.collections(mongo, 'healthhack'))
db <- mongo.get.database.collections(mongo, 'healthhack')
mongo.get.database.collections(mongo, "healthhack")
if(mongo.is.connected(mongo) == TRUE) {
  db <- "healthhack"
  mongo.get.database.collections(mongo, db)
}
coll.tc <- "healthhack.testcoverage"
coll.qc <- "healthhack.test_qc"
if(mongo.is.connected(mongo) == TRUE) {
  help("mongo.count")
  mongo.count(mongo, coll.tc)
}
mongo.count(mongo, coll.qc)
test <- mongo.find.one(mongo, "healthhack.qc")
mongo.bson.to.list(mongo, coll.qc)
res <- mongo.distinct(mongo, coll.tc, "coverage")
head(res, 2)
all.qual <- mongo.distinct(mongo, coll.qc, "quality")
hist(all.qual)
all.qual <- mongo.bson.to.list(all.qual)
head(all.qual)
summary(all.qual)
uid <- mongo.distinct(mongo, coll.qc, "_id")
uid <- as.data.frame(uid)
uid <- as.vector(uid)
class(uid)
uid <- t(uid)
base <- mongo.distinct(mongo, coll.qc, "base")
base
class(base)
length(base)
length(all.qual) / length(base)

if(mongo.is.connected(mongo) == TRUE) {
  mongo.get.databases(mongo)
}


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
