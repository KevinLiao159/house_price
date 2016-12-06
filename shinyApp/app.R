library(shiny)
library(ggplot2)
library(glmnet)
library(dplyr)
library(caret)

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
load('../data/model/model.df.Rdata')

model.names <- c('PCA', 'lasso', 'ridge', 'gbm', 'random_forest')
model.list <- list(PCA = model.pca,
                   lasso = model.lasso.lambda,
                   ridge = model.ridge.lambda,
                   gbm = model.gbm,
                   random_forest = model.rf)

method.names <- c('lasso', 'ridge', 'gbm', 'random_forest')
method.list <- list(lasso = model.lasso.df,
                   ridge = model.ridge.df,
                   gbm = model.gbm.df,
                   random_forest = model.rf.df)



ui <- fluidPage(
  
  headerPanel('House Price: Advanced Regression Techniques'),
  fluidRow(
    column(12, offset = 0,
           sidebarPanel(width = "100%", "This Shiny App is designed in accordance with the report, which provides the structured outline of our project's methodology and analysis. The interactive App helps the reader to visualize the reproducible results and understand our appraoch to the problem."
           )
           
    )
  ),  
  
  headerPanel('Methodology'),
  fluidRow(
    column(12, offset = 0,
           sidebarPanel(width = "100%", "The goal of this analysis is to accurately predict the final price of each home. The methods we are using include the following steps: 1) Exploratory Data Analysis, which explores the initial relationship among variables; 2) Model Selection, which includes a variety of PCA, Lasso, Ridge, GBM and Random Forest; 3) Model Comparison, which aims to minimize RMSE of the prediction. The details are explained in the following subsections."
                        )
    )
  ),  
    

  headerPanel('Explanatory Data Analysis and Visualization'),
  sidebarPanel(
    selectInput('ycol', 'Y Variable', names_items, selected = names_items[38]),
    selectInput('xcol', 'X Variable', names_items, selected = names_items[1], multiple = T),
    selectInput('col', 'Colors', color, selected = color[1]),
    sliderInput("x1",
                "x-axis range",
                min = 0,  max = 2000, value = c(0, 1500)),
    sliderInput("y1",
                "y-axis range",
                min = 0,  max = 1000000, value = c(10000, 700000))
   
  ),
  
  
  mainPanel(
    plotOutput('plot1')
  ),
  
  
  headerPanel('Model Description'),
  fluidRow(
    column(12, offset = 0,
           sidebarPanel(width = "100%", "In order to effectively select hyper-parameters, we use 10-fold cross-validation. We first look at lasso and ridge, which are the shrinkage methods with lambda as the tuning parameter. We then look at the dimenson-reduction methods, including PCR and PLSR, where the number of principal components is the tuning parameter. We need to find the optimal number of subsets of PCs that summarize the entire data set without harming accuracy."
           )
           
    )
  ),  

  
  
  headerPanel('Model Selection - Tunning Parameter'),
  sidebarPanel(
    selectInput('model', 'Regression Methods', model.names, selected = model.names[1])),
  mainPanel(
    plotOutput('plot2') 
  ),
  
  headerPanel('Model comparison'),
  fluidRow(
    column(12, offset = 0,
           sidebarPanel(width = "100%", "After fitting models with various methods, we use RMSE to compare models and select the best model. Although RMSE does not provide an absolute means of model accuracy, it provides a relative measure to compare models. Thus, we finalize our model with the lowest RMSE."
           )
    )
  ),  
  
  
  headerPanel('Results'),
  sidebarPanel(
    selectInput('method', 'Regression Methods', method.names, selected = method.names[1])),
  mainPanel(
    plotOutput('plot3'),
    plotOutput('plot4')
  ),
  
  
  
  headerPanel('Model Comparison'),
  fluidRow(
    column(12, offset = 0, 
           mainPanel(width = "80%",
             plotOutput('plot5'),
             plotOutput('plot6')
           )
           
    )
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
         main = 'Scatter Plot', 
         xlim = c(input$x1[1], input$x1[2]),
         ylim = c(input$y1[1], input$y1[2])
         )
  })
  

  output$plot2 <- renderPlot({
    
    plot(model.list[[input$model]], 
         type = 'l',
         main = input$model) 
  })
  
  
  output$plot3 <- renderPlot({
    ggplot(method.list[[input$method]], 
           aes(x = 1:nrow(method.list[[input$method]]), y = residual)) + 
      geom_line() +
      ggtitle(input$method) + 
      labs(x = "Individual Obervation",y = "Residual")
  })  
  
  
  output$plot4 <- renderPlot({
    ggplot(method.list[[input$method]],  aes(x = y, y= pred)) +
      geom_point() +
      geom_smooth() +
      ggtitle(input$method) + 
      labs(x = "Obervations", y = "Predictions")
  })  
  
  
  output$plot5 <- renderPlot({
    ggplot(combined, aes(x = index, y = residual, color = model)) + 
      geom_line() + 
      facet_grid(~model) + 
      ggtitle("Residul comparison")
  })  
  
  
  output$plot6 <- renderPlot({
    ggplot(combined, aes(x = y, y = pred, color = model)) + 
      geom_point() + 
      geom_smooth() + 
      facet_grid(~model) + 
      ggtitle("Model prediction comparison")
  })  
  
}

shinyApp(ui = ui, server = server)
