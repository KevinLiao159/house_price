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

# pairs plot
png("images/pairsplot")  
pairs(data.train[,c("LotFrontage", "LotArea", "MSSubClass", "OverallCond", "OverallQual", 
                    "YearBuilt", "YearRemodAdd", "MasVnrArea", "BsmtFinSF1", "BsmtFinSF2", 
                    "BsmtUnfSF", "TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", 
                    "GrLivArea")])
dev.off()

# LotFrontage
ggplot(data = data.train, aes(y = SalePrice, x = LotFrontage)) + 
  geom_point()
# weak coorelation
cor(data.train$SalePrice, data.train$LotFrontage)
# Log transformation
ggplot(data.train, aes(x = LotFrontage)) + geom_histogram() + scale_x_log10()


# LotArea
ggplot(data = data.train[-c(54, 250, 314, 336, 385, 452, 458, 707, 770, 1299, 1397), ], 
       aes(y = SalePrice, x = LotArea)) + 
  geom_point()

# outlier with high leverage
which(data.train$LotArea > 50000)

cor(data.train$SalePrice, data.train$LotArea)
# stronger correlation
plot()

lm1 <- lm(SalePrice ~ LotArea, data = data.train)
plot(data.train$LotArea, data.train$SalePrice)
abline(lm1)
abline(lm2)

lm2 <- lm(SalePrice ~ LotArea, data = data.train[-c(54, 250, 314, 336, 385, 452, 458, 707, 770, 1299, 1397), ])
plot(data.train$LotArea, data.train$SalePrice)
abline(lm2)
## Log transformation
ggplot(data.train, aes(x = LotArea)) + geom_histogram() + scale_x_log10()


# MSSubClass ?????????????????
ggplot(data = data.train, aes(y = SalePrice, x = MSSubClass)) + 
  geom_point()

plot(data.train$MSSubClass)



