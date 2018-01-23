# function to check for installed packages and install
# them if they are not installed
install_my_pkgs <- function(packages){
     new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
     if (length(new_packages))
          install.packages(new_packages, dependencies = TRUE)
     sapply(packages, require, character.only = TRUE)
}

# usage
required_packages <- c(
"hflights",  # hflights data
"dplyr",     # data manipulation
"forcats",   # factors
"ggplot2",   # data visualization
"ggthemes",  # extra themes, scales and geoms for 'ggplot2'
"ggmap",     # functions for maps
"ggformula", # formula version of ggplot2
"haven",     # export/import data
"lubridate", # dealing with dates
"magrittr",  # the pipes %>%
"purrr",     # programming
"readr",     # reading data into R
"readxl",    # reading excel sheets into R
"stringr",   # dealing with strings
"tibble",    # creating fast and printable data frames
"tidyr",     # tidy data
"dbplyr",    # data base manipulation
"tidytext",  # tidyverse text mining for word processing/sentiment analysis
"gutenbergr",# download and process public domain works in the project
"devtools",  # developing R package tools
"tidyverse", # sort of everything above...
"gcookbook", # package contains data sets used in "r graphics cookbook"
"broom",     # convert statistical analysis objects from r into tidy data
"rmdexamples") # rmd examples from RStudio

extra_packages <- c(
"ISLR",      # introduction to statistical learning package
"e1071",     # misc functions from dept of stats, prob theory group
"rio",       # streamlined data import and export
"memisc",    # tools for managing survey data presentation of analysis
             # results

"Hmisc",     # contains many functions useful for data analysis,
             # high-level graphics, utility operations, functions for
             # computing sample size and power, importing and annotating
             # datasets, imputing missing values, advanced table making,
             # variable clustering, character string manipulation,
             # conversion of r objects to latex and html code,
             # and recoding variables
"reshape",   # Flexibly restructure and aggregate data using just two
             # functions: melt and cast
"Lahman",    # Provides the tables from the 'Sean Lahman Baseball Database'
"caret",     # Misc functions for training and plotting classification
             # and regression models
"timevis",   # create rich and fully interactive timeline visualizations
"LOGIT",     # functions, data and code for PGLR
"xtable",    # coerce data to latex and html tables
"tableone",  # creates 'table 1', i.e., description of baseline patient
             # characteristics, which is essential in every medical
             # research
"mosaic",    # data sets and utilities from project mosaic
"ggmap",     # ggmap for maps
"Ecdat",     # data sets for econometrics
"HistData",  # a collection of small data sets that are interesting and
             # important in the history of statistics and data
             # visualization. The goal of the package is to make these
             # available, both for instructional use and for historical
             # research. Some of these present interesting challenges for
             # graphics or analysis in R

             # gutenberg collection
"urltools",  # A toolkit for all URL-handling needs, including encoding,
             # decoding, parsing, parameter extraction and modification.
             # All functions are designed to be both fast and entirely
             # vectorised. It is intended to be useful for people dealing
             # with web-related datasets, such as server-side logs,
             # although may be useful for other situations involving
             # large sets of URLs
"DAAG",      # Various data sets used in examples and exercises in the
             # book Maindonald, J.H. and Braun, W.J. (2003, 2007, 2010)
             # "Data Analysis and Graphics Using R"
             # frames, so that they can more easily be combined, reshaped
             #  and otherwise processed with tools like 'dplyr', 'tidyr'
             #  and 'ggplot2'
"csvy",      # Import and Export CSV Data With a YAML Metadata Header
"feather",   # Access a feather store like a data frame
"fst",       # Read and write data frames at high speed.
"readODS",   # Import ODS (OpenDocument Spreadsheet) into R as a data
             # frame. Also support writing data frame into ODS file.
"rmatio")    # Reading and writing Matlab MAT files from R

install_my_pkgs(required_packages)

# if (!require("devtools")) install.packages("devtools")
# # you may also need to update packages: update.packages(ask = FALSE)
# devtools::install_github("rstudio/rmdexamples")

# source:
# https://tinyurl.com/y77lzv8b

# want the raw version in a tiny url?
# https://tinyurl.com/ya99kpcz
