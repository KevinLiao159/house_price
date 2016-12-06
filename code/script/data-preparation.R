# split into train, test matrix
load(file = "../../data/cleanedData/data.all.matrix.RData")
data.all.matrix <- as.data.frame(data.all.matrix)
data.train.matrix <- filter(data.all.matrix, data_type == "train")
data.train.matrix$data_type = NULL

set.seed(1000)
train_index <- createDataPartition(data.train.matrix$SalePrice, p = 0.8, list = FALSE)
data.train.matrix <- data.train.matrix[train_index, ]
data.validation.matrix <- data.train.matrix[-train_index, ]
data.validation.matrix <- arrange(data.validation.matrix, SalePrice)
data.test.matrix <- filter(data.all.matrix, data_type == "test")
data.test.matrix$data_type <- NULL
save(data.train.matrix, data.validation.matrix, file = "../../data/cleanedData/ddata_train_validation.matrix.RData")
