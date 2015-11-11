library(shiny)
library(dplyr) #for filter function
library(ggplot2) # for outputting graphs

##load tables
movie <- read.csv("movie.csv")
oscar <- read.csv("oscar.csv")

shinyServer(function(input,output) {
  
  ##filter information
  movieSubset <- reactive({
    
    minYear <- input$yearRange[1]
    maxYear <- input$yearRange[2]
    minNomination <- input$minNomination
    minAward <- input$minAward
    
    filter(movie,
           Year >= minYear,
           Year <= maxYear,
           Academy.Nominations >= minNomination,
           Academy.Awards >= minAward)
    
  })
  
  ##output graph
  output$moviePlot <- renderPlot(function() {
    
    plotData <- data.frame(y = movieSubset()[[input$varY]], x = movieSubset()[[input$varX]])
    
    p <- ggplot(plotData, aes(x, y)) + 
      geom_point(colour = "dodgerblue4") +
      xlab(input$varX) +
      ylab(input$varY)
    
    print(p)
  })
  
  ##output datatable
  output$oscar = renderDataTable({oscar})
  
})