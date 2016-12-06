library(testthat)

source("../function/util.R")

context("Test for get_rmse() function")

test_that("get_rmse() works as expected", {
  
  pred <- sample(x = 0 : 10, size = 10, replace = T) 
  real <- rnorm(10, mean = 5, sd = 5)
  
  expect_equal(get_rmse(pred, real), sqrt(mean((pred - real) ** 2)))
  expect_type(get_rmse(pred, real), 'double')
  expect_length(get_rmse(pred, real), 1)
})

