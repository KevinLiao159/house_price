# Declare the variables for folders and files
rawD = data/rawData
cleanD = data/cleanedData
M = code/script/model
S = code/script
T = code/test
R = report

# Declare PHONY targets
.PHONY: all eda test gbm lasso pca ridge randomforest svm xgboost regressions analysis report slides shinyApp session clean

all: data pre eda regressions report

data:
	curl -o $(rawD)/train.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/train.csv?sv=2015-12-11&sr=b&sig=ykQkJVuM5PSUEHecOhmOalQprzvBuCqfULPDF%2FtkpRs%3D&se=2016-12-09T03%3A39%3A41Z&sp=r"
	curl -o $(rawD)/test.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/test.csv?sv=2015-12-11&sr=b&sig=jc2ImGkSPjvJlxfXQLUJ6aOcIO6NOMxSVuHdcLdvsCw%3D&se=2016-12-09T03%3A41%3A14Z&sp=r"
	curl -o $(rawD)/sample_submission.csv "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/sample_submission.csv?sv=2015-12-11&sr=b&sig=r67fwegIDRxwV4XLTwGE5P%2BkFNhGANfK88p%2BYPY2fSY%3D&se=2016-12-09T03%3A40%3A39Z&sp=r"
	curl -o $(rawD)/data_description.txt "https://kaggle2.blob.core.windows.net/competitions-data/kaggle/5407/data_description.txt?sv=2015-12-11&sr=b&sig=GKqUEtKm%2FpBprF%2B7UYn48Adm8LBL6cTW1Rs1wZvlBY0%3D&se=2016-12-09T03%3A38%3A26Z&sp=r"

tests: $(T)/test-that.R
	cd $(T) && Rscript test-that.R

# ------------------------------------------------------------------------------------------
# Data Preprocessing and Preparing
# ------------------------------------------------------------------------------------------
pre: $(S)/preprocess.R $(S)/data-preparation.R
	cd $(S) && Rscript preprocess.R;
	cd $(S) && Rscript data-preparation.R

# ------------------------------------------------------------------------------------------
# Exploratory Data Analysis - three parts
# ------------------------------------------------------------------------------------------
eda: $(S)/daniel-eda.R $(S)/lingjie-eda.R $(S)/kevin-eda.R pre
	cd $(S) && Rscript daniel-eda.R && Rscript lingjie-eda.R && Rscript kevin-eda.R

# ------------------------------------------------------------------------------------------
# Run regression models independently
# ------------------------------------------------------------------------------------------
# gbm: $(M)/gbm.R pre
# 	cd $(M) && Rscript gbm.R

# ridge: $(M)/ridge.R pre
# 	cd $(M) && Rscript ridge.R

# lasso: $(M)/lasso.R pre
# 	cd $(M) && Rscript lasso.R

# pca: $(M)/pca.R pre
# 	cd $(M) && Rscript pca.R

# randomforest: $(M)/randomforest.R pre
# 	cd $(M) && Rscript randomforest.R

# regressions:
# 	make gbm 
# 	make lasso 
# 	make pca 
# 	make ridge 
# 	make randomforest

# ------------------------------------------------------------------------------------------
# Generate Analysis
# ------------------------------------------------------------------------------------------
analysis: $(S)/model-analysis.R
	cd $(S) && Rscript model-analysis.R

# ------------------------------------------------------------------------------------------
# Generate report
# ------------------------------------------------------------------------------------------
report: $(R)/report.Rnw
	cd $(R); Rscript -e "library(knitr); knit2pdf('report.Rnw', output = 'report.tex')"

# ------------------------------------------------------------------------------------------
# Generate slides
# ------------------------------------------------------------------------------------------
slides: slides/slides.Rmd
	cd slides; Rscript -e 'library(rmarkdown); render("slides.Rmd")'

# ------------------------------------------------------------------------------------------
# Generate shinyApp
# ------------------------------------------------------------------------------------------
shinyApp: shinyApp
	Rscript -e 'library(methods); shiny::runApp("shinyapp/", launch.browser=TRUE)'

# ------------------------------------------------------------------------------------------
# Generate session information
# ------------------------------------------------------------------------------------------
session: $(S)/session-info-script.R
	cd $(S) && Rscript session-info-script.R

clean: 
	cd $(R) && rm -f report.pdf
