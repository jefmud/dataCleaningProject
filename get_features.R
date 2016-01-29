# get_features.R
#
# Get column names and indices
#
# Author: Jeff Muday
#
# based on: University of California Irvine machine learning dataset

###
# FUNCTION: get_feature_metadata(destfile)
#
# Helper function to pull out the metadata on features and subset only MEAN and STDDEV readings

get_feature_metadata <- function(dataDir) {
  require(stringr)
  featurefile <- file.path(dataDir,'features.txt')
  all_features_dt <- read.table(featurefile)
  names(all_features_dt) <- c('index','feature')
  # dispose of features that aren't in mean or standard deviation
  features_dt <- subset(all_features_dt,
                        str_detect(feature, fixed('mean()')) | str_detect(feature,fixed('std()')))
  return(features_dt)
}

###
# FUNCTION: get_feature_codebook_markdown(dataDir)
#
# Helper function to harvest feature names and create markdown
get_feature_codebook_markdown <- function(dataDir) {
  # create some markdown for the long list
  metadata <- get_feature_metadata(dataDir)
  my_md <- paste0('- ',metadata$feature,' `(source column index ',metadata$index,')`')
}

###
# FUNCTION: save_feature_markdown(destfile)
#
# Helper function to save the markdown language for the features in the project
save_feature_markdown <- function(destfile) {
  my_markdown <- get_feature_codebook_markdown('./data/UCI HAR Dataset')
  write.table(my_markdown, destfile, quote=F, row.names=F)
}