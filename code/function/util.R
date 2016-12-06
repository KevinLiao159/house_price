
modify_dataframe_for_comparison <- function(df, model_name) {
  
  df = data.frame(pred = df, y=data.validation.matrix$SalePrice)
  colnames(df) <- c('pred', 'y')
  df$model <- model_name
  df$index <- 1:nrow(df)
  df$residual <- df$y - df$pred
  return(df)
  
}


get_rmse <- function(pred, real) {
  
  return(sqrt(mean((pred - real) ** 2)))
  
}



convert_na_to_factor <- function(data) {
  
  for (predictor in colnames(data)){
    pred = eval(quote(predictor))
    selected_pred = data[, pred]
    if (is.factor(selected_pred)) {
      
      tmp = as.character(selected_pred)
      tmp[is.na(tmp)] = "None"
      tmp = as.factor(tmp)
      data[, pred] = tmp
    }
    if (is.integer(selected_pred)) {
      
      selected_pred[is.na(selected_pred)] = mean(selected_pred, na.rm = TRUE)
      data[, pred] = selected_pred
    }
    
  }
  return(data)
  
  
}


get_only_numerical_predictors <- function(data) {

  tmp = NULL
  
  for (predictor in colnames(data)){
    pred <- eval(quote(predictor))
    predictor <- data[, pred]
    if (is.numeric(predictor)) {

      tmp = c(tmp, pred)

    }

  }
  data[, eval(quote(tmp))]
}



get_number_none <- function(data) {
  
  number_of_nones <- apply(data, 1, function(x) {
    sum(x == 'None')
  })
  
  return(number_of_nones)
}




make_submission_form <- function(model, data.test) {
  data.test$SalePrice <- NULL
  result3 <- exp(predict(model.gbm3, data.test))
  result2 <- exp(predict(model.gbm2, data.test))
  result <- exp(predict(model.gbm, data.test))
  data.sample$SalePrice <- (result * 0.3 + result2 * 0.3+ result3 * 0.4)
  write.csv(data.sample, "tenth_submission.csv", row.names = FALSE)
}

