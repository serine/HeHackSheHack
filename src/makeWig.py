#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

import sys, os, gzip

f = sys.argv[1]

list_of_files = os.listdir(f)

file_dict = {}

for text_file in list_of_files:
    make_path = os.path.join(f, text_file)
    file_name = text_file.split(".")[0]
    file_dict[file_name] = {}
    with gzip.open(make_path, "rb") as open_file:
       for i in open_file:
           line = i.split('\t')
           chr_id = line[0]
           geneId = line[1]
           chroPos = int(line[2])
           coverage = [int(i) for i in line[3].split(",")]
           data_values = zip([chroPos+i for i in range(len(coverage))], coverage)
           #print chr_id, geneId, chroPos, len(coverage), coverage
           if chr_id not in file_dict[file_name]:
               file_dict[file_name][chr_id]={}

           if geneId not in file_dict[file_name][chr_id]:
               file_dict[file_name][chr_id][geneId] = []
           file_dict[file_name][chr_id][geneId].append(data_values)
           #print chr_id, geneId, data_values
    #break

track = 'track'
file_type = 'type=wiggle_0'
name = 'name=%s'
description = 'description=%s'
step = 'variableStep'
span = 'span=1'
chname = None
ch = 'chrom=%s'

track_header = True
chr_header = True

for file_name, data in file_dict.items():
    wiggle_file = file_name.split(".")[0]+".wig"
    with open(wiggle_file, "w") as out_handler:
        chr_keys = data.keys()
        for chr in chr_keys:
            for gene, values in data[chr].items():
                #print gene, values
                check = [item for sublist in values for item in sublist]
                for position, coverage in check:
                    if chr_header:
                        if track_header:
                            out_handler.write(' '.join((track, file_type, name % file_name, description % file_name, "\n")))
                            #print ' '.join((track, file_type, name % file_name, description % file_name))
                            track_header = False
                        out_handler.write(' '.join((step, ch % chr, span, "\n")))
                        #print ' '.join((step, ch % chr, span))
                        chr_header = False
                    out_handler.write(' '.join((str(position), str(coverage), "\n")))
                    #print ' '.join((str(position), str(coverage)))
            chr_header = True
    #break
