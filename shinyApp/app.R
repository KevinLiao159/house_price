library(shiny)

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
        plotOutput('plot1')
        
    )
)

server <- function(input, output) {
    
    selectedData <- reactive({
        train[, c(input$x, SalePrice)]
    })
    
    output$plot1 <- renderPlot({
        plot(train[, input$x],
             train$SalePrice,
             xlab = input$x,
             ylab = "Sale Price")
    })
}

shinyApp(ui = ui, server = server)
