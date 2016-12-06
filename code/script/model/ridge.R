library(doMC)
library(caret)
library(glmnet)

load("../../../data/cleanedData/ddata_train_validation.matrix.RData")

# ridge modeling
grid <- 10 ^ -c(seq(0, 10, by = 0.1))
set.seed(1000)
model.ridge.lambda <- cv.glmnet(as.matrix(select(data.train.matrix, -SalePrice)), as.matrix(data.train.matrix$SalePrice), nfolds = 5, intercept = FALSE, lambda = grid, alpha = 0)
model.ridge.lambda.min = model.ridge.lambda$lambda.min
model.ridge <- glmnet(as.matrix(select(data.train.matrix, -SalePrice)), as.matrix(data.train.matrix$SalePrice), alpha = 0, lambda = model.ridge.lambda.min)
save(model.ridge.lambda, model.ridge.lambda.min, model.ridge, file = "../../../data/model/ridge.RData")
