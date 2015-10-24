#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-
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
    break                                                                                                           
                                                                                                                    
                                                                                                                    
track = 'track'                                                                                                     
file_type = 'type=wiggle_0'                                                                                         
name = 'name = %s'                                                                                                  
description = 'description = %s'                                                                                    
step = 'variableStep'                                                                                               
span = 'span=1'                                                                                                     
chname = None                                                                                                       
ch = 'chrom=%s'                                                                                                     
                                                                                                                    
first_line = [track, file_type, name]                                                                               
chline = [step, "chrom=%s", span]                                                                                   
                                                                                                                    
for k,v in file_dict.items():                                                                                       
    for a,b in v["chrY"].items():                                                                                   
        check = [item for sublist in b for item in sublist]                                                         
        for q,c in check:                                                                                           
            print k, a, q, c 
