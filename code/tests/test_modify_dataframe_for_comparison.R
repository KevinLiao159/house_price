library(testthat)

source("../function/util.R")
load('../../data/cleanedData/ddata_train_validation.matrix.RData')

context("Test for modify_dataframe_for_comparison() function")

test_that("modify_dataframe_for_comparison() works as expected", {
  
  vec <- rep(1,224)

  expect_type(modify_dataframe_for_comparison(vec, "a"), 'list')
  expect_length(modify_dataframe_for_comparison(vec, "a"), 5)
}) 



