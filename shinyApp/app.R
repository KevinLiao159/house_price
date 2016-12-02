library(shiny)

advertising <- read.csv("Advertising.csv")
advertising <- advertising[,2:5]

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
