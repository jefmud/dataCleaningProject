
# This module fetches the dataset, if required

fetchProjectData <- function(dataDir) {
  setwd('/Users/jeff/Google Drive/datascience/datacleaning/project') # set on my machine
  setwd('.') # set local directory on an unknown machine
  
  # create data dir if necessary
  if (!file.exists(dataDir)) {
    dir.create(dataDir)
  }
  
  # fileURL as per project specifications
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  # our destination file
  zipFile <- 'Dataset.zip'
  destFile <- paste0(dataDir,'/',zipFile)
  if (!file.exists(destFile)) {
    download.file(fileURL, destfile = destFile, mode = 'wb')
  }
  
  # unzip the file into the data directory
  unzip(destFile, exdir=dataDir)
}