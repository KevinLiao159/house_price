library(dplyr)


# Explore Quantitative Variables

quantitative_analysis <- function(variable) {
    
    col <- which(names(DataTrain) == variable)
    
    # Select data
    data <- select(DataTrain, col)
    # Unlist data
    data <- unlist(data)
    
    # Plot
    png(paste0("../../images/plot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Plot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("../../images/histogram-", variable, ".png"))
    hist(data, xlab = variable, ylab = "Frequency", main = paste0("Histogram of the frequency of ", variable))
    dev.off()
}