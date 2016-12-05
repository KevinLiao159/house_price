library(shiny)
library(ggplot2)

load("../../data/model/lasso.RData")

ui <- fluidPage(
    headerPanel('Explanatory Data Analysis and Visualization'),
    sidebarPanel(
        selectInput('ycol', 'Y Variable', names_items, selected = names_items[38]),
        selectInput('xcol', 'X Variable', names_items, selected = names_items[1], multiple = T),
        selectInput('col', 'Colors', color, selected = color[1]),
        selectInput('size', 'Dot Size', dotsize, selected = dotsize[1])),
    
    mainPanel(
        plotOutput('plot1') 
    )
)


server <- function(input, output) {
    
    selectedData <- reactive({
      nfeatures[, c(input$xcol, input$ycol)]
    })
    
    output$plot1 <- renderPlot({

      plot(selectedData(),
           col = input$col,
           pch = 20, cex = as.numeric(input$size),
           main = 'Scatter Plot')
      
    })
}

shinyApp(ui = ui, server = server)
