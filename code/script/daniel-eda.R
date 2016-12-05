
head(data.all)
View(data.all)

data.train = filter(data.all, data_type == 'train')
# YrSold
ggplot(data.all, aes(x = YrSold)) + geom_histogram()

# MoSold
ggplot(data.all, aes(x = MoSold)) + geom_histogram()
# => This makes sense. People usually move in and out during summer.

# Price distribution

png("images/historgram_original_price.png")
filter(data.all, data_type == 'train') %>%
  ggplot(aes(x = SalePrice)) + geom_histogram() + ggtitle("Original house price histogram") + xlim('Price')
dev.off()
# => skewed to the right. 


# Price log distribution
filter(data.all, data_type == 'train') %>%
  ggplot(aes(x = SalePrice)) + geom_histogram()

summary(data.train$SalePrice)
quantile(data.train$SalePrice, probs = c(0.005, 0.995))
ggplot(data.train, aes(x = SalePrice)) + geom_histogram()

png("images/historgram_log_trasformed_price.png")
ggplot(data.train, aes(x = SalePrice)) + geom_histogram() + xlim(10.91511, 13.17509) + ggtitle("Log transformed house price histogram") + xlab('log(Price)')
dev.off()

filter(data.train, SalePrice <= 10.91511 | SalePrice >= 13.17509) 


filter(data.train, SalePrice == 0)
data.all$SalePrice

# Sold Year - Remodel Year -> how long it has been after remodeling.
png("images/scatter_Year_sold_Year_remodeled_Vs_Price.png")
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlab("Year sold - Year remodeled") + ggtitle("Year sold - Year remodeled vs Price")
dev.off()

ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(0, 20)
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(21, 40)
ggplot(data.train, aes(x = YrSold_YearRemodel, y = SalePrice)) + geom_point() + geom_smooth() + scale_y_log10() + xlim(41, 60)

# Sold Year - Built Year -> how long it has been after built
png("images/scatter_Year_sold_Year_built_Vs_Price.png")
ggplot(data.train, aes(x = YrSold_YearBuilt, y = SalePrice)) + geom_point() + geom_smooth() +  scale_y_log10() + xlim(0, 100)  + xlab("Year sold - Year built") + ggtitle("Year sold - Year built vs Price")
dev.off()

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



