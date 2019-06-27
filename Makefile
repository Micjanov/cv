TEX = pandoc
src = details.yml
FLAGS = --pdf-engine xelatex --template template.tex

CV-Amin-Kasrou-Aouam.pdf : $(src)
	$(TEX) $(src) -o $@ $(FLAGS)

.PHONY: clean
clean :
	rm output.pdf
