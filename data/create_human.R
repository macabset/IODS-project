#16.2.2017//Maija Absetz
#DAta Wrangling for the dimensionality

??ggpairs()
??ggplot()
?select()
??bind
boston_scaled2["km"] <- km
boston_scaled2$km <- kmeans(dist_eu, centers = 2)

#This function is from Veikko Isotalo to get my files more open to everyone.
install.packages("corrplot")
install.packages("tidyr")
initialsetup <- function(projectWD){
  setwd(projectWD)
  library(magrittr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
}
k <- "/Users/Murmeli/Documents/GitHub/IODS-project/data"
initialsetup(k)
getwd()


#REad files HUman development and gender inequality

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)



