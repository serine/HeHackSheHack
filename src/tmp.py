#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

import sys, gzip, os
from pymongo import MongoClient

connection = MongoClient("mongodb://146.118.98.44:27017")
db_collection_coverage = connection.healthhack.qc
#db_collection_coverage = connection.healthhack.testcoverage

f = sys.argv[1]

list_of_files = os.listdir(f)
file_dict = {}

for text_file in list_of_files:
    make_path = os.path.join(f, text_file)
    file_name = text_file.split(".")[0]
    #file_dict[file_name] = {}

    with gzip.open(make_path) as open_file:
        for i in open_file:
            line = i.strip().split("\t")
            chromosome = line[0]
            genename = line[1]
            startpos = int(line[2])
            coverage = [int(i) for i in line[3].split(',')]
    
            content = {'uid':file_name,
                       'startpos':startpos,
                       'chr':chromosome,
                       'genename':genename,
                       'coverage': coverage
                       }

            #print content
            db_collection_coverage.insert(content)
    #break

#if __name__ == "__main__":
#    input_file = sys.argv[1]
#
#    parse(input_file, db_test)
