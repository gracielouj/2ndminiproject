# 2nd Mini Project

## Problem 1
Create one R script called run_analysis.R that does the following:
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive activity names.
 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

- Load package for functions like `select()` or `summarise()` to efficiently manipulate datasets 
```R
library(dplyr)
```

- Read all the data and apply column names
```R
test_x <- read.table("specdata/test/X_test.txt", col.names = features$functions)
test_y <- read.table("specdata/test/y_test.txt", col.names = "code")
test_subject <- read.table("specdata/test/subject_test.txt", col.names = "subject")
train_subject <- read.table("specdata/train/subject_train.txt", col.names = "subject")
train_x <- read.table("specdata/train/X_train.txt", col.names = features$functions)
train_y <- read.table("specdata/train/y_train.txt", col.names = "code")
features <- read.table("specdata/features.txt", col.names = c("n","functions"))
activities <- read.table("specdata/activity_labels.txt", col.names = c("code", "activity"))
```

- Bind the rows into `x_data`, `y_data`, and `subject datasets`. Then, merge those three together to create one dataset
```R
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
subject <- rbind(train_subject, test_subject)
merged <- cbind(subject, y_data, x_data)
```

- Filter out only those columns that mentioned mean or std in them. The select() function is used to tidy the code and extract only the measurements on the mean and standard deviation for each measurement
```R
data <- merged %>% select(subject, code, contains("mean"), contains("std"))
```

- Replace the numerical activity label with the actual label of the activities.
```R
data$code <- activities[data$code, 2]
```

- Enhance readability by using `names()` which will give you only the column names of the dataset you’ve provided to it. `gsub()` will replace an old string with the new string you pass to it. 
```R
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
```

- Take the mean of each feature in the data dataset and represent them both by activity and subject using `group_by()` and `summarise()`.
```R
tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
```
