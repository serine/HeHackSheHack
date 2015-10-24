#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

import sys, os, gzip

f = sys.argv[1]

list_of_files = os.listdir(f)

list_of_dicts = []

for text_file in list_of_files:
    file_dict = {}
    make_path = os.path.join(f, text_file)
    with gzip.open(make_path, "rb") as open_file:
       for i in open_file:
           line = i.split('\t')
           chr_id = line[0]
           geneId = line[1]
           chroPos = int(line[2])
           coverage = [int(i) for i in line[3].split(",")]
           data_values = zip([chroPos+i for i in range(len(coverage))], coverage)
           #print chr_id, geneId, chroPos, len(coverage), coverage
           if chr_id not in file_dict:
               file_dict[chr_id]={}

           if geneId not in file_dict[chr_id]:
               file_dict[chr_id][geneId] = []
           file_dict[chr_id][geneId].append(data_values)
           #file_dict[chr_id][geneId].append(data_values)
           #print chr_id, geneId, data_values
    break

for k,v in file_dict["chrY"].items():
    print k, len(v)
