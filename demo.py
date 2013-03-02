#!/usr/bin/env python
# demo.py: template for parsing command-line options in Python
from optparse import OptionParser
import sys

usage = "Usage: demo.py [options] data.txt"
parser = OptionParser(usage=usage)
parser.add_option("-f", "--filter", dest="filter", action="store_true",
    default=False, help="apply strict filtering")
parser.add_option("-o", "--out", dest="outfile", type="string", default=None,
    help="file to which output will be written; default is terminal (stdout)")
parser.add_option("-s", "--strand", dest="strand",  type="int", default=0,
    help="strand to search; provide a positive number for the forward strand, a"
         " negative number for the revers strand, or 0 for both strands;"
         " default is 0")
parser.add_option("-w", "--weight", dest="weight",  type="float", default=0.9,
    help="user-defined weight; default is 0.9")

(options, args) = parser.parse_args()

options.outstream = sys.stdout
if options.outfile != None:
  try:
    options.outstream = open(options.outfile, "w")
  except IOError as e:
    print >> sys.stderr, "error opening output file %s" % options.outfile
    print >> sys.stderr, e
    sys.exit()

options.instream = sys.stdin
if len(args) > 0:
  options.infile = args[0]
  try:
    options.instream = open(options.infile, "r")
  except IOError as e:
    print >> sys.stderr, "error opening output file %s" % options.infile
    print >> sys.stderr, e
    sys.exit()

for line in options.instream:
  line.rstrip()
  # process your input file here
  # use 'options.outstream' file handle when printing program output
  
options.instream.close()
options.outstream.close()