library(dplyr)
library(ggplot2)
library(caret)
library(iterators)
library(parallel)
library(doMC)
registerDoMC(cores = 4)
source("script/util.R")

# import dataset
data.train = read.csv("rawData/train.csv")
data.test = read.csv("rawData/test.csv")
data.sample = read.csv("rawData/sample_submission.csv")

# prepocess
data.train$Id <- NULL
data.test.id <- data.test$Id
data.test$Id <- NULL

data.train$data_type = "train"
data.test$data_type = "test"
data.test$SalePrice = 0
data.all = rbind(data.train, data.test)
data.train$data_type = as.factor(data.train$data_type)

data.all$MSSubClass = as.factor(data.all$MSSubClass) 
data.all$YearBuilt = as.factor(data.all$YearBuilt)
data.all$YrSold = as.factor(data.all$YrSold)
data.all$GarageYrBlt = as.factor(data.all$GarageYrBlt)

data.all = convert_na_to_factor(data.all)

# split into train, test again
data.train = filter(data.all, data_type == 'train')
data.train$data_type = NULL
data.test = filter(data.all, data_type == 'test')
data.test$data_type = NULL

# eda
View(data.all)
summary(data.all)
str(data.all)

# simple plot
ggplot(data.train, aes(x = SalePrice)) + geom_histogram() + scale_x_log10()


# Existence of MiscFeature
data.tmp <- select(data.train, MiscFeature, SalePrice)
data.tmp$MiscFeature_exist <- !is.na(data.tmp$MiscFeature)

# featur engineering

data.numeric = get_only_numerical_predictors(data.all)
data.numeric %>% head


tmp4 = head(data.train)


sum(data.train[1, ] == "None")


#### visualization

# SalePrice based on Existence of MiscFeature
ggplot(data.tmp, aes(x = SalePrice, fill = factor(MiscFeature_exist))) + geom_histogram(position="dodge", bins = 500)
# SalePrice based on Existence of MiscFeature (log transform)
ggplot(data.tmp, aes(x = SalePrice, fill = factor(MiscFeature_exist))) + geom_histogram(position="dodge", bins = 500) + scale_x_log10()

# SalePrice based on MSZoning
ggplot(data.train, aes(x = SalePrice, fill = factor(MSZoning))) + geom_histogram(position="dodge", bins = 30)
data.train$SalePrice = log(data.train$SalePrice)
filter(data.train, SalePrice == max(SalePrice))


res=MCA(data.train, quanti.sup=19)





