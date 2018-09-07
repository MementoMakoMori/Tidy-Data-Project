#import packages
library("dplyr", "plyr")

#read test files
test.subjects <- read.delim("./test/subject_test.txt", header = FALSE)
test.data <- read.delim("./test/X_test.txt", header = FALSE, sep = "", colClasses = "numeric")
test.label <- read.delim("./test/Y_test.txt", header = FALSE)


#read train files
train.subjects <- read.delim("./train/subject_train.txt", header = FALSE)
train.data <- read.delim("./train/X_train.txt", header = FALSE, sep = "", colClasses = "numeric")
train.label <- read.delim("./train/Y_train.txt", header = FALSE)


#read activity code and feature labels
activity.code <- read.delim("./activity_labels.txt", sep = "", header = FALSE)
feature.labels <- read.delim("./features.txt", header = FALSE, sep = "", colClasses = "character")

##now that all the files are in, start the project instructions
#1. merge training and test data into one dataset
#apply feature labels to both data sets so they have same column names for binding
colnames(test.data) <- feature.labels[,2]
colnames(train.data) <- feature.labels[,2]
comb.data <- rbind(test.data, train.data)

#2. extract only mesaurements on mean and standard deviation
select.factors <- grep("mean|std", colnames(comb.data), ignore.case = TRUE, value = TRUE)
selected <- comb.data[, select.factors]

#3. use descriptive activity names
comb.label <- rbind(test.label, train.label)
comb.label <- join(comb.label, activity.code)

comb.label <- comb.label[,2]

selected <- cbind(comb.label, selected)

#4. use descriptive variable names
#these labels were applied in step 1 and selected variable stored in select.factors
#so now I am going to make sure subject and activity are labeled properly
subjects <- rbind(test.subjects, train.subjects)
selected <- cbind(subjects, selected)
colnames(selected) <- c("Subject", "Activity", select.factors)

#5. new dataset with averages for each activity and subject
group.data <- group_by(selected, Subject, Activity)
final <- summarize_all(group.data, mean)
write.table(final, file = "tidy_data.txt", sep = "\t", row.names = FALSE)
