# Code Book

In fullfillment of this project, I created two files of cleaned data in data analysis friendly formats:

- `./data/clean_data.txt`
- `./data/clean_data.csv`

## Identification Labels

* `subject` - The subject ID
* `activity` - The activity performed during measurement

activities are in the set (WALKING,WALKING_UPSTAIRS,WALKING_DOWNSTAIRS,SITTING, STANDING,LAYING)

## Feature Columns

The feature columns contain measurements extracted from the test and training datasets

- tBodyAcc-mean()-X `(source column index 1)`
- tBodyAcc-mean()-Y `(source column index 2)`
- tBodyAcc-mean()-Z `(source column index 3)`
- tBodyAcc-std()-X `(source column index 4)`
- tBodyAcc-std()-Y `(source column index 5)`
- tBodyAcc-std()-Z `(source column index 6)`
- tGravityAcc-mean()-X `(source column index 41)`
- tGravityAcc-mean()-Y `(source column index 42)`
- tGravityAcc-mean()-Z `(source column index 43)`
- tGravityAcc-std()-X `(source column index 44)`
- tGravityAcc-std()-Y `(source column index 45)`
- tGravityAcc-std()-Z `(source column index 46)`
- tBodyAccJerk-mean()-X `(source column index 81)`
- tBodyAccJerk-mean()-Y `(source column index 82)`
- tBodyAccJerk-mean()-Z `(source column index 83)`
- tBodyAccJerk-std()-X `(source column index 84)`
- tBodyAccJerk-std()-Y `(source column index 85)`
- tBodyAccJerk-std()-Z `(source column index 86)`
- tBodyGyro-mean()-X `(source column index 121)`
- tBodyGyro-mean()-Y `(source column index 122)`
- tBodyGyro-mean()-Z `(source column index 123)`
- tBodyGyro-std()-X `(source column index 124)`
- tBodyGyro-std()-Y `(source column index 125)`
- tBodyGyro-std()-Z `(source column index 126)`
- tBodyGyroJerk-mean()-X `(source column index 161)`
- tBodyGyroJerk-mean()-Y `(source column index 162)`
- tBodyGyroJerk-mean()-Z `(source column index 163)`
- tBodyGyroJerk-std()-X `(source column index 164)`
- tBodyGyroJerk-std()-Y `(source column index 165)`
- tBodyGyroJerk-std()-Z `(source column index 166)`
- tBodyAccMag-mean() `(source column index 201)`
- tBodyAccMag-std() `(source column index 202)`
- tGravityAccMag-mean() `(source column index 214)`
- tGravityAccMag-std() `(source column index 215)`
- tBodyAccJerkMag-mean() `(source column index 227)`
- tBodyAccJerkMag-std() `(source column index 228)`
- tBodyGyroMag-mean() `(source column index 240)`
- tBodyGyroMag-std() `(source column index 241)`
- tBodyGyroJerkMag-mean() `(source column index 253)`
- tBodyGyroJerkMag-std() `(source column index 254)`
- fBodyAcc-mean()-X `(source column index 266)`
- fBodyAcc-mean()-Y `(source column index 267)`
- fBodyAcc-mean()-Z `(source column index 268)`
- fBodyAcc-std()-X `(source column index 269)`
- fBodyAcc-std()-Y `(source column index 270)`
- fBodyAcc-std()-Z `(source column index 271)`
- fBodyAccJerk-mean()-X `(source column index 345)`
- fBodyAccJerk-mean()-Y `(source column index 346)`
- fBodyAccJerk-mean()-Z `(source column index 347)`
- fBodyAccJerk-std()-X `(source column index 348)`
- fBodyAccJerk-std()-Y `(source column index 349)`
- fBodyAccJerk-std()-Z `(source column index 350)`
- fBodyGyro-mean()-X `(source column index 424)`
- fBodyGyro-mean()-Y `(source column index 425)`
- fBodyGyro-mean()-Z `(source column index 426)`
- fBodyGyro-std()-X `(source column index 427)`
- fBodyGyro-std()-Y `(source column index 428)`
- fBodyGyro-std()-Z `(source column index 429)`
- fBodyAccMag-mean() `(source column index 503)`
- fBodyAccMag-std() `(source column index 504)`
- fBodyBodyAccJerkMag-mean() `(source column index 516)`
- fBodyBodyAccJerkMag-std() `(source column index 517)`
- fBodyBodyGyroMag-mean() `(source column index 529)`
- fBodyBodyGyroMag-std() `(source column index 530)`
- fBodyBodyGyroJerkMag-mean() `(source column index 542)`
- fBodyBodyGyroJerkMag-std() `(source column index 543)`

## Extraction of Features and Activity Labels
I use the function `get_metadata()` to return a data frame which includes two columns.

### Feature Metadata contained in columns
- index: column source for feature (this contains only mean() and std() features)
- label: the label of the feature

```
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
activity_metadata <- get_metadata(unzipped_dataDir,'activity_labels.txt')
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