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


make_submission_form = function(model, data.test) {
  data.test$SalePrice = NULL
  result = exp(predict(model.gbm, data.test))
  data.sample$SalePrice = result
  write.csv(data.sample, "first_submission.csv", row.names = FALSE)
}

