import sys
import re
import os
from pymongo import MongoClient

def parse(fname, db):
    with open(fname) as f:
        for line in f:
            fields = re.findall(r'[^	\s]+', line)
            chromosome = fields[0]
            genename = fields[1]
            startpos = int(fields[2])
            coverage = [int(i) for i in fields[3].split(',')]

            uid = (fname.split('/')[-1]).split('.')[0]

            content = {'uid':uid, 'startpos':startpos, 'chr':chromosome, 'genename':genename, 'coverage': coverage}

            #print content
            db.insert(content)

if __name__ == "__main__":
    input_file = sys.argv[1]

    connection = MongoClient("mongodb://146.118.98.44:27017")
    db_test = connection.healthhack.testcoverage

    parse(input_file, db_test)

