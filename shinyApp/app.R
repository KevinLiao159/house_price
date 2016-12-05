library(shiny)

# Laad Data
Advertising <- read.csv("Advertising.csv")
# Obtain relevant columns
Advertising <- Advertising[,2:5]

# store names for dropdown options
explainatory_variable <- names(Advertising)[1:3]

ui <- fluidPage(
  headerPanel('Analysis of Sales'),
  sidebarPanel(
    selectInput('xcol', 'Explainatory Variable', explainatory_variable)
  ),
  mainPanel(
    plotOutput('scatterplot')
  )
)

server <- function(input, output) {
  output$scatterplot <- renderPlot({
    plot(Advertising[ , input$xcol], Advertising$Sales, 
         main="Simple plot for sales and independent variable", 
         ylab = "Sales", xlab = input$xcol)
  })
}

shinyApp(ui = ui, server = server)