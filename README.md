# Getting and Cleaning Data Project

## run_analysis.R

The script `run_analysis.R` is a single file script that performs the following steps on
the data.

0. If required, creates a data folder and downloads the dataset and unzips the ZIP archive
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Sample of the script run

Note: to run this script, you should download the script into a user documents
or project directory and ensure that you set
the working directory to one in which you can create directories and files.

```
> setwd('.')
> source('run_analysis.R')
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 MB)
downloaded 59.7 MB

Loading required package: stringr
[1] "FUNCTION: get_metadata( ./data/UCI HAR Dataset/activity_labels.txt )"
[1] "DONE: get_metadata( ./data/UCI HAR Dataset/activity_labels.txt )"
[1] "FUNCTION: get_metadata( ./data/UCI HAR Dataset/features.txt )"
[1] "DONE: get_metadata( ./data/UCI HAR Dataset/features.txt )"
[1] "FUNCTION: get_merge_data()"
[1] "FUNCTION: get_data() on  ./data/UCI HAR Dataset/train"
[1] "::step 1: getting feature readings (please wait)..."
[1] "::step 2:  getting activities..."
[1] "::step 3 : getting subject ids"
[1] "DONE: get_data() on < train >"
[1] "FUNCTION: get_data() on  ./data/UCI HAR Dataset/test"
[1] "::step 1: getting feature readings (please wait)..."
[1] "::step 2:  getting activities..."
[1] "::step 3 : getting subject ids"
[1] "DONE: get_data() on < test >"
[1] "DONE: get_merge_data()"
Loading required package: reshape2
[1] "FUNCTION: do_reshape_data()"
[1] "DONE: do_reshape_data()"
[1] "FUNCTION: do_save_data()"
[1] "::: saved TXT as ./data/clean_data.txt"
[1] "::: saved CSV as ./data/clean_data.csv"
[1] "DONE: do_save_data()"
[1] "*** PROJECT RUN COMPLETED ***"
> 
```
## The Main Execution area

The Main execution area of the script is fairly self-documented by the following calls made to 
functions. Each code line performs an integral function described by its name.

- `fetch_project_files()` - downloads files if they haven't already been downloaded
- `get_metadata()` - is called twice... once for activity labels, and again for feature labels/indices
- `get_merge_data()` - merges the test and training data sets into `merge_dt` data frame.
- `reshape_dt()` - reshapes the data into a "molten" form and dcast on subject and activity
- `do_save_data()` - takes our reshape_dt and saves into a TXT and CSV tidy data table

```
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
```

## Extraction of Features and Activity Labels
I use the function `get_metadata()` to return a data frame which includes two columns.  I would not have
automated this but there were so many readings, that it was smarter to read the features and use this also to
created part of the CodeBook.md markdown in the file `features.md`

The `get_metadata()` function can be run in isolation to examine which activities and features are
contained in the files supplied for the project.

### Feature Metadata contained in columns
- index: column source for feature (this contains only mean() and std() features)
- label: the label of the feature

```
> unzipped_dataDir <- file.path(dataDir,'UCI HAR Dataset')
> feature_metadata <- get_metadata(unzipped_dataDir,'features.txt')
> str(feature_metadata)
'data.frame':	66 obs. of  2 variables:
 $ index: int  1 2 3 4 5 6 41 42 43 44 ...
 $ label: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 455 456 457 462 ...
> feature_metadata$index
 [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85  86 121 122 123 124 125 126 161 162 163 164 165 166
[31] 201 202 214 215 227 228 240 241 253 254 266 267 268 269 270 271 345 346 347 348 349 350 424 425 426 427 428 429 503 504
[61] 516 517 529 530 542 543
> feature_metadata$label
 [1] tBodyAcc-mean()-X           tBodyAcc-mean()-Y           tBodyAcc-mean()-Z           tBodyAcc-std()-X           
 [5] tBodyAcc-std()-Y            tBodyAcc-std()-Z            tGravityAcc-mean()-X        tGravityAcc-mean()-Y       
 [9] tGravityAcc-mean()-Z        tGravityAcc-std()-X         tGravityAcc-std()-Y         tGravityAcc-std()-Z        
[13] tBodyAccJerk-mean()-X       tBodyAccJerk-mean()-Y       tBodyAccJerk-mean()-Z       tBodyAccJerk-std()-X       
[17] tBodyAccJerk-std()-Y        tBodyAccJerk-std()-Z        tBodyGyro-mean()-X          tBodyGyro-mean()-Y         
[21] tBodyGyro-mean()-Z          tBodyGyro-std()-X           tBodyGyro-std()-Y           tBodyGyro-std()-Z          
[25] tBodyGyroJerk-mean()-X      tBodyGyroJerk-mean()-Y      tBodyGyroJerk-mean()-Z      tBodyGyroJerk-std()-X      
[29] tBodyGyroJerk-std()-Y       tBodyGyroJerk-std()-Z       tBodyAccMag-mean()          tBodyAccMag-std()          
[33] tGravityAccMag-mean()       tGravityAccMag-std()        tBodyAccJerkMag-mean()      tBodyAccJerkMag-std()      
[37] tBodyGyroMag-mean()         tBodyGyroMag-std()          tBodyGyroJerkMag-mean()     tBodyGyroJerkMag-std()     
[41] fBodyAcc-mean()-X           fBodyAcc-mean()-Y           fBodyAcc-mean()-Z           fBodyAcc-std()-X           
[45] fBodyAcc-std()-Y            fBodyAcc-std()-Z            fBodyAccJerk-mean()-X       fBodyAccJerk-mean()-Y      
[49] fBodyAccJerk-mean()-Z       fBodyAccJerk-std()-X        fBodyAccJerk-std()-Y        fBodyAccJerk-std()-Z       
[53] fBodyGyro-mean()-X          fBodyGyro-mean()-Y          fBodyGyro-mean()-Z          fBodyGyro-std()-X          
[57] fBodyGyro-std()-Y           fBodyGyro-std()-Z           fBodyAccMag-mean()          fBodyAccMag-std()          
[61] fBodyBodyAccJerkMag-mean()  fBodyBodyAccJerkMag-std()   fBodyBodyGyroMag-mean()     fBodyBodyGyroMag-std()     
[65] fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std() 
477 Levels: angle(tBodyAccJerkMean),gravityMean) angle(tBodyAccMean,gravity) ... tGravityAccMag-std()
```


### Activity Metadata contained in columns
- index: ordinal of the activity label
- label: the activity label (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

```
> activity_metadata <- get_metadata(unzipped_dataDir,'activity_labels.txt')
> str(activity_metadata)
'data.frame':	6 obs. of  2 variables:
 $ index: int  1 2 3 4 5 6
 $ label: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1
 > activity_metadata$index
[1] 1 2 3 4 5 6
> activity_metadata$label
[1] WALKING            WALKING_UPSTAIRS   WALKING_DOWNSTAIRS SITTING            STANDING           LAYING            
Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS
```

```
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
```

## Reshaping the data

I reshape the data with a two-pass process of melting and dcasting the merge_dt, using reshape2 "molten data"
shaping our table into identifier and measured variables.
The "subject" and "activity" are the identifier variables which cast our feature data as measured variables.

My implementation ideas were influenced by the excellent blog post:

- http://www.r-bloggers.com/reshape-and-aggregate-data-with-the-r-package-reshape2/

```############################
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
```

