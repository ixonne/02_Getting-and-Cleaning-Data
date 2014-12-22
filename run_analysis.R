#Merges the training and the test sets to create one data set.


# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

## run_analysis.R

## read data
setwd("UCI HAR Dataset/")

# 1. Merges the training and the test sets to create one data set.

features     <-read.table("features.txt")["V2"]
activityType <-read.table("activity_labels.txt")["V2"]

setwd("train")
subject_train<-read.table("subject_train.txt")
X_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
names(X_train)<-features$V2
names(subject_train)<- "Subjects"
names(y_train)<- "Activity"

setwd("../test/")
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
names(X_test)<-features$V2
names(subject_test)<- "Subjects"
names(y_test)<- "Activity"

#merge test with train
train_set <-cbind(subject_train, y_train, X_train)
test_set <- cbind(subject_test, y_test, X_test)


test_train_set <- rbind(train_set, test_set)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

#create vector with colnames
means_and_std_colnames <- colnames(test_train_set)
means_and_std_colnames<-grep("Subjects|Activity|-mean|Mean|-std", means_and_std_colnames)

set <- subset(test_train_set, select=means_and_std_colnames)

# 3. Uses descriptive activity names to name the activities in the data set
#set <- merge(set, activityType, by="Activity", all.x=TRUE)
set$Activity <- activityType[set$Activity,]
colNames <- colnames(set)

# 4. Appropriately labels the data set with descriptive variable names. 
for (i in 1:length(colNames))
{
  colNames[i] = gsub("^t", "time", colNames[i])
  colNames[i] = gsub("^f", "freq", colNames[i])
  colNames[i] = gsub("-mean", "Mean", colNames[i])
}
colnames(set)<- colNames


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

tidy<-aggregate(set[,3:ncol(set)],by=list(Subjects=set$Subjects, Activity=set$Activity), mean)
tidy<-tidy[order(tidy$Subjects),]

setwd("../../")
write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
