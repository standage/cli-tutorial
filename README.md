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

While scientists use a variety of programming languages in their work, the UNIX command line is the *lingua franca* for coordinating and executing software.
Sometimes used synonymously<sup>1</sup> with the terms *terminal* and *shell*, the term *command line* refers to an interactive interface in which a user issues commands to the computer using lines of text.
Every UNIX operating system comes with a core set of commands for managing the file system and performing simple data manipulation operations.
The behavior of each command can be adjusted by adding to or changing the text following the initial command, and the patterns of text that result in a valid operation are called the command's *user interface* or simply *interface*.
For the most part, UNIX commands adhere to a small number of common user interface conventions, such as printing output to the terminal by default or printing a descriptive help message when the command is followed by the text `--help`.

When writing software, a scientist is supplementing the core UNIX toolkit with scripts and programs of their own.
In the process, they make choices about how they and others will interact with that software: what are the expected inputs and outputs, how should these be formatted, how does one list and adjust settings, etc.
For a scientist making their first foray into programming, these choices will mostly be implicit, whereas a scientist with many years of programming experience might make more explicit and deliberate design decisions.
It is not always necessary or even prudent to invest much time upfront worrying about such design issues, since a large fraction of scientific software is implemented as exploratory prototypes or proofs-of-concept.
But some scripts, programs, and libraries are destined, whether reluctantly or by design, for eventual use and re-use by fellow lab members, collaborators, and other colleagues.
For these tools, user interface design has a substantial impact and warrants deliberate consideration.

It is common for science training programs to invest poorly in computational skills development in general, but this is particularly true when it comes to these kinds of software design concepts.
I am not the first to lament this state of affairs.
An early version of this article [(Standage, 2013)][standage2013] was well received by colleagues and [bioinformatics community forums][biostar2013].
Several months later, [Seeman (2013)][seeman2013] offered ten recommendations for making scientific software "as painless to use as possible."
More recently, command-line interfaces featured prominently in [Taschuk and Wilson's (2017)][taschuk2017] recommendations for making research software more robust.
Here I present an updated, focused, and comprehensive treatment of command line interfaces to address this training gap for scientists.
I discuss how the steps in transitioning a script from a copy-and-paste screen dump to a flexible and reusable utility.
I also provide examples of command line interfaces for several popular programming languages.
The material presented here is suitable as an entry-level introduction for beginners, but provides enough depth that even experienced scientific programmers may benefit.
My goal is not to convince the reader that robust CLIs are needed for every piece of software, but that compromise (when needed) will be a deliberate and informed choice.

- patterns = syntax
- TECHNICAL DEBT


[biostar2013]: https://www.biostars.org/p/65487/
[seeman2013]: https://doi.org/10.1186/2047-217X-2-15
[standage2013]: https://doi.org/10.6084/m9.figshare.643388.v2
[taschuk2017]: https://doi.org/10.1371/journal.pcbi.1005412
