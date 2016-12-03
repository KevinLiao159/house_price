library(shiny)

train <- read.csv("../data/rawData/train.csv")

source("../script/function/util.R")
num_items <- names(get_only_numerical_predictors(train))
 
train <- 

ui <- fluidPage(
    headerPanel('Simple Regression'),
    sidebarPanel(
        selectInput('x', 'Input', names(advertising)[1:3])
    ),
    mainPanel(
        plotOutput('plot1')
        
    )
)

server <- function(input, output) {
    
    selectedData <- reactive({
        advertising[, c(input$x, Sales)]
    })
    
    output$plot1 <- renderPlot({
        plot(advertising[, input$x],
             advertising$Sales,
             xlab = input$x,
             ylab = "Sales")
    })
}

shinyApp(ui = ui, server = server)
