# Codebook for run_analysis.R

## Requirements

1. The unzipped UCI HAR data set, including the following files and folder structure:
./UCI HAR Dataset:
activity_labels.txt  features.txt

./UCI HAR Dataset/test:
subject_test.txt  X_test.txt  y_test.txt

./UCI HAR Dataset/train:
Inertial Signals  subject_train.txt  X_train.txt  y_train.txt

This data set can be obtained here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. R working directory set to root of unzipped UCI HAR directory

3. R libraries:
* dplyr
* data.table

## Processing

### Import data
All the required files listed above are read as tables

### Combine datasets
1. Each of the "_test" tables' rows are appended to the bottom of their respective "_train" table, resulting in the following tables:
    * dataset: table of observations from X_train and X_test
    * subjects: table of subject numbers with each row listing the subject number for the corresponding observation in dataset
    * activity_numbers: table of activity numbers with each row listing the activity number for the corresponding observation in dataset
2. Variable names from HAR dataset's features.txt file are set as the variable names for their respective columns in the dataset table. 

### Remove extraneous columns
1. Variables with duplicate column names are removed from dataset
2. Variables that don't include mean or std in their names are removed from the dataset

### Add activities and subjects
1. The values in activity_numbers are replaced with their respective activity names
2. The resulting column of activity names is added to dataset and named Activity
3. The column of subject numbers from subjects is added to dataset and named Subjects

### cleanup names
All non-alphanumeric characters are deleted from the variable names in dataset

### Group and summarize data
1. dataset is grouped by Activity and Subjects (in that order)
2. Dataset is summarised, with mean of each column except Activity and Subjects

### Export tidy dataset
Data is exported to space-delimited text file named "tidy_results.txt"

### Key to tidy dataset's columns:
1. Activity - the name of the activity subject performed for each observation
2. Subject - the name of the subject for each observation
3. All other columns are variables defined in the features_info.txt file contained in the HAR dataset
