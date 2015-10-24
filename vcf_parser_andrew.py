#!/usr/bin/env python
from __future__ import print_function
import glob
import sys

"""Grabs the values we want from the vcf file and adds a unique identifier based on the input filename"""
def get_vals (in_file):


  with open(in_file) as f:

      uid = in_file[:-4]
      for line in f:
          split_line = line.strip().split("\t")
          indexes = [0,1,3,4,5]
          cols_i_want = [split_line[x] for x in indexes]
          cols_i_want.append(uid)
          #out = ' '.join(cols_i_want)
          print("{","uid:", cols_i_want[5], "chr:",cols_i_want[0], "pos:", cols_i_want[1], "variant:{","std", cols_i_want[2], "var", cols_i_want[3], "qual", cols_i_want[4], "}}")

if __name__ == "__main__":
  path = "*.vcf"

  for fname in glob.glob(path):

    get_vals (fname)