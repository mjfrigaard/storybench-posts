#=====================================================================#
# This is code to create: 02-excel-import.R
# Authored by and feedback to: 
# MIT License
# Version:
# Style guide: https://style.tidyverse.org/
#=====================================================================#


# motivation --------------------------------------------------------------
# this file demonstrates how to import .xlsx files in RStudio


# packages ----------------------------------------------------------------
# readxl is part of the tidyverse, but we will load it independently here
# install.packages("readxl")
# library(tidyverse)
library(readxl)

# locate data file --------------------------------------------------------
fs::dir_ls(".")
