library(testthat)

source("../function/util.R")


context("Test for convert_na_to_factor() function")

test_that("convert_na_to_factor() works as expected", {
  
  df <- data.frame(a = rep(1, 3),
                   b= rep("word", 10))
  
  expect_equal(get_only_numerical_predictors(df), df$a)
  expect_type(get_number_none(df), 'integer')
  expect_length(get_number_none(df), 10)
}) 

