library(testthat)

source("../function/util.R")


context("Test for get_number_none() function")

test_that("get_number_none() works as expected", {
  
  df <- data.frame(a = c(1, 1, 1, "None", 1, "None", 1, 1), 
                   b= c(1, 1, 1, "None", 1, "None", 1, 1))
  
  expect_equal(get_number_none(df), c(0, 0, 0, 2, 0, 2, 0, 0))
  expect_type(get_number_none(df), 'integer')
  expect_length(get_number_none(df), 8)
}) 

