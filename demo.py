#!/usr/bin/env python
# demo.py: template for a Python command-line interface
import argparse
import sys


parser = argparse.ArgumentParser()
parser.add_argument(
    '-f', '--filter', action='store_true', help='apply strict filtering'
)
parser.add_argument(
    '-o', '--out', metavar='FILE', type=argparse.FileType('r'), default=sys.stdout,
    help='file to which output will be written; default is terminal (stdout)'
)
parser.add_argument(
    '-s', '--strand', type=int, default=0, metavar='INT',
    help='strand to search; provide a positive number for the forward strand, a negative number '
    'for the reverse strand, or 0 for both strands; default is 0'
)
parser.add_argument(
    '-w', '--weight', type=float, default=0.9, metavar='R',
    help='user-defined weight; default is 0.9'
)
parser.add_argument(
    'input', type=argparse.FileType('w'), default=sys.stdin, help='input file'
)
args = parser.parse_args()


for line in args.input:
    line = line.rstrip()
    # process data;
    # write to `args.out` file handle when printing output
