install.packages("dplyr")
library(dplyr)

## Reading all the information

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Step 1 

x<-rbind(x_train,x_test)
y<-rbind(y_train,y_test)
subject<- rbind(subject_train,subject_test)
mergedata<- cbind(subject,y,x)

#Step 2
tidydata<- mergedata %>% select( subject, code, contains("mean"), contains("std"))

#Step 3

tidydata$code<-activities[tidydata$code,2]
tidydata

#Step 4

View(tidydata)
names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "accelerometer", names(tidydata))
tidydata
names(tidydata)<-gsub("Gyro", "gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "body", names(tidydata))
names(tidydata)<-gsub("Mag", "magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "time", names(tidydata))
names(tidydata)<-gsub("^f", "frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "timebody", names(tidydata))
names(tidydata)<-gsub("-mean()", "mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "std", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "frequency", names(tidydata), ignore.case = TRUE)

#Step 5

finaldata<- tidydata %>% group_by(subject,activity) %>%
    summarise_all(funs(mean))

write.table(finaldata, "FinalData.txt",row.names = FALSE)

str(finaldata)

finaldata
