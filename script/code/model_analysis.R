library(caret)
library(glmnet)
library(xgboost)
source("script/function/util.R")

### lasso

# load lasso RData
load('data/model/lasso.RData')

# plot lasso coefficient
plot(model.lasso.lambda)

# prediction
model.lasso.pred <- predict(model.lasso,newx= as.matrix(select(data.validation.matrix, -SalePrice)),type="response",s= model.lasso.lambda.min)
model.lasso.df <- modify_dataframe_for_comparison(model.lasso.pred, 'lasso')
ggplot(model.lasso.df, aes(x = 1:nrow(model.lasso.df), y = residual)) + geom_line()
ggplot(model.lasso.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
get_rmse(model.lasso.pred, data.validation.matrix$SalePrice)
### ridge

# load ridge RData
load('data/model/ridge.RData')

# plot lasso coefficient
plot(model.ridge.lambda)

# prediction
model.ridge.pred <- predict(model.ridge,newx= as.matrix(select(data.validation.matrix, -SalePrice)),type="response",s= model.ridge.lambda.min)
model.ridge.df <- modify_dataframe_for_comparison(model.ridge.pred, 'ridge')
ggplot(model.ridge.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.ridge.df, aes(x = 1:nrow(model.ridge.df), y = residual)) + geom_line()
get_rmse(model.ridge.pred, data.validation.matrix$SalePrice)

#### gbm

# load gbm RData
load('data/model/gbm.RData')

# model importance
plot(varImp(model.gbm))

# prediction
model.gbm.pred = predict(model.gbm, data.validation.matrix)
model.gbm.df <- modify_dataframe_for_comparison(model.gbm.pred, 'gbm')
ggplot(model.gbm.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.gbm.df, aes(x = 1:nrow(model.gbm.df), y = residual)) + geom_line()
get_rmse(model.gbm.pred, data.validation.matrix$SalePrice)
#### random forest

# load random forest RData
load('data/model/rf.RData')

# prediction
model.rf.pred = predict(model.rf, data.validation.matrix)
model.rf.df <- modify_dataframe_for_comparison(model.rf.pred, 'rf')
ggplot(model.rf.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.rf.df, aes(x = 1:nrow(model.rf.df), y = residual)) + geom_line()
get_rmse(model.rf.pred, data.validation.matrix$SalePrice)

# combine
combined = rbind(model.lasso.df, model.ridge.df, model.rf.df, model.gbm.df)
combined$model = as.factor(combined$model)

ggplot(combined, aes(x = index, y = residual, color = model)) + geom_line() + facet_wrap(~model) + ggtitle("Residul comparison")
ggplot(combined, aes(x = y, y = pred, color = model)) + geom_point() + geom_smooth()  + facet_wrap(~model) 


# load PCA RData
load('data/model/pca.RData')
plot(model.pca, type = 'l')
summary(model.pca)

##########
# 
# tmp11 = as.data.frame(varImp(model.gbm)$importance)
# tmp11$class = rownames(tmp11)
# tmp22 = filter(tmp11, Overall > 0) %>% arrange(Overall)
# 
# data.train.refined = data.train[, which(colnames(data.train) %in% tmp22$class)]
# data.train.refined$SalePrice = data.train$SalePrice
# 
# gbmGrid4 <- expand.grid(interaction.depth = c(1, 3,5 ),
#                         n.trees = c(4:6)*50, 
#                         shrinkage = 0.1,
#                         n.minobsinnode = c(15, 20)) # you can also put something        like c(5, 10, 15, 20)
# model.gbm4<- train(SalePrice ~., data =  data.train.refined , method = 'gbm', tuneGrid= gbmGrid4, trControl = fitControl)
# 



