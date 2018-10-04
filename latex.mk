DOCUMENTS:=$(patsubst %.tex,%,$(shell grep -Fl documentclass *.tex))
LATEX?=pdflatex
LATEXFLAGS?=--no-shell-escape -file-line-error -halt-on-error
BIBTEX?=bibtex
MAKEGLOSSARIES?=makeglossaries
MAKEINDEX?=makeindex

.PHONY: clean clobber all

all: $(addsuffix .pdf,$(DOCUMENTS))

%.pdf: %.tex $(wildcard *.tex)
	$(LATEX) $(LATEXFLAGS) $*
	grep -q '^\\bibdata{' $*.aux && $(BIBTEX) $(BIBTEXFLAGS) $* || true
	grep -q '\@istfilename' $*.aux && $(MAKEGLOSSARIES) $(MAKEGLOSSARIESFLAGS) $* || true
	[ -f $*.idx ] && $(MAKEINDEX) $(MAKEINDEXFLAGS) $* || true
	$(LATEX) $(LATEXFLAGS) $*
	$(LATEX) $(LATEXFLAGS) $*

clean: $(addprefix clean-,$(DOCUMENTS))
	$(RM) texput.log

clean-%:
	$(RM) $(addprefix $*.,acn acr alg aux bbl blg fmt glg glo gls idx ilg ind ist loa lof log lol lot nav out snm tdo toc vrb)

clobber: clean
	$(RM) -i *.pdf
