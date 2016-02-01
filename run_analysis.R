
# read features
features <- read.table("UCI HAR Dataset/features.txt")[,2]
# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# read test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(X_test) = features

# Extracts only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
# Bind test data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# read train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merges the training and the test sets to create one data set.
data <- rbind(train_data, test_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt")