library(caret)
library(glmnet)
library(xgboost)

# split into train, test matrix
data.train.matrix <- filter(data.all.matrix, data_type == "train")
data.train.matrix$data_type = NULL
data.test.matrix <- filter(data.all.matrix, data_type == "test")
data.test.matrix$data_type = NULL

range(data.train.matrix$SalePrice)

quantile(data.train.matrix$SalePrice, )


data.train.matrix = read.csv("cleanedData/data.train.matrix2.csv")

write.csv(data.train.matrix, "cleanedData/data.train.matrix.csv", row.names = F)
write.csv(data.test.matrix, "cleanedData/data.test.matrix.csv", row.names = F)

# setup fitcontrol
fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)

# param
gbmGrid3 <- expand.grid(interaction.depth = c(1, 3, 5),
                        n.trees = c(4, 5, 6, 7)*50, 
                        shrinkage = c(0.1, 0.2),
                        n.minobsinnode = c(10, 15, 20))

# gbm
model.gbm6<- train(SalePrice ~., data =  data.train.matrix, method = 'gbm', tuneGrid = gbmGrid3)
model.gbm6







data.train <- filter(data.all, data_type == "train")
data.train$SalePrice = log(data.train$SalePrice)
data.train$data_type = NULL


data.test <- filter(data.all, data_type == "test")
data.test$data_type = NULL

gbmGrid3 <- expand.grid(interaction.depth = c(1, 3, 5, 7),
                        n.trees = c(5, 7)*50, 
                        shrinkage = c(0.1, 0.15),
                        n.minobsinnode = c(15, 20, 25)) # you can also put something        like c(5, 10, 15, 20)

fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)

model.gbm3<- train(SalePrice ~., data =  data.train , method = 'gbm', tuneGrid= gbmGrid3, trControl = fitControl)

# model.c5 <- train(SalePrice ~., data =  data.train , method = 'C5.0',trControl = fitControl)
preProcValues <- preProcess(data.train, method = c("center", "scale"))
trainTransformed <- predict(preProcValues, data.train)
model.svmRadial <- train(SalePrice ~., data =  trainTransformed , method = 'svmRadial',trControl = fitControl, tuneLength = 20)
model.svmRadial

set.seed(1000)
grid <- 10 ^ seq(10, -2, length = 100)
model.lasso.lambda <- cv.glmnet(as.matrix(select(data.train, -SalePrice)), as.matrix(data.train$SalePrice), nfolds = 10, intercept = FALSE, lambda = grid, alpha = 1)
model.lasso <- glmnet(as.matrix(select(data.train, -SalePrice)), as.matrix(data.train$SalePrice), alpha = 1, lambda = model.lasso.lambda$lambda.min)

model.lasso.pred <- predict(model.lasso,newx= as.matrix(select(credit.test, -Balance)),type="response",s= model.lasso.lambda.min)

model.imp1 = as.data.frame(varImp(model.gbm)$importance)
model.imp2 = as.data.frame(varImp(model.gbm2)$importance)
model.imp3 = as.data.frame(varImp(model.gbm3)$importance)




 ### after nearzerovar removed

head(data.all)
data.all.data_type = data.all$data_type
data.all.dummy = dummyVars(~., data = data.all)
data.all.dummy = as.data.frame(predict(data.all.dummy, data.all))

# x = nearZeroVar(data.all.dummy)
# data.all.dummy = as.data.frame(data.all.dummy[, -x])

data.all.dummy$data_type = data.all.data_type

data.train <- filter(data.all.dummy, data_type == "train")
data.train$SalePrice = log(data.train$SalePrice)
data.train$data_type = NULL


data.test <- filter(data.all, data_type == "test")
data.test$data_type = NULL

# gbmGrid4 <- expand.grid(interaction.depth = 5,
#                         n.trees = 250, 
#                         shrinkage = 0.1,
#                         n.minobsinnode = 15) # you can also put something        like c(5, 10, 15, 20)
# model.gbm4<- train(SalePrice ~., data =  data.train , method = 'gbm', tuneGrid= gbmGrid4, trControl = fitControl)
# 
# 

tmp11 = as.data.frame(varImp(model.gbm)$importance)
tmp11$class = rownames(tmp11)
tmp22 = filter(tmp11, Overall > 0) %>% arrange(Overall)

data.train.refined = data.train[, which(colnames(data.train) %in% tmp22$class)]
data.train.refined$SalePrice = data.train$SalePrice

gbmGrid4 <- expand.grid(interaction.depth = c(1, 3,5 ),
                        n.trees = c(4:6)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = c(15, 20)) # you can also put something        like c(5, 10, 15, 20)
model.gbm4<- train(SalePrice ~., data =  data.train.refined , method = 'gbm', tuneGrid= gbmGrid4, trControl = fitControl)


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


# linear model

model.lasso = train(SalePrice ~., data = as.data.frame(train.x.dummified), method = 'lasso')

