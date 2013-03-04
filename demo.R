#!/usr/bin/env Rscript
# demo.R: template for parsing command-line options in R
library('getopt');

print_usage <- function(file=stderr())
{
  cat("Usage: demo.R [options] --in data.txt
  Options:
    -f|--filter          apply strict filtering
    -h|--help            print this help message and exit
    -o|--out: FILE       file to which output will be written;
                         default is terminal (stdout)
    -s|--strand: INT     strand to search; provide a positive number for the
                         forward strand, a negative number for the reverse
                         strand, or 0 for both strands; default is 0
    -w|--weight: REAL    user-defined weight; default is 0.9\n")
}

spec = matrix(
  c(
    "filter", 'f', 0, "logical",
    "help",   'h', 0, "logical",
    "in",     'i', 1, "character",
    "out",    'o', 1, "character",
    "strand", 's', 1, "integer",
    "weight", 'w', 1, "double"
  ),
  byrow=TRUE, ncol=4
);
opt = getopt(spec);
if( !is.null(opt$help) )
{
  print_usage(file=stdout());
  q(status=1);
}
if( is.null(opt$in) )     { opt$in     = "/dev/stdin" }
if( is.null(opt$strand) ) { opt$strand = 0 }
if( is.null(opt$weight) ) { opt$weight = 0.9 }

opt.outstream <- stdout()
if( !is.null(opt$out) )
{
  opt.outstream <- tryCatch(
    file(opt$out, "w", blocking=FALSE),
    error = function(e)
    {
      cat(sprintf("error opening output file %s\n", opt$out), file=stderr());
      quit(save="no",status=1)
    }
  )
}

# it is very uncommon to parse input line-by-line in R, so we'll use a common
# import function; if you do want/need to parse input line-by-line, you may want
# to consider whether R is the right tool for the job
data <- read.table(opt$in, header=FALSE, sep=',')

# process your input here
# use opt$out file handle when printing program output

q(save="no", status=0);
