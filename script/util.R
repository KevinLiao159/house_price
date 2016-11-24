convert_na_to_factor = function(data) {
  
  
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
      
      selected_pred[is.na(selected_pred)] = -1
      data[, pred] = selected_pred
    }
    
  }
  return(data)
  
  
}

get_only_numerical_predictors = function(data) {
  
  
  
  
  tmp = NULL
  
  for (predictor in colnames(data)){
    pred = eval(quote(predictor))
    predictor = data[, pred]
    if (is.numeric(predictor)) {

      tmp = c(tmp, pred)

    }

  }
  data[, eval(quote(tmp))]
}

get_number_none = function(data) {
  number_of_nones = apply(data, 1, function(x) {
    sum(x == 'None')
  })
  
  return(number_of_nones)
}

make_submission_form = function(model, data.test) {
  data.test$SalePrice = NULL
  result = exp(predict(model.gbm, data.test))
  data.sample$SalePrice = result
  write.csv(data.sample, "first_submission.csv", row.names = FALSE)
}

