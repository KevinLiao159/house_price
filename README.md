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

The main directories of this repository are:
* `data`, which stores the original data set `Credit.csv`, the preprocessed and scaled data set `scaled-credit.csv` and some other RData output
* `code`, which holds the codes for all analysis/computations and containes three main directories: 
   * functions, which contains generic functions used in scripts
   * scripts, which is the main folder for all regression model processing
   * tests, which holds unit tests for output comparison
* `images`, which stores the graphic output including histogram, boxplot, correlation matrix and barcharts etc.
* `report`, which is sectioned into 7 parts and produces the official project report and analysis
* `slides`, which adds on additional feature to the project and complements the materials in the report for a formal presentation
* `shinyApp`, which creates a shiny App for data visualization


The complete file-structure for the directory is as follows:

```
stat159-fall2016-project2/
   README.md
   Makefile
   LICENSE
   session-info.txt
   .gitignore
   code/
      functions/
         README.md
         evaluation.R
         eda/
            eda-quantitative.R
            eda-qualitative.R
            eda-qualitative-extra.R
      scripts/
         README.md
         eda-script.R
         preprocess.R
         ols.R
         ridge.R
         lasso.R
         pcr.R
         plsr.R
         seesion-info-script.R
      tests/
         README.md
         test-evaluation.R
   data/
      README.md
      Credit.csv
      scaled-credit.csv
   images/
   report/
      report.pdf
      report.Rmd
      sections/
         00-abstract.Rmd
         01-introduction.Rmd
         02-data.Rmd
         03-methods.Rmd
         04-analysis.Rmd
         05-results.Rmd
         06-conclusions.Rmd
   slides/
      slides.R
      slides.html
```

### Paper Structure 

> * 0. Abstract
> * 1. Introduction
> * 2. Data
> * 3. Methodology
> * 4. Analysis
> * 5. Results
> * 6. Conclusions
> * References


### Reproducibility

To reproduce the results represented in this project (images, dataset, report etc), simply clone the repository (download zip file) and run the make file with command
> make

If you would like to reproduce a specific section (for example, the report), run the corresponding command line in the terminal
> make report

If you would like to remove the report, run the following command line
> make clean

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
