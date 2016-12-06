# stat159-fall2016-finalproject

## Code

This directory holds the codes for all analysis/computations and containes three main directories: 
   * `function`, which contains generic functions used in scripts
   * `script`, which is the main folder for all regression model processing
   * `test`, which holds unit tests for output comparison

The complete file-structure for the directory is as follows:

```
code/
   README.md
   function/
      qualitative_analysis.R # For exploratory data analysis
      quantitative_analysis.R # For exploratory data analysis
      util.R # All util functions
   script/
      python/ # contains the original python code
      model/ # contains the transformed R code for each predictive model
         gbm.R
         lasso.R
         ridge.R
         pca.R
         randomforest.R
         svm.R
         xgboost.R
      lingjie-eda.R
      daniel-eda.R
      kevin-eda.R
      data-preparation.R
      preprocess.R
      model-analysis.R # the main model analysis and comparison file
      seesion-info-script.R
   test/
      test-evaluation.R
   qualitative_output.txt # output from eda script
```

### LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

Author: **Minsu Kim**, **Lingjie Qiao**, **Kevin Liao**, and **Cheng Peng**
