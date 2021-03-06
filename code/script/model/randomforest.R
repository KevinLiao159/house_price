library(doMC)
library(caret)

load("../../../data/cleanedData/ddata_train_validation.matrix.RData")


registerDoMC(cores = 4)
fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)
set.seed(1000)
model.rf <- train(SalePrice ~., data =  data.train.matrix, method = 'rf')
save(model.rf, file = "../../../data/model/rf.RData")
