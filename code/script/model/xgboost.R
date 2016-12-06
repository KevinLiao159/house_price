library(xgboost)

run_xgboost <- function(train_x, train_y, version) {
  # dir.create(paste0("model/xgboost_", version))
  set.seed(11)
  nround.cv = 2500
  nfold = 11
  
  # train.x <- select(data.train, -SalePrice)
  
  train.dummifier = data.train
  test.dummifier = data.test
  
  
  
  # write.csv(train.x.dummified[, -x], "train_x2.csv", row.names = F)
  # write.csv(test.x.dummifier, "test_x.csv", row.names = F)
  # 
  # write.csv(train.y, "train_y.csv", row.names = F)
  # write.csv(train.y, "train_y.csv", row.names = F)
  # 
  param <- list("objective" = "reg:linear",    # multiclass classification 
                "eval_metric" = "rmse",    # evaluation metric 
                "nthread" = 7,   # number of threads to be used 
                "max_depth" = 5,    # maximum depth of tree 
                "lambda_bias" = 1,
                "eta" = 0.005
  )
  bst_pre.cv <- xgb.cv(param=param, data= as.matrix(train.dummifier), label= as.matrix(train.y), nfold= nfold, nrounds=nround.cv, prediction=TRUE, verbose=TRUE)
  min.rmse.idx = which.min(bst_pre.cv$dt[, test.rmse.mean]) 
  
  plot(1:2500, bst_pre.cv$dt[, test.rmse.mean], type = 'l')
  lines(1:2500, bst_pre.cv$dt[, train.rmse.mean], col="green")
  
  model.xgb <- xgboost(param=param, data= as.matrix(train.x.dummified), label= as.matrix(train.y), nfold= nfold, nrounds = min.rmse.idx, verbose = TRUE, prediction = TRUE)
  
  
  result = exp(predict(model.xgb, test.x.dummifier))
  data.sample$SalePrice = result
  write.csv(data.sample, "fifth_submission_xgboost.csv", row.names = FALSE)
  
}

