## ---- user config ----

# Set to anything non-empty to suppress most of latex's messaging. To diagnose
# LaTeX errors, you may want to do `make latex_quiet=""` to get verbose output
latex_quiet := true

# Set to anything non-empty to reprocess TeX files every time we make a PDF.
# Otherwise these files will be regenerated only when the source markdown
# changes; in that case, if you change other dependencies (e.g. a
# bibliography), use the -B option to make in order to force regeneration.
always_latexmk := true

# Set to anything non-empty to use xelatex rather than pdflatex. I always do
# this in order to use system fonts and better Unicode support. pdflatex is
# faster, and there are some packages with which xelatex is incompatible.
xelatex := true

# list of markdown files that are not to be made into PDFs
EXCLUDE :=

# Extra options to pandoc (e.g. "-H mypreamble.tex")
PANDOC_OPTIONS :=

## ---- special external file ----

# Normally this does not need to be changed:
# works if the template is local or in ~/.pandoc/templates
PANDOC_TMPL := assets/one-column.tex

## ---- subdirectories (normally, no need to change) ----

# temporary file subdirectory; will be removed after every latex run
TEMP_DIR := tmp

# name of output directory for .pdf files
OUT_DIR := output
# name of input directory for .yml and .latex files
IN_DIR := input

## ---- commands ----

# Change these only to really change the behavior of the whole setup

PANDOC := pandoc --template $(PANDOC_TMPL) $(PANDOC_OPTIONS)

LATEXMK := latexmk $(if $(xelatex),-xelatex,-pdflatex="pdflatex %O %S") \
	$(if $(latex_quiet),-silent,-verbose)

## ---- build rules ----

ymls := $(filter-out $(addprefix $(IN_DIR)/,$(EXCLUDE)),$(wildcard $(IN_DIR)/*.yml))
pdfs_path := $(filter-out $(addprefix $(OUT_DIR)/,$(EXCLUDE)),$(wildcard $(OUT_DIR)/*.pdf))
texs := $(patsubst %.yml,%.tex,$(ymls))
pdfs := $(patsubst %.yml,%.pdf,$(ymls))
bibs := $(wildcard $(IN_DIR)/*.bib)

$(texs): %.tex: %.yml $(bibs) $(PANDOC_TMPL)
	$(PANDOC) -o $@ $<

.PHONY: all clean

$(pdfs): %.pdf: %.tex
	@echo $(bibs)
	$(LATEXMK) $<

all: $(pdfs) clean

# clean up everything except final pdfs
clean:
	latexmk -c .

.DEFAULT_GOAL := all
