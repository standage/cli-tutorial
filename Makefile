tutorial.pdf:	
		pdflatex -shell-escape tutorial
		pdflatex -shell-escape tutorial

clean:		
		rm tutorial.aux tutorial.log tutorial.pdf tutorial.toc
