
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



