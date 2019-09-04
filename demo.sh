#!/usr/bin/env bash
# demo.sh: template for a Bash command-line interface
set -eo pipefail

print_usage()
{
  cat <<EOF
Usage: demo.sh [options] data.txt
  Options:
    -f    apply strict filtering
    -h    show this help message and exit
    -o    file to which output will be written; default is terminal (stdout)
    -s    strand to search; provide a positive number for the forward strand,
          a negative number for the reverse strand, or 0 for both strands;
          default is 0
    -w    user-defined weight; default is 0.9
EOF
}

FILTER=0
STRAND=0
WEIGHT=0.9
while getopts "fho:s:w:" OPTION
do
  case $OPTION in
    f)
      FILTER=1
      ;;
    h)
      print_usage
      exit 0
      ;;
    o)
      OUTFILE=$OPTARG
      ;;
    s)
      STRAND=$OPTARG
      ;;
    w)
      WEIGHT=$OPTARG
      ;;
  esac
done
shift $((OPTIND-1))
INFILE=$1

# process your input here;
# shell scripts aren't typically used to process files line-by-line;
# rather, they call system commands that in turn do the line-by-line processing;
# if your bash script needs to accept input from stdin, you can use the system
# file '/dev/stdin' to redirect the contents of the stdin to other commands
