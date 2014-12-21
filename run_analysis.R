run_analysis <- function() {

  ## This function needs to be run with working directory set to UCI Har Dataset folder
  ## with the original structure of that folder intact
  
  ## load libraries
  library(dplyr)
  library(data.table)

  ## import all the relevant files
  activity_labels <- read.table("activity_labels.txt")
  features <- read.table("features.txt")
  subject_train <- read.table("train//subject_train.txt")
  x_train <- read.table("train//X_train.txt")
  y_train <- read.table("train//y_train.txt")
  subject_test <- read.table("test//subject_test.txt")
  x_test <- read.table("test//X_test.txt")
  y_test <- read.table("test//y_test.txt")
  
  ## merge test and training files
  dataset <- rbind(x_train, x_test)
  subjects <- rbind(subject_train, subject_test)
  activity_numbers <- rbind(y_train, y_test)
  
  ## name dataset variables by features
  feature_labels <- as.character(features[,2])
  setnames(dataset, feature_labels)
  
  ## remove columns with duplicate names
  dupindex <- duplicated(feature_labels)
  dataset[,dupindex] <- list(NULL)
  
  ## extract measurements of interest
  slim_dataset <- cbind(select(dataset, contains("mean")), select(dataset, contains("std")))
  
  ## Add activities column
  mergedlabels <- inner_join(activity_numbers, activity_labels)
  names(mergedlabels)[2] <- "Activity"
  labeled_dataset <- cbind(mergedlabels[2], slim_dataset)
  
  ## Add subjects column
  names(subjects)[1] <- "Subject"
  labeled_dataset <- cbind(subjects, labeled_dataset)

  ## Cleanup names
  names(labeled_dataset) <- gsub("[^a-zA-Z0-9]", "", names(labeled_dataset))
  
  ## Summarize data by groups
  data_summary <- labeled_dataset %>%
    group_by(Activity, Subject) %>%
    summarise_each(funs(mean), tBodyAccmeanX:fBodyBodyGyroJerkMagstd)
  
  ## Write results to new, tidy data set
  write.table(data_summary, "tidy_results.txt")
  
}


