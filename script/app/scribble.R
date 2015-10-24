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
test <- mongo.find.one(mongo, coll.qc)
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
