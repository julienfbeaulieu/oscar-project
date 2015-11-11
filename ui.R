library(shiny)

##load tables
oscar <- read.csv("oscar.csv")
movie <- read.csv("movie.csv")


shinyUI(pageWithSidebar(
  headerPanel('And the winner is... : Exploration of Oscar nominees'),
  sidebarPanel(
    
      h2("Filters"),
      p("Select filters for the graph"),
      br(),
      
      sliderInput("yearRange", 
                  "Year Range:",
                  min = 1927, 
                  max = 2010, 
                  value = c(1940,2010)),
    
      sliderInput("minNomination", 
                  "Minimum number of oscar nominations:", 
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1),
      
      sliderInput("minAward", 
                  "Minimum number of oscar awards:", 
                  min = 0,
                  max = 10,
                  value = 0,
                  step = 1),
      
      
      br(),
      br(),
      
      h2("Variables"),
      p("Select x and y variables for the graph"),
      br(),
      
      selectInput("varX",
                  "Variable for x-axis:",
                  list("Year" = "Year", 
                      "Imdb rating" = "imdbRating", 
                      "Metascore" = "Metascore", 
                      "Number of oscar awards" = "Academy.Awards", 
                      "Number of oscar nominations" = "Academy.Nominations", 
                      "Runtime (minutes)" = "Runtime"),
                  selected = "Year"),

      selectInput("varY",
                  "Variable for y-axis:",
                  list("Year" = "Year", 
                       "Imdb rating" = "imdbRating", 
                       "Metascore" = "Metascore", 
                       "Number of oscar awards" = "Academy.Awards", 
                       "Number of oscar nominations" = "Academy.Nominations", 
                       "Runtime (minutes)" = "Runtime"),
                  selected = "imdbRating")
      
  ),
  
  mainPanel(
      tabsetPanel(
          tabPanel("About",
                  p("This shiny app explores data from the movies that were nominated in the Oscar ceremonies."),
                  
                  br(),
                  p("The original dataset (which can be downloaded ",
                    a("here", href = "https://www.aggdata.com/free_data_awards_locations/academy_awards"),
                    ") lists information about each nomination. Since an award can either go to a film or to an 
                    artist, I processed the database to distinguish the two."),
                  br(),
                  p("From this, a second dataset was created and takes the point of view of each film. 
                    Number of academy nominations and awards were summed, and extra information was pulled out using the", 
                    a("omdb api.", href = "http://omdbapi.com/")),
                  
                  br(),
                  p("- The", strong("plot tab"),
                    "let you explore the relationship between several variables of the movie dataset."),
                  p("- The", strong("oscar tab"),
                    "include information about the academy awards. Each row corresponds to an Oscar nomination."),                  
                   
                  br(),
                  p("Other web applications explore movie databases in a similar fashion"),
                  p("- The", a("Academy Award Database", 
                    href = "http://awardsdatabase.oscars.org/ampas_awards/BasicSearchInput.jsp")), 
                  p("- The", a("Movie Explorer", 
                    href = "http://shiny.rstudio.com/gallery/movie-explorer.html")) 
                   ),         
          
          tabPanel("Graph", plotOutput("moviePlot")),
          tabPanel("Oscars", dataTableOutput("oscar")),

      )
  )
))
