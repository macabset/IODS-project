#RStudio exercise 2, take 2
#Maija Absetz//27.1.2017

#2
full_learn14<- read.table( "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
str(full_learn14)
dim(full_learn14)
#It's got 60 variables and 184 observations in those 60 variables.
#THe structure shows what's the content of the factors and dimensions how many observations and variables.
install.packages("dplyr")
library(dplyr)

#3.
full_learn14$gender
full_learn14$Age
full_learn14$Points

#Create stra, deep abd surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
#Combine questions with mean and rename
deep_columns <- select(full_learn14, one_of(deep_questions))
full_learn14$deep <- rowMeans(deep_columns)

surface_columns <- select(full_learn14, one_of(surface_questions))
full_learn14$surf <- rowMeans(surface_columns)

strategic_columns <- select(full_learn14, one_of(strategic_questions))
full_learn14$stra <- rowMeans(strategic_columns)

#Pick columns for your sub_data
New_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
sub_learn14 <- select(full_learn14, one_of(New_columns))
                      
str(sub_learn14)

#Exclude "0" values out of "Points"
sub_learn14 <- filter(sub_learn14, Points >! 0)

#4. SAve to iods-project.

