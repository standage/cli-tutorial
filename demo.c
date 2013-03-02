// demo.c: template for parsing command-line options in C
// compile with 'gcc -Wall -o demo demo.c'
#import <getopt.h>
#import <stdio.h>
#import <stdlib.h>

typedef int bool;
#define true 1
#define false 0
#define MAX_LINE_WIDTH 1024

void print_usage(FILE *outstream)
{
  fprintf( outstream,
"Usage: demo [options] data.txt\n"
"  Options:\n"
"    -f|--filter          apply strict filtering\n"
"    -h|--help            print this help message and exit\n"
"    -o|--out: FILE       file to which output will be written;\n"
"                         default is terminal (stdout)\n"
"    -s|--strand: INT     strand to search; provide a positive number for the\n"
"                         forward strand, a negative number for the reverse\n"
"                         strand, or 0 for both strands; default is 0\n"
"    -w|--weight: REAL    user-defined weight; default is 0.9\n" );
}

int main(int argc, char **argv)
{
  bool filter = false;
  const char *outfile = NULL;
  FILE *outstream = stdout;
  int strand = 0;
  float weight = 0.9;
  
  int opt = 0;
  int optindex = 0;
  const char *optstr = "fho:s:w:";
  const struct option demo_options[] =
  {
    { "filter", no_argument,       NULL, 'f' },
    { "help",   no_argument,       NULL, 'h' },
    { "out",    required_argument, NULL, 'o' },
    { "strand", required_argument, NULL, 's' },
    { "weight", required_argument, NULL, 'w' },
    { NULL, no_argument, NULL, 0 },
  };
  
  for( opt = getopt_long(argc, argv, optstr, demo_options, &optindex);
       opt != -1;
       opt = getopt_long(argc, argv, optstr, demo_options, &optindex) )
  {
    switch(opt)
    {
      case 'f':
        filter = true;
        break;
      
      case 'h':
        print_usage(stdout);
        return 0;
        break;
      
      case 'o':
        outfile = optarg;
        outstream = fopen(outfile, "w");
        if(outstream == NULL)
        {
          fprintf(stderr, "error opening output file '%s'\n", outfile);
          return 1;
        }
        break;
      
      case 's':
        strand = atoi(optarg);
        break;
      
      case 'w':
        weight = atof(optarg);
        break;
      
      default:
        break;
    }
  }

  int numargs = argc - optind;
  const char *infile = NULL;
  FILE *instream = stdin;
  if(numargs > 0)
  {
    infile = argv[optind];
    instream = fopen(infile, "r");
    if(instream == NULL)
    {
      fprintf(stderr, "error opening input file '%s'\n", infile);
      return 1;
    }
  }
  
  char buffer[MAX_LINE_WIDTH];
  while(fgets(buffer, MAX_LINE_WIDTH, instream) != NULL)
  {
    // process your input here
    // use 'outstream' file handle when printing program output
  }
  fclose(instream);
  fclose(outstream);
  
  return 0;
}
