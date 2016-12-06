library(dplyr)
library(ggplot2)

load("../../data/cleanedData/data.all.matrix.RData")
load("../../data/cleanedData/data.all.RData")
data.train <- filter(data.all.matrix, data_type == 'train')

# Price distribution

png("../../images/historgram_original_price.png")
filter(data.all.matrix, data_type == 'train') %>%
  ggplot(aes(x = exp(SalePrice))) + geom_histogram() + ggtitle("Original house price histogram") + xlim('Price')
dev.off()
# => skewed to the right. 

quantile(data.train$SalePrice, probs = c(0.005, 0.995))
ggplot(data.train, aes(x = SalePrice)) + geom_histogram()

png("../../images/historgram_log_trasformed_price.png")
ggplot(data.train, aes(x = SalePrice)) + geom_histogram() + xlim(10.91511, 13.17509) + ggtitle("Log transformed house price histogram") + xlab('log(Price)')
dev.off()

# Sold Year - Remodel Year -> how long it has been after remodeling.
png("../../images/scatter_Year_sold_Year_remodeled_Vs_Price.png")
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlab("Year sold - Year remodeled") + ggtitle("Year sold - Year remodeled vs Price") + xlim(0, 10)
dev.off()

# Sold Year - Built Year -> how long it has been after built
png("../../images/scatter_Year_sold_Year_built_Vs_Price.png")
ggplot(data.train, aes(x = YrSold_YearBuilt, y = SalePrice)) + geom_point() + geom_smooth() +  scale_y_log10() + xlim(0, 100)  + xlab("Year sold - Year built") + ggtitle("Year sold - Year built vs Price")
dev.off()

# group by YrSold_YearRemodel vs SalePrice
group_by(data.train, YrSold_YearRemodel) %>% summarise(mean(SalePrice)) %>% View

# group by YrSold_YearBuilt vs SalePrice
group_by(data.train, YrSold_YearBuilt) %>% summarise(mean(SalePrice)) %>% View

# SalePrice based on MSZoning
ggplot(data.all, aes(x = SalePrice, fill = factor(MSZoning))) + geom_histogram(position="dodge", bins = 30)
ggplot(data.all, aes(x = MasVnrArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()

ggplot(data.all, aes(x = GarageArea)) + geom_histogram()
ggplot(data.all, aes(x = GarageArea, y = SalePrice)) + geom_point()

# plot area related predictors
ggplot(data.all, aes(x = LotArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.all, aes(x = MasVnrArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.all, aes(x = GrLivArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.all, aes(x = GarageArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(data.all, aes(x = PoolArea, y = SalePrice)) + geom_point() + scale_x_log10() + scale_y_log10()




