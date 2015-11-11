library(jsonlite)
library(dplyr)

##set working directory
setwd('C:/Users/Julien/Google Drive/15 - coursera/dataproducts/project/oscar')

##load data
oscar <- read.csv("oscar.csv")
oscar.awarded <- read.csv("oscar_awarded.csv")

##count number of nomination and awards for each film
nominations <- as.data.frame(table(oscar$Film.ID)) 
awards <- as.data.frame(table(oscar.awarded$Film.ID))

years <- unique(oscar[,c(10,8,2)])
names(years) <- c("Film.ID", "Title", "Year")

##combine nominations and awards and start building the movie database
movie <- as.data.frame(cbind(nominations, awards$Freq))
names(movie) <- c("Film.ID", "Academy.Nominations", "Academy.Awards")
movie <- merge(years, movie, by = "Film.ID")

n.films <- dim(movie)[1]

##for each film, extract OMDb information
raw <- list()

for (f in 1:n.films) {
  
  ### form url for request
  t <- gsub(" ", "+", as.character(movie$Title[f]))
  y <- as.character(movie$Year[f])
  url <- paste0("http://www.omdbapi.com/?t=",t,"&y=",y,"&plot=short&r=json")
  
  ### call OMDb
  temp <- as.data.frame(fromJSON(url))
  
  if (temp$Response == "False") {
    t2 <- substr(t,2,6)
    url2 <- paste0("http://www.omdbapi.com/?t=",t2,"&y=",y,"&plot=short&r=json")
    temp <- as.data.frame(fromJSON(url2))
  }
  
  raw[[f]] <- temp
  
}

## Close connections
closeAllConnections()

## Combine omdb information with movie data frame
omdb <- rbind.pages(raw)
movie <- cbind(movie, omdb)

## Extract first country of movie
Country1 <- rep("NA",n.films)

for (f in 1:n.films) {
  comma <- regexpr(",",movie$Country[f])
  
  if (is.na(comma) == "FALSE"){
    if (comma > 0) {
      Country1[f] <- substr(movie$Country[f],1,comma-1)
    }
    else {
      Country1[f] <- as.character(movie$Country[f]) 
    } 
  }
}
movie <- cbind(movie,Country1)

## Process first genre of movie
Genre1 <- rep("NA",n.films)

for (f in 1:n.films) {
  comma <- regexpr(",",movie$Genre[f])
  
  if (is.na(comma) == "FALSE"){
    if (comma > 0) {
      Genre1[f] <- substr(movie$Genre[f],1,comma-1)
    }
    else {
      Genre1[f] <- as.character(movie$Genre[f]) 
    } 
  }
}
movie <- cbind(movie,Genre1)

##Remove repetititve information
movie <- movie[,c(-6,-7)]

##convert certains variables to numerics
movie <- transform(movie, 
                   imdbRating = as.numeric(as.character(imdbRating)),
                   Metascore = as.numeric(as.character(Metascore)),
                   Runtime = as.numeric(gsub("\\D", "", Runtime)))


##Export movie database
write.csv(movie, "movie.csv")
