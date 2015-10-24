# -*- coding: utf-8 -*-
"""
Created on Fri Oct 23 21:58:09 2015

@author: jiun
"""

import os
import re
import sys


# main function
# get list of txt.gz files, extract, parse and print to screen
# input main directory
def main():
    dirName = sys.argv[1]
    
    filenames = next(os.walk(dirName))[2]
    for iF in filenames:
        if iF.endswith(".gz"):
            fName = os.path.join(dirName, iF)
            fObj = unzipCoverageFile(fName)
            
            uid = os.path.splitext(os.path.splitext(iF)[0])[0]
            parseLines(fObj, uid)
    

# function to parse coverage text file
# takes in the file object and prints the each coverage value to screen
# in the following format:
# chromosomeName    GeneName    Location    CoverageValue
def parseLines(fileObj, uid):
    
    for line in fileObj:
        bits = re.split("\t", line)
        coverage = re.split(",", re.sub("\n","",bits[3]))
        startPos = int(bits[2])
        endPos = int(startPos) + len(coverage) 
        # seqLen = len(coverage)
        # seqIdx = range(startPos,startPos + seqLen)
        
        
    
        print "{UID: ", uid, ",\nChr: ", bits[0], ",\ngene_name: ", bits[1], ",\nstartPos: ", startPos, ",\nendPos: ", endPos, ",\ncoverage: ", coverage, "}"
        
            

# files are stored in gz format, so unzip and get unique id 
# based on the filename            
def unzipCoverageFile(fileName):
    import gzip
    fileObj = gzip.open(fileName, 'rb')
    
    return fileObj
    
    
if __name__ == '__main__':
  main()
