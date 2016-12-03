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

head(data.all)
View(data.all)

data.train = filter(data.all, data_type == 'train')
# YrSold
ggplot(data.all, aes(x = YrSold)) + geom_histogram()

# MoSold
ggplot(data.all, aes(x = MoSold)) + geom_histogram()
# => This makes sense. People usually move in and out during summer.

# Price distribution
filter(data.all, data_type == 'train') %>%
  ggplot(aes(x = SalePrice)) + geom_histogram()
# => skewed to the right. 


# Price log distribution
filter(data.all, data_type == 'train') %>%
  ggplot(aes(x = SalePrice)) + geom_histogram()

summary(data.train$SalePrice)
quantile(data.train$SalePrice, probs = c(0.005, 0.995))
ggplot(data.train, aes(x = SalePrice)) + geom_histogram()
ggplot(data.train, aes(x = SalePrice)) + geom_histogram() + xlim(10.91511, 13.17509)

filter(data.train, SalePrice <= 10.91511 | SalePrice >= 13.17509)


filter(data.train, SalePrice == 0)
data.all$SalePrice

# Sold Year - Remodel Year -> how long it has been after remodeling.
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10()
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(0, 20)
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(21, 40)
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(41, 60)

# Sold Year - Built Year -> how long it has been after built
ggplot(data.train, aes(x = YrSold_YearBuilt, y = SalePrice)) + geom_point() + geom_smooth() +  scale_y_log10() + xlim(0, 100)

# group by YrSold_YearRemodel vs SalePrice
group_by(data.train, YrSold_YearRemodel) %>% summarise(mean(SalePrice)) %>% View

# group by YrSold_YearBuilt vs SalePrice
group_by(data.train, YrSold_YearBuilt) %>% summarise(mean(SalePrice)) %>% View

# look at outliers 
filter(data.all, SalePrice > 500000)

summary(data.train$SalePrice)

# group by SaleCondition vs SalePrice
group_by(data.train, SaleCondition) %>% summarise(mean(SalePrice))

# group by SaleType vs SalePrice
group_by(data.train, SaleType) %>% summarise(mean(SalePrice))

# group by MoSold vs SalePrice
group_by(data.train, MoSold) %>% summarise(mean(SalePrice))

# group by YrSold vs SalePrice
group_by(data.train, YrSold) %>% summarise(mean(SalePrice))


# model analysis






data.all

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



