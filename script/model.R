
library(glmnet)

library(xgboost)

data.train <- filter(data.all, data_type == "train")
data.train$SalePrice = log(data.train$SalePrice)
data.train$data_type = NULL


data.test <- filter(data.all, data_type == "test")
data.test$data_type = NULL

gbmGrid <-  expand.grid(interaction.depth = c(1, 3, 6),
                        n.trees = c(1,3,5 , 6, 7,10)*50, 
                        shrinkage = seq(.0005, .05),
                        n.minobsinnode = 10) # you can also put something        like c(5, 10, 15, 20)


model.gbm <- train(SalePrice ~., data =  select(data.train, -cluster_dist, -cluster, -LotArea_log, -GrLivArea_log) , method = 'gbm', tuneGrid = gbmGrid)


model.lasso <- train(SalePrice ~., data =  train.x.dummified, method = 'lasso')
model.rf <- train(SalePrice ~., data =  data.train, method = 'rf')


varImp(model.gbm)

run_xgboost <- function(train_x, train_y, version) {
  # dir.create(paste0("model/xgboost_", version))
  set.seed(11)
  nround.cv = 2500
  nfold = 11
  
  # train.x <- select(data.train, -SalePrice)
  
  train.dummifier = dummyVars(~., data = data.train)
  test.dummifier = dummyVars(~., data = data.test)
  
  train.x.dummified = predict(train.dummifier, data.train)
  test.x.dummifier = predict(test.dummifier, data.test)
  
  
  
  param <- list("objective" = "reg:linear",    # multiclass classification 
                "eval_metric" = "rmse",    # evaluation metric 
                "nthread" = 7,   # number of threads to be used 
                "max_depth" = 11,    # maximum depth of tree 
                "lambda" = 1,
                "eta" = 0.005
  )
  bst_pre.cv <- xgb.cv(param=param, data= as.matrix(train.x.dummified), label= as.matrix(train.y), nfold= nfold, nrounds=nround.cv, prediction=TRUE, verbose=TRUE)
  min.rmse.idx = which.min(bst_pre.cv$dt[, test.rmse.mean]) 
  
  plot(1:2500, bst_pre.cv$dt[, test.rmse.mean], type = 'l')
  lines(1:2500, bst_pre.cv$dt[, train.rmse.mean], col="green")
  
  model.xgb <- xgboost(param=param, data= as.matrix(train.x.dummified), label= as.matrix(train.y), nfold= nfold, nrounds = min.rmse.idx, verbose = TRUE, prediction = TRUE)
  

  result = exp(predict(model.xgb, test.x.dummifier))
  data.sample$SalePrice = result
  write.csv(data.sample, "fifth_submission_xgboost.csv", row.names = FALSE)

}


# linear model

model.lasso = train(SalePrice ~., data = as.data.frame(train.x.dummified), method = 'lasso')

