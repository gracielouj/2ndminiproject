library(dplyr)

# Reads all the data
test_x <- read.table("specdata/test/X_test.txt", col.names = features$functions)
test_y <- read.table("specdata/test/y_test.txt", col.names = "code")
test_subject <- read.table("specdata/test/subject_test.txt", col.names = "subject")
train_subject <- read.table("specdata/train/subject_train.txt", col.names = "subject")
train_x <- read.table("specdata/train/X_train.txt", col.names = features$functions)
train_y <- read.table("specdata/train/y_train.txt", col.names = "code")
features <- read.table("specdata/features.txt", col.names = c("n","functions"))
activities <- read.table("specdata/activity_labels.txt", col.names = c("code", "activity"))

# 1. Merges the training and the test sets to create one data set
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
subject <- rbind(train_subject, test_subject)
merged <- cbind(subject, y_data, x_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
data <- merged %>% select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the dataset
data$code <- activities[data$code, 2]

# 4. Appropriately labels the data set with descriptive variable names
names(data)[2] = "activity"
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
