library(dplyr)

# Util function

convert_na_to_factor = function(data) {
    
    
    for (predictor in colnames(data)){
        pred = eval(quote(predictor))
        selected_pred = data[, pred]
        if (is.factor(selected_pred)) {
            
            tmp = as.character(selected_pred)
            tmp[is.na(tmp)] = "None"
            tmp = as.factor(tmp)
            data[, pred] = tmp
        }
        if (is.integer(selected_pred)) {
            
            selected_pred[is.na(selected_pred)] = -1
            data[, pred] = selected_pred
        }
        
    }
    return(data)
}

# Import Data
DataTrain <- read.csv("../rawData/train.csv")
DataTrain <- convert_na_to_factor(DataTrain)
DataTest <- read.csv("../rawData/test.csv")
DataTest <- convert_na_to_factor(DataTest)


# Variable Names
names(DataTest) == names(DataTest)

# Price
summary(DataTrain)


# Exploratory Data Analysis
numerical_variable <- c("LotFrontage", "LotArea", "MSSubClass", "OverallCond", "OverallQual", "YearBuilt", 
                        "YearRemodAdd", "MasVnrArea", "BsmtFinSF1", "BsmtFinSF2", "BsmtUnfSF", "TotalBsmtSF", 
                        "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea", "BsmtFullBath", "BsmtHalfBath", 
                        "FullBath", "HalfBath", "BedroomAbvGr", "KitchenAbvGr", "TotRmsAbvGrd", "Fireplaces", 
                        "GarageYrBlt", "GarageCars", "GarageArea", "WoodDeckSF", "OpenPorchSF", "EnclosedPorch", 
                        "X3SsnPorch", "ScreenPorch", "PoolArea", "MiscVal", "MoSold", "YrSold")
categorical_variable <- c()
for (i in 2:ncol(DataTest)) {
    if (!is.element(names(DataTest)[i], numerical_variable)) {
        categorical_variable <- c(categorical_variable, names(DataTest)[i])
    }
}

# Explore Qualitative Variables

qualitative_analysis <- function(variable) {
    
    col <- which(names(DataTrain) == variable)
    
    # Select data
    data <- select(DataTrain, col)
    # Unlist data
    data <- unlist(data)
    
    # Frequency Table - Relative Frequency
    sink("qualitative_output.txt", append = TRUE)
    cat(c("Frequency Table - Relative Frequency of", variable, "\n"), append = TRUE)
    print(table(data) / nrow(DataTrain))
    cat(" \n", append = TRUE)
    sink()
    
    # Count plot and plot of variable vs price
    png(paste0("../images/boxplot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Boxplot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("../images/distribution-", variable, ".png"))
    plot(data, xlab = variable, ylab = "Count", main = paste0("Distribution of ", variable))
    dev.off()
}


# Explore Quantitative Variables

quantitative_analysis <- function(variable) {
    
    col <- which(names(DataTrain) == variable)
    
    # Select data
    data <- select(DataTrain, col)
    # Unlist data
    data <- unlist(data)
    
    # Plot
    png(paste0("../images/plot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Plot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("../images/histogram-", variable, ".png"))
    hist(data, xlab = variable, ylab = "Frequency", main = paste0("Histogram of the frequency of ", variable))
    dev.off()
}

for (i in 1:length(numerical_variable)) {
    quantitative_analysis(numerical_variable[i])
}

for (i in 1:length(categorical_variable)) {
    qualitative_analysis(categorical_variable[i])
}

pairs(DataTrain[,numerical_variable[1:10]])


# Individual Variable Exploration
# Numerical Variables into Categorical Vectors
# MiscFeature
library(ggplot2)
DataTrain$MiscFeature_exist <- !is.na(DataTrain$MiscFeature)
ggplot(DataTrain, aes(x = SalePrice, fill = factor(MiscFeature_exist))) + geom_histogram(position="dodge", bins = 500)

# MSZoning
ggplot(DataTrain, aes(x = SalePrice, fill = factor(MSZoning))) + geom_histogram(position="dodge", bins = 30)


# Bathroom
# Hypothesis: Does the bathroom number positively correlated to saleprice

# BsmtFullBath
ggplot(DataTrain, aes(x = SalePrice, fill = factor(BsmtFullBath))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = BsmtFullBath, y = SalePrice, col = factor(BsmtFullBath))) + geom_point()

# BsmtHalfBath
ggplot(DataTrain, aes(x = SalePrice, fill = factor(BsmtHalfBath))) + geom_histogram(position="dodge", bins = 30)

# New Variable - BsmtBath
# Intuition: Does not matter whether it is half bath or full bath, the total number matters
# Full bath and half bath have similar value
ggplot(DataTrain, aes(x = BsmtBath, y = SalePrice, col = factor(BsmtFullBath))) + geom_point()
# Create new variable
DataTrain$BsmtBath <- DataTrain$BsmtFullBath + DataTrain$BsmtHalfBath
ggplot(DataTrain, aes(x = SalePrice, fill = factor(BsmtBath))) + geom_histogram(position="dodge", bins = 30)

# FullBath
# More obvious upward trending
ggplot(DataTrain, aes(x = SalePrice, fill = factor(FullBath))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = FullBath, y = SalePrice, col = factor(FullBath))) + geom_point()

# HalfBath
ggplot(DataTrain, aes(x = SalePrice, fill = factor(HalfBath))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = HalfBath, y = SalePrice, col = factor(HalfBath))) + geom_point()

# New variable - Bath
# Count halfbath as 0.5 and fullbath as 1
DataTrain$Bath <- DataTrain$BsmtFullBath + DataTrain$BsmtHalfBath * 0.5 + DataTrain$FullBath + DataTrain$HalfBath * 0.5
ggplot(DataTrain, aes(x = SalePrice, fill = factor(Bath))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = Bath, y = SalePrice, col = factor(Bath))) + geom_point()
# Outliers
which(DataTrain$Bath > 4.5)
# 739 and 922 seem to be outliers - although they have a lot of bathrooms, the price is cheap
# How are 739 and 922 similar
DataTrain[739,] == DataTrain[922,]
# Intuition: Because the house type are duplex, the price is cheap as the baths are shared by multiple families
# Things to consider: BathFamily, which measures the bath per family has


# BedroomAbvGr
ggplot(DataTrain, aes(x = SalePrice, fill = factor(BedroomAbvGr))) + geom_histogram(position="dodge", bins = 30)

# KitchenAbvGr
ggplot(DataTrain, aes(x = SalePrice, fill = factor(KitchenAbvGr))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = KitchenAbvGr, y = SalePrice, col = factor(BldgType))) + geom_point()
# Kitchen with regards to kitchen quality
ggplot(DataTrain, aes(x = KitchenAbvGr, y = SalePrice, col = factor(KitchenQual))) + geom_point()
ggplot(DataTrain, aes(x = SalePrice, fill = factor(KitchenQual))) + geom_histogram(position="dodge", bins = 30)
# New Variable - KitchenQualBinary
# In order to create interaction term between kitchen number and kitchen quantity
DataTrain$KitchenQualBinary <- 0
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$KitchenQual == "Ex" | DataTrain[i,]$KitchenQual == "Gd") {
        DataTrain[i,]$KitchenQualBinary <- 1
    }
}
ggplot(DataTrain, aes(x = KitchenAbvGr, y = SalePrice, col = factor(KitchenQualBinary))) + geom_point()


# TotRmsAbvGrd
ggplot(DataTrain, aes(x = SalePrice, fill = factor(TotRmsAbvGrd))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = TotRmsAbvGrd, y = SalePrice, col = factor(BldgType))) + geom_point()
# New Variable - MiscRoom
# Since total room include bedrooms, we can create another predictor of functional rooms other than bedrooms
DataTrain$MiscRoom <- DataTrain$TotRmsAbvGrd - DataTrain$BedroomAbvGr
ggplot(DataTrain, aes(x = SalePrice, fill = factor(MiscRoom))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = MiscRoom, y = SalePrice, col = factor(BldgType))) + geom_point()
# Strong linear relationship with Sales Price


# Fireplaces
ggplot(DataTrain, aes(x = Fireplaces, y = SalePrice)) + geom_point()
ggplot(DataTrain, aes(x = SalePrice, fill = factor(Fireplaces))) + geom_histogram(position="dodge", bins = 30)
# With regards to fireplace quality
ggplot(DataTrain, aes(x = Fireplaces, y = SalePrice, col = factor(FireplaceQu))) + geom_point()
# New Variable - FireplaceQuBinary
DataTrain$FireplaceQuBinary <- 0
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$FireplaceQu == "Ex" | DataTrain[i,]$FireplaceQu == "Gd") {
        DataTrain[i,]$FireplaceQuBinary <- 1
    }
}
ggplot(DataTrain, aes(x = Fireplaces, y = SalePrice, col = factor(FireplaceQuBinary))) + geom_point()



# GarageYrBlt
# Any missing value in garage year
DataTrain[DataTrain$GarageYrBlt == -1, ]$GarageType == "None"
# No missing value in garage year built
DataTrain[DataTrain$GarageYrBlt != -1,] %>%
    ggplot(aes(x = GarageYrBlt, y = SalePrice)) + geom_point()
# New variable - GarageAge
min(DataTrain[DataTrain$GarageYrBlt != -1, ]$GarageYrBlt)
# The oldest garage was built in 1900
DataTrain$GarageAge <- -1
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$GarageYrBlt != -1) {
        DataTrain[i,]$GarageAge <- DataTrain[i,]$GarageYrBlt - 1900
    }
}
DataTrain[DataTrain$GarageAge != -1,] %>%
    ggplot(aes(x = GarageAge, y = SalePrice)) + geom_point()
ggplot(DataTrain, aes(x = GarageAge, y = SalePrice, col = factor(GarageFinish))) + geom_point()


# GarageCars
ggplot(DataTrain, aes(x = GarageCars, y = SalePrice, col = factor(BldgType))) + geom_point()


# GarageArea
ggplot(DataTrain, aes(x = GarageArea, y = SalePrice)) + geom_point()
ggplot(DataTrain, aes(x = GarageArea, y = SalePrice)) + geom_point() + scale_x_log10()

# WoodDeckSF
ggplot(DataTrain, aes(x = WoodDeckSF, y = SalePrice)) + geom_point()

# OpenPorchSF
ggplot(DataTrain, aes(x = OpenPorchSF, y = SalePrice)) + geom_point()

# EnclosedPorch
# X3SsnPorch
# ScreenPorch

# New Variable - PorchArea, which calculates the total area of porch of a house
DataTrain$PorchArea = DataTrain$OpenPorchSF + DataTrain$EnclosedPorch + DataTrain$X3SsnPorch + DataTrain$ScreenPorch
ggplot(DataTrain, aes(x = PorchArea, y = SalePrice)) + geom_point()
# New Variable - PorchBinary, which measures if a house has porch or not
DataTrain$PorchBinary <- 1
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$OpenPorchSF == 0 && DataTrain[i,]$EnclosedPorch == 0 && DataTrain[i,]$X3SsnPorch == 0 && DataTrain[i,]$ScreenPorch == 0) {
        DataTrain[i,]$PorchBinary <- 0
    }
}
ggplot(DataTrain, aes(x = PorchBinary, y = SalePrice)) + geom_point()


# PoolArea
ggplot(DataTrain, aes(x = PoolArea, y = SalePrice)) + geom_point()
# New Variable - PoolBinary, which measures if a house has pool or not
DataTrain$PoolBinary <- 0
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$PoolArea > 0) {
        DataTrain[i,]$PoolBinary <- 1
    }
}
ggplot(DataTrain, aes(x = SalePrice, fill = factor(PoolBinary))) + geom_histogram(position="dodge", bins = 30)


# MiscVal
ggplot(DataTrain, aes(x = SalePrice, fill = factor(MiscVal))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = MiscVal, y = SalePrice)) + geom_point()
# New Variable - MiscBinary, which measures if a house has pool or not
DataTrain$MiscBinary <- 0
for (i in 1:nrow(DataTrain)) {
    if (DataTrain[i,]$MiscVal > 0) {
        DataTrain[i,]$MiscBinary <- 1
    }
}
ggplot(DataTrain, aes(x = MiscBinary, y = SalePrice)) + geom_point()

# MoSold
ggplot(DataTrain, aes(x = SalePrice, fill = factor(MoSold))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = MoSold, y = SalePrice)) + geom_point()

# YrSold
ggplot(DataTrain, aes(x = SalePrice, fill = factor(YrSold))) + geom_histogram(position="dodge", bins = 30)
ggplot(DataTrain, aes(x = YrSold, y = SalePrice)) + geom_point()
