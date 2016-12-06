# Declare the variables for folders and files
D = data
rawD = data/rawData
cleanD = data/cleanedData
M = code/script/model
S = code/script
T = code/tests
R = report

# Declare PHONY targets
.PHONY: all data tests eda pre gbm lasso pca ridge randomforest svm xgboost regressions report slides session clean

all: eda regressions report

data:
	curl -o $(rawD)/train.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/train.csv?sv=2015-12-11&sr=b&sig=m%2FXEQ6M07l7RgzPG7yQF2gvm0o32G2UzzFHNoHL82LQ%3D&se=2016-12-06T01%3A56%3A58Z&sp=r"
	curl -o $(rawD)/test.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/test.csv?sv=2015-12-11&sr=b&sig=k4B%2FEHoCF4fOc6kkovM%2FFURCktPbjCfI6SjJg6pRsD8%3D&se=2016-12-06T01%3A58%3A24Z&sp=r"
	curl -o $(rawD)/sample_submission.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/test.csv?sv=2015-12-11&sr=b&sig=AazDyubohhgo5Vhe6Hb9ikuAFiOeEmCxI6pEYXTot78%3D&se=2016-12-06T01%3A58%3A59Z&sp=r"
	curl -o $(rawD)/data_description.txt "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/data_description.txt?sv=2015-12-11&sr=b&sig=hFnRp6bMRyjDVf8gxBI3nYSTAvZVTJSrI8HwpE5sFOQ%3D&se=2016-12-06T01%3A59%3A17Z&sp=r"

tests: $(T)/test-evaluation.R
	cd $(T) && Rscript test-evaluation.R

# ------------------------------------------------------------------------------------------
# Exploratory Data Analysis - three parts
# ------------------------------------------------------------------------------------------
eda: $(S)/eda.R $(S)/lingjie-eda.R $(S)/kevin-eda.R
	cd $(S) && Rscript eda.R && Rscript lingjie-eda.R && Rscript kevin-eda.R

# ------------------------------------------------------------------------------------------
# Data Preprocessing
# ------------------------------------------------------------------------------------------
pre: $(S)/preprocess.R $(S)/data_preparation.R
	cd $(S) && Rscript preprocess.R && Rscript data_preparation.R

# ------------------------------------------------------------------------------------------
# Run regression models independently
# ------------------------------------------------------------------------------------------
gbm: $(M)/gbm.R pre
	cd $(M) && Rscript gbm.R

ridge: $(M)/ridge.R pre
	cd $(M) && Rscript ridge.R

lasso: $(M)/lasso.R pre
	cd $(M) && Rscript lasso.R

pca: $(M)/pca.R pre
	cd $(M) && Rscript pca.R

randomforest: $(M)/randomforest.R pre
	cd $(M) && Rscript randomforest.R

regressions:
	make gbm 
	make lasso 
	make pca 
	make ridge 
	make randomforest

# ------------------------------------------------------------------------------------------
# Generate report
# ------------------------------------------------------------------------------------------
report: $(R)/report_final.Rnw
	cd $(R); Rscript -e "library(knitr); knit2pdf('report_final.Rnw', output = 'report_final.tex')"

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
