library(shiny)
library(ggplot2)

load('../data/model/pca.RData')
load('../data/model/lasso.RData')
load('../data/model/ridge.RData')
load('../data/model/gbm.RData')
load('../data/model/rf.RData')

model.names <- c('PCA', 'lasso', 'ridge', 'gbm', 'random_forest')
model.list <- list(PCA = model.pca,
                   lasso = model.lasso,
                   ridge = model.ridge,
                   gbm = model.gbm,
                   random_forest = model.rf)

ui <- fluidPage(
    headerPanel('Tunning Parameter'),
    sidebarPanel(
        selectInput('model', 'Regression Methods', model, selected = model[1])),
        #selectInput('xcol', 'X Variable', names_items, selected = names_items[1], multiple = T),
        #selectInput('col', 'Colors', color, selected = color[1]),
        #selectInput('size', 'Dot Size', dotsize, selected = dotsize[1])),
    
    mainPanel(
        plotOutput('plot1') 
    )
)


server <- function(input, output) {
    
    selectedData <- reactive({
      #nfeatures[, c(input$xcol, input$ycol)]
      model.list[input$model]
    })
    
    output$plot1 <- renderPlot({

      plot(selectedData())#,
           #col = input$col,
           #pch = 20, cex = as.numeric(input$size),
           #main = 'Scatter Plot')
      
    })
}

shinyApp(ui = ui, server = server)
