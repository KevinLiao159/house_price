library(shiny)
library(ggplot2)

train <- read.csv("../data/rawData/train.csv")

source("../script/function/util.R")
names_items <- names(get_only_numerical_predictors(train))
 
numeric_items <- train[, names_items]

ui <- fluidPage(
    headerPanel('Explanatory Data Analysis and Visualization'),
    sidebarPanel(
        selectInput('x', 'Input', names_items)
    ),
    mainPanel(
        plotOutput('plot1') +
        plotOutput('plot2')
    )
)


server <- function(input, output) {
    
    selectedData <- reactive({
      numeric_items[, c(input$x, SalePrice)]
    })
    
    output$plot1 <- renderPlot({
      ggplot(numeric_items, aes(x = numeric_items[,input$x], y = numeric_items$SalePrice)) + 
        geom_point() +
        ggtitle(paste0("Scatter Plot: Sale Price vs. ", input$x)) +
        labs(x = input$x, y = "Sale Price")
    })
    
    output$plot2 <- renderPlot({
      ggplot(numeric_items, aes(x = numeric_items[,input$x])) +
        geom_histogram() +
        ggtitle(paste0("Histogram of ", input$x)) +
        labs(x = input$x)
      
      
    })
    
    
    
}

shinyApp(ui = ui, server = server)
