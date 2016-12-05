library(dplyr)
library(ggplot2)
library(caret)
library(doMC)
library(stringr)
library(glmnet)
source("code/function/util.R")

# import dataset
data.train <- read.csv("data/rawData/train.csv")
data.test <- read.csv("data/rawData/test.csv")
data.sample <- read.csv("data/rawData/sample_submission.csv")

##################### prepocess #####################
data.train$Id <- NULL
data.test$Id <- NULL

# add predictor called data_type
data.train$data_type <- "train"
data.test$data_type <- "test"
data.test$SalePrice <- 0

# Scale log transform
data.train$SalePrice <- log(data.train$SalePrice + 1)

# remove outliers 17 points
data.train <- filter(data.train, 10.91511 < SalePrice, SalePrice < 13.17509)

# combine train, test
data.all <- rbind(data.train, data.test)
data.train$data_type <- as.factor(data.train$data_type)

# sold - built
data.all$YrSold_YearBuilt <- data.all$YrSold - data.all$YearBuilt

# Remodel - built
data.all$YearRemodel_YearBuilt <- data.all$YearRemodAdd - data.all$YearBuilt

# sold - remodel
data.all$YrSold_YearRemodel <- data.all$YrSold - data.all$YearRemodAdd

head(data.all)

# factorize
data.all$MSSubClass <- as.factor(data.all$MSSubClass) 
data.all$YearBuilt <- as.factor(data.all$YearBuilt)
data.all$YrSold <- as.factor(data.all$YrSold)
data.all$MoSold <- as.factor(data.all$MoSold)
data.all$GarageYrBlt <- as.factor(data.all$GarageYrBlt)

# convert NAs to factor
data.all <- convert_na_to_factor(data.all)

# add number of nones
data.all$num_none <- get_number_none(data.all)

# add existance
data.all$pool_exist <- as.factor(data.all$PoolArea != 0)
data.all$garage_exist <- as.factor(data.all$GarageArea != 0)
data.all$masVnrArea_exist <- as.factor(data.all$MasVnrArea != 0)

# # kmeans using areas
# set.seed(11)
# data.area <- select(data.all, LotArea, GrLivArea)
# scaled_data = as.data.frame(scale(data.area))
# data.model.kmeans = kmeans(scaled_data, centers = 10)
# 
# data.all$cluster <- as.factor(data.model.kmeans$cluster)
# scaled_data$cluster <- as.factor(data.model.kmeans$cluster)
# 
# data.all$cluster_dist = 0
# for (i in 1:nrow(data.all)) {
#   
#   data.all$cluster_dist[i] = dist(rbind( select(scaled_data[i, ], -cluster), data.model.kmeans$centers[scaled_data[i, ]$cluster, ] ))
#   
# }

# add log term for area related predictors

data.all$LotArea <- log(data.all$LotArea + 1)
data.all$GrLivArea <- log(data.all$GrLivArea + 1)


data_type <- data.all$data_type
data.all$data_type <- NULL
data.all.matrix <- as.data.frame(model.matrix( ~ ., data = data.all))
data.all.matrix$`(Intercept)` <- NULL
data.all.matrix$data_type <- data_type

# save RData
save(data.all, file = "data/cleanedData/data.all.RData")
save(data.all.matrix, file = "data/cleanedData/data.all.matrix.RData")


