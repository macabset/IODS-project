#16.2.2017//Maija Absetz
#Data Wrangling for the dimensionality
#This data is originally from United Nations Development Programme(http://hdr.undp.org/en/content/human-development-index-hdi)


#Setting the needed packages and working directory to my computer:

library(Matrix)
library(ggplot2)
library(dplyr)

getwd()

#Read files Human development and gender inequality to R

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)
str(gii)
dim(gii)

#We have 2 datasets that we eventually want to combine, but let's first see what we have.
#Human development focuses what are the factors that determine how well our country ranks when looking at human development. It has 8 variables and 195 observations. Variables are both numeric and character.
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

#Join datasets by country
join_by <- c("Country")


hdi_gii <- inner_join(hd, gii, by= join_by, suffix= c(".hd", ".gii"))
colnames(hdi_gii)


#Saving project to data file


write.csv(hdi_gii, file = "human.csv", row.names = FALSE)
human <- read.csv("human.csv", sep=",", header= T)

#And final check that everything works.
str(human)

#This is continuum for last week's data wrangling. We are continuing with the same data.
#1. mutate data GNI to numeric

human <- mutate(human, GNI = as.numeric(human$GNI))
str(human)

#2. Keep columns: (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"

keep_columns <- c("Country", "Sex_edu2", "Lab_ratio", "Edu_expect", "Life_expect", "GNI", "Mom_death", "Young_birth", "Present_parl")
human <- select(human, one_of(keep_columns))
str(human)

#3.Remove rows with missing values
  #create column with missing values and then filter leaving NA's out.
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human))
complete.cases(human)
str(human)

#Let's clean the column country and filter regions out
#The last 7 rows with column country are infact regions instead of countries.
last <- nrow(human) - 7
last
# I'll choose everything until the last 7 observations, the 155's being Nigeria.
human <- human[1:155, ]
str(human)

#4. add countries as rownames and remove country as column

rownames(human) <- human$Country
#Remove country as column
human <- dplyr::select(human, -Country)
str(human)
head(human)

#Now we have wanted 155 observations and 8 variables, with countries as rownames.
#override the old data:

write.csv(human, file = "human.csv", row.names = FALSE)
human <- read.csv("human.csv", sep=",", header= T)
str(human)
summary(human)
complete.cases(human)
head(human)

