library(dplyr)
library(caret)
library(glmnet)
library(xgboost)
library(gbm)
library(randomForest)
source("../function/util.R")


######################################### PCA ######################################### 

load('../../data/cleanedData/ddata_train_validation.matrix.RData')


# load PCA RData
load('../../data/model/pca.RData')
png("../../images/model_pca_scree_plot.png")
plot(model.pca, type = 'l', main = "PCA Scree plot")
dev.off()

# 1st PC vs 2nd PC
png("../../images/model_pca_pc_comparison_plot.png")
qplot(model.pca$x[, 1], model.pca$x[, 2]) + ggtitle("1st PC vs 2nd PC") + xlab("1st PC") + ylab("2nd PC")
dev.off()
summary(model.pca)

######################################### lasso #########################################

# load lasso RData
load("../../data/model/lasso.RData")

# plot lasso lambda
png("../../images/model_lasso_lambda.png")
plot(model.lasso.lambda, main ='Lasso Lambda') 
dev.off()
model.lasso.lambda.min

model.ridge.lambda.coeff <- as.data.frame.matrix(coef(model.ridge, s = model.ridge.lambda.min))
model.ridge.lambda.coeff$coefficent_name <- rownames(model.ridge.lambda.coeff)
rownames(model.ridge.lambda.coeff) <- NULL
colnames(model.ridge.lambda.coeff) <- c('coefficients', 'predictor')
filter(model.ridge.lambda.coeff, coefficients != 0) %>% nrow




# load ridge RData
load('../../data/model/ridge.RData')

# plot ridge lambda
png("../../images/model_ridge_lambda.png")
plot(model.ridge.lambda, main ='Ridge Lambda')
log(model.ridge.lambda.min)
dev.off()


# coefficient

model.lasso.lambda.coeff <- as.data.frame.matrix(coef(model.lasso, s = model.lasso.lambda.min))
model.lasso.lambda.coeff$coefficent_name <- rownames(model.lasso.lambda.coeff)
rownames(model.lasso.lambda.coeff) <- NULL
colnames(model.lasso.lambda.coeff) <- c('coefficients', 'predictor')
model.lasso.lambda.coeff.filterd <- filter(model.lasso.lambda.coeff, coefficients != 0)

model.lasso.lambda.coeff$coefficients_exist <- model.lasso.lambda.coeff$coefficients > 0

png("../../images/model_lasso_number_of_coefficients_left.png")
ggplot(model.lasso.lambda.coeff, aes(x = as.factor(coefficients_exist))) + geom_bar() + ggtitle("The number of cofficients left and removed") + xlab("The number of coefficients left")
dev.off()

png("../../images/model_lasso_coefficients_top_10.png")
arrange(model.lasso.lambda.coeff.filterd, desc(coefficients))[2:11, ] %>% 
  ggplot(aes(x = predictor, y =coefficients )) + geom_density() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("cofficient for top 10 predictors from Lasso")
dev.off()

# prediction
model.lasso.pred <- predict(model.lasso,newx= as.matrix(select(data.validation.matrix, -SalePrice)),type="response",s= model.lasso.lambda.min)
model.lasso.df <- modify_dataframe_for_comparison(model.lasso.pred, 'lasso')

 

ggplot(model.lasso.df, aes(x = 1:nrow(model.lasso.df), y = residual)) + geom_line()
ggplot(model.lasso.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
get_rmse(model.lasso.pred, data.validation.matrix$SalePrice)

######################################### ridge #########################################


model.ridge.pred <- predict(model.ridge,newx= as.matrix(select(data.validation.matrix, -SalePrice)),type="response",s= model.ridge.lambda.min)
model.ridge.df <- modify_dataframe_for_comparison(model.ridge.pred, 'ridge')


model.ridge.lambda.coeff <- as.data.frame.matrix(coef(model.ridge, s = model.ridge.lambda.min))
model.ridge.lambda.coeff$coefficent_name <- rownames(model.ridge.lambda.coeff)
rownames(model.ridge.lambda.coeff) <- NULL
colnames(model.ridge.lambda.coeff) <- c('coefficients', 'predictor')

png("../../images/model_ridge_coefficients_top_10.png")
arrange(model.ridge.lambda.coeff, desc(coefficients))[2:11, ] %>% 
  ggplot(aes(x = predictor, y =coefficients )) + geom_density() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("cofficient for top 10 predictors from Ridge")
dev.off()

# 

ggplot(model.ridge.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.ridge.df, aes(x = 1:nrow(model.ridge.df), y = residual)) + geom_line()
get_rmse(model.ridge.pred, data.validation.matrix$SalePrice)

######################################### gbm ######################################### 

# load gbm RData
load('../../data/model/gbm.RData')

# model importance
plot(varImp(model.gbm))
model.gbm.imp <- varImp(model.gbm)$importance
model.gbm.imp$predictor <- rownames(model.gbm.imp)

png("../../images/model_gbm_predictor importance.png")
arrange(model.gbm.imp, desc(Overall))[1:10, ] %>% 
  ggplot(aes(x = predictor, y =Overall )) + geom_density() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("predictor importance from GBM") + ylab("Importance")
dev.off()
# prediction
model.gbm.pred <- predict(model.gbm, data.validation.matrix)
model.gbm.df <- modify_dataframe_for_comparison(model.gbm.pred, 'gbm')
ggplot(model.gbm.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.gbm.df, aes(x = 1:nrow(model.gbm.df), y = residual)) + geom_line()
get_rmse(model.gbm.pred, data.validation.matrix$SalePrice)
#### random forest

#########################################  load random forest RData ######################################### 
load('../../data/model/rf.RData')

# prediction
model.rf.pred = predict(model.rf, data.validation.matrix)
model.rf.df <- modify_dataframe_for_comparison(model.rf.pred, 'rf')
ggplot(model.rf.df, aes(x = y, y= pred)) + geom_point() + geom_smooth()
ggplot(model.rf.df, aes(x = 1:nrow(model.rf.df), y = residual)) + geom_line()
get_rmse(model.rf.pred, data.validation.matrix$SalePrice)

# combine
combined = rbind(model.lasso.df, model.ridge.df, model.rf.df, model.gbm.df)
combined$model = as.factor(combined$model)

png("../../images/model_residual_comparison.png", width = 1000, height = 300)
ggplot(combined, aes(x = index, y = residual, color = model)) + geom_line() + facet_grid(~model) + ggtitle("Residul comparison")
dev.off()

png("../../images/model_prediction_comparison.png", width = 1000, height = 300)
ggplot(combined, aes(x = y, y = pred, color = model)) + geom_point() + geom_smooth()  + facet_grid(~model) + ggtitle("Model prediction comparison")
dev.off()



# RMSE
get_rmse(model.lasso.pred, data.validation.matrix$SalePrice)
get_rmse(model.ridge.pred, data.validation.matrix$SalePrice)
get_rmse(model.gbm.pred, data.validation.matrix$SalePrice)
get_rmse(model.rf.pred, data.validation.matrix$SalePrice)


# Save data for shiny app
save(model.lasso.df,
     model.ridge.df,
     model.gbm.df,
     model.rf.df,
     combined,
     file = "../../data/model/model.df.RData")












