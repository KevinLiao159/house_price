library(testthat)

source("../function/util.R")

context("Test for modify_dataframe_for_comparison")

test_that("mse() works as expected", {
  
  fitted_value <- sample(x = 0 : 10, size = 10, replace = T) 
  true_value <- rnorm(10, mean = 5, sd = 5)
  
  expect_equal(mse(fitted_value, true_value), mean((fitted_value - true_value)^2))
  expect_type(mse(fitted_value, true_value), 'double')
  expect_length(mse(fitted_value, true_value), 1)
})

