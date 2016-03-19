## 1. Merges the training and the test sets to create one data set

## First, read activity, subject and features files
dataActivityTest  <- read.table(file.path("test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path("train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path("train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path("test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path("test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path("train", "X_train.txt"),header = FALSE)

## Combine data tables by rows
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path("features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

##Merge columns to get the data frame Data for all data
dataCombine <- cbind(dataSubject, dataActivity)
tidyData <- cbind(dataFeatures, dataCombine)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement

##Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

##Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
tidyData<-subset(tidyData,select=selectedNames)

##3. Uses descriptive activity names to name the activities in the data set

##Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

##4. Appropriately labels the data set with descriptive variable names.

## Replace prefix t by time
names(tidyData)<-gsub("^t", "time", names(tidyData))
## Replace Acc by Accelerometer
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
## Replace Gyro by Gyroscope
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
## Replace prefix f by frequency
names(tidyData)<-gsub("^f", "frequency", names(tidyData))
## Replace Mag by Magnitude
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
## Replace BodyBody by Body
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr);
outputData<-aggregate(. ~subject + activity, tidyData, mean)
outputData<-outputData[order(outputData$subject,outputData$activity),]
write.table(outputData, file = "tidydata.txt",row.name=FALSE)
##Produce Codebook
update.packages(ask = FALSE, repos = 'http://cran.rstudio.org')
install.packages('knitr', repos = c('http://rforge.net', 'http://cran.rstudio.org'),
                 type = 'source')
library(knitr)
knit2html("codebook.Rmd")