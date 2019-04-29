library(data.table)
library(dplyr)

#Retrieving activity labels
activity_labels <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\activity_labels.txt")
activity_labels <- rename(activity_labels, activityID = V1, activitylabels = V2)

#Retrieving features
features <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\features.txt")
features <- rename(features, featureID = V1, featurename = V2)

#Retrieving Test Data (X_test)
X_test <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\test\\X_test.txt")
colnames(X_test) <- features[,2]

#Retrieving Test Data (Y_test)
Y_test <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\test\\Y_test.txt")
Y_test <- rename(Y_test, activityID = V1)

#Retrieving Test Data (Subject_Test)
subject_test <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\test\\subject_test.txt")
subject_test <- rename(subject_test, subjectID = V1)

#Generate test_data
test_data <- cbind(subject_test, X_test, Y_test)



#Retrieving Train Data (X_train)
X_train <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\train\\X_train.txt")
colnames(X_train) <- features[,2]

#Retrieving Test Data (Y_test)
Y_train <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\train\\Y_train.txt")
Y_train <- rename(Y_train, activityID = V1)

#Retrieving Test Data (Subject_Test)
subject_train <- read.table("C:\\Users\\10012212\\Downloads\\Week 4 Project Assignment\\UCI HAR Dataset\\train\\subject_train.txt")
subject_train <- rename(subject_train, subjectID = V1)
View(subject_test)

#Generate train_data
train_data <- cbind(subject_train, X_train, Y_train)


#Merge test_data and train_data
testtrain <- rbind(test_data, train_data)


#Extract mean and sd
testtrain <- testtrain[, grep("mean|std|activity|subject", names(testtrain))]

#Changing activtiy ID to the actual activity name
testtrain <- merge(testtrain, activity_labels, by = "activityID")


#Label the data set with descriptive variable name
names(testtrain) <- gsub("^t", "Time", names(testtrain))
names(testtrain) <- gsub("^f", "Frequency", names(testtrain))
names(testtrain) <- gsub("Acc", "Accelerate", names(testtrain))
names(testtrain) <- gsub("\\(|\\)", "", names(testtrain))
names(testtrain) <- gsub("Mag", "Magnitude", names(testtrain))
names(testtrain) <- gsub("std", "Std", names(testtrain))
names(testtrain) <- gsub("mean", "Mean", names(testtrain))
names(testtrain) <- gsub("Freq", "Frequency", names(testtrain))

#Average
testtrain2 <- group_by(testtrain, activityID, activitylabels, subjectID)
testtrain2 <- summarise_all(testtrain2, funs(mean))
write.table(testtrain2,file="tidydata.txt")


