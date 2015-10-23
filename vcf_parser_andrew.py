#!/usr/bin/env python
from __future__ import print_function
import sys

"""Grabs the values we want from the vcf file and adds a unique identifier based on the input filename"""
def get_vals (in_file):

  with open(in_file) as f:
      uid = "test"
      for line in f:
          split_line = line.strip().split("\t")
          indexes = [0,1,3,4]
          cols_i_want = [split_line[x] for x in indexes]
          cols_i_want.append(uid)
          out = ' '.join(cols_i_want)
          print(out)

if __name__ == "__main__":
  input_file = sys.argv[1]

  get_vals (input_file)