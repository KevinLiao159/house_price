
# lasso modeling

grid <- seq(0, 1, length = 1000)
set.seed(1000)
model.lasso.lambda <- cv.glmnet(as.matrix(select(data.train.matrix, -SalePrice)), as.matrix(data.train.matrix$SalePrice), nfolds = 5, intercept = FALSE, lambda = grid, alpha = 1)
model.lasso.lambda.min = model.lasso.lambda$lambda.min
model.lasso <- glmnet(as.matrix(select(data.train.matrix, -SalePrice)), as.matrix(data.train.matrix$SalePrice), alpha = 1, lambda = model.lasso.lambda.min)
save(model.lasso.lambda, model.lasso.lambda.min, model.lasso, file = "data/model/lasso.RData")
