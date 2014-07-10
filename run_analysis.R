## Course Project
## Gregory Scott Wagner

library(plyr)

## Read in all files

features <- read.table(file="./features.txt", header=FALSE, sep="")
activity <- read.table(file="./activity_labels.txt", header=FALSE, sep="")
test.train <- read.table(file="./y_train.txt", header=FALSE, sep="")
test.test <- read.table(file="./y_test.txt", header=FALSE, sep="")
subject.train <- read.table(file="./subject_train.txt", header=FALSE, sep="")
subject.test <- read.table(file="./subject_test.txt", header=FALSE, sep="")
data.train <- read.table(file="./X_train.txt", header=FALSE, sep="")
data.test <- read.table(file="./X_test.txt", header=FALSE, sep="")

## Asssign names to variables and merge the train and test datasets

names(data.train) <- features[ , 2]
names(data.test) <- features[ , 2]
data <- rbind(data.test, data.train)

## Subset the mean and std data and remove special characters from the names

keep.columns <- grep("mean\\(\\)|std\\(\\)", names(data))
data <- data[ , keep.columns]

names(data) <- gsub("-", "", names(data))
names(data) <- gsub("\\(", "", names(data))
names(data) <- gsub("\\)", "", names(data))

##  Add the subject, test, and activity columns

columns.test <- join(test.test, activity, by="V1", match="all")
columns.test <- cbind(subject.test, columns.test)
names(columns.test) <- c("subject", "test", "activity")

columns.train <- join(test.train, activity, by="V1", match="all")
columns.train <- cbind(subject.train, columns.train)
names(columns.train) <- c("subject", "test", "activity")

add.columns <- rbind(columns.test, columns.train)
data <- cbind(add.columns, data)

## Calculate the means and gather our resulting tidy data frame

data.result <- aggregate(data[4:69], by=list(data$subject, data$activity), FUN=mean)
colnames(data.result)[1:2] <- c("subject", "activity")

## Output
data.result
write.table(data.result, file="./Data.CourseProject.txt")



