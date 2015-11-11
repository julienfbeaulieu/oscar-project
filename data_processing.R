library(dplyr)

##set working directory
setwd('C:/Users/Julien/Google Drive/15 - coursera/dataproducts/project/oscar')

##load data
if(!file.exists("rawdata.csv")){
  download.file("http://www.aggdata.com/download_sample.php?file=academy_awards_07-17-13.csv", 
                destfile = "rawdata.csv")
}

oscar <- read.csv('rawdata.csv')

##count number of observations
n.nominees <- dim(oscar)[1]

##extract year of ceremony
oscar <- mutate(oscar, year = substr(Year,1,4))

## rearrange and rename variables
names(oscar) <- c("Ceremony","Category","Nominee", "Additional.Info", "Won.Academy.Award", "Year")
oscar <- oscar[,c(6,1,2,3,4,5)]

##remove first ceremony data (unreliable and erratic data)
oscar <- subset(oscar, Year >= 1928)

##count number of observations
n.nominees <- dim(oscar)[1]

## list of categories
categories <- unique(oscar$Category) 

awarded2Artist <- categories[1:4]
awarded2Film <- categories[5:23]

Artist <- rep(NA,n.nominees)
Film <- rep(NA,n.nominees)

## extract Film and Artist informations
for (i in 1:n.nominees) {
  
  ### case where award is given to the artist
  if (oscar$Category[i] %in% awarded2Artist){
    
    Artist[i] <- as.character(oscar$Nominee[i])
    
    findbracket <- regexpr("\\{",oscar$Additional.Info[i])
    Film[i] <- substr(oscar$Additional.Info[i],1,findbracket-2)
    
    
  }
  
  ### case where award is given to the film itself
  if (oscar$Category[i] %in% awarded2Film){
    
    Film[i] <- as.character(oscar$Nominee[i])
    Artist[i] <- as.character(oscar$Additional.Info[i])
  }
  
}

## add new information to dataframe
oscar <- cbind(oscar, Film, Artist)

## Combine date and film for more precision
Film.ID <- rep(NA,n.nominees)

for (i in 1:n.nominees) {
  if (!is.na(oscar$Film[i])){
    Film.ID[i] <- paste0(oscar$Film[i]," (", oscar$Year[i], ")")
  } 
}
oscar <- cbind(oscar,Film.ID)

## subset for only awarded nominees
oscar.awarded <- subset(oscar, Won.Academy.Award == "YES")

##export oscar databases
write.csv(oscar, "oscar.csv")
write.csv(oscar, "oscar_awarded.csv")


