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

#4. SAve to iods-project as csv format

?write.csv

write.csv(sub_learn14, file = "learning2014.csv", row.names = FALSE)
lrn2014 <- read.csv("learning2014.csv")


head(lrn2014)

#Part 2: Analysis (max 15p)
#2.1: Exploring our dataset

str(lrn2014)
dim(lrn2014)

# Here you can see the learning2014 dataset, whih has 7 variables with 166 observations. 
#This questionnary has been collected from students from course Introduction to Social Statistics, fall 2014 (Finnish)
#Dataset has been modified so that questions has been combined and Point values of 0 has been removed.

summary(lrn2014)
install.packages("ggplot2")
library(ggplot2)

#In our summary we can see that all variables except gender are numeric with continuous values.

#2.2 Picturing our dataset

A <- ggplot(lrn2014, aes(x= Attitude, y=Points, col=gender))
B <- A +geom_point()

C <- B + geom_smooth(method = "lm")

Figure1 <-C + ggtitle("The Relationship between attitude and points")
Figure1

# Figure 1 shows us how attitude towards statistics correlate the points from exam. In this case, such in many others, motivation explains partly success.


#EXTRA: Combinig strategic learning to points.
D <- ggplot(lrn2014, aes(x=stra, y=Points, col=gender))
D1 <- D + geom_point()
D2 <- D1 + geom_smooth(method="lm")
Figure2 <- D2 + ggtitle("The Relationship between Strategic Learning and Points")
Figure2
#If we look at Figure 2 there seems to be very small linear relationship between strategic learning and exam points. If student used strateg learning method for exam, he or she might have gained a bit better exam points.

#2.3 Regression model
#Choosing explaining variables
install.packages("GGally")
library(GGally)
ggpairs(lrn2014, lower= list(combo = wrap("facethist", bins = 20)))

#As we can see in our plot matrix, variables Attitude, stra and surf correlate the most with points. Lets try those as explanatory values in opur regression model.

#Explaining points with attitude, agge and strategic learning

my_reg <- lm(Points ~ Attitude + stra + surf, data = lrn2014 )
summary(my_reg)

# Attitude seems to be the only one statistically significant in explaining points. This result compatitive with our result in Figure 2, where correlation between strategic learning and points was bearly noticeable.
#Let's remove first surf and see again our model

my_reg2 <- lm(Points ~ Attitude + stra, data = lrn2014)
summary(my_reg2)

#The strategic learning gives still too high p-value, so we cannot exclude it being significant by chance.
#Let's try our regression model with only attitude explaining it.

my_reg3 <- lm(Points ~ Attitude, data=lrn2014)
summary(my_reg3)

#It seems that attitude towards statistics is our key explanatory variable to exam points. The more poisitive attitude toward statistics in general the better outcome in exam.
# 2.4 R-squared
#Then we should look at our R-squared figures to see how well our model fits to our observations.
#Our 3 tests of regression model show that our Multiple R-squared lowers each time we drop a variable. That happens, because it increases every time you add a variable.
#What we also see is that the 2nd test has the highest adjusted R-square, even though it has more variables than the last one.
# I conclude that we still should consider bringing back strategic learning to our multiple regression model, even though its p-value is over magical line of 0.05.

#2.5 Errors in our model
#Let's check Residuals vs Fitted values, Normal QQ-plot and Residuals vs Leverage.
#2.4