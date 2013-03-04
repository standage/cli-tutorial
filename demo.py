#!/usr/bin/env python
# demo.py: template for parsing command-line options in Python
import getopt
import sys

def print_usage(outstream):
  usage = ("Usage: demo.py [options] data.txt\n"
           "  Options:\n"
           "    -f|--filter          apply strict filtering\n"
           "    -h|--help            print this help message and exit\n"
           "    -o|--out: FILE       file to which output will be written;\n"
           "                         default is terminal (stdout)\n"
           "    -s|--strand: INT     strand to search; provide a positive number for the\n"
           "                         forward strand, a negative number for the reverse\n"
           "                         strand, or 0 for both strands; default is 0\n"
           "    -w|--weight: REAL    user-defined weight; default is 0.9")
  print >> outstream, usage

# Option defaults
dofilter = False
infile = None
instream = sys.stdin
outfile = None
outstream = sys.stdout
strand = 0
weight = 0.9

# Parse options
optstr   = "fho:s:w:"
longopts = ["filter", "help", "out=", "strand=", "weight="]
(options, args) = getopt.getopt(sys.argv[1:], optstr, longopts)
for key, value in options:
  if key in ("-f", "--filter"):
    dofilter = True
  elif key in ("-h", "--help"):
    print_usage(sys.stdout)
    sys.exit(0)
  elif key in ("-o", "--out"):
    outfile = value
    try:
      outstream = open(outfile, "w")
    except IOError as e:
      print >> sys.stderr, "error opening output file %s" % options.outfile
      print >> sys.stderr, e
      sys.exit(1)
  elif key in ("-s", "--strand"):
    strand = int(value)
  elif key in ("-w", "--weight"):
    weight = float(value)
  else:
    assert False, "unsupported option '%s'" % key

if len(args) > 0:
  infile = args[0]
  try:
    instream = open(infile, "r")
  except IOError as e:
    print >> sys.stderr, "error opening input file %s" % infile
    print >> sys.stderr, e
    sys.exit(1)

for line in instream:
  line.rstrip()
  # process your input file here
  # use 'outstream' file handle when printing program output
  
instream.close()
outstream.close()
