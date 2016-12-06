library(doMC)
library(caret)

load("../../../data/cleanedData/ddata_train_validation.matrix.RData")

registerDoMC(cores = 4)
gbmGrid <- expand.grid(interaction.depth = c(3, 5),
                        n.trees = c(4, 5, 6, 7)*50, 
                        shrinkage = c(0.1, 0.2),
                        n.minobsinnode = c(10, 15))

fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)
set.seed(1000)
model.gbm <- train(SalePrice ~., data =  data.train.matrix, method = 'gbm', tuneGrid = gbmGrid)
save(model.gbm, gbmGrid, file = "../../../data/model/gbm.RData")
