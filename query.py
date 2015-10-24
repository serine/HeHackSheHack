'''
Does a test query to return coverages around a genome position
'''

from pymongo import MongoClient

connection = MongoClient("mongodb://localhost:27017")

dbcov = connection.healthhack.testcoverage

position = 1004400

results = dbcov.find({"$and": [{"startpos":{"$gte": position-10000}}, {"endpos":{"$lt": position+10000}}]})


for result in results:
    print result


