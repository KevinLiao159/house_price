import pandas as pd
import numpy as np
import pickle

from scipy.stats import randint as sp_randint
from sklearn.model_selection import KFold
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import skew
from scipy.stats.stats import pearsonr
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.svm import SVR
from sklearn.ensemble import AdaBoostRegressor
from itertools import product
from sklearn.ensemble import VotingClassifier
from sklearn.linear_model import Ridge, RidgeCV, ElasticNet, LassoCV, LassoLarsCV
from sklearn.model_selection import cross_val_score

def report(results, n_top=3):
    for i in range(1, n_top + 1):
        candidates = np.flatnonzero(results['rank_test_score'] == i)
        for candidate in candidates:
            print("Model with rank: {0}".format(i))
            print("Mean validation score: {0:.3f} (std: {1:.3f})".format(
                  results['mean_test_score'][candidate],
                  results['std_test_score'][candidate]))
            print("Parameters: {0}".format(results['params'][candidate]))
            print("")

train = pd.read_csv("../rawData/train.csv")
test = pd.read_csv("../rawData/test.csv")

all_data = pd.concat((train.loc[:,'MSSubClass':'SaleCondition'],
                      test.loc[:,'MSSubClass':'SaleCondition']))

prices = pd.DataFrame({"price":train["SalePrice"], "log(price + 1)":np.log1p(train["SalePrice"])})
# prices.hist()
#log transform the target:
train["SalePrice"] = np.log1p(train["SalePrice"])

#log transform skewed numeric features:
numeric_feats = all_data.dtypes[all_data.dtypes != "object"].index

skewed_feats = train[numeric_feats].apply(lambda x: skew(x.dropna())) #compute skewness
skewed_feats = skewed_feats[skewed_feats > 0.75]
skewed_feats = skewed_feats.index

all_data[skewed_feats] = np.log1p(all_data[skewed_feats])
all_data = pd.get_dummies(all_data)
all_data = all_data.fillna(all_data.mean())


X_train = all_data[:train.shape[0]]
X_test = all_data[train.shape[0]:]
y = train.SalePrice



def rmse_cv(model):
    rmse= np.sqrt(-cross_val_score(model, X_train, y, scoring="neg_mean_squared_error", cv = 5))
    return(rmse)


clf = RandomForestRegressor(n_estimators=500, n_jobs=-1)
param_grid = {"max_depth": [15, 20, 25],
              "max_features": [10],
              "min_samples_split": [1, 3, 10],
              "min_samples_leaf": [1, 3, 10],
              "bootstrap": [True, False],
              "criterion": ["mse"]}

model_lasso = LassoCV(alphas = [1, 0.5, 0.1, 0.01, 0.05, 0.005, 0.001, 0.0005]).fit(X_train, y)
lasso_cv = rmse_cv(model_lasso)
print("lasso")
print(lasso_cv)
print(lasso_cv.mean())


n_estimators = 2000

param_bundle = {

    'randomForest': {
        "max_depth": [None],
        "n_estimators": [n_estimators],
        "max_features": ["auto", "log2"],
        "min_samples_split": [2, 4],
        "bootstrap": [True, False],
        'n_jobs': [-1]
    },
    'gbm': {
        "max_depth": [None],
        "n_estimators": [n_estimators],
        "learning_rate": [0.1, 0.05, 0.001]
    },
    'extra': {
        "max_depth": [None],
        "n_estimators": [n_estimators],
        "max_features": ["auto", "log2"],
        "min_samples_split": [2, 4],
        "bootstrap": [True, False],
        'n_jobs': [-1]
    }
}

model_bundle = {
    'randomForest': RandomForestRegressor,
    'gbm': GradientBoostingRegressor,
    'extra': ExtraTreesRegressor

}

for key, val in param_bundle.items():
    print("model name: ", key)
    param_grid = param_bundle[key]
    model = model_bundle[key]()
    grid_search = GridSearchCV(model, param_grid=param_grid, n_jobs=-1, cv=8)
    grid_search.fit(X_train, y)
    report(grid_search.cv_results_)
    cv_result = rmse_cv(grid_search)
    print("rmse: ", cv_result.mean())
    print("------------------------")

    pickle.dump({'model': grid_search, 'mse': cv_result.mean()}, open("model/%s.pkl" % key, "wb"))
