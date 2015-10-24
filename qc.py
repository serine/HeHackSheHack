import sys
import os
import re
from pymongo import MongoClient


def main():
	
	db = connecttomongo()
	#enter the directory where the files are stored
	working_dir = sys.argv[1]
	all_files = os.listdir(working_dir)
	#open a file in the dir	
	a_dict = {}
	for sf in all_files:
		if sf.endswith('-0.txt'):
			of = open(working_dir+'/'+sf, 'r')
			#reading whole file
			x=of.read()
			#defining the uid to correlate with coverage and variant data
			uid = os.path.splitext(sf)[0]
			uid = re.sub("qc","sdat", re.split("-", uid)[0])
			#add uid to dict
			a_dict['uid']=uid

			#select the area of txt to grab
			y = [m.start() for m in re.finditer('>>END_MODULE', x)] # search x for >>END_MODULE assign to y - this returnsa list of indices whaich can be used to select data
			text = x[y[0]:y[1]] #select the first block of >>END_MODULES
			lines = text.split('\n') 
			base_list = []
			qc_list =[]
			for x in range(3,len(lines)-1): #don't want the first three lines
				row = lines[x]
				split_row = row.split('\t')
				base_list.append(split_row[0])
                                #qc_list.append(int(split_row[1]))
                                qc_list.append(float(split_row[1]))

	   		a_dict['_id'] = uid
			a_dict['quality'] = qc_list
			a_dict['base'] = base_list
			#print(a_dict)
			insertrecord(db, a_dict)

def insertrecord(db, r):
	db.insert(r)

def connecttomongo():
    #connection = MongoClient("mongodb://localhost:27017")
    connection = MongoClient("mongodb://146.118.98.44:27017")
    db_test = connection.healthhack.test_qc
    return db_test
				
if __name__ == '__main__':
	main()
