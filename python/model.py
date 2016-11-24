import numpy as np

from time import time
from scipy.stats import randint as sp_randint
import pandas as pd
from sklearn.model_selection import KFold
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import RandomizedSearchCV
from sklearn.datasets import load_digits

from sklearn.model_selection import cross_val_score
# from xgboost import XGBClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import RandomForestRegressor


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


clf = RandomForestRegressor(n_estimators=10, n_jobs=-1)
param_grid = {"max_depth": [5, 10, 15],
              "max_features": ["auto", "log2"],
              "min_samples_split": [1, 3, 10],
              "min_samples_leaf": [1, 3, 10],
              "bootstrap": [True, False],
              "criterion": ["mse"]}


X_train = pd.read_csv("../train_x.csv")
y_train = pd.read_csv("../train_y.csv")
X_test = pd.read_csv("../test_x.csv")

num_folds = 10
num_instances = len(X_train)
seed = 10

# run grid search
grid_search = GridSearchCV(clf, param_grid=param_grid, n_jobs = -1, cv= 8)
start = time()
grid_search.fit(X_train.values, np.concatenate(y_train.values))



print("GridSearchCV took %.2f seconds for %d candidate parameter settings."
      % (time() - start, len(grid_search.cv_results_['params'])))
report(grid_search.cv_results_)
print(grid_search.best_score_)