# stat159-fall2016-finalproject

## House Price: Advanced Regression Techniques

Authors: **Minsu Kim**, **Lingjie Qiao**, **Kevin Liao**, **Cheng Peng**
<div>
University of California, Berkeley </br>
Berkeley CA, 94072 USA </br>
Minsu Kim: kaj011@berkeley.edu </br>
Lingjie Qiao: katherine_qiao@berkeley.edu </br>
Kevin Liao: lwk723@berkeley.edu </br>
Cheng Peng: hanson.peng@berkeley.edu </br>
</div>

### Project Objective
This repository holds the information of Course Stats 159 at UC Berkeley, fall 2016 – final project. This project aims to estimate housing price based on 79 variables covering every aspect of residential homes in Ames, Iowa with statistical models. Two main focuses are:
1. Incorporate advanced machine learning techniques and predictive model building to solve real-life industry problems
2. Demonstrate aptitude in research and data analysis by emphasizing computational reproducibility and project collaboration 

Project Instruction: [github project repository](https://github.com/ucb-stat159/stat159-fall-2016/blob/master/projects/proj03/stat159-final-project.rmd)

Course website: [gastonsanchez.com/stat159](http://gastonsanchez.com/stat159)

### Project Structure 

Since the main deliverables of this project include report, slides, shinyApp and related data in the process, we create the following repository structure to better organize the files for the purpose of reproducibility. 

The main directories of this repository are:
* `data`, which stores the original data set, the preprocessed and scaled data set, and some other RData output
* `code`, which holds the codes for all analysis/computations and containes three main directories: 
   * `function`, which contains generic functions used in scripts
   * `script`, which is the main folder for all regression model processing
   * `test`, which holds unit tests for output comparison
* `images`, which stores the graphic output including histogram, boxplot, correlation matrix and barcharts, as well as the banner of project etc.
* `report`, which has 7 sections and produced with latex format
* `slides`, which adds on additional feature to the project and complements the materials in the report for a formal presentation
* `shinyApp`, which creates a shiny App for data visualization and interactive process walk-through
* `submission`, which holds the 16 submissions made to Kaggle Competition


The complete file-structure for the directory is as follows:

```
stat159-fall2016-finalproject/
   README.md
   Makefile
   LICENSE
   session-info.txt
   .gitignore
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
   data/
      README.md
      rawData/ # downloaded from Kaggle website
         train.csv
         test.csv
         sample_submission.csv
         data_description.txt
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
   images/ # which holds over 80 png image files
   report/
      report.pdf
      report.Rmd
      sections/
   slides/
      README.md
      slides.R
      slides.html
   shinyApp/
      README.md
      app.R # main shinyApp file
   submission/ # which holds 16 submissions made to Kaggle Competition

```

### Report Structure 

> * 0. Abstract
> * 1. Introduction
> * 2. Data
> * 3. Exploratory Data Analysis
> * 4. Methodology
> * 5. Analysis
> * 6. Results
> * 7. Conclusions
> * Acknowledgement
> * References


### Reproducibility

To reproduce most of the results represented in this project (images, dataset, report etc), simply clone the repository (download zip file) and run the make file with command
> make

If you would like to reproduce a specific section (for example, the report), run the corresponding command line in the terminal
> make report

If you would like to remove the report, run the following command line
> make clean

If you would like to know how we obstained the 16 submissions, please feel free to contact the owner of this repository for more information

the following is a complete list of make commands for phony targets:
* make all 
* make data 
* make tests 
* make eda 
* make pre  
* make regressions 
* make report 
* make slides 
* make session 
* make clean


### LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

Author: **Minsu Kim**, **Lingjie Qiao**, **Kevin Liao**, and **Cheng Peng**
