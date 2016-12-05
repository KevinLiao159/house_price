library(shiny)
library(ggplot2)

train <- read.csv("../data/rawData/train.csv")

source("../code/function/util.R")
names_items <- names(get_only_numerical_predictors(train))

nfeatures <- train[, names_items]

color <- c('black', 'blue', 'red', 'yellow', 'green')

dotsize <- c('1', '1.1', '1.2', '1.5', '2') 

load('../data/model/pca.RData')
load('../data/model/lasso.RData')
load('../data/model/ridge.RData')
load('../data/model/gbm.RData')
load('../data/model/rf.RData')

model.names <- c('PCA', 'lasso', 'ridge', 'gbm', 'random_forest')
model.list <- list(PCA = model.pca,
                   lasso = model.lasso.lambda,
                   ridge = model.ridge.lambda,
                   gbm = model.gbm,
                   random_forest = model.rf)


ui <- fluidPage(
  
  headerPanel('Methodology'),
  mainPanel(
    h4("The goal of this analysis is to accurately predict the final price of each home. Therefore, we frame this problem as a regression problem, and decide to use the L2 loss function [10] which is often used in regression problem. Taking this objective into account, we preprocess original dataset so that regression models can work well. Furthermore, we extract more features by involving feature engineering. Finally, we fit two shrinkage models and two ensemble models. The details are explained in the following subsections.")
  ),
  

  headerPanel('Explanatory Data Analysis and Visualization'),
  
  
  sidebarPanel(
    selectInput('ycol', 'Y Variable', names_items, selected = names_items[38]),
    selectInput('xcol', 'X Variable', names_items, selected = names_items[1], multiple = T),
    selectInput('col', 'Colors', color, selected = color[1]),
    selectInput('size', 'Dot Size', dotsize, selected = dotsize[1])),
  
  mainPanel(
    plotOutput('plot1')
  ),
  
  
  headerPanel('Model Description'),
  
  mainPanel(
    h4("While training each model, we need to find optimal paramters for each model. In order to effectively select hyper-parameters, we use 10-fold cross-validation. For lasso and ridge, lambda is the tuning parameter. It determines how much we will penalize models for high weights on predictors. If lambda is high, it penalizes models more and ends up generating sparse models. This kind of models is called shrinkage method because they shrinken weights or even remove predictors by penalizing models. These models are especially good options when there are many predictors. By penalziing or removing unnecessary predictors, they provide more interpretable results. Thus, they are often utilized in genomic and pharametical analysis. For PCR and PLSR, the number of principal components is the tuning parameter. They both internally use the precipal component analysis to obtain pricipal components, which are linear combination of original predictors in dataset. Based on spectral theorem, the eigenvector corresponding to highest eigenvalue is the direction that explains the most about the variability in data, which is the first principal component. We need to find the optimal number of subsets of PCs that summarize the entire data set without harming accuracy. Again, we use 10-kold cross validation to obtain the optimal number of principal components.")
  ),
  
  
  
  
  headerPanel('Model Selection - Tunning Parameter'),
  sidebarPanel(
    selectInput('model', 'Regression Methods', model.names, selected = model.names[1])),
  
  mainPanel(
    plotOutput('plot2') 
  )
)


server <- function(input, output) {
  
  selectedData <- reactive({
    nfeatures[, c(input$xcol, input$ycol)]
  })
  
  output$plot1 <- renderPlot({
    #par(mar = c(1, 1, 1, 1))
    plot(selectedData(),
         col = input$col,
         pch = 20, cex = as.numeric(input$size),
         main = 'Scatter Plot')
    
  })
  

  output$plot2 <- renderPlot({
    
    plot(model.list[[input$model]], 
         type = 'l',
         main = input$model) 
    
  })
}

shinyApp(ui = ui, server = server)
