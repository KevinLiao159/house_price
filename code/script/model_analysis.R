library(dplyr)
library(caret)
library(glmnet)
library(xgboost)
source("../function/util.R")

### lasso

# load lasso RData
load("../../data/model/lasso.RData")

# plot lasso lambda
png("../../images/model_lasso_lambda.png")
plot(model.lasso.lambda, main ='Lasso Lambda') 
dev.off()

model.lasso.lambda.coeff <- as.data.frame.matrix(coef(model.lasso, s = model.lasso.lambda.min))
model.lasso.lambda.coeff$coefficent_name <- rownames(model.lasso.lambda.coeff)
rownames(model.lasso.lambda.coeff) <- NULL
colnames(model.lasso.lambda.coeff) <- c('coefficients', 'predictor')
filter(model.lasso.lambda.coeff, coefficients != 0) %>% nrow

# prediction
model.lasso.pred <- predict(model.lasso,newx= as.matrix(select(data.validation.matrix, -SalePrice)),type="response",s= model.lasso.lambda.min)
model.lasso.df <- modify_dataframe_for_comparison(model.lasso.pred, 'lasso')

ggplot(model.lasso.df, aes(x = 1:nrow(model.lasso.df), y = residual)) + geom_line()
ggplot(model.lasso.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
get_rmse(model.lasso.pred, data.validation.matrix$SalePrice)
### ridge

# load ridge RData
load('data/model/ridge.RData')

# plot ridge lambda
png("images/model_ridge_lambda.png")
plot(model.ridge.lambda)
dev.off()

model.ridge.lambda.coeff <- as.data.frame.matrix(coef(model.ridge, s = model.ridge.lambda.min))
model.ridge.lambda.coeff$coefficent_name <- rownames(model.ridge.lambda.coeff)
rownames(model.ridge.lambda.coeff) <- NULL
colnames(model.ridge.lambda.coeff) <- c('coefficients', 'predictor')
filter(model.ridge.lambda.coeff, coefficients != 0) %>% nrow

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

png("images/model_residual_comparison.png", width = 1000, height = 300)
ggplot(combined, aes(x = index, y = residual, color = model)) + geom_line() + facet_grid(~model) + ggtitle("Residul comparison")
dev.off()

png("images/model_prediction_comparison.png", width = 1000, height = 300)
ggplot(combined, aes(x = y, y = pred, color = model)) + geom_point() + geom_smooth()  + facet_grid(~model) + ggtitle("Model prediction comparison")
dev.off()


# load PCA RData
load('data/model/pca.RData')
png("images/model_pca.png")
plot(model.pca, type = 'l')
summary(model.pca)

# RMSE
get_rmse(model.lasso.pred, data.validation.matrix$SalePrice)
get_rmse(model.ridge.pred, data.validation.matrix$SalePrice)
get_rmse(model.gbm.pred, data.validation.matrix$SalePrice)
get_rmse(model.rf.pred, data.validation.matrix$SalePrice)


