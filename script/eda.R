library(dplyr)
library(ggplot2)
library(caret)
library(doMC)
library(stringr)
registerDoMC(cores = 7)
source("script/util.R")

# import dataset
data.train = read.csv("rawData/train.csv")
data.test = read.csv("rawData/test.csv")
data.sample = read.csv("rawData/sample_submission.csv")

##################### prepocess #####################
data.train$Id <- NULL
data.test.id <- data.test$Id
data.test$Id <- NULL

# combine train, test
data.train$data_type = "train"
data.test$data_type = "test"
data.test$SalePrice = 0
data.all = rbind(data.train, data.test)
data.train$data_type = as.factor(data.train$data_type)

# factorize
data.all$MSSubClass = as.factor(data.all$MSSubClass) 
data.all$YearBuilt = abs(max(data.all$YearBuilt) - data.all$YearBuilt)

data.all$YrSold = abs(max(data.all$YrSold) - data.all$YrSold)
data.all$GarageYrBlt = as.factor(data.all$GarageYrBlt)

# convert NAs to factor
data.all = convert_na_to_factor(data.all)

# split into train, test again
data.train = filter(data.all, data_type == 'train')
data.train$data_type = NULL
data.test = filter(data.all, data_type == 'test')
data.test$data_type = NULL

############# featur engineering ##############
# add number of nones
data.all$num_none = get_number_none(data.all)
data.all$pool_exist = as.factor(data.all$PoolArea != 0)
data.all$garage_exist = as.factor(data.all$GarageArea != 0)
data.all$masVnrArea_exist = as.factor(data.all$MasVnrArea != 0)


# kmeans using areas
set.seed(11)
data.area <- select(data.all, LotArea, GrLivArea)
scaled_data = as.data.frame(scale(data.area))
data.model.kmeans = kmeans(scaled_data, centers = 10)

data.all$cluster <- as.factor(data.model.kmeans$cluster)
scaled_data$cluster <- as.factor(data.model.kmeans$cluster)

data.all$cluster_dist = 0
for (i in 1:nrow(data.all)) {

  data.all$cluster_dist[i] = dist(rbind( select(scaled_data[i, ], -cluster), data.model.kmeans$centers[scaled_data[i, ]$cluster, ] ))
      
}

# add log term for area related predictors

data.all$LotArea_log = log(data.all$LotArea)
data.all$GrLivArea_log = log(data.all$GrLivArea)
# data.all$GarageArea_log = log(data.all$GarageArea + 100)
# data.all$MasVnrArea = log(data.all$MasVnrArea + 100)
# data.all$PoolArea = log(data.all$PoolArea + 100)

################################################################





data.numeric = get_only_numerical_predictors(data.all)
model.pca = prcomp(as.matrix(data.numeric), scale. = TRUE, center = TRUE)
plot(prcomp(as.matrix(data.numeric), scale. = TRUE, center = TRUE), type='l')
summary(model.pca)




#### visualization

# SalePrice based on Existence of MiscFeature
ggplot(data.tmp, aes(x = SalePrice, fill = factor(MiscFeature_exist))) + geom_histogram(position="dodge", bins = 500)
# SalePrice based on Existence of MiscFeature (log transform)
ggplot(data.tmp, aes(x = SalePrice, fill = factor(MiscFeature_exist))) + geom_histogram(position="dodge", bins = 500) + scale_x_log10()

# SalePrice based on MSZoning
ggplot(data.train, aes(x = SalePrice, fill = factor(MSZoning))) + geom_histogram(position="dodge", bins = 30)

ggplot(data.train, aes(x = MasVnrArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()

ggplot(data.train, aes(x = GarageArea)) + geom_histogram()
ggplot(data.train, aes(x = LotArea + GarageArea + MasVnrArea + GrLivArea + PoolArea, y = SalePrice)) + geom_sm + geom_point()+ scale_x_log10() + scale_y_log10()
ggplot(data.train, aes(x = GarageArea, y = SalePrice)) + geom_point()

colnames(data.train)
for (col in colnames(data.train)) {
  if (str_detect(col, "Area")) {
    print(col)
  }
}

# plot area related predictors
ggplot(data.train, aes(x = LotArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.train, aes(x = MasVnrArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.train, aes(x = GrLivArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.train, aes(x = GarageArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.train, aes(x = PoolArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()


################ eda ###################
# View(data.all)
# summary(data.all)
# str(data.all)

# simple plot
# ggplot(data.train, aes(x = SalePrice)) + geom_histogram() + scale_x_log10()



