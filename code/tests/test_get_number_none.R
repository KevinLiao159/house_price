library(testthat)

source("../function/util.R")


context("Test for get_number_none() function")

test_that("get_number_none() works as expected", {
  
  vec <- c(1, 1, 1, "None", 1, "None", 1, 1)
  
  expect_equal(mse(fitted_value, true_value), mean((fitted_value - true_value)^2))
  expect_type(mse(fitted_value, true_value), 'double')
  expect_length(mse(fitted_value, true_value), 1)
})

