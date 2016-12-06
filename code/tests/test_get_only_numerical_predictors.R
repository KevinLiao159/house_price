library(testthat)

source("../function/util.R")


context("Test for get_only_numerical_predictors() function")

test_that("get_only_numerical_predictors() works as expected", {
  
  df <- data.frame(a = rep(1, 10),
                   b= rep("word", 10))
  
  expect_equal(get_only_numerical_predictors(df), df$a)
  expect_type(get_number_none(df), 'integer')
  expect_length(get_number_none(df), 10)
}) 

