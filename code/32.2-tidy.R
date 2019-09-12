#=====================================================================#
# This is code to create: 02-tidy
# Authored by and feedback to:
# MIT License
# Version:
#=====================================================================#


# packages ----------------------------------------------------------------

library(magrittr) # Pipes %>%, %T>% and equals(), extract().
library(tidyverse) # all tidyverse packages
library(fs) # file management functions
library(fivethirtyeight)
library(mdsr) # modern data science with R
library(broom) # tidying models
library(modelr) # modelr package
library(ggrepel) # repel text overlay in graphs
library(gridExtra) # arrange multiple plots
library(grid) # text for graph title
library(egg) # for ggarrange
library(corrr) # correlations
# devtools::install_github("ropensci/skimr", ref = "v2")
library(skimr)


source("code/32.1-import.R")

# bind these
YouTubeComedyDataRaw <- dplyr::bind_rows(AmySchumerRaw,
                                      KeyAndPeeleRaw,
                                      .id = "source")

