library(testthat)

source("../function/util.R")

context("Test for get_rmse() function")

test_that("get_rmse() works as expected", {
  
  a <- sample(x = 0 : 10, size = 10, replace = T) 
  b <- rnorm(10, mean = 5, sd = 5)
  
  expect_equal(get_rmse(a, b), sqrt(mean((a - b) ** 2)))
  expect_type(get_rmse(a, b), 'double')
  expect_length(get_rmse(a, b), 1)
})

