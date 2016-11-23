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
DataTrain <- read.csv("train.csv")
DataTrain <- convert_na_to_factor(DataTrain)
DataTest <- read.csv("test.csv")
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
    png(paste0("images/boxplot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Boxplot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("images/distribution-", variable, ".png"))
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
    png(paste0("images/plot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Plot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("images/histogram-", variable, ".png"))
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
    