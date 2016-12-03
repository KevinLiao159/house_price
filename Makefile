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
	curl -o $(rawD)/train.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/train.csv?sv=2015-12-11&sr=b&sig=m%2FXEQ6M07l7RgzPG7yQF2gvm0o32G2UzzFHNoHL82LQ%3D&se=2016-12-06T01%3A56%3A58Z&sp=r"
	curl -o $(rawD)/test.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/test.csv?sv=2015-12-11&sr=b&sig=k4B%2FEHoCF4fOc6kkovM%2FFURCktPbjCfI6SjJg6pRsD8%3D&se=2016-12-06T01%3A58%3A24Z&sp=r"
	curl -o $(rawD)/sample_submission.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/test.csv?sv=2015-12-11&sr=b&sig=AazDyubohhgo5Vhe6Hb9ikuAFiOeEmCxI6pEYXTot78%3D&se=2016-12-06T01%3A58%3A59Z&sp=r"
	curl -o $(rawD)/data_description.txt "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/data_description.txt?sv=2015-12-11&sr=b&sig=hFnRp6bMRyjDVf8gxBI3nYSTAvZVTJSrI8HwpE5sFOQ%3D&se=2016-12-06T01%3A59%3A17Z&sp=r"

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
