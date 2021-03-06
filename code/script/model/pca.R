library(doMC)
library(caret)
library(glmnet)
library(stats)

load("../../../data/cleanedData/ddata_train_validation.matrix.RData")

set.seed(1000)
nzv <- nearZeroVar(data.train.matrix)
data.train.matrix.filtered <- data.train.matrix[, -nzv]
model.pca <- prcomp(as.matrix(select(data.train.matrix.filtered, -SalePrice)), center = TRUE, scale. = TRUE)
save(model.pca, file = "../../../data/model/pca.RData")


