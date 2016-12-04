library(dplyr)


# Explore Qualitative Variables

qualitative_analysis <- function(variable) {
    
    col <- which(names(DataTrain) == variable)
    
    # Select data
    data <- select(DataTrain, col)
    # Unlist data
    data <- unlist(data)
    
    # Frequency Table - Relative Frequency
    sink("../qualitative_output.txt", append = TRUE)
    cat(c("Frequency Table - Relative Frequency of", variable, "\n"), append = TRUE)
    print(table(data) / nrow(DataTrain))
    cat(" \n", append = TRUE)
    sink()
    
    # Count plot and plot of variable vs price
    png(paste0("../../images/boxplot-", variable, ".png"))
    plot(data, DataTrain$SalePrice, xlab = variable, ylab = "SalePrice", main = paste0("Boxplot of ", variable, "and Sale Price"))
    dev.off()
    png(paste0("../../images/distribution-", variable, ".png"))
    plot(data, xlab = variable, ylab = "Count", main = paste0("Distribution of ", variable))
    dev.off()
}
