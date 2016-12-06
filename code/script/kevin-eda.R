library(dplyr)
library(ggplot2)
library(caret)
library(iterators)
library(parallel)
library(doMC)
registerDoMC(cores = 4)
source("../function/util.R")

# import dataset
data.train = read.csv("../../data/rawData/train.csv")
data.test = read.csv("../../data/rawData/test.csv")
data.sample = read.csv("../../data/rawData/sample_submission.csv")

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
#data.all$YearBuilt = as.factor(data.all$YearBuilt)
data.all$YrSold = as.factor(data.all$YrSold)
data.all$GarageYrBlt = as.factor(data.all$GarageYrBlt)

data.all = convert_na_to_factor(data.all)


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
png("../../images/pairsplot.png")  
pairs(data.train[,c("LotFrontage", "LotArea", "MSSubClass", "OverallCond", "OverallQual", 
                    "YearBuilt", "YearRemodAdd", "MasVnrArea", "BsmtFinSF1", "BsmtFinSF2", 
                    "BsmtUnfSF", "TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", 
                    "GrLivArea")])
dev.off()

# LotFrontage ------ take log
ggplot(data = data.train, aes(y = SalePrice, x = LotFrontage)) + 
  geom_point()
# weak coorelation
cor(data.train$SalePrice, data.train$LotFrontage)
# Log transformation
ggplot(data.train, aes(x = LotFrontage)) + geom_histogram() + scale_x_log10()


# LotArea ----- take log
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

# OverallCond  ????????
ggplot(data = data.train, aes(y = SalePrice, x = OverallCond)) + 
  geom_point()

# Why outliers
which(data.train$SalePrice > 5e+05 & data.train$OverallCond == 5)
data.train[c(179, 441, 770, 804, 899, 1047, 1170, 1183),]


# OverallQual  ---- Strong 
ggplot(data = data.train, aes(y = SalePrice, x = OverallQual)) + 
  geom_point()

# add price multiple to data.all
data.all$multiple <- data.all$SalePrice / data.all$GrLivArea

# Look at the top 5 multiples
head(data.all[order(data.all$multiple),][data.all$data_type=="train",])

# plot multiple vs. neighborhood
plot(data.train$Neighborhood, data.train$multiple, las = 2)



# YearBuilt

ggplot(data = data.train, aes(y = SalePrice, x = YearBuilt)) + 
  geom_point()

ggplot(data.train, aes(x = YearBuilt)) + geom_bar() 

# standize YearBuilt
# data.all$YearBuilt <- scale(as.numeric(data.all$YearBuilt), center = TRUE, scale = TRUE)
# Mean = 1971.3
mean(as.numeric(data.all$YearBuilt))
