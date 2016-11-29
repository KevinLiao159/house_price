# Declare the variables for folders and files
D = data
rawD = data/rawData
cleanD = data/cleanedData
C = code
S = code/scripts
T = code/tests
R = report
ST = report/sections/*.Rmd

# Declare PHONY targets
.PHONY: all data tests eda pre ols ridge lasso pcr plsr regressions post report slides session clean

all: eda regressions report

data:
	curl -o $(rawD)/train.csv "https://www.kaggle.com/c/house-prices-advanced-regression-techniques/download/train.csv"
	curl -o $(rawD)/test.csv "https://www.kaggle.com/c/house-prices-advanced-regression-techniques/download/test.csv"

tests: $(T)/test-evaluation.R
	cd $(T) && Rscript test-evaluation.R

eda: $(S)/eda-script.R
	cd $(S) && Rscript eda-script.R

# ------------------------------------------------------------------------------------------
# Data Preprocessing
# ------------------------------------------------------------------------------------------
pre: $(S)/preprocess.R
	cd $(S) && Rscript preprocess.R

# ------------------------------------------------------------------------------------------
# Run regression models
# ------------------------------------------------------------------------------------------
ols: $(S)/ols.R pre
	cd $(S) && Rscript ols.R

ridge: $(S)/ridge.R pre
	cd $(S) && Rscript ridge.R

lasso: $(S)/lasso.R pre
	cd $(S) && Rscript lasso.R

pcr: $(S)/pcr.R pre
	cd $(S) && Rscript pcr.R

plsr: $(S)/plsr.R pre
	cd $(S) && Rscript plsr.R

regressions:
	make ols
	make ridge
	make lasso
	make pcr
	make plsr

# ------------------------------------------------------------------------------------------
# Data Postprocessing
# ------------------------------------------------------------------------------------------
post: $(S)/postprocess.R
	cd $(S) && Rscript postprocess.R

# ------------------------------------------------------------------------------------------
# Generate report
# ------------------------------------------------------------------------------------------
report: $(ST) post
	cat $(ST) > $(R)/report.Rmd
	cd $(R); Rscript -e "library(rmarkdown); render('report.Rmd', 'pdf_document')"

# ------------------------------------------------------------------------------------------
# Generate slides
# ------------------------------------------------------------------------------------------
slides: slides/slides.Rmd
	cd slides; Rscript -e 'library(rmarkdown); render("slides.Rmd")'

# ------------------------------------------------------------------------------------------
# Generate session information
# ------------------------------------------------------------------------------------------
session: $(S)/session-info-script.R
	cd $(S) && Rscript session-info-script.R

clean: 
	cd $(R) && rm -f report.pdf
