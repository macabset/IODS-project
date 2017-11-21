#Exercise 3 Data wrangling
##Jaakko Keinaenen 20.11.2017
## Data from: 
##P. Cortez and A. Silva. 
##Using Data Mining to Predict Secondary School Student Performance. 
##In A. Brito and J. Teixeira Eds., 
##Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7. 
## data available in https://archive.ics.uci.edu/ml/datasets/Student+Performance
getwd()
## read the file to dataset "mat" and explore the structure and dimensions
## of the data
mat <- read.csv("~/Documents/Jaakon tutkimus/Open data kurssi s2017/GitHub/IODS-project/data/student-mat.csv", header=T,
                sep=";")
str(mat); dim(mat)

## read the other file to dataset "por" and do the same
por <- read.csv("student-por.csv", header=T, sep=";")
str(por); dim(por)

#access dplyr to join the data
library(dplyr)

#choose variables used to join the data
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", 
             "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

#join the datasets by the chosen variables
mat_por <- inner_join(mat, por, by=join_by, suffix=c(".mat", ".por"))

# see the dim and str of the joined data
dim(mat_por); str(mat_por)

#combine duplicated answers in the joined data
colnames(mat_por)
# create a new data frame with only the joined columns
alc <- select(mat_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns
# if the duplicated columns are numeric, take the rounded average of the two
#if not, then use the answer from the first column
for(column_name in notjoined_columns) {
  two_columns <- select(mat_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}
#new variable alc_use is the average of weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#new variable high_use is true if alc_use > 2
alc <- mutate(alc, high_use = alc_use >2)
alc$high_use

#alc has 382 obs and 35 var
glimpse(alc)

#save data
write.csv(alc, "create_alc.csv", row.names=F)

alc <- read.csv("create_alc.csv")


#alc$X <- NULL


