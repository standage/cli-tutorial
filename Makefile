tutorial.pdf:	demo.c demo.pl demo.py demo.R demo.sh
		perl load-source.pl < tutorial-sanscode.tex > tutorial.tex
		pdflatex -shell-escape tutorial
		pdflatex -shell-escape tutorial

clean:		
		rm -f tutorial.tex tutorial.aux tutorial.log tutorial.pdf tutorial.toc
