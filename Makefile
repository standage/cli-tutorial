tutorial.pdf:	
		pdflatex -shell-escape tutorial
		pdflatex -shell-escape tutorial

clean:		
		rm -f tutorial.aux tutorial.log tutorial.pdf tutorial.toc
