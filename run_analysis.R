# run_analysis.R
#
# Getting and Cleaning Data
#
# Author: J. Muday
#
# goals:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
#       with the average of each variable for each activity and each subject.


#############################
# FUNCTION: fetch_project_files(dataDir)
#
# downloads and unzips to dataDir the master file for the project
# "dataDir" paramenter would be typically set to subdirectory of source file, but is not limited to that.

fetch_project_files <- function(dataDir) {
  
  # use my_local_directory, if available if not, then the current working directory
  my_local_project_directory <- '/Users/jeff/Google Drive/datascience/datacleaning/project'
  
  if (file.exists(my_local_project_directory)) {
    setwd(my_local_project_directory) # my development machine
  } else {
    setwd('.') # set current working directory on an unknown machine
  }
  
  # create data dir if necessary
  if (!file.exists(dataDir)) {
    dir.create(dataDir)
  }
  
  # fileURL as per project specifications, hardcoded below.
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  # our destination file
  zipFile <- 'Dataset.zip'
  destFile <- file.path(dataDir, zipFile)
  if (!file.exists(destFile)) {
    download.file(fileURL, destfile = destFile, mode = 'wb')
  }
  
  # unzip the file into the data directory
  unzip(destFile, exdir=dataDir)
}

###
# FUNCTION: get_metadata(dataDir,metadatafile)
#
# Helper function to pull out the metadata on features and subset only MEAN and STDDEV readings
# usage:
# feature_metadata <- get_metadata('./data/UCI HAR Dataset','features.txt')
# activity_metadata <- get_metadata('./data/UCI HAR Dataset','activity_labels.txt')

get_metadata <- function(dataDir, metadatafile) {
  require(stringr)
 
  thisfile <- file.path(dataDir,metadatafile)
  print(paste("FUNCTION: get_metadata(",thisfile,")"))
  this_dt <- read.table(thisfile)
  names(this_dt) <- c('index','label')
  # dispose of features that aren't in mean or standard deviation
  if (str_detect(metadatafile,fixed('features'))) {
    this_dt <- subset(this_dt, str_detect(label, fixed('mean()')) | str_detect(label,fixed('std()')))
  }
  print(paste("DONE: get_metadata(",thisfile,")"))
  return(this_dt)
}

############################
# FUNCTION: get_data()
# structure is duplicated in training and test
# example: get_data('./data','training') # fetches training data
#          get_data('./data','test')

get_data <- function(dataDir, subDir) {
  
  # Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
  # this is represented in activity_metadata in the parent frame
  # The sensors have MANY feature readings, we are interested in only mean() and std() (66 in total)
  # this is represented in feature_metadata in the parent frame
  
  # establish filenames for features, activities, and subjects
  current_dir     <- file.path(dataDir, subDir)
  
  # individual files we need to open... features, activites, subjects
  features_file   <- file.path(current_dir, paste0("X_", subDir, ".txt"))
  activities_file <- file.path(current_dir, paste0("Y_", subDir, ".txt"))
  subjects_file   <- file.path(current_dir, paste0("subject_", subDir, ".txt"))
  
  print(paste("FUNCTION: get_data() on ", current_dir))
  
  # First, get the features data
  print("::step 1: getting feature readings (please wait)...")
  features <- read.table(features_file)[feature_metadata$index]
  names(features) <- feature_metadata$label
  
  # start the CLEAN table with the features data
  my_clean_data <- features
  
  # Get the activities column and bind to my_clean_data
  print("::step 2:  getting activities...")
  activities <- read.table(activities_file)
  names(activities) <- c("activity")
  activities$activity <- factor(activities$activity, levels = activity_metadata$index, labels = activity_metadata$label)
  my_clean_data <- cbind(my_clean_data, activity = activities$activity)
  
  # Get the subjects column and bind to my_clean_data
  print("::step 3 : getting subject ids")
  subjects <- read.table(subjects_file)
  names(subjects) <- c("subject")
  my_clean_data <- cbind(my_clean_data, subject=subjects$subject)
  
  # Return the clean data
  print(paste("DONE: get_data() on <",subDir,">"))
  return(my_clean_data)
}

#########################
# FUNCTION: get_merge_data(dataDir)
# 
# This function merges the training data in the sub directory 'train'
# with the test data in sub directory 'test'

get_merge_data <- function(dataDir) {
  print("FUNCTION: get_merge_data()")
  
  training_dt <- get_data(dataDir,'train') # cleaned training data
  test_dt <- get_data(dataDir,'test') # cleaned test data
  
  # columns are identical, so we can perform a simple merge of rows from both datasets
  merge_dt <- rbind(training_dt,test_dt)
  
  print("DONE: get_merge_data()")
  return(merge_dt)
}

############################
# FUNCTION: do_reshape_data(merge_dt)
#
# Two pass process of melting and dcasting the merge_dt, using reshape2 "molten data"
#  shaping our table into identifier and measured variables.
# "subject" and "activity" are the identifier variables which cast our feature data as measured variables.
#
# my ideas were influenced by:
#   http://www.r-bloggers.com/reshape-and-aggregate-data-with-the-r-package-reshape2/

do_reshape_data <- function(merge_dt) {
  # install.packages("reshape2")
  require(reshape2) # must have
  
  print("FUNCTION: do_reshape_data()")
  
  # Melting the data table along IDENTIFIER variables -- subject and activity
  molten_dt <- melt(merge_dt, id = c("subject", "activity"))
  
  # Now, we dcast the variables by subject~activity then calculate mean related to the activity
  dcast_dt <- dcast(molten_dt, subject+activity~variable, mean)
  
  print("DONE: do_reshape_data()")
  return(dcast_dt)
}

####################
# FUNCTION: do_save_data(this_dt, destfile_txt, destfile_csv, datadir )
#
# simply saves this_dt to a destfile name and datadir in two analysis-friendly formats
#
# destfile_txt - filename to save as TXT file (whitespace delimited)
# destfile_csv - filename to save as CSV file (commad delimited)

do_save_data <- function(this_dt, destfile_txt, destfile_csv, datadir) {
  print("FUNCTION: do_save_data()")
  
  # save as TXT (whitespace delimited file)
  destpathname <- file.path(datadir,destfile_txt)
  write.table(this_dt, destpathname, quote=F, row.names=F)
  print(paste("::: saved TXT as",destpathname))
  
  # save as CSV (comma delimited file)
  destpathname <- file.path(datadir, destfile_csv)
  write.csv(this_dt, destpathname)
  print(paste("::: saved CSV as",destpathname))
  
  print("DONE: do_save_data()")
}

############
# MAIN SCRIPT EXECUTION
#############

dataDir <- './data'
destfile_txt <- 'clean_data.txt' # destination TXT file
destfile_csv <- 'clean_data.csv' # destination CSV file

unzipped_dataDir <- file.path(dataDir,'UCI HAR Dataset') # Unzipped data folder

fetch_project_files(dataDir) # get/download project data files

activity_metadata <- get_metadata(unzipped_dataDir,'activity_labels.txt') # get activity label metadata
feature_metadata <- get_metadata(unzipped_dataDir,'features.txt') # get the feature name, indices metadata

merge_dt <- get_merge_data(unzipped_dataDir) # clean and merge data

reshape_dt <- do_reshape_data(merge_dt) # reshape the data to "tidy standards"

do_save_data(reshape_dt, destfile_txt, destfile_csv, dataDir) # save into two analysis-friendly formats
print("*** PROJECT RUN COMPLETED ***")

