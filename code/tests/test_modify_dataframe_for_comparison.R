library(testthat)

source("../function/util.R")


context("Test for convert_na_to_factor() function")

test_that("convert_na_to_factor() works as expected", {
  
  df <- data.frame(a = rep(1, 3),
                   b= c(1, NA, 1))
  
  expect_equal(get_only_numerical_predictors(df), df)
  expect_type(get_only_numerical_predictors(df), 'list')
  expect_length(get_only_numerical_predictors(df), 2)
}) 

