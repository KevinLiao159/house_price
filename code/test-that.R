# Script to be called from command line to perform unit tests:
# Rscript test-that.R

library(testthat)
load('../data/cleanedData/ddata_train_validation.matrix.RData')


# loading all function files
files <- list.files("function")
for (i in 1:length(files)) {
  source(paste0("function/", files[i]))
}

# run unit tests in folder 'tests/'
test_dir("tests", reporter = "Summary")