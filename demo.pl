#!/usr/bin/env perl
# demo.pl: template for parsing command-line options in Perl
use strict;
use Getopt::Long;

sub print_usage
{
  my $OUT = shift(@_);
  print $OUT "Usage: demo.pl [options] data.txt
  Options:
    -f|--filter          apply strict filtering
    -h|--help            print this help message and exit
    -o|--out: FILE       file to which output will be written;
                         default is terminal (stdout)
    -s|--strand: INT     strand to search; provide a positive number for the
                         forward strand, a negative number for the reverse
                         strand, or 0 for both strands; default is 0
    -w|--weight: REAL    user-defined weight; default is 0.9
"
}

my $filter    = 0;
my $outfile   = "";
my $outstream = \*STDOUT;
my $strand    = 0;
my $weight    = 0.9;
GetOptions
(
  "f|filter"   => \$filter,
  "h|help"     => sub{ print_usage(\*STDOUT); exit(0) },
  "o|out=s"    => \$outfile,
  "s|strand=i" => \$strand,
  "w|weight=f" => \$weight,
);

if($outfile ne "")
{
  open($outstream, ">", $outfile) or die("error opening output file $outfile");
}

my $instream = \*STDIN;
my $infile = "";
if(scalar(@ARGV) > 0)
{
  $infile = shift(@ARGV);
  open($instream, "<", $infile) or die("error opening input file $infile");
}

while(my $line = <$instream>)
{
  chomp($line);
  # process your input here
  # use '$outstream' file handle when printing program output
}
close($instream);
close($outstream);
