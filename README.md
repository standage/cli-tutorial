# Designing command line interfaces (CLIs) for scientific software

Daniel S. Standage <daniel.standage@gmail.com>  
Copyright &copy; 2013, 2019

This work is released under the Creative Commons CC BY 3.0 license. You are free
to modify, copy, and/or distribute the work so long as you attribute the
original work by including the text of this license and a link to the published
work (http://dx.doi.org/10.6084/m9.figshare.643388) with any copies or
derivative works. By exercising your rights to this work, you agree to be bound
by the terms of the license (full text available at
http://creativecommons.org/licenses/by/3.0/).


## Introduction

While scientists use a variety of programming languages in their work, the UNIX command line is the *lingua franca* for coordinating and executing scientific software.
Sometimes used synonymously<sup>1</sup> with the terms *terminal* and *shell*, the term *command line* refers to an interactive interface through which a user issues commands to the computer using lines of text.
For example, the command `cp -r data/ data-backup/` instructs the computer to copy the contents of the directory `data/` into a new directory named `data-backup/`.
The first element of the command, `cp`, specifies the name of a program to be executed.
This is followed by additional text (*arguments*) specifying the data or file(s) on which the program is to operate.
Sometimes, the command will also include text to adjust the program's default behavior, referred to as *options* or *flags* (such as `-r` in the example above).

Every UNIX operating system comes with a core set of commands for managing the file system and performing common data manipulation operations.
Different commands perform different operations, and thus each command requires a different set of mandatory arguments, and supports a different set of configuration flags.
The order and placement of text required to invoke a command correctly is called the command's *user interface*, or simply *inferface*.
For the most part, UNIX commands adhere to a small number of common user interface conventions, such as printing output to the terminal by default, or printing a descriptive help message when the command is followed by the flag `-h` or `--help`.

When writing software, a scientist is supplementing the core UNIX toolkit with programs of their own.
In the process, they make choices about how they and others will interact with that software: what are the expected inputs and outputs, how should these be formatted, how does one list and adjust settings, and so on.
For a scientist making their first foray into programming, these choices will be mostly implicit.
They are baked into example code borrowed and extended from programming books, blogs, Internet Q&A forums, or former lab members.
On the other hand, a scientist with many years of programming experience might make more explicit and deliberate design decisions.

It is not always necessary or even prudent to invest much time upfront worrying about command-line interface design issues, since a large fraction of scientific software is implemented as exploratory prototypes or proofs-of-concept.
But some scripts, programs, and libraries are destined, whether reluctantly or intentionally, for eventual use and re-use by fellow lab members, collaborators, and other colleagues.
For these tools, user interface design has a substantial impact and warrants intentional consideration.

It is common for science training programs to invest poorly in computational skills development in general, but this is particularly true when it comes to these kinds of software design concepts.
As a result, the interfaces of many scientific software tools are *ad hoc* and impenetrable to an unfamiliar user, leading to many lost hours and considerable frustration.
The present article is not the first to lament this state of affairs.
An early draft of this article [(Standage, 2013)][standage2013] has proven valuable to the author as a teaching and mentoring resource, and was well received by members of [a popular bioinformatics community forum][biostar2013].
Several months later, Torsten Seeman, motivated by the struggles he experienced as a creator of bioinformatics software and a frequent user of research software written by others, offered ten recommendations for making scientific software "as painless to use as possible" for all involved [(Seeman 2013)][seeman2013].
More recently, command line interfaces featured prominently in "Taschuk's Rules" for making research software more robust [(Taschuk & Wilson 2017)][taschuk2017].
Yet despite a growing recognition of the need for software usability training resources for scientists, the best learning materials available to many scientists-turned-programmers are blogs, forums such as StackOverflow, and a pile of Perl scripts from the postdoc that recently left the lab.

Here I present an updated, focused, and comprehensive treatment of command line interfaces (CLIs) to address this critical training gap for scientists.
I discuss how a script might naturally evolve from a copy-and-paste screen dump to a flexible and reusable utility.
I also discuss the concept of technical debt, and how the time investment required to implement well-designed CLIs pays off in the long run.
Finally, I provide example CLIs for several popular programming languages.
This article is written to be accessible as an introduction for beginners with little programming experience, but provides enough depth that even experienced programmers are likely to benefit.

----------

<sup>1</sup>If we want to be precise, the *terminal* refers to the text input/output device file on the computer, and the *shell* refers to a program that interprets user input and launches other programs on the user's behalf.
However, from the perspective of a beginner programmer these subtle distinctions are unimportant.


## A Motivating Example

Imagine that you are conducting pilot study in which you have performed DNA sequencing of four biological samples in triplicate, resulting in 12 total pairs of FASTQ files from the sequencing instrument.
A statistics collaborator has provided an R script to perform some calculations on each sample replicate, stored in a file called `runanalysis.R`.
Once the pilot is complete, you will sequence 64 samples in triplicate for the full study—192 pairs of FASTQ files!

After a week or two of trial and error, with input from colleagues, you are able to successfully process one of the datasets with the following set of commands.

```bash
bwa mem -t 4 refr.fasta sample1a_R1.fastq sample1a_R2.fastq > sample1a.sam
samtools view -S -b -q 10 sample1a.sam > sample1a-unsorted.bam
samtools sort -o sample1a-sorted.bam sample1a-unsorted.bam
samtools index sample1a-sorted.bam
./runanalysis.R sample1a-sorted.bam target-genes.gtf 0.5 report.csv
```

Having successfully tested these commands on sample 1a, you now want to process 1b and 1c, as well as samples 2, 3, and 4.
You quickly realize that re-typing and executing this set of commands 12 times will be tedious, time intensive, and error prone.
Following a tip from one of your colleagues, you copy these commands a file called `process.sh`.
Now, all you have to do to re-run the procedure on each dataset is edit the sample names in `process.sh` and then invoke `bash process.sh` on the command line.
You have undoubtedly saved yourself hours of headache and tedium!


## Your First Program

You have just unwittingly created your first program.
While you may not yet consider yourself a programmer, you have just stored a set of instructions for the computer to execute in a file so you can invoke those instructions over and over again.
That file is a program, and that makes you a programmer!

That said, let's not deceive ourselves about the limitations of this program.
It can only be used to process a single pair of FASTQ files...assuming the files have been placed in the same directory as the script...and assuming that several other scripts and data files are also present in the directory.
If you want to run this program on the other 11 pairs of FASTQ files, you will have to edit it before each time you invoke it.
This is of course an improvement over typing out the commands by hand each time, but it still requires a significant amount of manual intervention from you as a user.
And when it comes to processing the full collection of 192 datasets, this approach simply won't scale.
You'll *definitely* need a script that doesn't require editing each time you run it.


## Flexibility with Arguments

If you want to make your program more flexible, you'll need to edit it so that it has placeholders for input data instead of "hard-coded" file names that need to be edited each time you process a new data set.
In programming parlance these placeholders are called *variables*, and a program's user specifies the contents of each variable using arguments and option flags (more on those soon).

You can make some simple edits to your shell script to take advantage of arguments and make it much more flexible.

```bash
sample=$1
output=$2

bwa mem -t 4 refr.fasta ${sample}_R1.fastq ${sample}_R2.fastq > sample1a.sam
samtools view -S -b -q 10 ${sample}.sam > ${sample}-unsorted.bam
samtools sort -o ${sample}-sorted.bam ${sample}-unsorted.bam
samtools index ${sample}-sorted.bam
./runanalysis.R ${sample}-sorted.bam target-genes.gtf 0.5 ${output}
```

Here, we are creating a variable named `${sample}` and assigning it the value of the first command-line argument (`$1`).
We are creating another variable named `${output}` and assigning it the value of the second command-line argument.
Then, throughout the script, we've replaced `sample1a` with the `${sample}` variable and `report.csv` with the `${output}` variable.

> *__NOTE__: This example is written in Bash, the default shell for most UNIX systems.
> Code to declare variables and parse command line arguments will look different in different programming languages.
> See the Appendix for example CLIs in several popular programming languages.*

With these changes, you can now invoke the program on the command line like so.

```bash
bash process.sh sample1b report1b.csv
```

The benefit is that when it's time to process the next sample, you won't have to modify the script.
You can simply invoke the program again, using a different set of arguments.

```bash
bash process.sh sample1c report1c.csv
```

In fact, if you're feeling *really* ambitious, you can take it a step further—write a loop to start a batch process before you go home on Friday, and have the results for all 12 datasets waiting when you arrive at your desk again on Monday morning.

```bash
for sample in 1 2 3 4; do
    for replicate in a b c; do
        bash process.sh sample${sample}${replicate} report${sample}${replicate}.csv
    done
done
```

Don't worry if this last example is unclear, since batch processing of large datasets is beyond the scope of this document.


## Mandatory & Optional Arguments

Taking another look at the `process.sh` script, there are a couple more values that we could potentially replace with variables: the minimum mapping quality indicated by `-q 10` in the `samtools view` command; and the `0.5` cutoff value provided to the `runanalysis.R` script.
You could use the same approach as before, and replace these values with variable placeholders.
This would require the user to supply 4 arguments rather than 2 when invoking `process.sh` on the command line.
The added flexibility could be helpful if you anticipate that you may need to adjust these parameters to get optimal results for different samples.
On the other hand, if you're going to use the default values 10 and 0.5 most of the time, it would be convenient if you didn't have to explicitly type those out when running the program.

It is common for UNIX programs to distinguish between mandatory and optional arguments.
Optional arguments control aspects of the program's behavior for which a suitable default can be determined.
For example, `samtools view` uses 0 as the minimum mapping quality by default, but adding `-q 10` to the command overrides the default and sets the minimum mapping quality to 10.
In this example, `-q` is the flag and `10` is the argument.
In some cases, optional arguments use a "flag-only" syntax—no argument follows the flag, which acts like a toggle switch.
To continue with the `samtools view` example, the `-b` and `-S` flags operate in this manner, indicating respectively that the input is in SAM format and that the output should be in BAM format.
Changing the order of the `-q 10`, `-S`, and `-b` flags will not change the behavior of the program.

In contrast, mandatory arguments have no preceding flag, and typically correspond to data or settings for which a suitable default cannot be determined.
The number and order of mandatory arguments *does* matter, and is specific to each individual program.
A description of the mandatory and optional arguments—the command line interface or CLI—is customarily communicated in a README file, a help message or usage statment (shown when running the program with the `-h` or `--help` flag), or in a user manual.

> *__NOTE__: Mandatory arguments are sometimes called "positional arguments", since the variable to which they are assigned depends on their position in the argument list.*

Now imagine that you rename your script from `process.sh` to `process` and make it an executable file.

```bash
mv process.sh process   # Rename script
chmod 755 process       # Make it executable
```

Now we would invoke the script like this.

```bash
./process sample2a report2a.csv
```

If you want to run the script with a mapping quality other than 10, or a cutoff value other than 0.5, you would have to edit the contents of the script.
If you update the script to make arguments for these two parameters arguments, you would now run the script like this.

```bash
./process sample2a report2a.csv 12 0.75
```

However, optional arguments are much better suited for these parameters than mandatory arguments.
You've already selected 10 and 0.5 as default values, and you don't want to have to specify these values every time unless you're overriding them.
If you update your script to use optional arguments for mapping quality and cutoff, you can run it like this.

```bash
./process -q 12 -c 0.75 sample2a report2a.csv
```


## Short & Long Options

More info soon.


## Naming Things

- script names
- option names
- variable names


## The Danger of Baked-in Assumptions

- hard-coded file paths
- name/patterns/locations of input files
- creating output files not specified by user (use outdir if necessary)


## Standard Input (stdin) & Standard Output (stdout)

More info soon.


## Usage Statements

More info soon.


## Sandbox

Upon further reflection, you have two additional insights.

- You're unsure how the DNA sequencing facility is going to name the 192 pairs of FASTQ files associated with the main study. You may not be able to rely on the files following the `sample[serialnumber][replicate]_R[end].fastq` that you used for the pilot study. So rather than using the sample name as an argument, you decide it's better to accept two arguments corresponding to the names of the pair of FASTQ files.
- You've also noticed that many UNIX programs print output to the terminal (standard output) by default. You decide this is good default behavior for your script as well, but you add an option to print the output to a user-specified file if provided.

Once these changes have been implemented, you now have the flexibility to run your script in the following ways on the sample 3 replicates.

```bash
# mapping quality: 10; cutoff: 0.5; output: terminal
./process sample3a_R1.fastq sample3a_R2.fastq

# mapping quality: 10; cutoff: 0.8; output: terminal (piped to another program)
./process -c 0.8 sample3a_R1.fastq sample3a_R2.fastq | head -n 5 > sample3a-strict-summary.csv

# mapping quality: 10; cutoff: 0.6; output: sample3a-full-report.csv
./process -c 0.6 -o sample3a-full-report.csv sample3a_R1.fastq sample3a_R2.fastq

# mapping quality: 15; cutoff: 0.5; output: sample3b-report.csv
./process -q 15 -o sample3b-report.csv sample3b_R1.fastq sample3b_R2.fastq

# mapping quality: 12; cutoff: 0.6; output: sample3c-report.csv
./process -q 15 -c 0.6 -o sample3c-report.csv sample3c_R1.fastq sample3c_R2.fastq
```

And finally, you add a usage statement describing the program's CLI so that you will remember how to use it when the remaining sequence data arrives in 3 months.

```
$ ./process -h
Usage: ./process [-c REAL] [-h] [-o FILE] [-q INT] read1 read2

Arguments:
  read1        FASTQ file containing left paired read fragment
  read2        FASTQ file containing right paired read fragment

Options:
  -c REAL      cutoff value between 0.0 and 1.0; default is 0.5
  -h           print this help message and exit
  -o FILE      file to which output will be written; by default, output is
               written to the terminal (standard output)
  -q INT       minimum read mapping quality; default is 10
$ 
```

> *__NOTE__: See the Appendix for the final version of this script.*


[biostar2013]: https://www.biostars.org/p/65487/
[seeman2013]: https://doi.org/10.1186/2047-217X-2-15
[standage2013]: https://doi.org/10.6084/m9.figshare.643388.v2
[taschuk2017]: https://doi.org/10.1371/journal.pcbi.1005412
