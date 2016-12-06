library(doMC)
library(caret)
library(stats)

load("../../../data/cleanedData/ddata_train_validation.matrix.RData")


preProcValues <- preProcess(data.train.matrix, method = c("center", "scale"))
trainTransformed <- predict(preProcValues, data.train)
fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)
model.svmRadial <- train(SalePrice ~., data =  trainTransformed , method = 'svmRadial',trControl = fitControl, tuneLength = 20)
save(model.svmRadial, file = "../../../data/model/svm.RData")