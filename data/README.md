# stat159-fall2016-finalproject

## Data

This directory holds the data used to create the reproducible report. It includes three separate folders, `rawData`, `cleanData` and `model`. 
* rawData: which includes the originally downloaded datasets, including `sample_submission.csv`, `test.csv`, `train.csv` and data description text file.
* cleanedData: which includes the RData files after preprocessing and cleaning
* model: which includes the RData files produced with each predictive model

The complete file-structure for the directory is as follows:

```
data/
   README.md
   rawData/
      data_description.txt
      train.csv
      test.csv
      sample_submission.csv
   cleanedData/
         data.all.matrix.RData
         data.all.RData
         ddata_train_validation.matrix.RData
         RMSEL_Table.RData
   model/
      gbm.RData
      lasso.RData
      ridge.RData
      pca.RData
      rf.RData

```

### LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

Author: **Minsu Kim**, **Lingjie Qiao**, **Kevin Liao**, and **Cheng Peng**
