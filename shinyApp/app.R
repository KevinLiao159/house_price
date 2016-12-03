library(shiny)
library(ggplot2)

<<<<<<< HEAD
train <- read.csv("../data/rawData/train.csv")

source("../script/function/util.R")
names_items <- names(get_only_numerical_predictors(train))
 
numeric_items <- train[, names_items]
=======
test <- read.csv("../data/rawData/test.csv")
advertising <- advertising[,2:5]
>>>>>>> 6b2256087f07511695d2057be39f9c07dcda4d64

ui <- fluidPage(
    headerPanel('Explanatory Data Analysis and Visualization'),
    sidebarPanel(
        selectInput('x', 'Input', names_items)
    ),
    mainPanel(
        plotOutput('plot1')
        
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
}

shinyApp(ui = ui, server = server)
