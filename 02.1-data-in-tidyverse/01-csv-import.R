#=====================================================================#
# This is code to create: 01-csv-import.R
# Authored by and feedback to: 
# MIT License
# Version:
# Style guide: https://style.tidyverse.org/
#=====================================================================#


# motivation --------------------------------------------------------------
# this file demonstrates how to import .CSV files in RStudio


# packages ----------------------------------------------------------------
# readr is part of the tidyverse, but we will load it independently here
# install.packages("readr")
# # library(tidyverse)
library(readr)


# locate data file --------------------------------------------------------
fs::dir_ls("data")
# this shows us the two folders in the data/ folder
fs::dir_ls("data/csv-data")
# there it is!


# import the data.csv file ------------------------------------------------
# complete the read_csv() function below to import the CSV file

# OneHitWonders <- readr::read_csv(file = "______")


# inspect dataset ---------------------------------------------------------
# view the new OneHitWonders with the following functions: View(), str(), 
# class()




