#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

import sys, gzip, os
from pymongo import MongoClient
#from pymongo import Connection

#--------------------------------------------------
# Set connection up
#--------------------------------------------------
connection = MongoClient("mongodb://146.118.98.44:27017")
#--------------------------------------------------
# Set db collection
#--------------------------------------------------
db = connection.healthhack
#--------------------------------------------------
# Get list of all collections
#--------------------------------------------------
get_collections = db.collection_names()
#db.testcoverage.drop()
#results = db.testcoverage.find()
#results = db.testcoverage.find()
print get_collections
#print get_collections
#print get_collections.count("ZNF496")
#for result in results:
#    print result
