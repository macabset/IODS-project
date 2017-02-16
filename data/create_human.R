#16.2.2017//Maija Absetz
#DAta Wrangling for the dimensionality


#how to make more readable?

#Setting the working directory to my computer:

library(Matrix)
library(ggplot2)
library(dplyr)

setwd("C:/Users/Murmeli/Documents/GitHub/IODS-project/data/")
getwd()
#REad files Hman development and gender inequality to R

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)
str(gii)
dim(gii)

#We have 2 datasets that we eventually want to combine, but let's first see what we have.
#Human development focuses what are the factors that determine how well our country ranks when looking at human development. It has 8 variables and 195 observations. VAriables are both numeric and character.
#Gender inequality tries to grasp the inequality between men and women in achievements. It focuses on health, empowerement and work markets. This dataset contains 10 variables and also 195 observations( since it's based on the same resaerch??). This dataset has also both numeric and character variables.

summary(hd)
summary(gii)

#Let's give our variables shorter names, so they will be easier to use further.
colnames(hd)
colnames(hd)[1] <-"Rank"
colnames(hd)[3] <-"HDI"
colnames(hd)[4] <- "Life_expect"
colnames(hd)[5] <- "Edu_expect"
colnames(hd)[6] <- "Edu_years"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI-Rank"
colnames(hd)


colnames(gii)
colnames(gii)[1] <- "Rank"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mom_death"
colnames(gii)[5] <- "Young_birth"
colnames(gii)[6] <- "Present_parl"
colnames(gii)[7] <- "Edu2F"
colnames(gii)[8] <- "Edu2M"
colnames(gii)[9] <- "LabF"
colnames(gii)[10] <- "LabM"
colnames(gii)

#Mutate: gii
#2 new variables

gii <- mutate(gii, Sex_edu2 = Edu2F / Edu2M)
gii <- mutate(gii, Lab_ratio = LabF/LabM)
colnames(gii)
gii <- dplyr::select(gii, -sex_edu2)
colnames(gii)

#Join datasets by country
join_by <- c("Country")


hdi_gii <- inner_join(hd, gii, by= join_by, suffix= c(".hd", ".gii"))
colnames(hdi_gii)


#Saving project to data file


write.csv(hdi_gii, file = "human.csv", row.names = FALSE)
human <- read.csv("human.csv", sep=",", header= T)
str(human)
