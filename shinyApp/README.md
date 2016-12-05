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

### Directory Structure 

* `shinyApp_scatterplot`, which creates a shiny App for scatter plot visualization

* `shinyApp_model`, which creates a shiny App for tuning parameters of each model

* `README.md`, which describes details of this directory


The complete file-structure for this directory is as follows:
```
shinyApp/
	README.md
	shinyApp_scatterplot/
	  app.R                   # code that creates shiny app for scatter plots
	shinyApp_model/
	  app.R                   # code that creates shiny app for model analysis
        
```
**ShinyDoc**, which is created by the code in app.R, is based on the simple linear regression between two variables. The ShinyDoc will have a dropdown with a list of 3 options - TV, Radio and newspaper as an input element. The output will be a scatter plot between `Sales` and the input option chosen from the dropdown.

### LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

Author: **Minsu Kim**, **Lingjie Qiao**, **Kevin Liao**, and **Cheng Peng**





