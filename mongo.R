library(rmongodb)
query <- mongo.bson.from.list(list('city' = 'COLORADO CITY'))
mongo <- mongo.create()
mongo.get.databases(mongo)

mongo.get.database.collections(mongo, db)
db <-  "healthhack"

res <- mongo.distinct(mongo, "healthhack.test_qc" , "uid")

test2 <- mongo.find.all(mongo,  "healthhack.test_qc", list('uid' = "sdat89"))

pops1 <- mongo.find.all(mongo, "healthhack.test_qc", query = list('uid'  = "sdat89", "quality" = list('$gte' = 32)))

test_qc <- mongo.find.all(mongo, "healthhack.test_qc")
