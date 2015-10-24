# -*- coding: utf-8 -*-
"""
Created on Fri Oct 23 21:58:09 2015

@author: jiun
"""

import os
import re
import sys
from pymongo import MongoClient

# main function
# get list of txt.gz files, extract, parse and print to screen
# input main directory
def main():
    dirName = sys.argv[1]
    db = connecttomongo()

    filenames = next(os.walk(dirName))[2]
    for iF in filenames:
        if iF.endswith(".gz"):
            fName = os.path.join(dirName, iF)
            fObj = unzipCoverageFile(fName)
            
            uid = os.path.splitext(os.path.splitext(iF)[0])[0]
            parselines_insert(db, fObj, uid)
    
# function to parse coverage text file
# takes in the file object and prints the each coverage value to screen
# in the following format:
# chromosomeName    GeneName    Location    CoverageValue
def parselines_insert(db, fileObj, uid):
    
    for line in fileObj:
        bits = re.split("\t", line)
        #coverage = re.split(",", re.sub("\n","",bits[3]))
        coverage = [int(i) for i in re.sub("\n", "", bits[3]).split(",")]
        startPos = int(bits[2])
        endPos = int(startPos) + len(coverage) 
        # seqLen = len(coverage)
        # seqIdx = range(startPos,startPos + seqLen)
        
        
        content = {"UID": uid, "chr": bits[0], "genename": bits[1], "startpos": startPos, "endpos": endPos, "coverage": coverage}
       
        #print content # print it
        insertrecord(db, content) # insert it

# files are stored in gz format, so unzip and get unique id 
# based on the filename            
def unzipCoverageFile(fileName):
    import gzip
    fileObj = gzip.open(fileName, 'rb')
    
    return fileObj

def insertrecord(db, r):
    db.insert(r)
    
def connecttomongo():
    #connection = MongoClient("mongodb://localhost:27017")
    connection = MongoClient("mongodb://146.118.98.44:27017")
    db_test = connection.healthhack.testcoverage
    return db_test

if __name__ == '__main__':
  main()
