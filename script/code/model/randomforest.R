
fitControl <- trainControl(method = "repeatedcv", number = 7, repeats = 3)
model.rf <- train(SalePrice ~., data =  data.train.matrix, method = 'rf')
save(model.rf, file = "data/model/rf.RData")
