#### COURSE PROJECT ####

# 1. Merge the training and test sets to create one data set
# 2. Extract only the measurements on the mean and std. dev for each measurement
# 3. Uses descriptive activity names to name the activities in the data set 
# 4. Appropriately labels the data set with descriptive variable names 
# 5. Create a second, independent tidy data set with the average of each variable for each activity and subject


## Download the file and unzip
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(url, destfile = "./data/UCI HAR Dataset.zip") 
unzip("./data/UCI HAR Dataset.zip") 

## read data sets into R ##
features <- read.table("./data/UCI Har Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

# Merge training and test data set to create one data set
all_x <- rbind(x_test, x_train)
colnames(all_x) <- c(as.character(features[,2]))

# Extract only the mean and std. dev for each measurement
## Get indexes of the means and std. devs
all_means_indexes <- grep("mean()",colnames(all_x), fixed = TRUE)
all_stddev_indexes <- grep("std()",colnames(all_x),fixed = TRUE)
## Subset the data
subset_meansd <- all_x[,c(all_means_indexes, all_stddev_indexes)]

# Appropriately labels the data set with descriptive variable names 
all_y <- rbind(y_test, y_train)
all_activities <- cbind(all_y, subset_meansd)
colnames(all_activities)[1]<- "Activity"

#Use descriptive activity names
activity_labels[,2]<- as.character(activity_labels[,2])
count_act <- length(all_activities[,1])

for ( i in 1:count_act){
  all_activities[i,1] <- activity_labels[all_activities[i,1],2]
}

# Create a second, independent tidy data set with the average of each variable for each activity
all <- cbind(all_subjects, all_activities)
colnames(all)[1] <- "subject"
library(plyr)
new_tidy_data <- aggregate(all[,3]~subject+Activity, data = all, FUN = "mean")

for(i in 4:ncol(all)){ 
     new_tidy_data[,i] <- aggregate( all[,i] ~ subject+Activity, data = all, FUN= "mean" )[,3] 
   }  

colnames(new_tidy_data)[3:ncol(new_tidy_data)] <- colnames(subset_meansd) 
 
write.table(new_tidy_data, file = "TidyData.txt") 

