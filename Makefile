STYLE-PATH= ${HOME}/Library/texmf/tex/latex/
LANGSCI-PATH=~/Documents/Dienstlich/Projekte/LangSci/Git-HUB/latex/


all: germanisch.pdf


SOURCE=/Users/stefan/Documents/Dienstlich/Bibliographien/biblio.bib $(wildcard *.tex chapters/*.tex)

.SUFFIXES: .tex


# for Stefan. Uses memoize.
germanisch.pdf: germanisch.tex $(SOURCE)
	lualatex -shell-escape -no-pdf germanisch |grep -v math
	biber germanisch
	lualatex -shell-escape -no-pdf germanisch |grep -v math
	biber germanisch
	lualatex germanisch -shell-escape -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
	correct-toappear
	correct-index
	sed -i.backup s/.*\\emph.*// germanisch.adx #remove titles which biblatex puts into the name index
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' germanisch.sdx # ordering of references to footnotes
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' germanisch.adx
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' germanisch.ldx
	sed -i.backup 's/\\MakeCapital //g' germanisch.adx
	python3 fixindex.py a germanisch
	mv germanischmod.adx germanisch.adx
	sed -i.backup 's/\\MakeCapital //g' germanisch.adx
	footnotes-index.pl germanisch.ldx
	footnotes-index.pl germanisch.sdx
	footnotes-index.pl germanisch.adx 
	makeindex -o germanisch.and germanisch.adx
	makeindex -gs index.format -o germanisch.lnd germanisch.ldx
	makeindex -gs index.format -o germanisch.snd germanisch.sdx 
	lualatex -shell-escape germanisch | egrep -v 'math|PDFDocEncod|\\mark' |egrep 'Warning|label'



#	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.adx
#	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.ldx
#	sed -i.backup 's/\\protect \\active@dq \\dq@prtct {=}/"=/g' *.adx
#	sed -i.backup 's/{\\O }/Oe/' *.adx
#	python3 fixindex.py

# for Sebastian and overleaf. Does not use memoize
main.pdf: main.tex $(SOURCE)
	lualatex -shell-escape -no-pdf main |grep -v math
	biber main
	lualatex -shell-escape -no-pdf main |grep -v math
	biber main
	lualatex main -shell-escape -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
	correct-toappear
	correct-index
	sed -i.backup s/.*\\emph.*// main.adx #remove titles which biblatex puts into the name index
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.sdx # ordering of references to footnotes
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.adx
# sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.ldx
	sed -i.backup 's/\\MakeCapital //g' main.adx
	python3 fixindex.py a main
	mv mainmod.adx main.adx
	sed -i.backup 's/\\MakeCapital //g' main.adx
	footnotes-index.pl main.ldx
	footnotes-index.pl main.sdx
	footnotes-index.pl main.adx 
	makeindex -o main.and main.adx
	makeindex -gs index.format -o main.lnd main.ldx
	makeindex -gs index.format -o main.snd main.sdx 
	lualatex -shell-escape main | egrep -v 'math|PDFDocEncod|\\mark' |egrep 'Warning|label'



# just for quick comile and checking
index: germanisch.tex $(SOURCE)
	lualatex germanisch -shell-escape -no-pdf 
	footnotes-index.pl germanisch.ldx
	footnotes-index.pl germanisch.sdx
	footnotes-index.pl germanisch.adx 
	makeindex -o germanisch.and germanisch.adx
	makeindex -gs index.format -o germanisch.lnd germanisch.ldx
	makeindex -gs index.format -o germanisch.snd germanisch.sdx 
	lualatex -shell-escape germanisch | egrep -v 'math|PDFDocEncod|\\mark' |egrep 'Warning|label'


# http://stackoverflow.com/questions/10934456/imagemagick-pdf-to-jpgs-sometimes-results-in-black-background
cover: germanisch.pdf
	convert $<\[0\] -resize 486x -background white -alpha remove -bordercolor black -border 2  cover.png


# fuer Sprachenindex
#	makeindex -gs index.format -o $*.lnd $*.ldx


lsp-styles:
	rsync -a $(LSP-STYLES) LSP/




public: germanisch.pdf
	cp $? /Users/stefan/public_html/Pub/


commit:
	svn commit -m "published version to the web"

forest-commit:
	git add germanisch.for.dir/*.pdf
	git commit -m "forest trees" germanisch.for.dir/*.pdf germanisch.for
	git push -u origin


/Users/stefan/public_html/Pub/germanisch.pdf: main.pdf
	cp -p $?                      /Users/stefan/public_html/Pub/germanisch.pdf


o-public: o-public-lehrbuch 
#commit 
#o-public-bib

o-public-lehrbuch: /Users/stefan/public_html/Pub/germanisch.pdf 
	scp -p $? hpsg.hu-berlin.de:/home/stefan/public_html/Pub/



PUB_FILE=stmue.bib

o-public-bib: $(PUB_FILE)
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/



#-f '(author){%n(author)}{%n(editor)}:{%2d(year)#%s(year)#no-year}'

#$(IN_FILE).dvi
$(PUB_FILE): ../hpsg/make_bib_header ../hpsg/make_bib_html_number  ../hpsg/.bibtool77-no-comments grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux 
	sort -u grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux  >tmp.aux
	bibtool -r ../hpsg/.bibtool77-no-comments  -x tmp.aux -o $(PUB_FILE).tmp
	sed -e 's/-u//g'  $(PUB_FILE).tmp  >$(PUB_FILE).tmp.neu
	../hpsg/make_bib_header
	cat bib_header.txt $(PUB_FILE).tmp.neu > $(PUB_FILE)
	rm $(PUB_FILE).tmp $(PUB_FILE).tmp.neu



# lualatex has to be run two times + biber to get "also printed as ..." right.
germanisch.bib: ../../Bibliographien/biblio.bib $(SOURCE) langsci.dbx bib-creation.tex
	lualatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation 
	biber bib-creation
	lualatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation
	biber --output_format=bibtex --output-resolve-xdata --output-legacy-date bib-creation.bcf -O germanisch_tmp.bib
	biber --tool --configfile=biber-tool.conf --output-field-replace=location:address,journaltitle:journal --output-legacy-date germanisch_tmp.bib -O germanisch.bib


todo-bib.unique.txt: germanisch.bcf
	biber -V germanisch | grep -i warn | sort -uf > todo-bib.unique.txt


languagecandidates:
	ggrep -ohP "(?<=[a-z]|[0-9])(\))?(,)? (\()?[A-Z]['a-zA-Z-]+" chapters/*tex| grep -o  [A-Z].* |sort -u >languagelist.txt

memo-install:
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/nomemoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/xparse-arglist.sty .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memomanager.py .


avm-install:
	cp -fp ~/Documents/Dienstlich/Projekte/LangSci/Git-HUB/langsci-avm/langsci-avm.sty .


install:
	cp -p ${STYLE-PATH}makros.2020.sty styles/
	cp -p ${STYLE-PATH}abbrev.sty    styles/
	cp -p ${STYLE-PATH}mycommands.sty    styles/
	cp -p ${STYLE-PATH}fixcitep.sty  styles/
	cp -p ${STYLE-PATH}eng-date.sty   styles/
	cp -p ${STYLE-PATH}oneline.sty   styles/
	cp -p ${STYLE-PATH}my-theorems.sty   styles/
	cp -p ${STYLE-PATH}Ling/article-ex.sty           styles/
	cp -p ${STYLE-PATH}Ling/merkmalstruktur.sty      styles/
	cp -p ${STYLE-PATH}my-xspace.sty            styles/
	cp -p ${STYLE-PATH}Ling/my-ccg-ohne-colortbl.sty styles/
	cp -p ${STYLE-PATH}Ling/cgloss.sty               styles/
	cp -p ${STYLE-PATH}Ling/jambox.sty               styles/
	cp -p ${LANGSCI-PATH}langsci-forest-setup.sty    .
	cp -p ${STYLE-PATH}Ling/forest.sty               .
	cp -p ${STYLE-PATH}Ling/forest-lib-edges.sty     .
	cp -p ${STYLE-PATH}Ling/forest-lib-linguistics.sty .
	cp -p ${STYLE-PATH}Ling/xparse-arglist.sty .





source: 
	tar chzvf ~/Downloads/germanisch.tgz *.tex styles/*.sty LSP/


clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tpm *.adx *.idx *.ilg *.ind *.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.backup *.mw *.bcf *.lnd *.ldx *.rdx *.sdx *.wdx *.xdv *.run.xml *.aux.copy *.auxlock chapters/*.aux

check-clean:
	rm -f *.bak *~ *.log *.blg complex-draft.dvi


cleanmemo:
	rm -f *.mmz chapters/*.mmz germanisch.memo.dir/*

realclean: clean
#	rm -f *.dvi *.ps *.pdf chapters/*.pdf

brutal-clean: realclean cleanmemo


