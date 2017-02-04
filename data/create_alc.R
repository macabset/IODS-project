#Maija Absetz// 4.2.2017
#This is Rstudio exercice 2 data wrangling part for student alcohol consumption.
full_mat <- read.csv("C:/Users/Petri/Documents/GitHub/IODS-project/data/student-mat.csv", header = TRUE, sep=";")
full_por <- read.csv("C:/Users/Petri/Documents/GitHub/IODS-project/data/student-por.csv", header = TRUE, sep=";")
str(full_mat)
str(full_por)
dim(full_mat)
dim(full_por)
# Both our data sets have 33 variables. Data from math course has 295 observations and data from portuguese course has 649 observations.

#Join the 2 datasets:
library(dplyr)
#Common columns: "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet"   
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
joined_math_por <- inner_join(full_mat, full_por, by= join_by, suffix= c(".full_mat", ".full_por"))
colnames(joined_math_por)
str(joined_math_por)
dim(joined_math_por)
#Now we have 53 variables and 382 observations.

#Lets concentrate on alcohol consumption.
#The if-else structure
alc <- select(joined_math_por, one_of(join_by))
#Not joined columns
notjoined_columns <- colnames(full_mat)[!colnames(full_mat) %in% join_by]
notjoined_columns

##Making a logical rule for the not joined columns:

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(joined_math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

glimpse(alc)

#Create alcohol usage + hgh alcohol usage to alcohol consumption data
library(ggplot2)
alc <- mutate(alc, alc_use= (Dalc + Walc)/2)
alc <- mutate(alc, high_use = (alc_use) > 2)

glimpse (alc)

#Saving project to data file
write.csv(alc, file = "C:/Users/Petri/Documents/GitHub/IODS-project/data/create_alc.csv", row.names = FALSE)
alc2016 <- read.csv("C:/Users/Petri/Documents/GitHub/IODS-project/data/create_alc.csv")

