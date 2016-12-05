---
output: html_document
runtime: shiny
---
library(shiny)
library(ggplot2)

train <- read.csv("../data/rawData/train.csv")

source("../code/function/util.R")
names_items <- names(get_only_numerical_predictors(train))
 
nfeatures <- train[, names_items]

color <- c('black', 'blue', 'red', 'yellow', 'green')

dotsize <- c('1', '1.1', '1.2', '1.5', '2') 

ui <- fluidPage(
    headerPanel('Explanatory Data Analysis and Visualization'),
    sidebarPanel(
        selectInput('ycol', 'Y Variable', names_items, selected = names_items[38]),
        selectInput('xcol', 'X Variable', names_items, selected = names_items[1], multiple = T),
        selectInput('col', 'Colors', color, selected = color[1]),
        selectInput('size', 'Dot Size', dotsize, selected = dotsize[1])),
    
    mainPanel(
        plotOutput('plot1') 
        #+
        #plotOutput('plot2')
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
           pch = 20, cex = as.numeric(input$size))
      
      #ggplot(nfeatures, aes(x = nfeatures[,input$xcol], y = nfeatures[, input$ycol])) + 
        #geom_point() +
        #ggtitle(paste0("Scatter Plot: ", input$ycol, " vs. ", input$xcol)) +
        #labs(x = input$xcol, y = input$ycol)
    })
    
    #output$plot2 <- renderPlot({
      #ggplot(nfeatures, aes(x = nfeatures[,input$x])) +
        #geom_histogram() +
        #ggtitle(paste0("Histogram of ", input$x)) +
        #labs(x = input$x)
      
      
    #})
    
    
    
}

shinyApp(ui = ui, server = server)
