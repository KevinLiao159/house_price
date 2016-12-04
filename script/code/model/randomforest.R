model.rf <- train(SalePrice ~., data =  data.train.matrix, method = 'rf')
save(model.rf, file = "data/model/rf.RData")
